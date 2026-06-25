<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../config/TimezoneManager.php';

class EmpresaModel
{
    private $db;
    private $table = 'empresas';

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    // ponytail: audit helper reutilizado de otros modelos
    private function nowWithAudit(): string
    {
        $env     = new ClientEnvironmentInfo(APP_ROOT . '/app/config/geolite.mmdb');
        $actorId = $_SESSION['user_id'] ?? UuidHelper::generateUUIDv4();
        $env->applyAuditContext($this->db, $actorId);
        (new TimezoneManager($this->db))->applyTimezone();
        return $env->getCurrentDatetime();
    }



    // LISTAR CENTROS DE ACOPIO
    public function listar(): array
    {
        $sql = "SELECT * FROM centros";
        $res = $this->db->query($sql);
        $rows = $res->fetch_all(MYSQLI_ASSOC);
        return $rows;
    }
}
