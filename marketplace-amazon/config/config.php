<?php
// Configuración Global del Proyecto MarketZone

// =============================================
// MANEJO DE ERRORES - PRIMERO PARA SUPRIMIR DEPRECATION WARNINGS
// =============================================
// Suprimir TODAS las salidas de error que romperían JSON (display_errors = off)
// Los errores aún se registran en log interno
@ini_set('display_errors', 0);
@ini_set('display_startup_errors', 0);
// No mostrar deprecaciones (PHP 8.5+)
error_reporting(E_ALL & ~E_DEPRECATED & ~E_USER_DEPRECATED);

// =============================================
// CONFIGURACIÓN DE SESIÓN SEGURA
// =============================================
// Configurar cookie de sesión con parámetros de seguridad
@ini_set('session.use_strict_mode', 1);
@ini_set('session.use_only_cookies', 1);
@ini_set('session.use_trans_sid', 0);
@ini_set('session.cookie_httponly', 1);
@ini_set('session.cookie_samesite', 'Lax');

// Secure cookie solo si es HTTPS
if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') {
    @ini_set('session.cookie_secure', 1);
}

// Tiempo máximo de inactividad de sesión (30 minutos)
@ini_set('session.gc_maxlifetime', 1800);
@ini_set('session.cookie_lifetime', 0); // Hasta que cierre el navegador

// GC probability
@ini_set('session.gc_probability', 1);
@ini_set('session.gc_divisor', 100);

// Cache limiter para prevenir almacenamiento en caché
session_cache_limiter('nocache');

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
define('BASE_URL', 'http://localhost:8080/');

// Nombre del Proyecto
define('APP_NAME', 'MarketZone HN');

// Moneda del sistema
define('CURRENCY_SYMBOL', 'L.');
define('CURRENCY_CODE', 'HNL');
define('CURRENCY_LOCALE', 'es-HN');

// Rutas absolutas del sistema
define('ROOT_PATH', dirname(__DIR__) . '/');
define('VIEWS_PATH', ROOT_PATH . 'views/');
define('UPLOADS_PATH', ROOT_PATH . 'public/uploads/');

// Configuración de SMTP para correos (Gmail)
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_AUTH', true);
define('SMTP_USER', 'jimya.rubio@gmail.com');
define('SMTP_PASS', 'kkih hvbi oraf azvg');
define('SMTP_DEBUG', 0);
define('SMTP_FROM_EMAIL', 'jimya.rubio@gmail.com');
define('SMTP_FROM_NAME', APP_NAME . ' - Soporte');

// =============================================
// CONFIGURACIÓN DE SEGURIDAD ADICIONAL
// =============================================
// Tiempo máximo de sesión inactiva en segundos (30 min)
define('SESSION_TIMEOUT', 1800);
// Máximo de intentos de login fallidos antes de bloqueo temporal
define('MAX_LOGIN_ATTEMPTS', 5);
// Tiempo de bloqueo por intentos fallidos en segundos (15 min)
define('LOGIN_BLOCK_TIME', 900);
// Tiempo de expiración del token de recuperación en segundos (1 hora)
define('RESET_TOKEN_EXPIRY', 3600);
// Versión de hash de contraseña (Bcrypt cost)
define('PASSWORD_COST', 10);

// Configuración de zona horaria y errores
date_default_timezone_set('America/Mexico_City');

// =============================================
// MANEJO DE ERRORES SEGURO
// =============================================
// En producción, NO mostrar errores al cliente
if (!defined('IS_DEV')) {
    // Por defecto, asumimos producción
    error_reporting(0);
    ini_set('display_errors', 0);
    ini_set('display_startup_errors', 0);
    ini_set('log_errors', 1);
} else {
    // Solo en desarrollo mostrar errores (filtrar deprecaciones)
    error_reporting(E_ALL & ~E_DEPRECATED & ~E_USER_DEPRECATED);
    ini_set('display_errors', 1);
}

// Cargar Helpers Globales
require_once ROOT_PATH . 'app/Helpers/Security.php';
require_once ROOT_PATH . 'app/Helpers/Response.php';
require_once ROOT_PATH . 'app/Helpers/AuthHelper.php';
