<?php
// Configuración Global del Proyecto MarketZone

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Configuración de la Base de Datos MySQL
define('DB_HOST', 'localhost');
define('DB_NAME', 'marketplace_db');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

// URL Base Exacta
define('BASE_URL', 'http://localhost:8080/ProyectoWebII/marketplace-amazon/');

// Nombre del Proyecto
define('APP_NAME', 'Marketplace Amazon');

// Rutas absolutas del sistema
define('ROOT_PATH', dirname(__DIR__) . '/');
define('VIEWS_PATH', ROOT_PATH . 'views/');
define('UPLOADS_PATH', ROOT_PATH . 'public/uploads/');

// Configuración de zona horaria y errores
date_default_timezone_set('America/Mexico_City');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Cargar Helpers Globales
require_once ROOT_PATH . 'app/Helpers/Security.php';
require_once ROOT_PATH . 'app/Helpers/Response.php';
require_once ROOT_PATH . 'app/Helpers/AuthHelper.php';