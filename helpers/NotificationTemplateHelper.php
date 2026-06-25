<?php
/**
 * NotificationTemplateHelper
 * PHP 7.4 compatible – Plantillas en ES para ERP_GANADO.
 *
 * Uso:
 *   $tpl = NotificationTemplateHelper::render('repro_revision_20_21_due', [
 *       'hembra_identificador' => 'H-0021',
 *       'dia' => 20,
 *       'fecha_programada' => '2025-11-05'
 *   ]);
 *   // $tpl['title'], $tpl['desc']
 *
 *   // Para armar registro para INSERT en `notifications`:
 *   $row = NotificationTemplateHelper::buildForInsert([
 *       'template_key'   => 'peso_fuera_rango',
 *       'template_params'=> ['animal_identificador'=>'A-001','peso'=>'12.4','rango'=>'10.2 - 11.0','edad_dias'=>'28','ideal'=>'10.6'],
 *       'route'          => '/animales?animal_id=...',
 *       'module'         => 'pesos',
 *       'rol'            => null,
 *       'user_id'        => 'cc81d1d4-....'
 *   ]);
 */

class NotificationTemplateHelper
{
    /** @var array<string, array{module:string,title:string,desc:string}> */
    private static $templates = [

    /* =========================
     * ACONTECIMIENTOS (Sanidad/Manejo)
     * (Nuevos templates basados en AcontecimientosModel)
     * ========================= */
    'acon_vacunacion_registrada' => [
        'module' => 'acontecimientos',
        'title'  => 'Vacunación registrada',
        'desc'   => 'Se aplicó la vacuna {{vacuna_nombre}} a {{detalle_animales}} el {{vacuna_fecha}}. (Dosis: {{vacuna_dosis}}).'
    ],
    'acon_deceso_registrado' => [
        'module' => 'acontecimientos',
        'title'  => 'Deceso registrado',
        'desc'   => 'Se registró el deceso de {{detalle_animales}} el {{deceso_fecha}}. Causa probable: {{deceso_causa}}.'
    ],
    'acon_revision_registrada' => [
        'module' => 'acontecimientos',
        'title'  => 'Revisión veterinaria registrada',
        'desc'   => 'Se registró una revisión veterinaria para {{detalle_animales}} el {{revision_fecha}} (Veterinario: {{revision_veterinario}}).'
    ],
    'acon_cuarentena_inicio' => [
        'module' => 'acontecimientos',
        'title'  => 'Inicio de cuarentena',
        'desc'   => 'Se puso en cuarentena a {{detalle_animales}} desde {{cuarentena_inicio}} hasta {{cuarentena_fin}}. Motivo: {{cuarentena_motivo}}.'
    ],
    'acon_tratamiento_registrado' => [
        'module' => 'acontecimientos',
        'title'  => 'Tratamiento registrado',
        'desc'   => 'Se registró un tratamiento ({{tratamiento_medicamento}}, Dosis: {{tratamiento_dosis}}) para {{detalle_animales}}.'
    ],
    'acon_brote_registrado' => [
        'module' => 'acontecimientos',
        'title'  => 'Alerta de brote/enfermedad',
        'desc'   => 'Se registró un brote de {{brote_tipo}} (Severidad: {{brote_severidad}}) afectando a {{detalle_animales}}.'
    ],
    'acon_limpieza_registrada' => [
        'module' => 'acontecimientos',
        'title'  => 'Saneamiento de área registrado',
        'desc'   => 'Se registró una limpieza/saneamiento el {{limpieza_fecha}} para {{detalle_areas}}.'
    ],


    /* =========================
     * REPRODUCCIÓN (REV 20/21, PROX PARTO 117)
     * ========================= */
    // REVISION 20/21 pendiente (día 20 o 21 desde 1ra monta del periodo)
    'repro_revision_20_21_due' => [
        'module' => 'reproduccion',
        'title'  => 'Revisión día {{dia}} pendiente',
        'desc'   => 'La hembra {{hembra_identificador}} tiene revisión programada para el día {{dia}} del ciclo ({{fecha_programada}}). Verificar celo o signos de preñez.'
    ],
    // Resultados de revisión 20/21 (tres variantes)
    'repro_revision_20_21_result_entro_celo' => [
        'module' => 'reproduccion',
        'title'  => 'Resultado revisión 20/21: Entró en celo',
        'desc'   => 'La hembra {{hembra_identificador}} entró en celo en la revisión del {{fecha_revision}}. Reiniciar periodo de servicio.'
    ],
    'repro_revision_20_21_result_sospecha' => [
        'module' => 'reproduccion',
        'title'  => 'Resultado revisión 20/21: Sospecha de preñez',
        'desc'   => 'La hembra {{hembra_identificador}} presenta sospecha de preñez ({{fecha_revision}}). Continuar observación.'
    ],
    'repro_revision_20_21_result_confirmada' => [
        'module' => 'reproduccion',
        'title'  => 'Resultado revisión 20/21: Preñez confirmada',
        'desc'   => 'La hembra {{hembra_identificador}} quedó confirmada preñada en la revisión del {{fecha_revision}}. Cerrar seguimiento de este servicio.'
    ],
    // PROX PARTO 117 (alerta por proximidad a parto)
    'repro_prox_parto_117' => [
        'module' => 'reproduccion',
        'title'  => 'Proximidad a parto (117 días)',
        'desc'   => 'La hembra {{hembra_identificador}} se acerca a parto ({{fecha_estimada_parto}}). Preparar maternidad y supervisión.'
    ],
    'repro_pregnancy_autoclosed' => [
        'module' => 'reproduccion',
        'title'  => 'Preñez confirmada automáticamente',
        'desc'   => 'El período {{periodo_codigo}} quedó confirmado por preñez tras 3 ciclos de 21 días sin retorno al celo para la hembra {{hembra_identificador}}.'
    ],

    /* =========================
     * INCIDENCIAS (incluye reincidencia aplastamiento)
     * ========================= */
    'incidencia_registrada' => [
        'module' => 'incidencias',
        'title'  => 'Incidencia registrada: {{tipo_incidencia}}',
        'desc'   => 'Se registró la incidencia {{correlativo}} ({{tipo_incidencia}}) para {{animal_identificador}} en {{fecha_evento}}.'
    ],
    'incidencia_actualizada' => [
        'module' => 'incidencias',
        'title'  => 'Incidencia actualizada',
        'desc'   => 'Se actualizó la incidencia {{correlativo}} ({{tipo_incidencia}}) de {{animal_identificador}} el {{fecha_actualizacion}}.'
    ],
    'incidencia_eliminada' => [
        'module' => 'incidencias',
        'title'  => 'Incidencia eliminada',
        'desc'   => 'Se eliminó la incidencia {{correlativo}} ({{tipo_incidencia}}) de {{animal_identificador}}.'
    ],
    // Alerta preventiva por historial de APLASTAMIENTO (reincidencia)
    'inc_reincidencia_aplastamiento' => [
        'module' => 'incidencias',
        'title'  => 'Alerta: antecedentes de aplastamiento',
        'desc'   => '{{animal_identificador}} acumula {{conteo}} antecedente(s) de APLASTAMIENTO. (Última: {{correlativo}}). Aplicar medidas preventivas.'
    ],

    /* =========================
     * PESO / TABULADORES
     * ========================= */
    'peso_fuera_rango' => [
        'module' => 'pesos',
        'title'  => 'Peso fuera de rango',
        'desc'   => 'Animal {{animal_identificador}} con {{peso}} kg fuera del rango {{rango}} (ideal {{ideal}} kg, {{edad_dias}} días). Revisar plan de alimentación.'
    ],
    'peso_en_rango' => [
        'module' => 'pesos',
        'title'  => 'Peso dentro de rango',
        'desc'   => 'Animal {{animal_identificador}} con {{peso}} kg dentro del rango esperado {{rango}} (ideal {{ideal}} kg, {{edad_dias}} días).'
    ],

    /* =========================
     * TRANSFERENCIAS (compatibilidad)
     * ========================= */
    'transfer_compatibilidad_riesgo' => [
        'module' => 'transferencias',
        'title'  => 'Riesgo de convivencia detectado',
        'desc'   => 'Posible incompatibilidad al transferir {{animal_identificador}} a {{destino_nombre}}: {{motivo_riesgo}}. Revisar antes de confirmar.'
    ],
    'transfer_confirmada' => [
        'module' => 'transferencias',
        'title'  => 'Transferencia confirmada',
        'desc'   => 'Se transfirió {{animal_identificador}} de {{origen_nombre}} a {{destino_nombre}} el {{fecha_transferencia}}.'
    ],

    /* =========================
     * ÓRDENES DE TRABAJO (mapeo de “Work Orders – Delays”)
     * - Traslados / tareas programadas
     * ========================= */
    'ot_traslado_programado' => [
        'module' => 'ordenes_trabajo',
        'title'  => 'Orden de traslado programada',
        'desc'   => 'OT #{{ot_numero}} programada: {{origen_full}} → {{destino_full}}. Salida {{pickup_at}}, llegada estimada {{delivery_at}}.'
    ],
    // Equivalente “Pickup Delayed”
    'ot_salida_retrasada' => [
        'module' => 'ordenes_trabajo',
        'title'  => 'Salida retrasada',
        'desc'   => 'OT #{{ot_numero}} con salida retrasada. Programada {{hora_programada}}, sin registro de partida.'
    ],
    // Equivalente “Work Order Delayed / New ETA”
    'ot_eta_reprogramada' => [
        'module' => 'ordenes_trabajo',
        'title'  => 'Orden retrasada: nueva ETA',
        'desc'   => 'OT #{{ot_numero}} retrasada. Nueva ETA {{nueva_eta}} (original {{eta_programada}}).'
    ],
    // Equivalente “Delivery completed late”
    'ot_entrega_tardia' => [
        'module' => 'ordenes_trabajo',
        'title'  => 'Entrega completada con retraso',
        'desc'   => 'OT #{{ot_numero}} entregada tarde. Programada {{entrega_programada}}, completada {{entrega_real}} (retraso {{retraso_humano}}).'
    ],

    /* =========================
     * ÁREAS / RECINTOS (mapeo de “Inventory / Containers”)
     * ========================= */
    'area_creada' => [
        'module' => 'areas',
        'title'  => 'Área creada',
        'desc'   => 'Se creó el área {{area_nombre}} ({{tipo_area}}) en {{aprisco}} · {{finca}}.'
    ],
    'area_actualizada' => [
        'module' => 'areas',
        'title'  => 'Área actualizada',
        'desc'   => 'Se actualizó el área {{area_nombre}} ({{tipo_area}}) en {{aprisco}} · {{finca}}. Fecha: {{fecha}}.'
    ],
    'area_eliminada' => [
        'module' => 'areas',
        'title'  => 'Área eliminada',
        'desc'   => 'Se eliminó el área {{area_nombre}} de {{aprisco}} · {{finca}}.'
    ],
    'area_estado_cambiado' => [
        'module' => 'areas',
        'title'  => 'Cambio de estado del área',
        'desc'   => 'El área {{area_nombre}} cambió su estado a {{nuevo_estado}}.'
    ],
    /* Opcionales por si más adelante manejas reservas/disponibilidad desde otras acciones */
    'area_reservada' => [
        'module' => 'areas',
        'title'  => 'Área reservada',
        'desc'   => 'El área {{area_nombre}} ha sido reservada para {{motivo_reserva}}.'
    ],
    'area_disponible' => [
        'module' => 'areas',
        'title'  => 'Área disponible',
        'desc'   => 'El área {{area_nombre}} ahora está disponible en {{aprisco}}.'
    ],

    /* =========================
     * INFRAESTRUCTURA – REPORTES DE DAÑO
     * ========================= */
    'reporte_dano_creado' => [
        'module' => 'infraestructura',
        'title'  => 'Nuevo reporte de daño: {{titulo}}',
        'desc'   => 'Se reportó daño en {{ubicacion_full}}. Criticidad: {{criticidad}}. {{descripcion}}.'
    ],
    'reporte_dano_actualizado' => [
        'module' => 'infraestructura',
        'title'  => 'Actualización de reporte de daño',
        'desc'   => 'El reporte "{{titulo}}" cambió a estado {{estado_reporte}}. Última actualización: {{fecha_actualizacion}}.'
    ],
];

