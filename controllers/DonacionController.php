<?php
namespace App\Controllers;

require_once __DIR__ . '/../models/DonacionModel.php';

class DonacionController
{
    private \DonacionModel $model;

    public function __construct()
    {
        $this->model = new \DonacionModel();
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
            $this->jsonResponse(false, 'No hay sesión activa de centro de acopio.', null, 401);
            return;
        }

        $donacion = $input['donacion'] ?? null;
        $insumos = $input['insumos'] ?? null;

        if (!$donacion || empty($insumos) || !is_array($insumos)) {
            $this->jsonResponse(false, 'Datos incompletos para registrar la donación e insumos.', null, 400);
            return;
        }

        try {
            $result = $this->model->crear($donacion, $insumos, (int)$centroId);
            
            if (!$result['ok']) {
                $this->jsonResponse(false, $result['message'], null, 400);
                return;
            }

            $this->jsonResponse(true, 'Donación y ' . count($insumos) . ' insumo(s) registrados correctamente.', ['id_donacion' => $result['id_donacion']]);
        } catch (\Throwable $e) {
            error_log("Error en DonacionController::crear: " . $e->getMessage());
            $this->jsonResponse(false, $e->getMessage(), null, 500);
        }
    }

    public function listar(): void
    {
        $centroId = $_SESSION['user_id'] ?? null;

        if (!$centroId) {
            $this->jsonResponse(false, 'No hay sesión activa.', null, 401);
            return;
        }

        try {
            $datos = $this->model->listarPorCentro((int)$centroId);
            $this->jsonResponse(true, 'Listado obtenido correctamente.', $datos);
        } catch (\Throwable $e) {
            error_log("Error en DonacionController::listar: " . $e->getMessage());
            $this->jsonResponse(false, 'Error al obtener el listado.', null, 500);
        }
    }

    public function listarTodas(): void
    {
        try {
            $datos = $this->model->listarTodas();
            $this->jsonResponse(true, 'Listado general obtenido correctamente.', $datos);
        } catch (\Throwable $e) {
            error_log("Error en DonacionController::listarTodas: " . $e->getMessage());
            $this->jsonResponse(false, 'Error al obtener el listado general.', null, 500);
        }
    }

    public function actualizarInsumo(): void
    {
        $input = json_decode(file_get_contents('php://input') ?: '', true) ?? [];
        $id = (int) ($input['id_insumo'] ?? 0);
        $categoria = trim((string) ($input['categoria'] ?? ''));
        $descripcion = trim((string) ($input['descripcion_insumo'] ?? ''));

        if ($id <= 0 || $categoria === '' || $descripcion === '') {
            $this->jsonResponse(false, 'Datos incompletos para actualizar el insumo.', null, 400);
            return;
        }

        try {
            $result = $this->model->actualizarInsumo($id, $categoria, $descripcion);
            if ($result['ok']) {
                $this->jsonResponse(true, 'Insumo actualizado correctamente.');
            } else {
                $this->jsonResponse(false, $result['message'], null, 400);
            }
        } catch (\Throwable $e) {
            error_log("Error en DonacionController::actualizarInsumo: " . $e->getMessage());
            $this->jsonResponse(false, 'Error al actualizar el insumo.', null, 500);
        }
    }

    public function listarCategorias(): void
    {
        try {
            $cats = $this->model->listarCategoriasDistinct();
            $this->jsonResponse(true, 'OK', $cats);
        } catch (\Throwable $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 500);
        }
    }

    public function renombrarCategoria(): void
    {
        $input = json_decode(file_get_contents('php://input') ?: '', true) ?? [];
        $vieja = trim((string) ($input['vieja'] ?? ''));
        $nueva = trim((string) ($input['nueva'] ?? ''));
        if ($vieja === '' || $nueva === '') {
            $this->jsonResponse(false, 'Faltan parámetros vieja/nueva.', null, 400);
            return;
        }
        try {
            $result = $this->model->renombrarCategoria($vieja, $nueva);
            if ($result['ok']) {
                $this->jsonResponse(true, "Categoría renombrada. {$result['afectados']} insumo(s) actualizado(s).");
            } else {
                $this->jsonResponse(false, $result['message'], null, 400);
            }
        } catch (\Throwable $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 500);
        }
    }

    public function eliminar($parametros): void
    {
        $id = (int) ($parametros['id'] ?? 0);
        if ($id <= 0) {
            $this->jsonResponse(false, 'ID de donación inválido.', null, 400);
            return;
        }
        try {
            $result = $this->model->eliminar($id);
            if ($result['ok']) {
                $this->jsonResponse(true, 'Donación eliminada correctamente.');
            } else {
                $this->jsonResponse(false, $result['message'], null, 400);
            }
        } catch (\Throwable $e) {
            error_log("Error en DonacionController::eliminar: " . $e->getMessage());
            $this->jsonResponse(false, 'Error al eliminar la donación.', null, 500);
        }
    }
}
