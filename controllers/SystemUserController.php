<?php
require_once __DIR__ . '/../models/SystemUserModel.php';
require_once __DIR__ . '/../models/UsersPermisosModel.php';
require_once __DIR__ . '/../models/SessionManagementModel.php';
class SystemUserController
{
    private $model;

    public function __construct()
    {
        $this->model = new SystemUserModel();
    }

    private function getJsonInput(): array
    {
        $raw = file_get_contents('php://input') ?: '';
        $json = json_decode($raw, true);
        return is_array($json) ? $json : [];
    }

    private function jsonResponse($value, string $message = '', $data = null, int $status = 200): void
    {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode([
            'value' => $value,
            'message' => $message,
            'data' => $data
        ]);
        exit;
    }

    public function loginApp(): void
    {
        // 1) Entradas
        $email = trim((string) ($_POST['email'] ?? ''));
        $password = (string) ($_POST['password'] ?? ($_POST['contrasena'] ?? ''));
        // token de la app => deviceId
        $deviceId = trim((string) ($_POST['token'] ?? ($_POST['dispositivo_token'] ?? '')));

        // 2) Validaciones
        if ($email === '' || $password === '' || $deviceId === '') {
            $this->jsonResponse(false, 'Email, contraseña y token de dispositivo son obligatorios.', null, 400);
            return;
        }


        // 3) Respuesta base
        $result = ['verificado' => false, 'mensaje' => 'Error indeterminado.'];
        $data = null;
        $status = 500;

        try {
            $SessionManagementModel = new \SessionManagementModel();
            $deviceType = 'mobile';
            $userTypeDef = 'user';

            // ----- Rate limiting por email -----
            $maxIntentos = 3;
            $tiempoBloqueo = 60; // seg
            $keyIntentos = 'login_attempts_' . md5($email);
            $ahora = time();
            $intentos = $_SESSION[$keyIntentos] ?? ['count' => 0, 'last_attempt' => 0, 'locked_until' => 0];

            if ($intentos['locked_until'] > $ahora) {
                $espera = ceil(($intentos['locked_until'] - $ahora) / 60);

                // Auditoría (si es posible, obtener user_id/nivel por email)
                $audUserId = null;
                $audUserType = $userTypeDef;
                if (method_exists($this->model, 'obtenerPorEmail')) {
                    $u = $this->model->obtenerPorEmail($email);
                    if (is_array($u) && !empty($u)) {
                        $audUserId = $u['user_id'];
                        $audUserType = ((int) ($u['nivel'] ?? 1) === 0) ? 'administrator' : 'user';
                    }
                }
                $SessionManagementModel->create($audUserId, $audUserType, $deviceId, $deviceType, false, 'Demasiados intentos fallidos (App)');

                $result['verificado'] = false;
                $result['mensaje'] = "Demasiados intentos. Intente nuevamente en {$espera} minuto(s).";
                $status = 429;

                $this->jsonResponse($result['verificado'], $result['mensaje'], $data, $status);
                return;
            }

            // ----- AUTENTICACIÓN (usa loginConToken para actualizar dispositivo_token) -----
            // Estructura esperada de retorno:
            // ['verificado'=>bool,'mensaje'=>string,'nombre'=>?, 'nivel'=>int|null,'permisos'=>array|null]
            $auth = $this->model->loginConToken($email, $password, $deviceId);

            if (empty($auth) || ($auth['verificado'] ?? false) !== true) {
                // Fallo de autenticación: mapear motivo a status y rate-limit
                $msg = (string) ($auth['mensaje'] ?? 'Credenciales inválidas.');
                $reason = 'Fallo de autenticación';
                $status = 401;

                // Intentar obtener datos de usuario para auditoría
                $userIdAudit = null;
                $userTypeAudit = $userTypeDef;
                if (method_exists($this->model, 'obtenerPorEmail')) {
                    $u = $this->model->obtenerPorEmail($email);
                    if (is_array($u) && !empty($u)) {
                        $userIdAudit = $u['user_id'];
                        $userTypeAudit = ((int) ($u['nivel'] ?? 1) === 0) ? 'administrator' : 'user';
                    }
                }

                // Ajustes por mensaje
                if (stripos($msg, 'no encontrado') !== false) {
                    $reason = 'Usuario no encontrado';
                } elseif (stripos($msg, 'desactivado') !== false) {
                    $reason = 'Usuario desactivado';
                    $status = 403;
                } elseif (stripos($msg, 'contraseña incorrecta') !== false) {
                    $reason = 'Contraseña incorrecta';
                    // Aumentar contador de intentos solo en contraseña incorrecta
                    $intentos['count']++;
                    $intentos['last_attempt'] = $ahora;
                    if ($intentos['count'] >= $maxIntentos) {
                        $intentos['locked_until'] = $ahora + $tiempoBloqueo;
                    }
                    $_SESSION[$keyIntentos] = $intentos;
                }

                $SessionManagementModel->create($userIdAudit, $userTypeAudit, $deviceId, $deviceType, false, $reason);

                $result['verificado'] = false;
                $result['mensaje'] = $msg !== '' ? $msg : 'Credenciales inválidas.';
                $this->jsonResponse(false, $result['mensaje'], null, $status);
                return;
            }

            // ----- ÉXITO -----
            unset($_SESSION[$keyIntentos]);

            // Necesitamos user_id y nivel reales para auditoría y permisos
            $usuario = null;
            if (method_exists($this->model, 'obtenerPorEmail')) {
                $usuario = $this->model->obtenerPorEmail($email); // debe traer user_id, nombre, nivel, estado, etc.
            }
            if (!is_array($usuario) || empty($usuario['user_id'])) {
                // Fallback duro (no debería ocurrir si la BD está coherente)
                $result['verificado'] = false;
                $result['mensaje'] = 'No se pudo completar el inicio de sesión (usuario no localizado).';
                $this->jsonResponse(false, $result['mensaje'], null, 500);
                return;
            }

            $nivel = (int) ($usuario['nivel'] ?? ($auth['nivel'] ?? 1));
            $userType = ($nivel === 0) ? 'administrator' : 'user';

            // ----- PERMISOS -----
            $permisosArray = [];
            $permisosModel = new \UsersPermisosModel();

            if ($nivel === 0) {
                // Admin: todos los permisos de menú
                $permisos = $permisosModel->listarTodosLosPermisosDeMenu();
                $permisosArray = array_values(array_filter(array_map(static function ($p) {
                    return $p['menu']['url'] ?? '';
                }, is_array($permisos) ? $permisos : [])));
            } else {
                // Usuario estándar: usar los permisos que devolvió loginConToken o consultarlos
                $permisos = $auth['permisos'] ?? $permisosModel->listarPermisosConMenu($usuario['user_id']);
                $permisosArray = array_values(array_filter(array_map(static function ($p) {
                    return $p['menu']['url'] ?? '';
                }, is_array($permisos) ? $permisos : [])));

                if (empty($permisosArray)) {
                    // Sin permisos asignados => bloquear login
                    $SessionManagementModel->create($usuario['user_id'], $userType, $deviceId, $deviceType, false, 'Sin permisos asignados');
                    $this->jsonResponse(false, 'El usuario no tiene permisos asignados.', null, 403);
                    return;
                }
            }

            // ----- Crear sesión y token de sesión -----
            $sessionData = $SessionManagementModel->create(
                $usuario['user_id'],
                $userType,
                $deviceId,
                $deviceType,
                true,
                null
            );

            // ----- Variables de sesión (para webview / coherencia) -----
            $_SESSION['logged_in'] = true;
            $_SESSION['user_id'] = $usuario['user_id'];
            $_SESSION['nombre'] = $usuario['nombre'] ?? ($auth['nombre'] ?? 'Usuario');
            $_SESSION['nivel'] = $nivel;
            $_SESSION['user_type'] = $userType;
            $_SESSION['permisos'] = $permisosArray;
            $_SESSION['session_id'] = $sessionData['session_id'];

            $stmtTipo = \Database::getInstance()->prepare("SELECT tipo FROM centros WHERE id = ?");
            $stmtTipo->bind_param('i', $usuario['user_id']);
            $stmtTipo->execute();
            $rowTipo = $stmtTipo->get_result()->fetch_assoc();
            $_SESSION['tipo'] = $rowTipo['tipo'];
            $stmtTipo->close();

            // ----- Payload -----
            $data = [
                'nombre' => $_SESSION['nombre'],
                'nivel' => $nivel,
                'permisos' => $permisosArray,
                'token' => $sessionData['token'],      // token de sesión
                'session_id' => $sessionData['session_id'], // id de sesión
                'redirect_url' => '/perfil'
            ];

            $result['verificado'] = true;
            $result['mensaje'] = 'Inicio de sesión exitoso.';
            $status = 200;

            $this->jsonResponse(true, $result['mensaje'], $data, $status);
        } catch (Throwable $e) {
            error_log("Error en loginApp: " . $e->getMessage());
            $this->jsonResponse(false, 'Error interno del servidor: ' . $e->getMessage(), null, 500);
        }
    }

