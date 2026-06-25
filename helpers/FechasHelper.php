<?php

class FechaHelper
{
    public static function estado($fechaHora)
    {
        if (empty($fechaHora)) return null;

        date_default_timezone_set('America/Caracas'); // Ajusta tu zona horaria

        $ahora = new DateTime();
        $fechaObjetivo = new DateTime($fechaHora);

        $diffDias = (int)$ahora->diff($fechaObjetivo)->format('%r%a');
        $diffSegundos = $fechaObjetivo->getTimestamp() - $ahora->getTimestamp();

        // --- CASOS ---
        if ($diffSegundos < 0) {
            return 'VENCIDA'; // Ya pasó (fecha o hora)
        }

        if ($diffDias === 0) {
            // Es hoy, pero si la hora ya pasó => vencida
            if (
                $fechaObjetivo->format('Y-m-d') === $ahora->format('Y-m-d') &&
                $fechaObjetivo->format('H:i:s') <= $ahora->format('H:i:s')
            ) {
                return 'VENCIDA';
            }
            return 'HOY'; // Es hoy, pero aún no llega la hora
        }

        if ($diffDias === 1) {
            return 'MAÑANA';
        }

        if ($diffDias > 1) {
            return 'PROXIMO';
        }

        return null;
    }
    public static function hoy()
    {
        return date('Y-m-d');
    }
}
