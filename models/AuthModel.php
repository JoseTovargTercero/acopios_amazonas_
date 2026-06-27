<?php
require_once __DIR__ . '/../config/Database.php';

class AuthModel
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    /**
     * Valida credenciales contra la tabla centros.
     * Retorna el registro (id, nombre, codigo) si es válido, o null si no.
     */
    public function login(string $nombre, string $codigo): ?array
    {
        $sql = "SELECT id, nombre, codigo, tipo FROM centros WHERE nombre = ? AND codigo = ? LIMIT 1";
        $stmt = $this->db->prepare($sql);
        if (!$stmt) {
            throw new \RuntimeException("Error al preparar consulta: " . $this->db->error);
        }
        $stmt->bind_param('si', $nombre, $codigo);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        $stmt->close();
        return $row ?: null;
    }
}
