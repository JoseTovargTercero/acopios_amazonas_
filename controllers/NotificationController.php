<?php
require_once __DIR__ . '/../models/NotificationModel.php';

class NotificationController
{
    private $model;

    public function __construct()
    {
        $this->model = new NotificationModel();
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

    private function errorResponse(int $statusCode, string $message): void
    {
        http_response_code($statusCode);
        header('Content-Type: application/json');
        echo json_encode([
            'value' => false,
            'message' => $message,
            'data' => null
        ]);
        exit;
    }

    /* ================== Rutas (estilo AreaController) ================== */

    // GET /notifications?limit=&offset=&incluirEliminados=0|1&user_id=UUID&soloNuevas=0|1&soloNoLeidas=0|1
    public function listar(): void
    {
        $limit = isset($_GET['limit']) ? (int) $_GET['limit'] : 10000;
        $offset = isset($_GET['offset']) ? (int) $_GET['offset'] : 0;
        $incluir = isset($_GET['incluirEliminados']) ? ((int) $_GET['incluirEliminados'] === 1) : false;

        $userId = isset($_GET['user_id']) ? trim((string) $_GET['user_id']) : null;
        $soloNuevas = isset($_GET['soloNuevas']) ? (int) $_GET['soloNuevas'] : null;       // 0|1
        $soloNoLeidas = isset($_GET['soloNoLeidas']) ? (int) $_GET['soloNoLeidas'] : null;   // 0|1

        try {
            $data = $this->model->listar($limit, $offset, $incluir, $userId, $soloNuevas, $soloNoLeidas);
            $this->jsonResponse(true, 'Listado de notificaciones obtenido correctamente.', $data);
        } catch (InvalidArgumentException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al listar notificaciones: ' . $e->getMessage(), null, 500);
        }
    }

    // GET /notifications/mias?limit=&offset=&filtro=(all|unread)
    public function listarDeSesion(): void
    {
        // MODIFICADO: Valores por defecto para paginación y filtro
        $limit = isset($_GET['limit']) ? (int) $_GET['limit'] : 20;
        $offset = isset($_GET['offset']) ? (int) $_GET['offset'] : 0;
        $filtro = isset($_GET['filtro']) ? (string) $_GET['filtro'] : 'all'; // 'all' o 'unread'

        // Determina si filtramos por "soloNoLeidas"
        $soloNoLeidas = ($filtro === 'unread') ? 0 : null;

        try {
            // MODIFICADO: Pasa $soloNoLeidas al modelo
            $data = $this->model->listarDeUsuarioActual($limit, $offset, $soloNoLeidas);
            $this->jsonResponse(true, 'Listado de notificaciones del usuario en sesión obtenido correctamente.', $data);
        } catch (mysqli_sql_exception $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al listar notificaciones del usuario: ' . $e->getMessage(), null, 500);
        }
    }

    // --- NUEVO MÉTODO ---
    // GET /notifications/mias/conteos
    public function obtenerConteosDeSesion(): void
    {
        try {
            $sessionUserId = $_SESSION['user_id'] ?? $_SESSION['usuario_id'] ?? $_SESSION['administrator_id'] ?? null;
            if (!$sessionUserId) {
                $this->jsonResponse(false, 'No se encontró el user_id en sesión.', null, 400);
            }

            $counts = $this->model->obtenerConteos((string) $sessionUserId);
            $this->jsonResponse(true, 'Conteos de notificaciones obtenidos.', $counts);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al obtener conteos: ' . $e->getMessage(), null, 500);
        }
    }
    // --- FIN DEL NUEVO MÉTODO ---


    // GET /notifications/{notifications_id}
    public function mostrar(array $params): void
    {
        $id = $params['notifications_id'] ?? $params['id'] ?? '';
        if ($id === '') {
            $this->jsonResponse(false, 'Parámetro notifications_id es obligatorio.', null, 400);
        }

        try {
            $row = $this->model->obtenerPorId($id);
            if (!$row) {
                $this->jsonResponse(false, 'Notificación no encontrada.', null, 404);
            }
            $this->jsonResponse(true, 'Notificación encontrada.', $row);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al obtener notificación: ' . $e->getMessage(), null, 500);
        }
    }

    // POST /notifications
    public function crear(): void
    {
        $in = $this->getJsonInput();
        try {
            $uuid = $this->model->crear($in);
            $this->jsonResponse(true, 'Notificación creada correctamente.', ['notifications_id' => $uuid]);
        } catch (InvalidArgumentException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (RuntimeException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 409);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al crear notificación: ' . $e->getMessage(), null, 500);
        }
    }

    // PUT /notifications/{notifications_id}
    public function actualizar(array $params): void
    {
        $id = $params['notifications_id'] ?? $params['id'] ?? '';
        if ($id === '') {
            $this->jsonResponse(false, 'Parámetro notifications_id es obligatorio.', null, 400);
        }

        $in = $this->getJsonInput();
        try {
            $ok = $this->model->actualizar($id, $in);
            $this->jsonResponse(true, 'Notificación actualizada correctamente.', ['updated' => $ok]);
        } catch (InvalidArgumentException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (RuntimeException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 409);
        } catch (mysqli_sql_exception $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 404);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al actualizar notificación: ' . $e->getMessage(), null, 500);
        }
    }

