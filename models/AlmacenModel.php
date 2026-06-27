<?php
require_once __DIR__ . '/../config/Database.php';

class AlmacenModel
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function crear(array $almacen, array $insumos, int $centroId): array
    {
        $this->db->begin_transaction();

        try {
            $rawGuia = $almacen['numero_guia_remision'] ?? '';
            $guiaRemision = ($rawGuia !== '' && strtoupper($rawGuia) !== 'N/A') ? $rawGuia : null;
            $transportista = !empty($almacen['nombre_transportista']) ? $almacen['nombre_transportista'] : null;
            $placa = !empty($almacen['placa_vehiculo']) ? $almacen['placa_vehiculo'] : null;

            if ($guiaRemision !== null) {
                $sqlCheck = "SELECT id_donacion FROM almacen WHERE numero_guia_remision = ?";
                $stmtCheck = $this->db->prepare($sqlCheck);
                $stmtCheck->bind_param('s', $guiaRemision);
                $stmtCheck->execute();
                if ($stmtCheck->get_result()->num_rows > 0) {
                    throw new \Exception("El número de guía de remisión ya está registrado.");
                }
                $stmtCheck->close();
            }

            $sql = "INSERT INTO almacen (fecha_hora_llegada, nombre_transportista, placa_vehiculo, numero_guia_remision, centro_acopio_id) VALUES (?, ?, ?, ?, ?)";
            $stmt = $this->db->prepare($sql);
            if (!$stmt) throw new \Exception("Error preparando consulta: " . $this->db->error);

            $stmt->bind_param(
                'ssssi',
                $almacen['fecha_hora_llegada'],
                $transportista,
                $placa,
                $guiaRemision,
                $centroId
            );
            $stmt->execute();
            $idAlmacen = $this->db->insert_id;
            $stmt->close();

            $sqlIns = "INSERT INTO almacen_insumos (id_donacion, codigo_item, categoria, descripcion_insumo, presentacion, unidades_por_presentacion, peso_por_unidad, unidad_medida, cantidad_manifestada, cantidad_recibida, estado, fecha_vencimiento, centro_acopio_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $stmtIns = $this->db->prepare($sqlIns);
            if (!$stmtIns) throw new \Exception("Error preparando consulta de insumos: " . $this->db->error);

            foreach ($insumos as $ins) {
                $peso = (float)$ins['peso_por_unidad'];
                $uni = (int)$ins['unidades_por_presentacion'];
                $manif = (int)$ins['cantidad_manifestada'];
                $recib = (int)$ins['cantidad_recibida'];
                $venc = empty($ins['fecha_vencimiento']) ? null : $ins['fecha_vencimiento'];
                $codigoItem = 'ALM-' . time() . '-' . rand(1000, 9999);
                $unidadMedida = 'N/A';

                $stmtIns->bind_param(
                    'isssssdisissi',
                    $idAlmacen,
                    $codigoItem,
                    $ins['categoria'],
                    $ins['descripcion_insumo'],
                    $ins['presentacion'],
                    $uni,
                    $peso,
                    $unidadMedida,
                    $manif,
                    $recib,
                    $ins['estado'],
                    $venc,
                    $centroId
                );
                $stmtIns->execute();
            }
            $stmtIns->close();

            $this->db->commit();
            return ['ok' => true, 'id_almacen' => $idAlmacen];

        } catch (\Exception $e) {
            $this->db->rollback();
            return ['ok' => false, 'message' => $e->getMessage()];
        }
    }

    public function listarTodas(): array
    {
        $sql = "SELECT a.*, c.nombre as centro_nombre 
                FROM almacen a
                INNER JOIN centros c ON a.centro_acopio_id = c.id
                ORDER BY a.fecha_hora_llegada DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $almacenRes = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        if (empty($almacenRes)) {
            return [];
        }

        $ids = array_column($almacenRes, 'id_donacion');
        $in = str_repeat('?,', count($ids) - 1) . '?';
        $sqlIns = "SELECT * FROM almacen_insumos WHERE id_donacion IN ($in)";
        $stmtIns = $this->db->prepare($sqlIns);
        $types = str_repeat('i', count($ids));
        $stmtIns->bind_param($types, ...$ids);
        $stmtIns->execute();
        $insumosRes = $stmtIns->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmtIns->close();

        $insumosPorAlmacen = [];
        foreach ($insumosRes as $ins) {
            $insumosPorAlmacen[$ins['id_donacion']][] = $ins;
        }

        foreach ($almacenRes as &$a) {
            $a['insumos'] = $insumosPorAlmacen[$a['id_donacion']] ?? [];
        }

        return $almacenRes;
    }
}
