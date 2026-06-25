<?php
require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../helpers/UuidHelper.php';

class AsignacionModel
{
    private $db;
    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function listar(): array
    {
        $r = $this->db->query(
            "SELECT ac.id, ac.fecha_asignacion, ac.estado, ac.created_at,
                    v.nombre as vendedor_nombre, v.cedula as vendedor_cedula,
                    cc.nombre as coleccion_nombre, cc.tipo as coleccion_tipo,
                    cc.precio_venta_vendedor,
                    t.nombre as temporada_nombre
             FROM asignaciones_colecciones ac
             LEFT JOIN vendedores v ON ac.vendedor_id = v.id
             LEFT JOIN colecciones_combos cc ON ac.coleccion_combo_id = cc.id
             LEFT JOIN temporadas t ON ac.temporada_id = t.id
             ORDER BY ac.created_at DESC"
        );
        return $r ? $r->fetch_all(MYSQLI_ASSOC) : [];
    }

    public function crear(array $d): string
    {
        // Forzamos el casteo a INT (si tu BD usa IDs numéricos)
        $vendedor_id   = isset($d['vendedor_id']) ? (int)$d['vendedor_id'] : 0;
        $coleccion_id  = isset($d['coleccion_id']) ? (int)$d['coleccion_id'] : 0;
        $temporada_id  = isset($d['temporada_id']) ? (int)$d['temporada_id'] : 0;

        $fecha_asig    = trim($d['fecha_asignacion'] ?? '');
        $cuotas        = $d['cuotas'] ?? [];
        $u             = $_SESSION['user_id'] ?? '';

        if (!$vendedor_id || !$coleccion_id || !$temporada_id || !$fecha_asig)
            throw new Exception('Faltan datos obligatorios o son inválidos');
        if (empty($cuotas)) throw new Exception('Debe definir al menos una cuota');

        $this->db->begin_transaction();
        try {
            $stmt = $this->db->prepare(
                "INSERT INTO asignaciones_colecciones
                 (vendedor_id, coleccion_combo_id, temporada_id, estado, aplica_premio_especial, fecha_asignacion, usuario_id)
                 VALUES (?, ?, ?, 'activa', 0, ?, ?)"
            );

            // CORRECCIÓN 1: 'iiiss' ahora coincide exactamente con 3 enteros (i) y 2 strings (s)
            $stmt->bind_param('iiiss', $vendedor_id, $coleccion_id, $temporada_id, $fecha_asig, $u);

            if ($stmt->execute()) {
                $asignacion_id = $this->db->insert_id;
            } else {
                throw new Exception("Error al insertar asignación: " . $stmt->error);
            }

            $stmt->close();

            $stmt2 = $this->db->prepare(
                "INSERT INTO cuotas_coleccion
                 (asignacion_id, numero_cuota, porcentaje, monto_a_pagar, fecha_pago, fecha_vencimiento, estatus_pago, usuario_id)
                 VALUES (?, ?, ?, ?, ?, ?, 'pendiente', ?)"
            );

            foreach ($cuotas as $c) {
                $num           = (int)$c['numero'];
                $porcentaje    = (float)$c['porcentaje'];
                $monto         = (float)$c['monto'];
                $fecha_pago    = $c['fecha_pago'];
                $fecha_venc    = date('Y-m-d', strtotime($fecha_pago . ' +3 days'));

                // CORRECCIÓN 2: Si el asignacion_id es un INT autoincremental, el primer tipo debe ser 'i', no 's'
                // Cambiado de 'siddsss' a 'iiddsss'
                $stmt2->bind_param('iiddsss', $asignacion_id, $num, $porcentaje, $monto, $fecha_pago, $fecha_venc, $u);
                $stmt2->execute();
            }
            $stmt2->close();

            $this->db->commit();
            return (string)$asignacion_id;
        } catch (Exception $e) {
            $this->db->rollback();
            throw $e;
        }
    }
    public function eliminar(string $id): bool
    {
        $this->db->begin_transaction();
        try {
            $s1 = $this->db->prepare("DELETE FROM cuotas_coleccion WHERE asignacion_id=?");
            $s1->bind_param('s', $id);
            $s1->execute();
            $s1->close();

            $s2 = $this->db->prepare("DELETE FROM asignaciones_colecciones WHERE id=?");
            $s2->bind_param('s', $id);
            $s2->execute();
            $aff = $s2->affected_rows;
            $s2->close();

            $this->db->commit();
            return $aff > 0;
        } catch (Exception $e) {
            $this->db->rollback();
            throw $e;
        }
    }
}
