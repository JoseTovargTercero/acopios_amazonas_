<?php
/**
 * Helper functions for permission checking
 */

/**
 * Verifica si el usuario actual tiene permiso para acceder a una URL
 * 
 * @param string $url URL a verificar (ej: 'acontecimientos', 'acontecimientos/crear')
 * @return bool True si tiene permiso, false si no
 */
function tienePermiso(string $url): bool
{
    // Verificar si hay sesión activa
    if (!isset($_SESSION['user_id']) || !isset($_SESSION['nivel'])) {
        return false;
    }

    $userId = $_SESSION['user_id'];
    $userLevel = (int)$_SESSION['nivel'];

    // Los administradores (nivel 0) siempre tienen acceso
    if ($userLevel === 0) {
        return true;
    }

    // Cargar el modelo de permisos
    require_once __DIR__ . '/../models/UsersPermisosModel.php';
    
    try {
        $permisosModel = new UsersPermisosModel();
        return $permisosModel->tienePermisoUrl($userId, $url, $userLevel);
    } catch (Exception $e) {
        error_log("Error verificando permiso para URL '$url': " . $e->getMessage());
        return false;
    }
}

/**
 * Verifica si el usuario actual es administrador
 * 
 * @return bool True si es admin, false si no
 */
function esAdmin(): bool
{
    return isset($_SESSION['nivel']) && (int)$_SESSION['nivel'] === 0;
}
