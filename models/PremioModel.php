<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../helpers/UuidHelper.php';

class PremioModel {
    private $db;
    public function __construct() { $this->db = Database::getInstance(); }

    public function listar(): array {
        // Asumo que se lista filtrando por los premios del usuario actual (o empresas a las que tiene acceso).
        // Si hay una tabla empresas, podemos hacer un JOIN o simplemente ordenar por empresa_id.
        // Dado que la tabla solo tiene empresa_id, ordeno por eso.
        $r = $this->db->query("SELECT p.id, p.empresa_id, p.nombre, p.foto, p.valor, e.nombre as empresa_nombre 
                               FROM premios p 
                               LEFT JOIN empresas e ON p.empresa_id = e.id 
                               ORDER BY e.nombre ASC, p.nombre ASC");
        return $r ? $r->fetch_all(MYSQLI_ASSOC) : [];
    }

    private function fill(&$d) {
        $d['nombre'] = trim($d['nombre'] ?? '');
        $d['foto'] = trim($d['foto'] ?? '');
        $d['valor'] = (float)($d['valor'] ?? 0);
        if (!$d['nombre']) throw new Exception('Nombre requerido');
    }

    public function crear(array $d): string {
        $this->fill($d);
        $e = trim($d['empresa_id'] ?? '');
        if (!$e) throw new Exception('Empresa requerida');
        $id = UuidHelper::generateUUIDv4();
        
        $stmt = $this->db->prepare("INSERT INTO premios (id, empresa_id, nombre, foto, valor) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param('ssssd', $id, $e, $d['nombre'], $d['foto'], $d['valor']);
        $stmt->execute();
        return $id;
    }

    public function actualizar(string $id, array $d): bool {
        $this->fill($d);
        $stmt = $this->db->prepare("UPDATE premios SET nombre=?, foto=?, valor=? WHERE id=?");
        $stmt->bind_param('ssds', $d['nombre'], $d['foto'], $d['valor'], $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }

    public function eliminar(string $id): bool {
        $stmt = $this->db->prepare("DELETE FROM premios WHERE id=?");
        $stmt->bind_param('s', $id);
        $stmt->execute();
        return $stmt->affected_rows > 0;
    }
}