    /**
     * Devuelve ['title' => ..., 'desc' => ...] con placeholders reemplazados.
     * @param string $key
     * @param array  $params
     * @return array{title:string,desc:string}
     */
    public static function render($key, array $params = [])
    {
        if (!isset(self::$templates[$key])) {
            return ['title' => $key, 'desc' => ''];
        }
        $tpl = self::$templates[$key];
        return [
            'title' => self::replacePlaceholders($tpl['title'], $params),
            'desc'  => self::replacePlaceholders($tpl['desc'],  $params),
        ];
    }

    /**
     * Devuelve la metadata de una plantilla (module, title, desc crudos).
     * @param string $key
     * @return array|null
     */
    public static function getMeta($key)
    {
        return self::$templates[$key] ?? null;
    }

    /**
     * Lista todas las claves disponibles.
     * @return string[]
     */
    public static function allKeys()
    {
        return array_keys(self::$templates);
    }

    /**
     * Construye un array listo para INSERT en `notifications`.
     * Requiere UuidHelper::generateUUIDv4().
     *
     * @param array $in [
     *   template_key(string), template_params(array), route(?string), module(string), rol(?string), user_id(?string)
     * ]
     * @return array
     */
    public static function buildForInsert(array $in)
    {
        $now = date('Y-m-d H:i:s');
        return [
            'notifications_id' => UuidHelper::generateUUIDv4(),
            'template_key'     => (string)($in['template_key'] ?? ''),
            'template_params'  => json_encode($in['template_params'] ?? [], JSON_UNESCAPED_UNICODE),
            'route'            => isset($in['route'])  ? (string)$in['route']  : null,
            'module'           => (string)($in['module'] ?? ''),
            'rol'              => isset($in['rol'])    ? (string)$in['rol']    : null,
            'user_id'          => isset($in['user_id'])? (string)$in['user_id']: null,
            'new'              => 1,
            'read_unread'      => 0,
            'created_at'       => $now,
            'created_by'       => null,
            'updated_at'       => null,
            'updated_by'       => null,
            'deleted_at'       => null,
            'deleted_by'       => null,
        ];
    }

    /* =========================
     * Helpers internos
     * ========================= */
    private static function replacePlaceholders($text, array $params)
    {
        if ($text === '' || empty($params)) {
            return $text;
        }
        foreach ($params as $k => $v) {
            $text = str_replace('{{'.$k.'}}', (string)$v, $text);
        }
        return $text;
    }
}
