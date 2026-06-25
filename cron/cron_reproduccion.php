<?php
// cron_reproduccion.php
// Ejecuta el scheduler de reproducción y notifica a TODOS los usuarios Nivel 0 usando NotificationModel.
// Uso CLI: php cron_reproduccion.php
declare(strict_types=1);

// 1. Carga de dependencias
try {
    // Cargar el Autoloader de Composer (necesario para librerías externas como GeoIp2 en los Modelos)
    if (file_exists(__DIR__ . '/../vendor/autoload.php')) {
        require_once __DIR__ . '/../vendor/autoload.php';
    } else {
        require_once __DIR__ . '/../../vendor/autoload.php'; 
    }

    require_once __DIR__ . '/../config/Database.php';
    require_once __DIR__ . '/../helpers/UuidHelper.php';
    require_once __DIR__ . '/../helpers/NotificationTemplateHelper.php';
    require_once __DIR__ . '/../models/NotificationModel.php';
} catch (Throwable $e) {
    fwrite(STDERR, "[FATAL] Error cargando dependencias: " . $e->getMessage() . PHP_EOL);
    exit(1);
}

// Configuración
date_default_timezone_set('America/Caracas');

$SYSTEM_ACTOR_ID = '00000000-0000-0000-0000-000000000000'; 

