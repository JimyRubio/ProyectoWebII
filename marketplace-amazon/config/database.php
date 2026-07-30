<?php
require_once __DIR__ . '/config.php';

class Database {
    private static ?PDO $instance = null;

    private function __construct() {}
    private function __clone() {}

    /**
     * Obtiene la instancia única de conexión PDO (Singleton)
     */
    public static function getInstance(): PDO {
        if (self::$instance === null) {
            try {
                $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
                $options = [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ];
                
                self::$instance = new PDO($dsn, DB_USER, DB_PASS, $options);
            } catch (PDOException $e) {
                // Registrar error en log interno (no exponer al cliente)
                error_log("Error de conexión a la Base de Datos: " . $e->getMessage());
                die(json_encode([
                    'success' => false,
                    'message' => 'Error interno del servidor. Intente nuevamente más tarde.'
                ]));
            }
        }
        return self::$instance;
    }

    /**
     * Verifica si la base de datos está conectada
     */
    public static function isConnected(): bool {
        try {
            if (self::$instance === null) {
                return false;
            }
            self::$instance->query('SELECT 1');
            return true;
        } catch (\PDOException $e) {
            return false;
        }
    }
}