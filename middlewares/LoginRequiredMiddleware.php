<?php

require_once 'Middleware.php';

/**
 * Middleware que solo verifica si existe una sesión de usuario activa.
 * Si no existe, redirige al login.
 * Usado para rutas como /perfil que no son "módulos" pero requieren login.
 */
class LoginRequiredMiddleware implements Middleware
{
    /**
     * Maneja la lógica de autenticación.
     * @param string $ruta La ruta a la que el usuario intenta acceder.
     */
    public function handle($ruta)
    {
        // 1. Verificar si existe una sesión activa.
        if (!isset($_SESSION['user_id'])) {
            $this->redirigirALogin();
        }

        // 2. Si hay sesión, permitir el acceso.
        return;
    }

    /**
     * Redirige al usuario a la página de login.
     */
    private function redirigirALogin()
    {
        session_unset();
        session_destroy();
        header('Location: ' . BASE_URL . 'login');
        exit();
    }
}