    public function verificarLoginApp(): void
    {
        $result = ['verificado' => false, 'mensaje' => 'Error indeterminado.'];
        $data = null;
        $status = 500;


        $token = $_POST['token'] ?? null;

        if (!$token) {
            $status = 401;
            $this->jsonResponse(false, 'No se recibió el token de la sesión.', null, $status);
            return;
        }


        $user = $this->model->obtenerUsuarioPorToken($token);

        // En caso de no encontrar el token o el usuario asociado
        if ($user === null) {
            $status = 401;
            $this->jsonResponse(false, 'Token de sesión inválido o expirado.', $data, $status);
            return;
        }


        // login con los datos del usuario
        $email = $user['email'];


        try {
            $result = $this->model->loginPassLeft($email);

            // ✅ Éxito
            $usuario = $result['user'];
            $nivel = (int) $usuario['nivel'];
            $userType = ($nivel === 0) ? 'administrator' : 'user';

            $_SESSION['logged_in'] = true;
            $_SESSION['user_id'] = $usuario['user_id'];
            $_SESSION['nombre'] = $usuario['nombre'] ?? 'Usuario';
            $_SESSION['nivel'] = $nivel;
            $_SESSION['user_type'] = $userType;

            if ($nivel === 0) {
                $_SESSION['permisos'] = ['*'];
            } else {
                $permisosModel = new \UsersPermisosModel(); // Usar \ si hay namespace
                $permisos = $permisosModel->listarPermisosConMenu($usuario['user_id']);
                if (empty($permisos)) {
                    $this->jsonResponse(false, 'El usuario no tiene permisos asignados.', null, 403);
                    return;
                }
                $_SESSION['permisos'] = array_map(fn($p) => $p['menu']['url'] ?? '', $permisos);
            }


            $sessionId = $user['session_id'];

            $_SESSION['session_id'] = $sessionId;

            $responseData = $usuario;
            $responseData['session_id'] = $sessionId;
            $responseData['token'] = $token;

            header("Location: " . BASE_URL . "/perfil");
            exit;
        } catch (\Throwable $e) {
            error_log("Error en login: " . $e->getMessage());
            $this->jsonResponse(false, 'Error al iniciar sesión: ' . $e->getMessage(), null, 500);
        }
    }

