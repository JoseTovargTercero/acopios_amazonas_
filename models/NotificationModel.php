<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../config/ClientEnvironmentInfo.php';
require_once __DIR__ . '/../config/TimezoneManager.php';
require_once __DIR__ . '/../helpers/UuidHelper.php';
require_once __DIR__ . '/../helpers/NotificationTemplateHelper.php';

class NotificationModel
{
    private $db;
    private string $table = 'notifications';

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    /* ============ Utilidades ============ */

    /**
     * Aplica contexto de auditoría y timezone, y devuelve [now, env].
     */
    private function nowWithAudit(): array
    {
        $env = new ClientEnvironmentInfo(APP_ROOT . '/app/config/geolite.mmdb');
        // userId=0 si aún no hay sesión; lo importante es setear contexto y tz
        $uuid = UuidHelper::generateUUIDv4();
        $actorId = $_SESSION['user_id'] ?? $uuid;
        $env->applyAuditContext($this->db, $actorId);
        $tzManager = new TimezoneManager($this->db);
        $tzManager->applyTimezone();
        return [$env->getCurrentDatetime(), $env];
    }

    /**
     * Enriquecer un registro con la información del template (title/desc/module) renderizada
     * usando template_key y template_params.
     */
    private function enrichWithTemplate(array $row): array
    {
        try {
            $tplKey = (string) ($row['template_key'] ?? '');
            $params = $row['template_params'] ?? '';
            $paramsAr = [];

            if (is_array($params)) {
                $paramsAr = $params;
            } else {
                $decoded = json_decode((string) $params, true);
                $paramsAr = is_array($decoded) ? $decoded : [];
            }

            $rendered = NotificationTemplateHelper::render($tplKey, $paramsAr);
            $meta = NotificationTemplateHelper::getMeta($tplKey);

            $row['template_render'] = [
                'title' => isset($rendered['title']) ? (string) $rendered['title'] : '',
                'desc' => isset($rendered['desc']) ? (string) $rendered['desc'] : '',
                'module' => is_array($meta) && isset($meta['module']) ? (string) $meta['module'] : null,
            ];
        } catch (\Throwable $e) {
            $row['template_render'] = [
                'title' => (string) ($row['template_key'] ?? ''),
                'desc' => '',
                'module' => null,
            ];
        }
        return $row;
    }

