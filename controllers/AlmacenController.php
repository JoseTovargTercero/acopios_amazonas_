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

    private function logError(int $centroId, string $error, array $payload): void
    {
        try {
            $db = \Database::getInstance();
            $json = json_encode($payload, JSON_UNESCAPED_UNICODE);
            $stmt = $db->prepare("INSERT INTO errores_json (centro_id, json_donacion_insumos, error) VALUES (?, ?, ?)");
            $stmt->bind_param('iss', $centroId, $json, $error);
            $stmt->execute();
            $stmt->close();
        } catch (\Throwable $logErr) {
            error_log("Error al guardar en errores_json: " . $logErr->getMessage());
        }
    }

    public function listarTodas(): void
    {
        try {
            $datos = $this->model->listarTodas();
            $this->jsonResponse(true, 'Listado general obtenido correctamente.', $datos);
        } catch (\Throwable $e) {
            error_log("Error en AlmacenController::listarTodas: " . $e->getMessage());
            $this->jsonResponse(false, 'Error al obtener el listado general.', null, 500);
        }
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
                $this->logError($centroId, $result['message'], $input);
            }
        } catch (\Throwable $e) {
            error_log("Error en AlmacenController::crear: " . $e->getMessage());
            $this->logError($centroId, $e->getMessage(), $input);
        }

        $this->jsonResponse(true, 'Ingreso a almacén y ' . count($insumos) . ' insumo(s) registrados correctamente.');
    }
}
