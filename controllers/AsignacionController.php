<?php
require_once __DIR__ . '/../models/AsignacionModel.php';

class AsignacionController {
    private $m;
    public function __construct() { $this->m = new AsignacionModel(); }

    private function res($v, $m, $d=null, $c=200) {
        http_response_code($c); header('Content-Type: application/json');
        echo json_encode(['value'=>$v,'message'=>$m,'data'=>$d]); exit;
    }

    public function listar() {
        try { $this->res(true, 'OK', $this->m->listar()); }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 500); }
    }

    public function crear() {
        try {
            $d = json_decode(file_get_contents('php://input'), true) ?: [];
            if (empty($d)) $d = $_POST;
            $this->res(true, 'OK', ['id' => $this->m->crear($d)], 201);
        }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 400); }
    }

    public function eliminar($p) {
        if (!($id = $p['id'] ?? '')) $this->res(false, 'ID req', null, 400);
        try { $this->res(true, 'OK', ['ok' => $this->m->eliminar($id)]); }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 500); }
    }

    public function cuotas($p) {
        if (!($id = $p['id'] ?? '')) $this->res(false, 'ID req', null, 400);
        try { $this->res(true, 'OK', $this->m->listarCuotas($id)); }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 500); }
    }
}
