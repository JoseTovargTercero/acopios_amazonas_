<?php

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../helpers/mailHelper.php';
require_once __DIR__ . '/../models/SystemUserModel.php';

class RecoveryPasswordController
{
    private $db;
    private $model;

    public function __construct()
    {
        $this->db    = Database::getInstance();
        $this->model = new SystemUserModel();
    }

    private function jsonResponse($value, string $message = '', $data = null, int $status = 200): void
    {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode([
            'value'   => $value,
            'message' => $message,
            'data'    => $data
        ]);
        exit;
    }

    /* ======================================================
     * 1) Enviar correo de recuperación (por email)
     *    POST: email
     * ====================================================== */
    public function verifyEmail(): void
    {
        $email = trim($_POST['email'] ?? '');

        if ($email === '') {
            $this->jsonResponse(false, 'El parámetro email es obligatorio.', null, 400);
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->jsonResponse(false, 'El formato del correo electrónico no es válido.', null, 400);
        }

        try {
            // Buscar usuario en system_users
            $user = $this->model->obtenerPorEmail($email);

            if (!$user || empty($user['user_id'])) {
                $this->jsonResponse(false, 'Email no encontrado.', null, 404);
            }

            // Verificar si ya se envió un token recientemente (menos de 10 minutos)
            $stmt = $this->db->prepare("SELECT created_at FROM password_resets WHERE email = ?");
            if ($stmt) {
                $stmt->bind_param("s", $email);
                $stmt->execute();
                $result = $stmt->get_result();
                $row    = $result->fetch_assoc();
                $stmt->close();

                if ($row) {
                    $createdAt = strtotime($row['created_at']);
                    $now       = time();
                    $diff      = $now - $createdAt;

                    if ($diff < 600) { // 600 segundos = 10 minutos
                        $this->jsonResponse(false, 'Ya se envió un correo de recuperación recientemente. Intente nuevamente en unos minutos.', null, 429);
                    }
                }
            }

            // Enviar correo con enlace de reseteo
            $emailSent = $this->sendPasswordResetEmail($email);

            if ($emailSent) {
                $this->jsonResponse(true, 'Se ha enviado un enlace de recuperación al correo indicado.', null, 200);
            } else {
                $this->jsonResponse(false, 'Ocurrió un error al enviar el correo de recuperación.', null, 500);
            }
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al procesar la recuperación: ' . $e->getMessage(), null, 500);
        }
    }

    /**
     * Genera token, lo guarda en password_resets y envía el correo.
     */
    private function sendPasswordResetEmail(string $email): bool
    {
        $token     = bin2hex(random_bytes(32));
        $createdAt = date('Y-m-d H:i:s');

        $sql = "INSERT INTO password_resets (email, token, created_at)
                VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE token = VALUES(token), created_at = VALUES(created_at)";

        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            error_log("Error al preparar password_resets: " . $this->db->error);
            return false;
        }

        $stmt->bind_param("sss", $email, $token, $createdAt);
        if (!$stmt->execute()) {
            error_log("Error al ejecutar password_resets: " . $stmt->error);
            $stmt->close();
            return false;
        }
        $stmt->close();

        // URL base de la app (ajusta APP_URL en tu entorno)
        $appUrl = rtrim($_ENV['APP_URL'] ?? (defined('BASE_URL') ? BASE_URL : 'https://localhost'), '/');

        // Ruta de recuperación: ajusta a la ruta real de tu vista de reset
        // por ejemplo: /reset-password, /recuperar-clave, etc.
        $resetLink = $appUrl . '/login?token_reset=' . urlencode($token);

        // Logo
        $logoBase = defined('BASE_URL') ? BASE_URL : ($appUrl . '/');
        $logoUrl  = $logoBase . 'public/assets/images/logo-dark.png';

