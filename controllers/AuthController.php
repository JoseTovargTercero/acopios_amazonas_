<?php
require_once __DIR__ . '/../models/AuthModel.php';

class AuthController
{
    private AuthModel $model;

    public function __construct()
    {
        $this->model = new AuthModel();
    }

    private function json(bool $value, string $message, $data = null, int $status = 200): void
    {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode(['value' => $value, 'message' => $message, 'data' => $data]);
        exit;
    }

    public function login(): void
    {
        $input = json_decode(file_get_contents('php://input') ?: '', true) ?? [];
        $nombre = trim((string) ($input['nombre'] ?? ''));
        $codigo = (int) ($input['codigo'] ?? 0);

        if ($nombre === '' || $codigo === 0) {
            $this->json(false, 'El nombre y el código son obligatorios.', null, 400);
            return;
        }

        try {
            $centro = $this->model->login($nombre, $codigo);

            if (!$centro) {
                $this->json(false, 'Credenciales inválidas.', null, 401);
                return;
            }

            $_SESSION['logged_in'] = true;
            $_SESSION['user_id']   = $centro['id'];
            $_SESSION['nombre']    = $centro['nombre'];
            $_SESSION['codigo']    = $centro['codigo'];
            $_SESSION['tipo']      = $centro['tipo'] ?? null;

            $this->json(true, 'Inicio de sesión exitoso.', [
                'id'     => $centro['id'],
                'nombre' => $centro['nombre'],
                'codigo' => $centro['codigo'],
            ]);
        } catch (\Throwable $e) {
            error_log("Error en login: " . $e->getMessage());
            $this->json(false, 'Error al iniciar sesión.', null, 500);
        }
    }

    public function logout(): void
    {
        session_unset();
        session_destroy();
        $baseUrl = defined('BASE_URL') ? BASE_URL : '/';
        header('Location: ' . $baseUrl);
        exit;
    }
}
