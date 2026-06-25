<?php
// Habilitar la visualización de todos los errores de PHP
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/middlewares/AuthMiddleware.php';
require_once __DIR__ . '/middlewares/SessionRedirectMiddleware.php';
require_once __DIR__ . '/middlewares/LoginRequiredMiddleware.php';
require_once __DIR__ . '/helpers/helpers.php'; // Permission helpers

require_once __DIR__ . '/controllers/AuthController.php';
require_once __DIR__ . '/controllers/SystemUserController.php';
require_once __DIR__ . '/controllers/MenuController.php';
require_once __DIR__ . '/controllers/MenuCategoriaController.php';
require_once __DIR__ . '/controllers/UsersPermisosController.php';
require_once __DIR__ . '/controllers/AlertaController.php';
require_once __DIR__ . '/controllers/NotificationController.php';
require_once __DIR__ . '/controllers/EmpresaController.php';
require_once __DIR__ . '/controllers/DonacionController.php';

use App\Core\ViewRenderer;

use App\Router;

if (session_status() === PHP_SESSION_NONE) {
    session_start(); // Iniciar sesión si no está iniciada
} else {
    echo "la sesión ya estaba iniciada";
}




$host = $_SERVER['HTTP_HOST'];

$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? "https" : "http";
$host = $_SERVER['HTTP_HOST'];
$path = rtrim(dirname($_SERVER['PHP_SELF']), '/\\') . '/';


// Uso para archivos en php
define('APP_ROOT', __DIR__ . '/'); // Define la ruta raíz de la aplicación
// Uso para rutas en el js/html
define('BASE_URL', "$protocol://$host$path");



$viewRenderer = new ViewRenderer('views/');

$router = new Router($viewRenderer);

// Login
$router->post('auth/login', ['controlador' => AuthController::class, 'accion' => 'login']);




// Rutas públicas (sin autenticación)
$router->group(['middleware' => SessionRedirectMiddleware::class], function ($router) {
    $router->get('/login', ['vista' => 'auth/login', 'vistaData' => ['titulo' => 'Iniciar Sesión', 'layout' => false]]);
    $router->get('/', ['vista' => 'auth/login', 'vistaData' => ['titulo' => 'Iniciar Sesión', 'layout' => false]]);
    $router->get('', ['vista' => 'auth/login', 'vistaData' => ['titulo' => 'Iniciar Sesión', 'layout' => false]]);
});
// lista de centros para login (público, sin middleware)
$router->get('/centros_acopio_lista',   ['controlador' => EmpresaController::class, 'accion' => 'listar']);

/*
// Rutas protegidas (requieren autenticación)
$router->group(['middleware' => AuthMiddleware::class], function ($router) {
    // Para permisos y niveles (No disponible)
});
*/

// El perfil es la única vista que todos los usuarios logueados deben ver
$router->group(['middleware' => LoginRequiredMiddleware::class], function ($router) {
    $router->get('/perfil', ['vista' => 'modules/perfil_view', 'vistaData' => ['titulo' => 'Perfil de Usuario']]);
    $router->get('/historial_donaciones', ['vista' => 'modules/historial_donaciones_view', 'vistaData' => ['titulo' => 'Historial de Donaciones']]);
    $router->get('/admin_donaciones', ['vista' => 'modules/admin_donaciones_view', 'vistaData' => ['titulo' => 'Administración General de Donaciones']]);
    $router->get('/empresas', ['vista' => 'modules/empresas_view', 'vistaData' => ['titulo' => 'Empresas']]);
});






$router->group(['prefix' => '/api'], function ($router) {


    // FUNCIONAMIENTO DEL SISMTEA

    // Donaciones
    $router->post('/donaciones', ['controlador' => \App\Controllers\DonacionController::class, 'accion' => 'crear']);
    $router->get('/donaciones', ['controlador' => \App\Controllers\DonacionController::class, 'accion' => 'listar']);
    $router->get('/admin_donaciones', ['controlador' => \App\Controllers\DonacionController::class, 'accion' => 'listarTodas']);


    // endpoints de usuarios
    $router->get('/system_users', ['controlador' => SystemUserController::class, 'accion' => 'listar']);
    $router->get('/system_users/{user_id}', ['controlador' => SystemUserController::class, 'accion' => 'mostrar']);
    $router->post('/system_users', ['controlador' => SystemUserController::class, 'accion' => 'crear']);
    $router->put('/system_users/{user_id}', ['controlador' => SystemUserController::class, 'accion' => 'actualizar']);
    $router->delete('/system_users/{user_id}', ['controlador' => SystemUserController::class, 'accion' => 'eliminar']);
    // check email user
    $router->post('/system_users/check_email', ['controlador' => SystemUserController::class, 'accion' => 'checkEmail']);
    // Logout
    $router->get('/logout', ['controlador' => AuthController::class, 'accion' => 'logout']);

    // endpoints de empresas
    $router->get('/empresas',         ['controlador' => EmpresaController::class, 'accion' => 'listar']);
    $router->get('/empresas/{id}',    ['controlador' => EmpresaController::class, 'accion' => 'mostrar']);
    $router->post('/empresas',        ['controlador' => EmpresaController::class, 'accion' => 'crear']);
    $router->post('/empresas/{id}',   ['controlador' => EmpresaController::class, 'accion' => 'actualizar']);
    $router->delete('/empresas/{id}', ['controlador' => EmpresaController::class, 'accion' => 'eliminar']);


    // endpoints de alertas
    $router->get('/alertas', ['controlador' => AlertaController::class, 'accion' => 'listar']);
    $router->get('/alertas/{alerta_id}', ['controlador' => AlertaController::class, 'accion' => 'mostrar']);
    $router->post('/alertas', ['controlador' => AlertaController::class, 'accion' => 'crear']);
    $router->post('/alertas/{alerta_id}', ['controlador' => AlertaController::class, 'accion' => 'actualizar']);
    $router->post('/alertas/{alerta_id}/estado', ['controlador' => AlertaController::class, 'accion' => 'cambiarEstado']);
    $router->delete('/alertas/{alerta_id}', ['controlador' => AlertaController::class, 'accion' => 'eliminar']);

    // endpoints de notificaciones
    $router->get('/notifications', ['controlador' => NotificationController::class, 'accion' => 'listar']);
    $router->get('/notifications/mias', ['controlador' => NotificationController::class, 'accion' => 'listarDeSesion']);
    $router->get('/notifications/mias/conteos', ['controlador' => NotificationController::class, 'accion' => 'obtenerConteosDeSesion']);
    $router->get('/notifications/{notifications_id}', ['controlador' => NotificationController::class, 'accion' => 'mostrar']);
    $router->post('/notifications', ['controlador' => NotificationController::class, 'accion' => 'crear']);
    $router->post('/notifications/{notifications_id}/flag/new', ['controlador' => NotificationController::class, 'accion' => 'actualizarNew']);
    $router->post('/notifications/{notifications_id}/flag/read_unread', ['controlador' => NotificationController::class, 'accion' => 'actualizarReadUnread']);
    $router->delete('/notifications/{notifications_id}', ['controlador' => NotificationController::class, 'accion' => 'eliminar']);
    $router->post('/notifications/marcar_todas_vistas', ['controlador' => NotificationController::class, 'accion' => 'marcarTodasComoVistas']);
    $router->post('/notifications/marcar_todas_leidas', ['controlador' => NotificationController::class, 'accion' => 'marcarTodasComoLeidas']);
});


// --- Ejecutar el Router ---
$router->route();
