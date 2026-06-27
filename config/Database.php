<?php

class Database
{
    private static $instance = null;
    private $mysqli;

    private function __construct()
    {
        // === CORRECCIÓN AQUÍ ===
        // Si APP_ROOT no está definida (como pasa en el CRON), la definimos
        // basándonos en la ubicación de este archivo.
        // __DIR__ es /ruta/al/proyecto/config
        // dirname(__DIR__) es /ruta/al/proyecto/
        if (!defined('APP_ROOT')) {
            define('APP_ROOT', dirname(__DIR__));
        }
        // =======================

        $this->loadEnv(APP_ROOT . '/.env');

        // verifica si es localhost

        $host = 'localhost';
        $dbname = 'acopio';

        if ($_SERVER['HTTP_HOST'] === 'localhost') {
            $username = 'root';
            $password =  '';
        } else {
            $usesirname = 'acopio_user';
            $password =  'd{adu7O~Hygc';
        }


        // Definimos estas constantes solo si no existen, para evitar notificaciones de "Constant already defined"
        if (!defined('APP_URL')) {
            define('APP_URL', $_ENV['APP_URL'] ?? 'http://localhost/acopio');
        }
        if (!defined('FCM_PROJECT_ID')) {
            define('FCM_PROJECT_ID', $_ENV['FCM_PROJECT_ID'] ?? 'sissup-cb2db');
        }

        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $this->mysqli = new mysqli($host, $username, $password, $dbname);
            $this->mysqli->set_charset("utf8mb4");
        } catch (mysqli_sql_exception $e) {
            // En modo CLI (Cron), errorResponse podría no ser ideal si devuelve JSON y mata el script,
            // pero lo mantenemos para consistencia.
            // Lo ideal en CRON es usar fwrite(STDERR, ...)
            if (php_sapi_name() === 'cli') {
                fwrite(STDERR, "Database connection error: " . $e->getMessage() . PHP_EOL);
                exit(1);
            } else {
                $this->errorResponse(500, "Database connection error: " . $e->getMessage());
            }
        }
    }

    private function loadEnv($filePath)
    {
        // Si no existe el archivo con punto, probamos sin punto
        if (!file_exists($filePath)) {
            $altFilePath = str_replace('.env', 'env', $filePath);
            if (file_exists($altFilePath)) {
                $filePath = $altFilePath;
            } else {
                // En CRON es mejor no matar el proceso con JSON si falla el env, 
                // pero si es crítico, se deja.
                // Solo asegúrate de que la ruta sea correcta.
                // $this->errorResponse(500, ".env or env file not found at $filePath");
                return; // Opcional: Si no hay env, confiamos en los valores por defecto del constructor
            }
        }

        $lines = file($filePath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            $line = trim($line);
            if (strpos($line, '#') === 0 || strpos($line, '=') === false) {
                continue;
            }

            list($key, $value) = explode('=', $line, 2);
            $_ENV[trim($key)] = trim($value);
        }
    }

    public static function getInstance()
    {
        if (self::$instance === null) {
            self::$instance = new Database();
        }
        return self::$instance->mysqli; // Ojo: esto devuelve la instancia de mysqli, no la clase Database
    }

    // Nota: Si getInstance devuelve $mysqli, este método no se podrá llamar estáticamente 
    // sobre el resultado de getInstance(). 
    // Normalmente getInstance devuelve la instancia de la clase (self::$instance).
    // Pero respetando tu código original, lo dejo así.
    public function getConnection()
    {
        return $this->mysqli;
    }

    public function startTransaction()
    {
        $this->mysqli->begin_transaction();
    }

    public function commit()
    {
        $this->mysqli->commit();
    }

    public function rollback()
    {
        $this->mysqli->rollback();
    }

    private function errorResponse($http_code, $message)
    {
        // Si es CLI, solo mostramos texto y salimos
        if (php_sapi_name() === 'cli') {
            fwrite(STDERR, "[ERROR $http_code] $message" . PHP_EOL);
            exit(1);
        }

        http_response_code($http_code);
        echo json_encode([
            'value' => false,
            'message' => $message
        ]);
        exit;
    }
}
