<?php
require_once __DIR__ . '/config/Database.php';
$db = Database::getInstance();
$sql = "CREATE TABLE IF NOT EXISTS temporadas (
    id VARCHAR(36) PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    created_at DATETIME NOT NULL,
    empresa_id VARCHAR(36) NOT NULL,
    usuario_id VARCHAR(36) NOT NULL
)";
if ($db->query($sql)) {
    echo "Tabla temporadas creada con éxito\n";
} else {
    echo "Error: " . $db->error . "\n";
}