    /* ============ Endpoints ============ */

    // POST /system-users/login
    // POST /system-users/login
    // POST /system-users/login
    public function login(): void
    {
        $input = $this->getJsonInput();
        $email = trim((string) ($input['email'] ?? ''));
        $password = (string) ($input['password'] ?? ($input['contrasena'] ?? ''));

        // Auditoría / contexto
        $deviceId = $input['device_id'] ?? null;
        $isMobile = isset($input['is_mobile']) ? (bool) $input['is_mobile'] : null;
        $deviceType = ($isMobile === null ? '' : ($isMobile ? 'mobile' : 'desktop'));
        $userTypeDef = 'user'; // por defecto antes de conocer nivel

        // require_once __DIR__ . '/../helpers/login_helpers.php'; // Movido arriba por si acaso
        // require_once __DIR__ . '/../models/SessionManagementModel.php'; // Movido arriba
        $SessionManagementModel = new \SessionManagementModel(); // Usar \ si hay namespace

        $maxIntentos = 3;
        $tiempoBloqueo = 60; // seg
        $keyIntentos = 'login_attempts_' . md5($email);
        $ahora = time();
        $intentos = $_SESSION[$keyIntentos] ?? ['count' => 0, 'last_attempt' => 0, 'locked_until' => 0];

        /* ───── RATE LIMIT: bloqueado ───── */
        if ($intentos['locked_until'] > $ahora) {
            $espera = ceil(($intentos['locked_until'] - $ahora) / 60);

            // 🔎 NUEVO: si el correo es válido y existe el usuario, auditar con su user_id y user_type correcto
            $audUserId = null;
            $audUserType = $userTypeDef;

            if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
                // Usa el helper del modelo que te pasé antes
                if (method_exists($this->model, 'obtenerPorEmail')) {
                    $u = $this->model->obtenerPorEmail($email);
                    if (is_array($u) && !empty($u)) {
                        $audUserId = $u['user_id'];
                        $nivel = (int) ($u['nivel'] ?? 1);
                        $audUserType = ($nivel === 0) ? 'administrator' : 'user';
                    }
                }
            }

            $SessionManagementModel->create(
                $audUserId,      // ← si existe, va el real; si no, null
                $audUserType,    // ← administrator/user según nivel si lo conocemos
                $deviceId,
                $deviceType,
                false,
                'Demasiados intentos fallidos'
            );

            $this->jsonResponse(false, "Demasiados intentos. Intente nuevamente en {$espera} minuto(s).", ['espera_minutos' => $espera], 429);
            return;
        }

