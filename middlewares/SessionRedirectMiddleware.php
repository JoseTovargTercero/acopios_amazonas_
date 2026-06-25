<?php


class SessionRedirectMiddleware implements Middleware
{
    /**
     * Maneja la lógica de redirección si ya existe una sesión.
     * @param string $ruta La ruta a la que el usuario intenta acceder (no se usa aquí, pero se requiere por la interfaz).
     */
    public function handle($ruta)
    {
        // 1. Verificar si existe una sesión activa.
        if (isset($_SESSION['user_id'])) {
            // 2. Si hay sesión, redirigir al perfil.
            // Usamos la constante BASE_URL definida en index.php
            header('Location: ' . BASE_URL . 'perfil');
            exit();
        }

        // 3. Si no hay sesión, no hacer nada y permitir que se muestre el login.
    }
}