try {
    echo "[INFO] Iniciando Cron de Reproducción (Model Based)..." . PHP_EOL;

    // 2. Instancias de Base de Datos y Modelos
    $db = Database::getInstance();
    $notificationModel = new NotificationModel();

    /**
     * Helper local para notificar con VERIFICACIÓN DE DUPLICADOS DIARIOS
     */
    function notificar(
        mysqli $db, // <--- Agregamos la conexión DB para hacer la verificación manual
        NotificationModel $model, 
        string $templateKey, 
        array $params, 
        ?string $route, 
        string $userId, 
        string $role = 'admin'
    ): void {
        
        // --- 1. Verificación de duplicados para HOY ---
        // Usamos el operador <=> (null-safe equality) para comparar la ruta aunque sea NULL
        $sqlCheck = "SELECT 1 FROM notifications 
                     WHERE template_key = ? 
                       AND user_id = ? 
                       AND route <=> ? 
                       AND DATE(created_at) = CURDATE() 
                     LIMIT 1";
        
        $stmt = $db->prepare($sqlCheck);
        if ($stmt) {
            $stmt->bind_param('sss', $templateKey, $userId, $route);
            $stmt->execute();
            $stmt->store_result();
            $existe = $stmt->num_rows > 0;
            $stmt->close();

            if ($existe) {
                // Si ya existe, no hacemos nada
                // echo "[SKIP] Notificación duplicada para User: $userId, Tpl: $templateKey" . PHP_EOL;
                return;
            }
        }

        // --- 2. Si no existe, preparamos datos y enviamos ---
        $meta = NotificationTemplateHelper::getMeta($templateKey);
        $module = $meta ? ($meta['module'] ?? 'reproduccion') : 'reproduccion';

        $data = [
            'template_key'    => $templateKey,
            'template_params' => $params, 
            'route'           => $route,
            'module'          => $module,
            'rol'             => $role,
            'user_id'         => $userId,
            'created_by'      => 'SYSTEM'
        ];

        try {
            $model->crear($data);
        } catch (Exception $e) {
            fwrite(STDERR, "[WARN] Error creando notificación para usuario $userId: " . $e->getMessage() . PHP_EOL);
        }
    }

    // =================================================================================
    // 0. Obtener lista de Administradores (Nivel 0)
    // =================================================================================
    $adminUsers = [];
    $sqlAdmins = "SELECT user_id FROM system_users WHERE nivel = 0 AND estado = 1 AND deleted_at IS NULL";
    if ($res = $db->query($sqlAdmins)) {
        while ($row = $res->fetch_assoc()) {
            $adminUsers[] = $row['user_id'];
        }
        $res->free();
    }

    $countAdmins = count($adminUsers);
    echo "[INFO] Destinatarios (Admin Nivel 0): {$countAdmins}" . PHP_EOL;


    // =================================================================================
    // 1. SCHEDULER: Generar Revisiones y Alertas (Periodos en SEGUIMIENTO)
    // =================================================================================
    
    $sqlScheduler = "
        SELECT 
            p.periodo_id, 
            p.fecha_inicio, 
            p.hembra_id, 
            COALESCE(a.identificador, 'SIN-ID') AS hembra_identificador
        FROM periodos_servicio p
        LEFT JOIN animales a ON a.animal_id = p.hembra_id
        LEFT JOIN revisiones_servicio r ON r.periodo_id = p.periodo_id AND r.deleted_at IS NULL
        WHERE p.estado_periodo IN ('SEGUIMIENTO', 'CERRADO') 
          AND p.deleted_at IS NULL
          AND r.revision_id IS NULL
    ";

    if (!$res = $db->query($sqlScheduler)) {
        throw new RuntimeException("Error en consulta Scheduler: " . $db->error);
    }

    $countGenerados = 0;

    while ($row = $res->fetch_assoc()) {
        $periodoId      = $row['periodo_id'];
        $fechaInicio    = $row['fecha_inicio'];
        $hembraId       = $row['hembra_id'];
        $hembraIdent    = $row['hembra_identificador'];
        $fechaProgramada = date('Y-m-d', strtotime($fechaInicio . ' + 21 days'));
        $now             = date('Y-m-d H:i:s');
        
        $db->begin_transaction();

        try {
            // A. Insertar Revisión
            $revisionId = UuidHelper::generateUUIDv4();
            $sqlRev = "INSERT INTO revisiones_servicio (revision_id, periodo_id, fecha_programada, created_by, created_at) VALUES (?, ?, ?, ?, ?)";
            $stmtRev = $db->prepare($sqlRev);
            $stmtRev->bind_param('sssss', $revisionId, $periodoId, $fechaProgramada, $SYSTEM_ACTOR_ID, $now);
            $stmtRev->execute();
            $stmtRev->close();

            // B. Insertar Alerta
            $alertaId = UuidHelper::generateUUIDv4();
            $detalle  = "Revisión 20/21 programada para la hembra {$hembraIdent} el {$fechaProgramada}.";
            $sqlAlert = "INSERT INTO alertas 
                (alerta_id, tipo_alerta, fecha_objetivo, periodo_id, animal_id, detalle, estado_alerta, created_at, created_by)
                VALUES (?, 'REVISION_20_21', ?, ?, ?, ?, 'PENDIENTE', ?, ?)";
            $stmtAlert = $db->prepare($sqlAlert);
            $stmtAlert->bind_param('sssssss', $alertaId, $fechaProgramada, $periodoId, $hembraId, $detalle, $now, $SYSTEM_ACTOR_ID);
            $stmtAlert->execute();
            $stmtAlert->close();

            // C. Notificar
            if ($countAdmins > 0) {
                $tplKey = 'repro_revision_20_21_due';
                $params = [
                    'dia'                  => '21',
                    'fecha_programada'     => $fechaProgramada,
                    'hembra_identificador' => $hembraIdent
                ];
                $route = '/agenda_reproductiva?periodo_id=' . $periodoId . '&revision_id=' . $revisionId;

                foreach ($adminUsers as $adminId) {
                    // Pasamos $db como primer argumento
                    notificar($db, $notificationModel, $tplKey, $params, $route, $adminId);
                }
            }

            $db->commit();
            $countGenerados++;

        } catch (Throwable $e) {
            $db->rollback();
            fwrite(STDERR, "[WARN] Falló transacción periodo {$periodoId}: " . $e->getMessage() . PHP_EOL);
        }
    }
    $res->free();
    echo "[OK] Periodos procesados (nuevos): {$countGenerados}" . PHP_EOL;


    // =================================================================================
    // 2. RECORDATORIOS DIARIOS (Lectura de alertas)
    // =================================================================================

    // === 2.1 Recordatorio: Revisión día 20/21 ===
    $sqlRev = "
        SELECT 
            a.alerta_id, a.fecha_objetivo, ps.periodo_id,
            COALESCE(an.identificador, 'SIN-ID') AS hembra_identificador, 
            r.revision_id
        FROM alertas a
        JOIN periodos_servicio ps ON ps.periodo_id = a.periodo_id
        LEFT JOIN animales an ON an.animal_id = ps.hembra_id
        JOIN revisiones_servicio r 
             ON r.periodo_id = a.periodo_id
            AND r.fecha_programada = a.fecha_objetivo
            AND r.deleted_at IS NULL
        WHERE a.tipo_alerta = 'REVISION_20_21'
          AND a.fecha_objetivo = CURDATE()
          AND ps.deleted_at IS NULL
    ";

    if ($res = $db->query($sqlRev)) {
        while ($row = $res->fetch_assoc()) {
            if ($countAdmins === 0) continue;

            $tplKey = 'repro_revision_20_21_due';
            $params = [
                'hembra_identificador' => $row['hembra_identificador'],
                'fecha_programada'     => date('Y-m-d', strtotime($row['fecha_objetivo'])),
                'dia'                  => '21'
            ];
            $route = '/agenda_reproductiva?periodo_id=' . $row['periodo_id'] . '&revision_id=' . $row['revision_id'];

            foreach ($adminUsers as $adminId) {
                // Pasamos $db como primer argumento
                notificar($db, $notificationModel, $tplKey, $params, $route, $adminId);
            }
        }
        $res->free();
    }

    // === 2.2 Recordatorio: Proximidad a parto ===
    $sqlParto = "
        SELECT 
            a.alerta_id, a.fecha_objetivo, ps.periodo_id,
            COALESCE(an.identificador, 'SIN-ID') AS hembra_identificador
        FROM alertas a
        JOIN periodos_servicio ps ON ps.periodo_id = a.periodo_id
        LEFT JOIN animales an ON an.animal_id = ps.hembra_id
        WHERE a.tipo_alerta = 'PROX_PARTO_117'
          AND a.fecha_objetivo = CURDATE()
          AND ps.deleted_at IS NULL
    ";

    if ($res2 = $db->query($sqlParto)) {
        while ($row = $res2->fetch_assoc()) {
            if ($countAdmins === 0) continue;

            $tplKey = 'repro_prox_parto_117';
            $params = [
                'hembra_identificador' => $row['hembra_identificador'],
                'fecha_estimada_parto' => date('Y-m-d', strtotime($row['fecha_objetivo'])),
            ];
            $route = '/animales/gestacion?periodo_id=' . $row['periodo_id'];

            foreach ($adminUsers as $adminId) {
                // Pasamos $db como primer argumento
                notificar($db, $notificationModel, $tplKey, $params, $route, $adminId);
            }
        }
        $res2->free();
    }

    echo "[OK] Ejecución finalizada: " . date('Y-m-d H:i:s') . PHP_EOL;

} catch (Throwable $e) {
    fwrite(STDERR, "[FATAL ERROR] " . $e->getMessage() . PHP_EOL);
    exit(2);
}