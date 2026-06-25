<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../config/ClientEnvironmentInfo.php';
require_once __DIR__ . '/../config/TimezoneManager.php';
require_once __DIR__ . '/../helpers/UuidHelper.php';

class SystemUserModel
{
    private $db;
    private $table = 'system_users';

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    /* ============ Utilidades ============ */



    private function hashPassword(string $plain): string
    {
        return password_hash($plain, PASSWORD_BCRYPT);
    }

    private function nowWithAudit(): array
    {
        $env = new ClientEnvironmentInfo(APP_ROOT . '/app/config/geolite.mmdb');
        // userId=0 si aún no hay sesión; lo importante es setear contexto y tz
        $uuid    = UuidHelper::generateUUIDv4();
        $actorId = $_SESSION['user_id'] ?? $uuid;
        $env->applyAuditContext($this->db, $actorId);
        $tzManager = new TimezoneManager($this->db);
        $tzManager->applyTimezone();
        return [$env->getCurrentDatetime(), $env];
    }
    /* ============ Lecturas ============ */

    // Lista excluyendo eliminados lógicamente por defecto
    public function listar(int $limit = 10000, int $offset = 0, bool $incluirEliminados = false): array
    {
        $where = $incluirEliminados ? '1=1' : 'deleted_at IS NULL';
        // MODIFICADO: Añadido dispositivo_token
        $sql = "SELECT user_id, nombre, email, nivel, estado, dispositivo_token, created_at, created_by, updated_at, updated_by
                FROM {$this->table}
                WHERE {$where}
                ORDER BY created_at DESC, nombre ASC
                LIMIT ? OFFSET ?";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al preparar consulta: " . $this->db->error);

