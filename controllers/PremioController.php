<?php
require_once __DIR__ . '/../models/PremioModel.php';

class PremioController {
    private $m;
    public function __construct() { $this->m = new PremioModel(); }

    private function res($v, $m, $d=null, $c=200) {
        http_response_code($c); header('Content-Type: application/json');
        echo json_encode(['value'=>$v,'message'=>$m,'data'=>$d]); exit;
    }

    private function upload() {
        if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
            $ext = pathinfo($_FILES['foto']['name'], PATHINFO_EXTENSION);
            $name = uniqid() . '.' . $ext;
            $dir = __DIR__ . '/../uploads/premios/';
            if (!is_dir($dir)) mkdir($dir, 0777, true);
            if (move_uploaded_file($_FILES['foto']['tmp_name'], $dir . $name)) {
                return 'uploads/premios/' . $name;
            }
        }
        return null;
    }

    public function listar() {
        try { $this->res(true, 'OK', $this->m->listar()); }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 500); }
    }
    public function crear() {
        try {
            $d = $_POST;
            if (empty($d)) $d = json_decode(file_get_contents('php://input'), true) ?: [];
            $foto = $this->upload();
            if ($foto) $d['foto'] = $foto;
            $this->res(true, 'OK', ['id' => $this->m->crear($d)], 201);
        }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 400); }
    }
    public function actualizar($p) {
        if (!($id = $p['id'] ?? '')) $this->res(false, 'ID req', null, 400);
        try {
            $d = $_POST;
            if (empty($d)) $d = json_decode(file_get_contents('php://input'), true) ?: [];
            $foto = $this->upload();
            if ($foto) $d['foto'] = $foto; 
            if (!$foto && !empty($d['foto_actual'])) $d['foto'] = $d['foto_actual'];

            $this->res(true, 'OK', ['ok' => $this->m->actualizar($id, $d)]);
        }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 400); }
    }
    public function eliminar($p) {
        if (!($id = $p['id'] ?? '')) $this->res(false, 'ID req', null, 400);
        try { $this->res(true, 'OK', ['ok' => $this->m->eliminar($id)]); }
        catch (Throwable $e) { $this->res(false, $e->getMessage(), null, 500); }
    }
}
