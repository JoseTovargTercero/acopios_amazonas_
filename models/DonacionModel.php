<?php
require_once __DIR__ . '/../config/Database.php';

class DonacionModel
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function crear(array $donacion, array $insumos, int $centroId): array
    {
        $this->db->begin_transaction();
        
        try {
            $guiaRemision = !empty($donacion['numero_guia_remision']) ? $donacion['numero_guia_remision'] : null;
            $transportista = !empty($donacion['nombre_transportista']) ? $donacion['nombre_transportista'] : null;
            $placa = !empty($donacion['placa_vehiculo']) ? $donacion['placa_vehiculo'] : null;

            // Validar si existe guia de remisión, sólo si no está vacía
            if ($guiaRemision !== null) {
                $sqlCheck = "SELECT id_donacion FROM donacion WHERE numero_guia_remision = ?";
                $stmtCheck = $this->db->prepare($sqlCheck);
                $stmtCheck->bind_param('s', $guiaRemision);
                $stmtCheck->execute();
                if ($stmtCheck->get_result()->num_rows > 0) {
                    throw new \Exception("El número de guía de remisión ya está registrado.");
                }
                $stmtCheck->close();
            }

            // Insertar donacion
            $sql = "INSERT INTO donacion (fecha_hora_llegada, organizacion_donante, nombre_transportista, placa_vehiculo, numero_guia_remision, centro_acopio_id) VALUES (?, ?, ?, ?, ?, ?)";
            $stmt = $this->db->prepare($sql);
            if (!$stmt) throw new \Exception("Error preparando consulta de donación: " . $this->db->error);
            
            $stmt->bind_param(
                'sssssi',
                $donacion['fecha_hora_llegada'],
                $donacion['organizacion_donante'],
                $transportista,
                $placa,
                $guiaRemision,
                $centroId
            );
            $stmt->execute();
            $idDonacion = $this->db->insert_id;
            $stmt->close();

            // Insertar insumos (arreglo)
            $sqlIns = "INSERT INTO insumos (id_donacion, codigo_item, categoria, descripcion_insumo, presentacion, unidades_por_presentacion, peso_por_unidad, unidad_medida, cantidad_manifestada, cantidad_recibida, estado, fecha_vencimiento, centro_acopio_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $stmtIns = $this->db->prepare($sqlIns);
            if (!$stmtIns) throw new \Exception("Error preparando consulta de insumos: " . $this->db->error);

            foreach ($insumos as $ins) {
                $peso = (float)$ins['peso_por_unidad'];
                $uni = (int)$ins['unidades_por_presentacion'];
                $manif = (int)$ins['cantidad_manifestada'];
                $recib = (int)$ins['cantidad_recibida'];
                $venc = empty($ins['fecha_vencimiento']) ? null : $ins['fecha_vencimiento'];
                $codigoItem = 'ITM-' . time() . '-' . rand(1000, 9999);
                $unidadMedida = 'N/A'; // Por defecto, o podrías pedirlo en el form

                $stmtIns->bind_param(
                    'isssssdisissi',
                    $idDonacion,
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
            return ['ok' => true, 'id_donacion' => $idDonacion];

        } catch (\Exception $e) {
            $this->db->rollback();
            return ['ok' => false, 'message' => $e->getMessage()];
        }
    }

    public function listarPorCentro(int $centroId): array
    {
        $sql = "SELECT * FROM donacion WHERE centro_acopio_id = ? ORDER BY fecha_hora_llegada DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->bind_param('i', $centroId);
        $stmt->execute();
        $donacionesRes = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        if (empty($donacionesRes)) {
            return [];
        }

        // Obtener insumos
        $ids = array_column($donacionesRes, 'id_donacion');
        $in = str_repeat('?,', count($ids) - 1) . '?';
        $sqlIns = "SELECT * FROM insumos WHERE id_donacion IN ($in)";
        $stmtIns = $this->db->prepare($sqlIns);
        $types = str_repeat('i', count($ids));
        $stmtIns->bind_param($types, ...$ids);
        $stmtIns->execute();
        $insumosRes = $stmtIns->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmtIns->close();

        // Agrupar insumos
        $insumosPorDonacion = [];
        foreach ($insumosRes as $ins) {
            $insumosPorDonacion[$ins['id_donacion']][] = $ins;
        }

        // Integrar insumos a donaciones
        foreach ($donacionesRes as &$don) {
            $don['insumos'] = $insumosPorDonacion[$don['id_donacion']] ?? [];
        }

        return $donacionesRes;
    }

    public function listarTodas(): array
    {
        $sql = "SELECT d.*, c.nombre as centro_nombre 
                FROM donacion d
                INNER JOIN centros c ON d.centro_acopio_id = c.id
                ORDER BY d.fecha_hora_llegada DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $donacionesRes = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmt->close();

        if (empty($donacionesRes)) {
            return [];
        }

        // Obtener insumos
        $ids = array_column($donacionesRes, 'id_donacion');
        $in = str_repeat('?,', count($ids) - 1) . '?';
        $sqlIns = "SELECT * FROM insumos WHERE id_donacion IN ($in)";
        $stmtIns = $this->db->prepare($sqlIns);
        $types = str_repeat('i', count($ids));
        $stmtIns->bind_param($types, ...$ids);
        $stmtIns->execute();
        $insumosRes = $stmtIns->get_result()->fetch_all(MYSQLI_ASSOC);
        $stmtIns->close();

        // Agrupar insumos
        $insumosPorDonacion = [];
        foreach ($insumosRes as $ins) {
            $insumosPorDonacion[$ins['id_donacion']][] = $ins;
        }

        // Integrar insumos a donaciones
        foreach ($donacionesRes as &$don) {
            $don['insumos'] = $insumosPorDonacion[$don['id_donacion']] ?? [];
        }

        return $donacionesRes;
    }
}
