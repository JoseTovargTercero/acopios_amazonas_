<?php
require_once __DIR__ . '/../models/EmpresaModel.php';

class EmpresaController
{
    private $model;

    public function __construct()
    {
        $this->model = new EmpresaModel();
    }

    // ponytail: helpers reutilizados de MenuController
    private function json($value, string $msg = '', $data = null, int $code = 200): void
    {
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode(['value' => $value, 'message' => $msg, 'data' => $data]);
        exit;
    }

    private function input(): array
    {
        $raw = file_get_contents('php://input') ?: '';
        $j   = json_decode($raw, true);
        return is_array($j) ? $j : [];
    }

    // GET /api/empresas
    public function listar(): void
    {
        try {
            $this->json(true, 'OK', $this->model->listar());
        } catch (Throwable $e) {
            $this->json(false, $e->getMessage(), null, 500);
        }
    }
}
