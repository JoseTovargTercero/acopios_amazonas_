<?php
declare(strict_types=1);

namespace App\Helpers;

use Firebase\JWT\JWT;
use Database;
use Exception;

class PushNotificationHelper
{
    private $db;
    private string $serviceAccountPath;
    private string $projectId;

    public function __construct(string $serviceAccountPath, string $projectId)
    {
        if (!defined('APP_ROOT')) {
            define('APP_ROOT', dirname(__DIR__));
        }

        require_once  'php-jwt-main/src/JWT.php';
        require_once APP_ROOT . '/config/Database.php';

        $this->db = Database::getInstance();
        $this->serviceAccountPath = $serviceAccountPath;
        $this->projectId = $projectId;
    }

    /**
     * Envía una notificación push a un usuario específico.
     * 
     * @param string $userId UUID del usuario en system_users
     * @param string $title  Título del mensaje
     * @param string $body   Cuerpo del mensaje
     * @return bool Éxito o fallo
     */
    public function send(string $userId, string $title, string $body): bool
    {
        try {
            $deviceToken = $this->getDeviceToken($userId);
            if (!$deviceToken) {
                error_log("PushNotificationHelper: Usuario sin token ($userId)");
                return false;
            }

            if (!file_exists($this->serviceAccountPath)) {
                throw new Exception("Archivo service-account.json no encontrado en: {$this->serviceAccountPath}");
            }

            $serviceAccount = json_decode(file_get_contents($this->serviceAccountPath), true);
            if (!$serviceAccount) {
                throw new Exception("No se pudo leer el contenido de service-account.json");
            }

            // Crear JWT
            $now = time();
            $payload = [
                'iss'   => $serviceAccount['client_email'],
                'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
                'aud'   => 'https://oauth2.googleapis.com/token',
                'iat'   => $now,
                'exp'   => $now + 3600
            ];
            $jwt = JWT::encode($payload, $serviceAccount['private_key'], 'RS256');

            // Token de acceso
            $accessToken = $this->getAccessToken($jwt);
            if (!$accessToken) {
                throw new Exception("No se obtuvo token de acceso de Google");
            }

            // Enviar mensaje FCM
            $this->sendToFirebase($deviceToken, $accessToken, $title, $body);
            return true;

        } catch (Exception $e) {
            error_log("PushNotificationHelper: Excepción -> " . $e->getMessage());
            return false;
        }
    }

    /* ======================================================
       MÉTODOS PRIVADOS
    ====================================================== */

    private function getDeviceToken(string $userId): ?string
    {
        $stmt = $this->db->prepare("
            SELECT dispositivo_token 
            FROM system_users 
            WHERE user_id = ? 
              AND dispositivo_token IS NOT NULL 
              AND dispositivo_token != '' 
            LIMIT 1
        ");
        if (!$stmt) {
            error_log("PushNotificationHelper: Error preparando consulta token: " . $this->db->error);
            return null;
        }

        $stmt->bind_param('s', $userId);
        $stmt->execute();
        $res = $stmt->get_result();
        $row = $res->fetch_assoc();
        $stmt->close();

        return $row['dispositivo_token'] ?? null;
    }

    private function getAccessToken(string $jwt): ?string
    {
        $ch = curl_init('https://oauth2.googleapis.com/token');
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POSTFIELDS => http_build_query([
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion'  => $jwt,
            ])
        ]);

        $response = curl_exec($ch);
        if ($response === false) {
            error_log("PushNotificationHelper: Error CURL token: " . curl_error($ch));
            curl_close($ch);
            return null;
        }

        $data = json_decode($response, true);
        curl_close($ch);

        return $data['access_token'] ?? null;
    }

    private function sendToFirebase(string $deviceToken, string $accessToken, string $title, string $body): void
    {
        $url = "https://fcm.googleapis.com/v1/projects/{$this->projectId}/messages:send";
        $payload = [
            'message' => [
                'token' => $deviceToken,
                'notification' => [
                    'title' => $title,
                    'body'  => $body
                ]
            ]
        ];

        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_HTTPHEADER => [
                "Authorization: Bearer {$accessToken}",
                "Content-Type: application/json"
            ],
            CURLOPT_POSTFIELDS => json_encode($payload)
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode >= 400) {
            error_log("PushNotificationHelper: Error HTTP {$httpCode} enviando FCM: {$response}");
        }
    }
}
