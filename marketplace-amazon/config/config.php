<?php
// Configuración Global del Proyecto - Marketplace Amazon
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// URL Base del Proyecto (Ajusta la carpeta según tu servidor local XAMPP/WAMP)
define('BASE_URL', 'http://localhost/marketplace-amazon/');

// Nombre del Proyecto
define('APP_NAME', 'Marketplace Amazon');

// Rutas absolutas del sistema de archivos
define('ROOT_PATH', dirname(__DIR__) . '/');
define('VIEWS_PATH', ROOT_PATH . 'views/');
define('UPLOADS_PATH', ROOT_PATH . 'public/uploads/');