        $subject = 'Restablece tu clave de acceso a tu cuenta';
        $body = "
        <body style='margin: 0; padding: 0; background-color: #f2f2f2;'>
            <div style='padding: 40px 0;'>
                <table align='center' width='100%' cellpadding='0' cellspacing='0'>
                    <tr>
                        <td align='center'>
                            <table style='max-width: 600px; background-color: #ffffff; border-radius: 8px; padding: 40px; font-family: sans-serif; color: #000000;'>
                                <tr>
                                    <td align='right'>
                                        <img src='{$logoUrl}' alt='Logo' style='height: 50px;' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <h2 style='margin-bottom: 10px;'>¿Restablecer tu contraseña?</h2>
                                        <p>Hemos recibido una solicitud para restablecer la contraseña de tu cuenta.</p>
                                        <p>Si realizaste esta solicitud, haz clic en el siguiente botón:</p>
                                        <p>
                                            <a href='{$resetLink}' style='background-color: #254a7e; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block; font-weight: bold;'>
                                                Restablecer contraseña
                                            </a>
                                        </p>
                                        <p>O copia y pega este enlace en tu navegador:</p>
                                        <p style='word-break: break-all;'><a href='{$resetLink}'>{$resetLink}</a></p>
                                        <p>Este enlace expirará en <strong>10 minutos</strong>.</p>
                                        <hr style='margin: 40px 0;'/>
                                        <p style='font-size: 12px; color: #666;'>
                                            Si no solicitaste este cambio, puedes ignorar este correo.
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </body>";

