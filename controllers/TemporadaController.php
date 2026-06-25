<?php
require_once __DIR__ . '/../models/TemporadaModel.php';

class TemporadaController {
    private $m;
    public function __construct() { $this->m = new TemporadaModel(); }

    private function res($v, $m, $d=null, $c=200) {
        http_response_code($c); header('Content-Type: application/json');
        echo json_encode(['value'=>$v,'message'=>$m,'data'=>$d]); exit;
    }
    private function input() { return json_decode(file_get_contents('php://input'), true) ?: []; }

    public function listar() {
        try { $this->res(true, 'OK', $this->m->listar()); }
        catch (Exception $e) { $this->res(false, $e->getMessage(), null, 500); }
    }
    public function crear() {
        try { $this->res(true, 'OK', ['id' => $this->m->crear($this->input())], 201); }
        catch (Exception $e) { $this->res(false, $e->getMessage(), null, 400); }
    }
    public function actualizar($p) {
        if (!($id = $p['id'] ?? '')) $this->res(false, 'ID req', null, 400);
        try { $this->res(true, 'OK', ['ok' => $this->m->actualizar($id, $this->input())]); }
        catch (Exception $e) { $this->res(false, $e->getMessage(), null, 400); }
    }
    public function eliminar($p) {
        if (!($id = $p['id'] ?? '')) $this->res(false, 'ID req', null, 400);
        try { $this->res(true, 'OK', ['ok' => $this->m->eliminar($id)]); }
        catch (Exception $e) { $this->res(false, $e->getMessage(), null, 500); }
    }
}
