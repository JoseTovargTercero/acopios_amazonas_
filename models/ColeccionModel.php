<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../helpers/UuidHelper.php';

class ColeccionModel
{
    private $db;
    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function listar(): array
    {
        $u = $_SESSION['user_id'] ?? '';
        $r = $this->db->query("SELECT id, empresa_id, nombre, foto, precio_base, precio_venta_vendedor, ganancia_vendedor, tipo FROM colecciones_combos WHERE usuario_id='$u'");
        return $r ? $r->fetch_all(MYSQLI_ASSOC) : [];
    }

    private function fill(&$d)
    {
        $d['nombre'] = trim($d['nombre'] ?? '');
        $d['foto'] = trim($d['foto'] ?? '');
        $d['tipo'] = trim($d['tipo'] ?? 'coleccion');
        $d['precio_base'] = (float)($d['precio_base'] ?? 0);
        $d['precio_venta_vendedor'] = (float)($d['precio_venta_vendedor'] ?? 0);
        $d['ganancia_vendedor'] = (float)($d['ganancia_vendedor'] ?? 0);
        if ($d['tipo'] === 'combo') $d['precio_venta_vendedor'] = $d['precio_base'];
        if (!$d['nombre']) throw new Exception('Nombre requerido');
    }

    public function crear(array $d): string
    {
        $this->fill($d);
        $e = trim($d['empresa_id'] ?? '');
        if (!$e) throw new Exception('Empresa requerida');
        $u = $_SESSION['user_id'] ?? '';
        $id = UuidHelper::generateUUIDv4();

        $stmt = $this->db->prepare("INSERT INTO colecciones_combos (id, empresa_id, nombre, foto, precio_base, precio_venta_vendedor, ganancia_vendedor, tipo, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param('ssssdddss', $id, $e, $d['nombre'], $d['foto'], $d['precio_base'], $d['precio_venta_vendedor'], $d['ganancia_vendedor'], $d['tipo'], $u);
        $stmt->execute();
        return $id;
    }

    public function actualizar(string $id, array $d): bool
    {
        $this->fill($d);

        $stmt = $this->db->prepare("UPDATE colecciones_combos SET nombre=?, foto=?, precio_base=?, precio_venta_vendedor=?, ganancia_vendedor=?, tipo=? WHERE id=?");
        $stmt->bind_param('ssddsss', $d['nombre'], $d['foto'], $d['precio_base'], $d['precio_venta_vendedor'], $d['ganancia_vendedor'], $d['tipo'], $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }

    public function eliminar(string $id): bool
    {
        $stmt = $this->db->prepare("DELETE FROM colecciones_combos WHERE id=?");
        $stmt->bind_param('s', $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }
}