        $mailer = new MailHelper();
        return $mailer->sendMail($email, $subject, $body);
    }

    /* ======================================================
     * 2) Actualizar contraseña
     *    POST: new_password, token (obligatorio)
     *    Opcional: user_id (si quieres permitir reseteo directo desde panel)
     * ====================================================== */
    public function updatePassword(): void
    {
        $newPassword = trim($_POST['new_password'] ?? '');
        $userId      = $_POST['user_id'] ?? ($_POST['userId'] ?? null);
        $token       = $_POST['token'] ?? null;

        if ($newPassword === '') {
            $this->jsonResponse(false, 'La nueva contraseña es obligatoria.', null, 400);
        }

        if (strlen($newPassword) < 6) {
            $this->jsonResponse(false, 'La contraseña debe tener al menos 6 caracteres.', null, 400);
        }

        try {
            // Si NO viene user_id, usamos token (flujo clásico por correo)
            if (empty($userId)) {
                if (empty($token)) {
                    $this->jsonResponse(false, 'Falta el token de recuperación.', null, 400);
                }

                $stmt = $this->db->prepare("SELECT email, created_at FROM password_resets WHERE token = ?");
                if (!$stmt) {
                    $this->jsonResponse(false, 'Error interno al preparar la consulta del token.', null, 500);
                }

                $stmt->bind_param("s", $token);
                $stmt->execute();
                $result   = $stmt->get_result();
                $resetRow = $result->fetch_assoc();
                $stmt->close();

                if (!$resetRow) {
                    $this->jsonResponse(false, 'El enlace de recuperación es inválido o ya fue utilizado.', null, 400);
                }

                // Opcional: verificar expiración (10 minutos)
                $createdAt = strtotime($resetRow['created_at'] ?? 'now');
                if ((time() - $createdAt) > 600) {
                    $this->jsonResponse(false, 'El enlace de recuperación ha expirado. Solicita uno nuevo.', null, 400);
                }

                $email = $resetRow['email'] ?? null;
                if (!$email) {
                    $this->jsonResponse(false, 'No se pudo asociar el token a un usuario.', null, 400);
                }

                $user = $this->model->obtenerPorEmail($email);
                if (!$user || empty($user['user_id'])) {
                    $this->jsonResponse(false, 'No se encontró el usuario asociado al token.', null, 404);
                }

                $userId = $user['user_id'];
            }

            // En este punto debemos tener un userId válido
            if (empty($userId)) {
                $this->jsonResponse(false, 'No se pudo determinar el usuario para actualizar la contraseña.', null, 400);
            }

            // Hashear contraseña y actualizar en system_users
            $hash = password_hash($newPassword, PASSWORD_BCRYPT);
            if ($hash === false) {
                $this->jsonResponse(false, 'Error al encriptar la contraseña.', null, 500);
            }

            // updated_by: el propio usuario (self-service) o 0 si prefieres
            $updatedBy = $userId;

            $sql = "UPDATE system_users
                    SET contrasena = ?, updated_at = NOW(), updated_by = ?
                    WHERE user_id = ? AND deleted_at IS NULL";

            $stmt = $this->db->prepare($sql);
            if (!$stmt) {
                $this->jsonResponse(false, 'Error interno al preparar la actualización de contraseña.', null, 500);
            }

            $stmt->bind_param("sss", $hash, $updatedBy, $userId);
            $ok = $stmt->execute();
            $stmt->close();

            if (!$ok) {
                $this->jsonResponse(false, 'No se pudo actualizar la contraseña. Inténtalo nuevamente.', null, 500);
            }

            // Si vino token, borrar el registro de password_resets (ya usado)
            if (!empty($token)) {
                $del = $this->db->prepare("DELETE FROM password_resets WHERE token = ?");
                if ($del) {
                    $del->bind_param("s", $token);
                    $del->execute();
                    $del->close();
                }
            }

            // Enviar correo de aviso
            $user = $this->model->obtenerPorId($userId);
            $emailAviso = $user['email'] ?? null;
            if ($emailAviso) {
                $this->sendPasswordChangedEmail($emailAviso);
            }

            $this->jsonResponse(true, 'Contraseña actualizada correctamente. Ahora puedes iniciar sesión con tu nueva contraseña.', null, 200);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al actualizar contraseña: ' . $e->getMessage(), null, 500);
        }
    }

    /**
     * Enviar correo informando que la contraseña fue cambiada.
     */
    private function sendPasswordChangedEmail(string $email): bool
    {
        $appUrl   = rtrim($_ENV['APP_URL'] ?? (defined('BASE_URL') ? BASE_URL : 'https://localhost'), '/');
        $loginUrl = $appUrl . '/login';

        $logoBase = defined('BASE_URL') ? BASE_URL : ($appUrl . '/');
        $logoUrl  = $logoBase . 'public/assets/images/logo-dark.png';

        $subject = 'Tu Clave de acceso ha sido actualizada';
        $body = "
        <body style='margin:0; padding:0; background-color:#f2f2f2;'>
            <div style='padding: 40px 0;'>
                <table align='center' width='100%' cellpadding='0' cellspacing='0'>
                    <tr>
                        <td align='center'>
                            <table style='max-width:600px; background-color:#ffffff; border-radius:8px; padding:40px; font-family:sans-serif; color:#000000;'>
                                <tr>
                                    <td align='right'>
                                        <img src='{$logoUrl}' alt='Logo' style='height:50px;' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <h2>Tu contraseña ha sido actualizada</h2>
                                        <p>La contraseña de tu cuenta fue actualizada recientemente.</p>
                                        <p>Si tú realizaste este cambio, no necesitas hacer nada más.</p>
                                        <p>Si <strong>no</strong> reconoces este cambio, te recomendamos ingresar al sistema y cambiar tu contraseña nuevamente.</p>
                                        <p style='margin-top:20px;'>
                                            <a href='{$loginUrl}' style='background:#254a7e; color:white; padding:8px 18px; text-decoration:none; border-radius:4px;'>
                                                Ir al inicio de sesión
                                            </a>
                                        </p>
                                        <hr style='margin:40px 0;'/>
                                        <p style='font-size:12px; color:#666;'>
                                            Si tienes dudas, contacta al administrador del sistema.
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </body>";

        $mailer = new MailHelper();
        return $mailer->sendMail($email, $subject, $body);
    }
}
