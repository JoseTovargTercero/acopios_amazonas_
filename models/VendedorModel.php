<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../helpers/UuidHelper.php';

class VendedorModel {
    private $db;
    public function __construct() { $this->db = Database::getInstance(); }

    public function listar(): array {
        $u = $_SESSION['user_id'] ?? '';
        $r = $this->db->query("SELECT id, nombre, cedula, telefono, nivel FROM vendedores WHERE usuario_id='$u' ORDER BY created_at DESC");
        return $r ? $r->fetch_all(MYSQLI_ASSOC) : [];
    }

    private function fill(&$d) {
        $d['nombre'] = trim($d['nombre'] ?? '');
        $d['cedula'] = trim($d['cedula'] ?? '');
        $d['telefono'] = trim($d['telefono'] ?? '');
        $d['nivel'] = (int)($d['nivel'] ?? 1);
        if (!$d['nombre'] || !$d['cedula']) throw new Exception('Nombre y cédula requeridos');
        if ($d['nivel'] < 1 || $d['nivel'] > 4) throw new Exception('Nivel inválido');
    }

    public function crear(array $d): string {
        $this->fill($d);
        $u = $_SESSION['user_id'] ?? '';
        $id = UuidHelper::generateUUIDv4();
        
        $stmt = $this->db->prepare("INSERT INTO vendedores (id, nombre, cedula, telefono, nivel, created_at, usuario_id) VALUES (?, ?, ?, ?, ?, NOW(), ?)");
        $stmt->bind_param('ssssis', $id, $d['nombre'], $d['cedula'], $d['telefono'], $d['nivel'], $u);
        $stmt->execute();
        return $id;
    }

    public function actualizar(string $id, array $d): bool {
        $this->fill($d);
        $stmt = $this->db->prepare("UPDATE vendedores SET nombre=?, cedula=?, telefono=?, nivel=? WHERE id=?");
        $stmt->bind_param('sssis', $d['nombre'], $d['cedula'], $d['telefono'], $d['nivel'], $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }

    public function eliminar(string $id): bool {
        $stmt = $this->db->prepare("DELETE FROM vendedores WHERE id=?");
        $stmt->bind_param('s', $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }
}