        $stmt->bind_param('ii', $limit, $offset);
        $stmt->execute();
        $res = $stmt->get_result();
        $data = $res->fetch_all(MYSQLI_ASSOC);
        $stmt->close();
        return $data;
    }


    public function obtenerPorId(string $userId): ?array
    {
        // MODIFICADO: Añadido dispositivo_token
        $sql = "SELECT user_id, nombre, email, nivel, estado, dispositivo_token,
                       created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
                FROM {$this->table}
                WHERE user_id = ?";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al preparar consulta: " . $this->db->error);

        $stmt->bind_param('s', $userId);
        $stmt->execute();
        $res = $stmt->get_result();
        $row = $res->fetch_assoc();
        $stmt->close();
        return $row ?: null;
    }

    public function obtenerPorEmail(string $email): ?array
    {
        // MODIFICADO: Añadido dispositivo_token
        $sql = "SELECT user_id, nombre, email, contrasena, nivel, estado, dispositivo_token, deleted_at
                FROM {$this->table}
                WHERE email = ?
                LIMIT 1";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al preparar consulta: " . $this->db->error);

        $stmt->bind_param('s', $email);
        $stmt->execute();
        $res = $stmt->get_result();
        $row = $res->fetch_assoc();
        $stmt->close();
        return $row ?: null;
    }

    /* ============ Escrituras ============ */

    public function crear(array $data): string
    {
        if (empty($data['nombre']) || empty($data['email']) || empty($data['contrasena']) || !isset($data['nivel'])) {
            throw new InvalidArgumentException('Faltan campos requeridos: nombre, email, contrasena, nivel.');
        }

        // Unicidad de email (excluye eliminados si así lo deseas)
        $existente = $this->obtenerPorEmail($data['email']);
        if ($existente && $existente['deleted_at'] === null) {
            throw new RuntimeException('El correo ya está registrado.');
        }

        $this->db->begin_transaction();
        try {
            [$now, $env] = $this->nowWithAudit();

            $uuid       = UuidHelper::generateUUIDv4();
            $actorId    = $_SESSION['user_id'] ?? $uuid; // si no hay actor en sesión, deja el propio
            $hash       = $this->hashPassword($data['contrasena']);
            $nivel      = (int)$data['nivel'];
            $estado     = isset($data['estado']) ? (int)$data['estado'] : 1;

            // MODIFICADO: Añadido 'dispositivo_token' al INSERT y 'NULL' a VALUES
            $sql = "INSERT INTO {$this->table}
                     (user_id, nombre, email, contrasena, nivel, estado, dispositivo_token,
                      created_at, created_by, updated_at, updated_by, deleted_at, deleted_by)
                     VALUES (?, ?, ?, ?, ?, ?, NULL, ?, ?, NULL, NULL, NULL, NULL)";
            $stmt = $this->db->prepare($sql);
            if (!$stmt) throw new mysqli_sql_exception("Error al preparar inserción: " . $this->db->error);

            // El bind_param sigue siendo 'ssssisss' porque el NULL se hardcodeó en la query
            $stmt->bind_param(
                'ssssisss',
                $uuid,
                $data['nombre'],
                $data['email'],
                $hash,
                $nivel,
                $estado,
                $now,
                $actorId
            );

            if (!$stmt->execute()) {
                $err = $stmt->error;
                $stmt->close();
                $this->db->rollback();
                if (str_contains(strtolower($err), 'duplicate')) {
                    throw new RuntimeException('El correo ya existe (índice único).');
                }
                throw new mysqli_sql_exception("Error al ejecutar inserción: " . $err);
            }

            $stmt->close();
            $this->db->commit();
            return $uuid;
        } catch (\Throwable $e) {
            $this->db->rollback();
            throw $e;
        }
    }

    public function actualizar(string $userId, array $data): bool
    {
        // Sólo permitirá actualizar campos explícitos
        $campos = [];
        $params = [];
        $types  = '';

        if (isset($data['nombre'])) {
            $campos[] = 'nombre = ?';
            $params[] = $data['nombre'];
            $types .= 's';
        }
        if (isset($data['email'])) {
            $campos[] = 'email = ?';
            $params[] = $data['email'];
            $types .= 's';
        }
        if (isset($data['nivel'])) {
            $campos[] = 'nivel = ?';
            $params[] = (int)$data['nivel'];
            $types .= 'i';
        }
        if (isset($data['estado'])) {
            $campos[] = 'estado = ?';
            $params[] = (int)$data['estado'];
            $types .= 'i';
        }
        if (isset($data['contrasena']) && $data['contrasena'] !== '') {
            $campos[] = 'contrasena = ?';
            $params[] = $this->hashPassword($data['contrasena']);
            $types   .= 's';
        }

        if (empty($campos)) {
            throw new InvalidArgumentException('No hay campos para actualizar.');
        }


        [$now, $env] = $this->nowWithAudit();
        $actorId     = $_SESSION['user_id'] ?? $userId;

        $campos[] = 'updated_at = ?';
        $params[] = $now;
        $types .= 's';
        $campos[] = 'updated_by = ?';
        $params[] = $actorId;
        $types .= 's';

        $sql = "UPDATE {$this->table} SET " . implode(', ', $campos) . " WHERE user_id = ? AND deleted_at IS NULL";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al preparar actualización: " . $this->db->error);

        $types .= 's';
        $params[] = $userId;

        $stmt->bind_param($types, ...$params);
        $ok = $stmt->execute();
        $err = $stmt->error;
        $stmt->close();

        if (!$ok) {
            if (str_contains(strtolower($err), 'duplicate')) {
                throw new RuntimeException('El correo ya existe para otro usuario.');
            }
            throw new mysqli_sql_exception("Error al actualizar: " . $err);
        }
        return true;
    }

    public function actualizarEstado(string $userId, int $estado): bool
    {
        [$now, $env] = $this->nowWithAudit();
        $actorId     = $_SESSION['user_id'] ?? $userId;

        $sql = "UPDATE {$this->table}
                SET estado = ?, updated_at = ?, updated_by = ?
                WHERE user_id = ? AND deleted_at IS NULL";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al preparar actualización de estado: " . $this->db->error);

        $stmt->bind_param('isss', $estado, $now, $actorId, $userId);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }

    // Soft delete
    public function eliminar(string $userId): bool
    {
        [$now, $env] = $this->nowWithAudit();
        $actorId     = $_SESSION['user_id'] ?? $userId;

        $sql = "UPDATE {$this->table}
                SET deleted_at = ?, deleted_by = ?
                WHERE user_id = ? AND deleted_at IS NULL";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al preparar eliminación: " . $this->db->error);

        $stmt->bind_param('sss', $now, $actorId, $userId);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }
    /* ============ Login básico (sin sesiones) ============ */
    // En models/SystemUserModel.php
    public function loginBasico(string $email, string $password): array
    {
        // MODIFICADO: Añadido dispositivo_token
        $sql = "SELECT user_id, nombre, email, contrasena, nivel, estado, dispositivo_token
            FROM system_users
            WHERE email = ? AND deleted_at IS NULL
            LIMIT 1";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error preparando login: " . $this->db->error);
        }
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $res = $stmt->get_result();

        if (!$res || $res->num_rows === 0) {
            $stmt->close();
            return [
                'ok'   => false,
                'code' => 'user_not_found'
            ];
        }

        $row = $res->fetch_assoc();
        $stmt->close();

        // MODIFICADO: Añadido dispositivo_token al array de usuario
        $userLite = [
            'user_id' => $row['user_id'],
            'nombre'  => $row['nombre'],
            'email'   => $row['email'],
            'nivel'   => (int)$row['nivel'],
            'estado'  => (int)($row['estado'] ?? 1),
            'dispositivo_token' => $row['dispositivo_token'] ?? null,
        ];

        // Estado desactivado
        if ((int)$row['estado'] === 0) {
            return [
                'ok'   => false,
                'code' => 'user_disabled',
                'user' => $userLite
            ];
        }

        // Contraseña incorrecta
        $hash = (string)$row['contrasena'];
        if (!password_verify($password, $hash)) {
            return [
                'ok'   => false,
                'code' => 'invalid_password',
                'user' => $userLite
            ];
        }

        // (Opcional) Rehash si cambiaste el algoritmo/constantes
        if (password_needs_rehash($hash, PASSWORD_DEFAULT)) {
            $nuevoHash = password_hash($password, PASSWORD_DEFAULT);
            $upd = $this->db->prepare("UPDATE system_users SET contrasena = ? WHERE user_id = ?");
            if ($upd) {
                $upd->bind_param("ss", $nuevoHash, $row['user_id']);
                $upd->execute();
                $upd->close();
            }
        }

        return [
            'ok'   => true,
            'user' => $userLite
        ];
    }


    /**
     * Login solo con email, sin contraseña.
     * Útil para autenticación por token de session solo disponible desde la app.
     */
    public function loginPassLeft(string $email): array
    {
        // MODIFICADO: Añadido dispositivo_token
        $sql = "SELECT user_id, nombre, email, contrasena, nivel, estado, dispositivo_token
            FROM system_users
            WHERE email = ? AND deleted_at IS NULL
            LIMIT 1";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error preparando login: " . $this->db->error);
        }
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $res = $stmt->get_result();

        if (!$res || $res->num_rows === 0) {
            $stmt->close();
            return [
                'ok'   => false,
                'code' => 'user_not_found'
            ];
        }

        $row = $res->fetch_assoc();
        $stmt->close();

        // MODIFICADO: Añadido dispositivo_token al array de usuario
        $userLite = [
            'user_id' => $row['user_id'],
            'nombre'  => $row['nombre'],
            'email'   => $row['email'],
            'nivel'   => (int)$row['nivel'],
            'estado'  => (int)($row['estado'] ?? 1),
            'dispositivo_token' => $row['dispositivo_token'] ?? null,
        ];

        // Estado desactivado
        if ((int)$row['estado'] === 0) {
            return [
                'ok'   => false,
                'code' => 'user_disabled',
                'user' => $userLite
            ];
        }



        return [
            'ok'   => true,
            'user' => $userLite
        ];
    }


    /**
     * Verifica la contraseña del usuario. Acepta el array de usuario (con 'contrasena').
     * Si el array no trae 'contrasena', reconsulta mínimo para obtener el hash y estado.
     * Retorna true si coincide; false en caso contrario o usuario desactivado.
     * Puede rehashear automáticamente si cambias el algoritmo por defecto.
     */
    public function verificarPassword(array $usuario, string $password): bool
    {
        // Si no viene el hash en $usuario, consultarlo
        if (!isset($usuario['contrasena']) || $usuario['contrasena'] === null) {
            if (empty($usuario['user_id'])) {
                return false;
            }
            $stmt = $this->db->prepare("SELECT contrasena, estado FROM system_users WHERE user_id = ? AND deleted_at IS NULL LIMIT 1");
            if (!$stmt) {
                throw new mysqli_sql_exception("Error preparando verificarPassword: " . $this->db->error);
            }
            $stmt->bind_param("s", $usuario['user_id']);
            $stmt->execute();
            $res = $stmt->get_result();
            if (!$res || $res->num_rows === 0) {
                $stmt->close();
                return false;
            }
            $row = $res->fetch_assoc();
            $stmt->close();
            $usuario['contrasena'] = $row['contrasena'] ?? null;
            $usuario['estado']     = isset($row['estado']) ? (int)$row['estado'] : 1;
        }

        // Usuario desactivado
        if (isset($usuario['estado']) && (int)$usuario['estado'] === 0) {
            return false;
        }

        $hash = (string)($usuario['contrasena'] ?? '');
        if ($hash === '' || !password_verify($password, $hash)) {
            return false;
        }

        // Rehash opcional si cambiaste el algoritmo/constantes
        if (password_needs_rehash($hash, PASSWORD_DEFAULT)) {
            $nuevoHash = password_hash($password, PASSWORD_DEFAULT);
            $upd = $this->db->prepare("UPDATE system_users SET contrasena = ? WHERE user_id = ? LIMIT 1");
            if ($upd) {
                $upd->bind_param("ss", $nuevoHash, $usuario['user_id']);
                $upd->execute();
                $upd->close();
            }
        }

        return true;
    }
    /* ============ Login con Token (Dispositivos) ============ */

    /**
     * Realiza el login, gestiona el token del dispositivo y retorna permisos.
     */
    public function loginConToken(string $email, string $password, string $token): array
    {

        // 1. Consultar el usuario por email
        $sql = "SELECT user_id, nombre, email, contrasena, nivel, estado, dispositivo_token
                FROM {$this->table}
                WHERE email = ? AND deleted_at IS NULL
                LIMIT 1";

        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error preparando login: " . $this->db->error);
        }

        $stmt->bind_param("s", $email);
        $stmt->execute();
        $res = $stmt->get_result();

        // 2. Manejar "Usuario no encontrado"
        if (!$res || $res->num_rows === 0) {
            $stmt->close();
            return [
                'verificado' => false,
                'mensaje' => 'Usuario no encontrado.',
                'nombre' => null,
                'nivel' => null,
                'permisos' => null
            ];
        }

        $row = $res->fetch_assoc();
        $stmt->close();

        $user_id = $row['user_id'];
        $user_nivel = (int)$row['nivel'];
        $db_token = $row['dispositivo_token'];
        $hash = (string)$row['contrasena'];

        // 3. Manejar "Usuario desactivado"
        if ((int)$row['estado'] === 0) {
            return [
                'verificado' => false,
                'mensaje' => 'El usuario está desactivado.',
                'nombre' => $row['nombre'],
                'nivel' => null,
                'permisos' => null
            ];
        }

        // 4. Manejar "Contraseña incorrecta"
        if (!password_verify($password, $hash)) {
            return [
                'verificado' => false,
                'mensaje' => 'Contraseña incorrecta.',
                'nombre' => $row['nombre'],
                'nivel' => null,
                'permisos' => null
            ];
        }

        // 5. LOGIN EXITOSO - Gestionar el Token
        if ($db_token !== $token) {
            $this->actualizarToken($user_id, $token);
        }

        // 6. Gestionar Rehash (Buena práctica de seguridad)
        if (password_needs_rehash($hash, PASSWORD_DEFAULT)) {
            $nuevoHash = password_hash($password, PASSWORD_DEFAULT);
            $upd = $this->db->prepare("UPDATE {$this->table} SET contrasena = ? WHERE user_id = ?");
            if ($upd) {
                $upd->bind_param("ss", $nuevoHash, $user_id);
                $upd->execute();
                $upd->close();
            }
        }

        // 
        // 7. OBTENER PERMISOS (MODIFICADO)
        // 
        $permisos = null;
        if ($user_nivel > 0) { // Asumiendo 0=Admin, >0=Estándar

            // Incluimos el modelo de permisos
            // (Ajusta la ruta si 'UsersPermisosModel.php' no está en el mismo directorio)
            require_once __DIR__ . '/UsersPermisosModel.php';

            // Instanciamos el modelo de permisos
            $permisosModel = new UsersPermisosModel();

            // Llamamos a la función que nos indicaste
            $permisos = $permisosModel->listarPermisosConMenu($user_id);
        }

        // 8. Devolver respuesta exitosa
        return [
            'verificado' => true,
            'mensaje' => 'Login exitoso.',
            'nombre' => $row['nombre'],
            'nivel' => $user_nivel,
            'permisos' => $permisos
        ];
    }


    /**
     * Recupera los datos del usuario mediante el token de session
     */
    public function obtenerUsuarioPorToken(string $token): ?array
    {
        $data = null;

        // Consulta la tabla session_management para obtener el user_id asociado al token
        $sql = "SELECT u.user_id, u.nombre, u.email, u.nivel, u.estado, sm.session_id 
                FROM session_management sm
                JOIN system_users u ON u.user_id = sm.user_id
                WHERE sm.session_id = ? AND sm.token_used = 0 AND u.estado = 1 AND sm.user_id IS NOT NULL";

        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new mysqli_sql_exception("Error al preparar consulta: " . $this->db->error);
        }

        $stmt->bind_param('s', $token);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($res && $res->num_rows > 0) {
            $data = $res->fetch_assoc();
        }
        $stmt->close();

        if ($data !== null) {
            $this->descartarToken($token);
        }
        return $data;
    }

    /**
     * Descarta el token usado
     */
    public function descartarToken(string $token): bool
    {
        $sql = "UPDATE session_management
                SET token_used = 1
                WHERE session_id = ?";

        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al descartar token: " . $this->db->error);

        $stmt->bind_param('s', $token);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }

    /**
     * Actualiza el 'dispositivo_token' de un usuario específico.
     */
    public function actualizarToken(string $userId, string $token): bool
    {
        // El token puede ser nulo si se quiere desvincular
        if (empty($token)) {
            $token = null;
        }

        [$now, $env] = $this->nowWithAudit();
        // El actor es el propio usuario que se está logueando
        $actorId = $userId;

        $sql = "UPDATE {$this->table}
                SET dispositivo_token = ?, updated_at = ?, updated_by = ?
                WHERE user_id = ? AND deleted_at IS NULL";

        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al preparar actualización de token: " . $this->db->error);

        $stmt->bind_param('ssss', $token, $now, $actorId, $userId);
        $ok = $stmt->execute();
        $stmt->close();
        return $ok;
    }
    /**
     * Obtiene los permisos de menú asignados a un usuario.
     */
    private function obtenerPermisosUsuario(string $userId): array
    {
        // Consulta las tablas 'users_permisos' y 'menu' para obtener los permisos
        $sql = "SELECT m.menu_id, m.categoria, m.nombre, m.url
                FROM users_permisos up
                JOIN menu m ON up.menu_id = m.menu_id
                WHERE up.user_id = ?
                  AND up.deleted_at IS NULL
                  AND m.deleted_at IS NULL";

        $stmt = $this->db->prepare($sql);
        if (!$stmt) throw new mysqli_sql_exception("Error al obtener permisos: " . $this->db->error);

        $stmt->bind_param('s', $userId);
        $stmt->execute();
        $res = $stmt->get_result();
        $data = $res->fetch_all(MYSQLI_ASSOC);
        $stmt->close();
        return $data;
    }
    /* ============ Logout ============ */
    public function logout(): bool
    {
        try {
            // Si no hay sesión activa, la iniciamos para poder destruirla
            if (session_status() === PHP_SESSION_NONE) {
                session_start();
            }

            // Limpiar todas las variables de sesión
            $_SESSION = [];

            // Destruir completamente la sesión
            session_destroy();

            return true;
        } catch (Throwable $e) {
            error_log("Error al cerrar sesión: " . $e->getMessage());
            return false;
        }
    }
}
