<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../helpers/UuidHelper.php';

class TemporadaModel {
    private $db;
    public function __construct() { $this->db = Database::getInstance(); }

    public function listar(): array {
        $u = $_SESSION['user_id'] ?? '';
        $r = $this->db->query("SELECT id, nombre, fecha_inicio, fecha_fin, empresa_id FROM temporadas WHERE usuario_id='$u'");
        return $r ? $r->fetch_all(MYSQLI_ASSOC) : [];
    }

    public function crear(array $d): string {
        $n = trim($d['nombre'] ?? '');
        $fi = trim($d['fecha_inicio'] ?? '');
        $ff = trim($d['fecha_fin'] ?? '');
        $e = trim($d['empresa_id'] ?? '');
        $u = $_SESSION['user_id'] ?? '';

        if (!$n || !$fi || !$ff || !$e) throw new Exception('Faltan datos');
        if ($fi >= $ff) throw new Exception('Fechas inválidas (inicio >= fin)');

        $id = UuidHelper::generateUUIDv4();
        $stmt = $this->db->prepare("INSERT INTO temporadas (id, nombre, fecha_inicio, fecha_fin, created_at, empresa_id, usuario_id) VALUES (?, ?, ?, ?, NOW(), ?, ?)");
        $stmt->bind_param('ssssss', $id, $n, $fi, $ff, $e, $u);
        $stmt->execute();
        return $id;
    }

    public function actualizar(string $id, array $d): bool {
        $n = trim($d['nombre'] ?? '');
        $fi = trim($d['fecha_inicio'] ?? '');
        $ff = trim($d['fecha_fin'] ?? '');

        if (!$n || !$fi || !$ff) throw new Exception('Faltan datos');
        if ($fi >= $ff) throw new Exception('Fechas inválidas (inicio >= fin)');

        $stmt = $this->db->prepare("UPDATE temporadas SET nombre=?, fecha_inicio=?, fecha_fin=? WHERE id=?");
        $stmt->bind_param('ssss', $n, $fi, $ff, $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }

    public function eliminar(string $id): bool {
        $stmt = $this->db->prepare("DELETE FROM temporadas WHERE id=?");
        $stmt->bind_param('s', $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }
}