    // PUT /notifications/{notifications_id}/flag/new
    public function actualizarNew(array $params): void
    {
        $id = $params['notifications_id'] ?? $params['id'] ?? '';
        if ($id === '') {
            $this->jsonResponse(false, 'Parámetro notifications_id es obligatorio.', null, 400);
        }

        $in = $this->getJsonInput();
        if (!isset($in['valor'])) {
            $this->jsonResponse(false, 'El campo valor es obligatorio (0|1).', null, 400);
        }

        try {
            $ok = $this->model->actualizarNew($id, (int) $in['valor']);
            $this->jsonResponse(true, 'Flag new actualizado correctamente.', ['updated' => $ok]);
        } catch (InvalidArgumentException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al actualizar flag new: ' . $e->getMessage(), null, 500);
        }
    }

    // PUT /notifications/{notifications_id}/flag/read_unread
    public function actualizarReadUnread(array $params): void
    {
        $id = $params['notifications_id'] ?? $params['id'] ?? '';
        if ($id === '') {
            $this->jsonResponse(false, 'Parámetro notifications_id es obligatorio.', null, 400);
        }

        $in = $this->getJsonInput();
        if (!isset($in['valor'])) {
            $this->jsonResponse(false, 'El campo valor es obligatorio (0|1).', null, 400);
        }

        try {
            $ok = $this->model->actualizarReadUnread($id, (int) $in['valor']);
            $this->jsonResponse(true, 'Flag read_unread actualizado correctamente.', ['updated' => $ok]);
        } catch (InvalidArgumentException $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 400);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al actualizar flag read_unread: ' . $e->getMessage(), null, 500);
        }
    }

    // PUT /notifications/marcar_todas_vistas
    public function marcarTodasComoVistas(): void
    {
        try {
            $sessionUserId = $_SESSION['user_id'] ?? $_SESSION['usuario_id'] ?? $_SESSION['administrator_id'] ?? null;
            if (!$sessionUserId) {
                $this->jsonResponse(false, 'No se encontró el user_id en sesión.', null, 400);
            }
            $ok = $this->model->marcarTodasComoVistas((string) $sessionUserId);
            $this->jsonResponse(true, 'Todas las notificaciones marcadas como vistas.', ['updated' => $ok]);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al marcar como vistas: ' . $e->getMessage(), null, 500);
        }
    }

    // PUT /notifications/marcar_todas_leidas
    public function marcarTodasComoLeidas(): void
    {
        try {
            $sessionUserId = $_SESSION['user_id'] ?? $_SESSION['usuario_id'] ?? $_SESSION['administrator_id'] ?? null;
            if (!$sessionUserId) {
                $this->jsonResponse(false, 'No se encontró el user_id en sesión.', null, 400);
            }
            $ok = $this->model->marcarTodasComoLeidas((string) $sessionUserId);
            $this->jsonResponse(true, 'Todas las notificaciones marcadas como leídas.', ['updated' => $ok]);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al marcar como leídas: ' . $e->getMessage(), null, 500);
        }
    }

    // DELETE /notifications/{notifications_id}
    public function eliminar(array $params): void
    {
        $id = $params['notifications_id'] ?? $params['id'] ?? '';
        if ($id === '') {
            $this->jsonResponse(false, 'Parámetro notifications_id es obligatorio.', null, 400);
        }

        try {
            $ok = $this->model->eliminar($id);
            if (!$ok) {
                $this->jsonResponse(false, 'No se pudo eliminar (o ya estaba eliminada).', null, 400);
            }
            $this->jsonResponse(true, 'Notificación eliminada correctamente.', ['deleted' => true]);
        } catch (mysqli_sql_exception $e) {
            $this->jsonResponse(false, $e->getMessage(), null, 404);
        } catch (Throwable $e) {
            $this->jsonResponse(false, 'Error al eliminar notificación: ' . $e->getMessage(), null, 500);
        }
    }
}