        /* ───── VALIDACIONES INICIALES ───── */
        if ($email === '' || $password === '') {
            $SessionManagementModel->create(null, $userTypeDef, $deviceId, $deviceType, false, 'Correo y/o contraseña vacíos');
            $intentos['count']++;
            $intentos['last_attempt'] = $ahora;
            if ($intentos['count'] >= $maxIntentos) {
                $intentos['locked_until'] = $ahora + $tiempoBloqueo;
            }
            $_SESSION[$keyIntentos] = $intentos;
            $this->jsonResponse(false, 'Correo y contraseña son obligatorios.', null, 400);
            return;
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $SessionManagementModel->create(null, $userTypeDef, $deviceId, $deviceType, false, 'Formato de correo inválido');
            $intentos['count']++;
            $intentos['last_attempt'] = $ahora;
            if ($intentos['count'] >= $maxIntentos) {
                $intentos['locked_until'] = $ahora + $tiempoBloqueo;
            }
            $_SESSION[$keyIntentos] = $intentos;
            $this->jsonResponse(false, 'El formato del correo electrónico no es válido.', null, 400);
            return;
        }

        /* ───── AUTENTICACIÓN con contrato loginBasico (ok/code/user) ───── */
        try {
            $result = $this->model->loginBasico($email, $password);

            if (!$result['ok']) {
                $code = $result['code'] ?? 'unknown';
                $u = $result['user'] ?? null;

                if ($code === 'user_not_found') {
                    $SessionManagementModel->create(null, $userTypeDef, $deviceId, $deviceType, false, 'Usuario no encontrado');
                    $this->jsonResponse(false, 'Credenciales inválidas.', null, 401);
                    return;
                }

                if ($code === 'user_disabled') {
                    $nivel = (int) ($u['nivel'] ?? 1);
                    $userType = ($nivel === 0) ? 'administrator' : 'user';
                    $SessionManagementModel->create($u['user_id'], $userType, $deviceId, $deviceType, false, 'Usuario desactivado');
                    $this->jsonResponse(false, 'Este usuario ha sido desactivado y no puede ingresar.', null, 403);
                    return;
                }

                if ($code === 'invalid_password') {
                    // ❗ Contraseña incorrecta: ya tenemos user_id y nivel → auditar con datos reales
                    $nivel = (int) ($u['nivel'] ?? 1);
                    $userType = ($nivel === 0) ? 'administrator' : 'user';
                    $SessionManagementModel->create($u['user_id'], $userType, $deviceId, $deviceType, false, 'Contraseña incorrecta');

                    // rate-limit
                    $intentos['count']++;
                    $intentos['last_attempt'] = $ahora;
                    if ($intentos['count'] >= $maxIntentos) {
                        $intentos['locked_until'] = $ahora + $tiempoBloqueo;
                    }
                    $_SESSION[$keyIntentos] = $intentos;

                    $this->jsonResponse(false, 'Contraseña incorrecta.', null, 401);
                    return;
                }

                // Fallback
                $SessionManagementModel->create($u['user_id'] ?? null, $userTypeDef, $deviceId, $deviceType, false, 'Fallo de autenticación');
                $this->jsonResponse(false, 'No se pudo iniciar sesión.', null, 401);
                return;
            }

            // ✅ Éxito
            unset($_SESSION[$keyIntentos]);
            $usuario = $result['user'];
            $nivel = (int) $usuario['nivel'];
            $userType = ($nivel === 0) ? 'administrator' : 'user';

            $_SESSION['logged_in'] = true;
            $_SESSION['user_id'] = $usuario['user_id'];
            $_SESSION['nombre'] = $usuario['nombre'] ?? 'Usuario';
            $_SESSION['nivel'] = $nivel;
            $_SESSION['user_type'] = $userType;

            $stmtTipo = \Database::getInstance()->prepare("SELECT tipo FROM centros WHERE id = ?");
            $stmtTipo->bind_param('i', $usuario['user_id']);
            $stmtTipo->execute();
            $rowTipo = $stmtTipo->get_result()->fetch_assoc();
            $_SESSION['tipo'] = $rowTipo['tipo'];
            $stmtTipo->close();

            if ($nivel === 0) {
                $_SESSION['permisos'] = ['*'];
            } else {
                $permisosModel = new \UsersPermisosModel(); // Usar \ si hay namespace
                $permisos = $permisosModel->listarPermisosConMenu($usuario['user_id']);
                if (empty($permisos)) {
                    $SessionManagementModel->create($usuario['user_id'], $userType, $deviceId, $deviceType, false, 'Sin permisos asignados');
                    $this->jsonResponse(false, 'El usuario no tiene permisos asignados.', null, 403);
                    return;
                }
                $_SESSION['permisos'] = array_map(fn($p) => $p['menu']['url'] ?? '', $permisos);
            }

            // --- MODIFICACIÓN: Capturar respuesta array ---
            $sessionData = $SessionManagementModel->create(
                $usuario['user_id'],
                $userType,
                $deviceId,
                $deviceType,
                true,
                null
            );

            $sessionId = $sessionData['session_id'];
            $token = $sessionData['token'];

            $_SESSION['session_id'] = $sessionId;

            // --- MODIFICACIÓN: Añadir token y session_id a la respuesta ---
            $responseData = $usuario;
            $responseData['session_id'] = $sessionId;
            $responseData['token'] = $token;

            $this->jsonResponse(true, 'Inicio de sesión exitoso.', $responseData);
        } catch (\Throwable $e) {
            error_log("Error en login: " . $e->getMessage());
            $nivelAudit = isset($usuario['nivel']) ? (int) $usuario['nivel'] : 1;
            $userTypeAudit = ($nivelAudit === 0) ? 'administrator' : 'user';
            $SessionManagementModel->create($usuario['user_id'] ?? null, $userTypeAudit, $deviceId, $deviceType, false, 'Error inesperado: ' . $e->getMessage());
            $this->jsonResponse(false, 'Error al iniciar sesión: ' . $e->getMessage(), null, 500);
        }
    }

    public function checkEmail()
    {
        $email = $_POST['email'] ?? '';
        if ($email === '') {
            $this->jsonResponse(false, 'El parámetro email es obligatorio.', null, 400);
        }

        try {
            $exists = $this->model->obtenerPorEmail($email);
            if ($exists) {
                $this->jsonResponse(true, 'El email ya está en uso.', ['exists' => true]);
            } else {
                $this->jsonResponse(false, 'El email está disponible.', ['exists' => false]);
            }
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al verificar email: ' . $e->getMessage(), null, 500);
        }
    }






    // POST /system-users/logout
    // POST /system-users/logout
    public function logout(): void
    {
        try {
            $ok = $this->model->logout();

            // Redirigir al inicio de sesión o a la página principal
            $baseUrl = defined('BASE_URL') ? BASE_URL : '/';
            header("Location: " . $baseUrl);
            exit;
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al cerrar sesión: ' . $e->getMessage(), null, 500);
        }
    }



    // GET /system-users?limit=&offset=&incluirEliminados=0|1
    public function listar(): void
    {
        $limit = isset($_GET['limit']) ? (int) $_GET['limit'] : 10000;
        $offset = isset($_GET['offset']) ? (int) $_GET['offset'] : 0;
        $incluir = isset($_GET['incluirEliminados']) ? ((int) $_GET['incluirEliminados'] === 1) : false;

        try {
            $data = $this->model->listar($limit, $offset, $incluir);
            $this->jsonResponse(true, 'Listado obtenido correctamente.', $data);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al listar: ' . $e->getMessage(), null, 500);
        }
    }

    // GET /system-users/show?user_id=UUID
    public function mostrar($parametros): void
    {
        $userId = $parametros['user_id'];
        if ($userId === '') {
            $this->jsonResponse(false, 'Parámetro user_id es obligatorio.', null, 400);
        }

        try {
            $row = $this->model->obtenerPorId($userId);
            if (!$row)
                $this->jsonResponse(false, 'Usuario no encontrado.', null, 404);
            $this->jsonResponse(true, 'Usuario encontrado.', $row);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al obtener usuario: ' . $e->getMessage(), null, 500);
        }
    }

    // POST /system-users/create
    // JSON: { nombre, email, contrasena, nivel, estado? }
    public function crear(): void
    {
        $in = $this->getJsonInput();
        try {
            $uuid = $this->model->crear($in);
            $this->jsonResponse(true, 'Usuario creado correctamente.', ['user_id' => $uuid]);
        } catch (InvalidArgumentException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (RuntimeException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 409);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al crear usuario: ' . $e->getMessage(), null, 500);
        }
    }

    // PUT/PATCH /system-users/update?user_id=UUID
    // JSON: { nombre?, email?, contrasena?, nivel?, estado? }
    public function actualizar($parametros): void
    {
        $userId = $parametros['user_id'] ?? '';
        if ($userId === '') {
            $this->jsonResponse(false, 'Parámetro user_id es obligatorio.', null, 400);
        }

        $in = $this->getJsonInput();
        try {
            $ok = $this->model->actualizar($userId, $in);
            $this->jsonResponse(true, 'Usuario actualizado correctamente.', ['updated' => $ok]);
        } catch (InvalidArgumentException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (RuntimeException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 409);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al actualizar usuario: ' . $e->getMessage(), null, 500);
        }
    }

    // PATCH /system-users/status?user_id=UUID
    // JSON: { estado: 0|1 }
    public function actualizarEstado($parametros): void
    {
        $userId = $parametros['user_id'] ?? '';
        if ($userId === '') {
            $this->jsonResponse(false, 'Parámetro user_id es obligatorio.', null, 400);
        }
        $in = $this->getJsonInput();
        if (!isset($in['estado'])) {
            $this->jsonResponse(false, 'El campo estado es obligatorio.', null, 400);
        }

        try {
            $ok = $this->model->actualizarEstado($userId, (int) $in['estado']);
            $this->jsonResponse(true, 'Estado actualizado correctamente.', ['updated' => $ok]);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al actualizar estado: ' . $e->getMessage(), null, 500);
        }
    }

    // DELETE (soft) /system-users/delete?user_id=UUID
    public function eliminar($parametros): void
    {
        $userId = $parametros['user_id'] ?? '';
        if ($userId === '') {
            $this->jsonResponse(false, 'Parámetro user_id es obligatorio.', null, 400);
        }

        try {
            $ok = $this->model->eliminar($userId);
            if (!$ok)
                $this->jsonResponse(false, 'No se pudo eliminar (o ya estaba eliminado).', null, 400);
            $this->jsonResponse(true, 'Usuario eliminado correctamente.', ['deleted' => true]);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al eliminar usuario: ' . $e->getMessage(), null, 500);
        }
    }

    /**
     * Devuelve la información del usuario actualmente autenticado en la sesión.
     * Ideal para poblar vistas de perfil de usuario.
     */
    public function perfil(): void
    {
        // 1. Verificar si hay una sesión activa
        if (!isset($_SESSION['user_id']) || !isset($_SESSION['logged_in'])) {
            $this->jsonResponse(false, 'No autorizado. Se requiere inicio de sesión.', null, 401);
            return;
        }

        try {
            $userId = $_SESSION['user_id'];

            // 2. Obtener los datos frescos del usuario desde la BD usando el modelo
            //
            $usuario = $this->model->obtenerPorId($userId);

            if (!$usuario) {
                // Esto podría pasar si el usuario fue eliminado mientras su sesión estaba activa
                $this->model->logout(); // Limpiar la sesión rota
                $this->jsonResponse(false, 'Usuario de sesión no encontrado. Se ha cerrado la sesión.', null, 404);
                return;
            }

            // 3. Obtener los permisos de la sesión
            // (Estos se cargaron y guardaron en la sesión durante el login)
            $permisos = $_SESSION['permisos'] ?? [];

            // 4. Combinar los datos para la respuesta
            // Nota: 'obtenerPorId' no incluye el hash de contraseña, lo cual es seguro.
            $data = [
                'user_id' => $usuario['user_id'],
                'nombre' => $usuario['nombre'],
                'email' => $usuario['email'],
                'nivel' => (int) $usuario['nivel'],
                'estado' => (int) $usuario['estado'],
                'dispositivo_token' => $usuario['dispositivo_token'], //
                'created_at' => $usuario['created_at'],
                'updated_at' => $usuario['updated_at'],
                'permisos' => $permisos // La lista de URLs/permisos de la sesión
            ];

            // 5. Responder
            $this->jsonResponse(true, 'Perfil de usuario obtenido.', $data, 200);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al obtener el perfil: ' . $e->getMessage(), null, 500);
        }
    }

    /**
     * POST /perfil
     * Actualiza el perfil del usuario autenticado.
     * Valida la contraseña actual si se intenta cambiar.
     */

    public function actualizarPerfil(): void
    {
        // 1. Verificar si hay una sesión activa
        if (!isset($_SESSION['user_id']) || !isset($_SESSION['logged_in'])) {
            $this->jsonResponse(false, 'No autorizado. Se requiere inicio de sesión.', null, 401);
            return;
        }

        $userId = $_SESSION['user_id'];
        $in = $this->getJsonInput();

        // 2. Obtener los datos del formulario
        $datosParaActualizar = [
            'nombre' => $in['nombre'] ?? null,
            'email' => $in['email'] ?? null,
        ];

        $contrasenaNueva = $in['contrasena'] ?? null;
        $contrasenaActual = $in['contrasena_actual'] ?? null;

        // 3. Validar campos básicos
        if (empty($datosParaActualizar['nombre']) || empty($datosParaActualizar['email'])) {
            $this->jsonResponse(false, 'El nombre y el email son obligatorios.', null, 400);
            return;
        }

        try {
            // 4. Lógica de cambio de contraseña
            if (!empty($contrasenaNueva)) {

                // 4a. Si quiere cambiarla, debe proveer la actual
                if (empty($contrasenaActual)) {
                    $this->jsonResponse(false, 'Debe proporcionar su contraseña actual para poder cambiarla.', null, 400); // 400 Bad Request
                    return;
                }

                // 4b. Obtener el usuario actual para verificar su hash
                // Usamos el método que ya existe en el modelo
                $usuarioActual = $this->model->obtenerPorId($userId);
                if (!$usuarioActual) {
                    $this->jsonResponse(false, 'Usuario de sesión no encontrado.', null, 404);
                    return;
                }

                // 4c. Verificar la contraseña actual
                // Usamos el helper del modelo: verificarPassword
                $esValida = $this->model->verificarPassword($usuarioActual, $contrasenaActual);

                if (!$esValida) {
                    $this->jsonResponse(false, 'La contraseña actual es incorrecta.', null, 403); // 403 Forbidden
                    return;
                }

                // 4d. Si la contraseña actual es válida, incluimos la NUEVA
                $datosParaActualizar['contrasena'] = $contrasenaNueva;
            }

            // 5. Actualizar los datos
            // El método 'actualizar' del modelo ya sabe cómo hashear la nueva contraseña si viene en el array.
            $this->model->actualizar($userId, $datosParaActualizar);

            // 6. Actualizar la sesión (si el nombre cambió)
            $_SESSION['nombre'] = $datosParaActualizar['nombre'];

            // 7. Responder con éxito (como espera perfil_view.js)
            $this->jsonResponse(true, 'Perfil actualizado correctamente.', [
                'nuevo_nombre' => $datosParaActualizar['nombre']
            ]);
        } catch (InvalidArgumentException $e) {
            // (p.ej. email duplicado)
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (RuntimeException $e) {
            // (p.ej. email duplicado)
            $this->jsonResponse(false, $e->getMessage(), null, 409);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al actualizar el perfil: ' . $e->getMessage(), null, 500);
        }
    }
}
