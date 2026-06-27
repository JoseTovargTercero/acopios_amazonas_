<?php
namespace App\Controllers;

require_once __DIR__ . '/../models/AlmacenModel.php';

class AlmacenController
{
    private \AlmacenModel $model;

    public function __construct()
    {
        $this->model = new \AlmacenModel();
    }

    private function jsonResponse(bool $value, string $message, $data = null, int $status = 200): void
    {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode(['value' => $value, 'message' => $message, 'data' => $data]);
        exit;
    }

    public function crear(): void
    {
        $input = json_decode(file_get_contents('php://input') ?: '', true) ?? [];
        $centroId = $_SESSION['user_id'] ?? null;

        if (!$centroId) {
            $this->jsonResponse(false, 'No hay sesión activa.', null, 401);
            return;
        }

        $almacen = $input['almacen'] ?? null;
        $insumos = $input['insumos'] ?? null;

        if (!$almacen || empty($insumos) || !is_array($insumos)) {
            $this->jsonResponse(false, 'Datos incompletos para registrar el ingreso a almacén.', null, 400);
            return;
        }

        try {
            $result = $this->model->crear($almacen, $insumos, (int)$centroId);

            if (!$result['ok']) {
                $this->jsonResponse(false, $result['message'], null, 400);
                return;
            }

            $this->jsonResponse(true, 'Ingreso a almacén y ' . count($insumos) . ' insumo(s) registrados correctamente.', ['id_almacen' => $result['id_almacen']]);
        } catch (\Throwable $e) {
            error_log("Error en AlmacenController::crear: " . $e->getMessage());
            $this->jsonResponse(false, 'Ocurrió un error al registrar el ingreso.', null, 500);
        }
    }
}
