<?php
// Configuración Global del Proyecto
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// URL Base Exacta
define('BASE_URL', 'http://localhost:8080/ProyectoWebII/marketplace-amazon/');

// Nombre del Proyecto
define('APP_NAME', 'Marketplace Amazon');

// Rutas absolutas del sistema
define('ROOT_PATH', dirname(__DIR__) . '/');
define('VIEWS_PATH', ROOT_PATH . 'views/');
define('UPLOADS_PATH', ROOT_PATH . 'public/uploads/');