    /**
     * Verifica existencia (no eliminado) y retorna el registro.
     */
    private function mustExist(string $id): array
    {
        $sql = "SELECT * FROM {$this->table}
                WHERE notifications_id = ? AND deleted_at IS NULL
                LIMIT 1";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar verificación: " . $this->db->error);
        }
        $stmt->bind_param('s', $id);
        $stmt->execute();
        $res = $stmt->get_result();
        $row = $res->fetch_assoc();
        $stmt->close();

        if (!$row) {
            throw new mysqli_sql_exception("Notificación no encontrada.");
        }
        return $row;
    }

    /**
     * Valida nombre de flag y valor permitido (0/1).
     */
    private function validarFlag(string $flag, int $valor): void
    {
        if (!in_array($flag, ['new', 'read_unread'], true)) {
            throw new InvalidArgumentException("Flag inválido: {$flag}");
        }
        if (!in_array($valor, [0, 1], true)) {
            throw new InvalidArgumentException("Valor inválido para flag {$flag}. Use 0 o 1.");
        }
    }

    /* ============ Lecturas ============ */

    /**
     * Lista notificaciones (por defecto solo no eliminadas) con filtros opcionales.
     */
    public function listar(
        int $limit = 10000,
        int $offset = 0,
        bool $incluirEliminadas = false,
        ?string $userId = null,
        ?int $soloNuevas = null,
        ?int $soloNoLeidas = null
    ): array {
        $where = [];
        $params = [];
        $types = '';

        $where[] = $incluirEliminadas ? '(deleted_at IS NULL OR deleted_at IS NOT NULL)' : 'deleted_at IS NULL';

        if ($userId !== null && $userId !== '') {
            $where[] = 'user_id = ?';
            $params[] = $userId;
            $types .= 's';
        }

        if ($soloNuevas !== null) {
            $this->validarFlag('new', (int) $soloNuevas);
            $where[] = '`new` = ?';
            $params[] = (int) $soloNuevas;
            $types .= 'i';
        }

        if ($soloNoLeidas !== null) {
            $this->validarFlag('read_unread', (int) $soloNoLeidas);
            $where[] = '`read_unread` = ?';
            $params[] = (int) $soloNoLeidas;
            $types .= 'i';
        }

        $whereSql = implode(' AND ', $where);

        $sql = "SELECT
                    notifications_id,
                    template_key,
                    template_params,
                    route,
                    module,
                    rol,
                    user_id,
                    `new`,
                    `read_unread`,
                    created_at,
                    created_by,
                    updated_at,
                    updated_by,
                    deleted_at,
                    deleted_by
                FROM {$this->table}
                WHERE {$whereSql}
                ORDER BY created_at DESC
                LIMIT ? OFFSET ?";

        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar listado: " . $this->db->error);
        }

        $types .= 'ii';
        $params[] = $limit;
        $params[] = $offset;

        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        $res = $stmt->get_result();
        $data = $res->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        // === Enriquecer cada fila con información del template ===
        foreach ($data as $i => $row) {
            $data[$i] = $this->enrichWithTemplate($row);
        }

        return $data;
    }

    /**
     * Lista notificaciones del usuario en sesión (atajo).
     * MODIFICADO: Acepta $soloNoLeidas para filtrar
     */
    public function listarDeUsuarioActual(
        int $limit = 20,
        int $offset = 0,
        ?int $soloNoLeidas = null // <-- NUEVO PARÁMETRO
    ): array {
        $sessionUserId = $_SESSION['user_id'] ?? $_SESSION['usuario_id'] ?? $_SESSION['administrator_id'] ?? null;
        if (!$sessionUserId) {
            throw new mysqli_sql_exception('No se encontró el user_id en sesión.');
        }
        // MODIFICADO: Pasa $soloNoLeidas al método principal
        return $this->listar($limit, $offset, false, (string) $sessionUserId, null, $soloNoLeidas);
    }

    /**
     * Obtiene una notificación por id (incluye eliminada).
     */
    public function obtenerPorId(string $id): ?array
    {
        $sql = "SELECT *
                FROM {$this->table}
                WHERE notifications_id = ?
                LIMIT 1";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar consulta: " . $this->db->error);
        }
        $stmt->bind_param('s', $id);
        $stmt->execute();
        $res = $stmt->get_result();
        $row = $res->fetch_assoc();
        $stmt->close();

        if (!$row) {
            return null;
        }

        $row = $this->enrichWithTemplate($row);
        return $row;
    }

    // --- NUEVO MÉTODO ---
    /**
     * Obtiene los conteos de 'new' y 'read_unread' para un usuario.
     * Optimizado para ser llamado por el sondeo (polling).
     */
    public function obtenerConteos(string $userId): array
    {
        $new_count = 0;
        $unread_count = 0;

        // Conteo de Nuevas (new = 1)
        $sqlNew = "SELECT COUNT(*) as total FROM {$this->table} WHERE user_id = ? AND `new` = 1 AND deleted_at IS NULL";
        $stmtNew = $this->db->prepare($sqlNew);
        if ($stmtNew) {
            $stmtNew->bind_param('s', $userId);
            $stmtNew->execute();
            $new_count = (int) $stmtNew->get_result()->fetch_assoc()['total'];
            $stmtNew->close();
        }

        // Conteo de No Leídas (read_unread = 0)
        $sqlUnread = "SELECT COUNT(*) as total FROM {$this->table} WHERE user_id = ? AND `read_unread` = 0 AND deleted_at IS NULL";
        $stmtUnread = $this->db->prepare($sqlUnread);
        if ($stmtUnread) {
            $stmtUnread->bind_param('s', $userId);
            $stmtUnread->execute();
            $unread_count = (int) $stmtUnread->get_result()->fetch_assoc()['total'];
            $stmtUnread->close();
        }

        return [
            'new_count' => $new_count,
            'unread_count' => $unread_count
        ];
    }
    // --- FIN DEL NUEVO MÉTODO ---


    /* ============ Escrituras ============ */

    /**
     * Crea una notificación.
     */
    public function crear(array $data): string
    {
        $req = ['template_key', 'route', 'module', 'rol', 'user_id'];
        foreach ($req as $k) {
            if (empty($data[$k])) {
                throw new InvalidArgumentException("Falta campo requerido: {$k}");
            }
        }

        $uuid = UuidHelper::generateUUIDv4();
        $paramsJ = json_encode($data['template_params'] ?? [], JSON_UNESCAPED_UNICODE);

        $this->db->begin_transaction();
        try {
            [$now] = $this->nowWithAudit();
            $actorId = $_SESSION['user_id'] ?? $uuid;

            $sql = "INSERT INTO {$this->table}
                    (notifications_id, template_key, template_params, route, module, rol, user_id,
                     `new`, `read_unread`, created_at, created_by, updated_at, updated_by,
                     deleted_at, deleted_by)
                    VALUES (?, ?, ?, ?, ?, ?, ?, 1, 0, ?, ?, NULL, NULL, NULL, NULL)";

            $stmt = $this->db->prepare($sql);
            if (!$stmt) {
                throw new mysqli_sql_exception("Error al preparar inserción: " . $this->db->error);
            }

            $stmt->bind_param(
                'sssssssss',
                $uuid,
                $data['template_key'],
                $paramsJ,
                $data['route'],
                $data['module'],
                $data['rol'],
                $data['user_id'],
                $now,
                $actorId
            );

            if (!$stmt->execute()) {
                $err = $stmt->error;
                $stmt->close();
                $this->db->rollback();
                throw new mysqli_sql_exception("Error al ejecutar inserción: " . $err);
            }

            $stmt->close();
            $this->db->commit();

            try {
                require_once __DIR__ . '/../helpers/NotificationTemplateHelper.php';
                require_once __DIR__ . '/../helpers/push.php';

                $params = $data['template_params'] ?? [];

                $rendered = NotificationTemplateHelper::render($data['template_key'], $params);
                $pushTitle = trim($rendered['title'] ?? '');
                $pushBody = trim($rendered['desc'] ?? '');

                if ($pushTitle !== '' || $pushBody !== '') {
                    $serviceAccountPath = APP_ROOT . '/service-account.json';
                    $projectId = getenv('FCM_PROJECT_ID') ?: (defined('FCM_PROJECT_ID') ? FCM_PROJECT_ID : '');

                    if ($projectId === '') {
                        error_log("[NotificationModel] FCM_PROJECT_ID no configurado; omitiendo push.");
                    } else {
                        $push = new \App\Helpers\PushNotificationHelper($serviceAccountPath, $projectId);
                        $ok = $push->send($data['user_id'], $pushTitle, $pushBody);

                        if (!$ok) {
                            error_log("[NotificationModel] Fallo al enviar push (user_id={$data['user_id']}, template={$data['template_key']})");
                        }
                    }
                }
            } catch (\Throwable $e) {
                error_log("[NotificationModel] Error en render/push: " . $e->getMessage());
            }

            return $uuid;

        } catch (\Throwable $e) {
            $this->db->rollback();
            error_log("[NotificationModel] crear() error: " . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Actualiza campos explícitos.
     */
    public function actualizar(string $id, array $data): bool
    {
        $this->mustExist($id);

        $campos = [];
        $params = [];
        $types = '';

        if (isset($data['template_key'])) {
            $campos[] = 'template_key = ?';
            $params[] = (string) $data['template_key'];
            $types .= 's';
        }
        if (array_key_exists('template_params', $data)) {
            $json = $data['template_params'] === null
                ? null
                : json_encode($data['template_params'], JSON_UNESCAPED_UNICODE);
            $campos[] = 'template_params = ?';
            $params[] = $json;
            $types .= 's';
        }
        if (isset($data['route'])) {
            $campos[] = 'route = ?';
            $params[] = (string) $data['route'];
            $types .= 's';
        }
        if (isset($data['module'])) {
            $campos[] = 'module = ?';
            $params[] = (string) $data['module'];
            $types .= 's';
        }
        if (isset($data['rol'])) {
            $campos[] = 'rol = ?';
            $params[] = (string) $data['rol'];
            $types .= 's';
        }
        if (isset($data['user_id'])) {
            $campos[] = 'user_id = ?';
            $params[] = (string) $data['user_id'];
            $types .= 's';
        }
        if (isset($data['new'])) {
            $this->validarFlag('new', (int) $data['new']);
            $campos[] = '`new` = ?';
            $params[] = (int) $data['new'];
            $types .= 'i';
        }
        if (isset($data['read_unread'])) {
            $this->validarFlag('read_unread', (int) $data['read_unread']);
            $campos[] = '`read_unread` = ?';
            $params[] = (int) $data['read_unread'];
            $types .= 'i';
        }

        if (empty($campos)) {
            throw new InvalidArgumentException('No hay campos para actualizar.');
        }

        [$now] = $this->nowWithAudit();
        $actorId = $_SESSION['user_id'] ?? $id;

        $campos[] = 'updated_at = ?';
        $params[] = $now;
        $types .= 's';
        $campos[] = 'updated_by = ?';
        $params[] = $actorId;
        $types .= 's';

        $sql = "UPDATE {$this->table}
                SET " . implode(', ', $campos) . "
                WHERE notifications_id = ? AND deleted_at IS NULL";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar actualización: " . $this->db->error);
        }

        $types .= 's';
        $params[] = $id;

        $stmt->bind_param($types, ...$params);
        $ok = $stmt->execute();
        $err = $stmt->error;
        $stmt->close();

        if (!$ok) {
            throw new mysqli_sql_exception("Error al actualizar: " . $err);
        }

        return true;
    }

    /**
     * Eliminación lógica (soft delete).
     */
    public function eliminar(string $id): bool
    {
        $this->mustExist($id);

        [$now] = $this->nowWithAudit();
        $actorId = $_SESSION['user_id'] ?? $id;

        $sql = "UPDATE {$this->table}
                SET deleted_at = ?, deleted_by = ?
                WHERE notifications_id = ? AND deleted_at IS NULL";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar eliminación: " . $this->db->error);
        }
        $stmt->bind_param('sss', $now, $actorId, $id);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }

    /* ============ Flags / Atajos ============ */

    public function actualizarNew(string $id, int $valor): bool
    {
        return $this->actualizarFlag($id, 'new', $valor);
    }

    public function actualizarReadUnread(string $id, int $valor): bool
    {
        return $this->actualizarFlag($id, 'read_unread', $valor);
    }

    private function actualizarFlag(string $id, string $flag, int $valor): bool
    {
        $this->mustExist($id);
        $this->validarFlag($flag, (int) $valor);

        [$now] = $this->nowWithAudit();
        $actorId = $_SESSION['user_id'] ?? $id;

        $sql = "UPDATE {$this->table}
                SET `{$flag}` = ?, updated_at = ?, updated_by = ?
                WHERE notifications_id = ? AND deleted_at IS NULL";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar actualización de flag: " . $this->db->error);
        }
        $stmt->bind_param('isss', $valor, $now, $actorId, $id);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }

    /**
     * Marcar todas como vistas (new=0) para un usuario.
     */
    public function marcarTodasComoVistas(string $userId): bool
    {
        [$now] = $this->nowWithAudit();
        $actorId = $_SESSION['user_id'] ?? $userId;

        $sql = "UPDATE {$this->table}
                SET `new` = 0, updated_at = ?, updated_by = ?
                WHERE user_id = ? AND `new` = 1";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar marcado de vistas: " . $this->db->error);
        }
        $stmt->bind_param('sss', $now, $actorId, $userId);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }

    /**
     * Marcar todas como leídas (read_unread=1 y new=0) para un usuario.
     */
    public function marcarTodasComoLeidas(string $userId): bool
    {
        [$now] = $this->nowWithAudit();
        $actorId = $_SESSION['user_id'] ?? $userId;

        $sql = "UPDATE {$this->table}
                SET `read_unread` = 1, `new` = 0, updated_at = ?, updated_by = ?
                WHERE user_id = ? AND `read_unread` = 0";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar marcado de leídas: " . $this->db->error);
        }
        $stmt->bind_param('sss', $now, $actorId, $userId);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }
}