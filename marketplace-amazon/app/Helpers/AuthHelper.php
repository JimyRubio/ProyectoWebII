<?php

class AuthHelper {
    /**
     * Inicia la sesión si no está iniciada
     */
    public static function init(): void {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }

    /**
     * Verifica si el usuario está autenticado y la sesión no ha expirado
     * También verifica consistencia IP/User-Agent contra Session Hijacking
     */
    public static function check(): bool {
        self::init();
        
        if (empty($_SESSION['usuario_id'])) {
            return false;
        }

        // Verificar timeout de sesión inactiva
        if (self::isSessionExpired()) {
            self::logout();
            return false;
        }

        // Verificar consistencia de IP y User-Agent (anti Session Hijacking)
        if (!self::verifySessionConsistency()) {
            $userId = $_SESSION['usuario_id'] ?? 'N/A';
            $ipAddr = $_SESSION['ip_address'] ?? 'N/A';
            $uaStr = $_SESSION['user_agent'] ?? 'N/A';
            error_log("Session Hijacking detectada: usuario_id={$userId}, IP esperada={$ipAddr}, UA esperado={$uaStr}");
            self::logout();
            return false;
        }

        // Actualizar timestamp de última actividad
        $_SESSION['last_activity'] = time();
        
        return true;
    }

    /**
     * Verifica si la sesión ha expirado por inactividad
     */
    private static function isSessionExpired(): bool {
        if (empty($_SESSION['last_activity'])) {
            return false;
        }
        $inactiveTime = time() - $_SESSION['last_activity'];
        return $inactiveTime > SESSION_TIMEOUT;
    }

    /**
     * Verifica que la IP y User-Agent coincidan con los registrados al inicio de sesión
     */
    private static function verifySessionConsistency(): bool {
        $currentIP = Security::getClientIP();
        $currentUA = $_SERVER['HTTP_USER_AGENT'] ?? '';
        
        // Si no hay datos registrados (sesión antigua), forzar relogin
        if (empty($_SESSION['ip_address']) || empty($_SESSION['user_agent'])) {
            return false;
        }

        return $_SESSION['ip_address'] === $currentIP && $_SESSION['user_agent'] === $currentUA;
    }

    /**
     * Retorna los datos del usuario autenticado
     */
    public static function user(): ?array {
        if (!self::check()) return null;
        return [
            'id' => $_SESSION['usuario_id'],
            'nombre' => $_SESSION['usuario_nombre'] ?? '',
            'apellido' => $_SESSION['usuario_apellido'] ?? '',
            'email' => $_SESSION['usuario_email'] ?? '',
            'rol_id' => $_SESSION['usuario_rol_id'] ?? 3,
            'rol_nombre' => $_SESSION['usuario_rol_nombre'] ?? 'Cliente',
            'cliente_id' => $_SESSION['cliente_id'] ?? null,
            'vendedor_id' => $_SESSION['vendedor_id'] ?? null
        ];
    }

    /**
     * Inicia sesión para un usuario con regeneración de session ID
     * para prevenir Session Fixation
     */
    public static function login(array $usuario, ?array $cliente = null, ?array $vendedor = null): void {
        self::init();
        
        // Regenerar ID de sesión para prevenir Session Fixation
        session_regenerate_id(true);
        
        // Limpiar datos antiguos pero mantener CSRF token
        $csrfToken = $_SESSION['csrf_token'] ?? null;
        $csrfTime = $_SESSION['csrf_token_time'] ?? null;
        $_SESSION = array();
        if ($csrfToken) {
            $_SESSION['csrf_token'] = $csrfToken;
            $_SESSION['csrf_token_time'] = $csrfTime;
        }
        
        $_SESSION['usuario_id'] = (int)$usuario['id'];
        $_SESSION['usuario_nombre'] = $usuario['nombre'];
        $_SESSION['usuario_apellido'] = $usuario['apellido'];
        $_SESSION['usuario_email'] = $usuario['email'];
        $_SESSION['usuario_rol_id'] = (int)$usuario['rol_id'];
        $_SESSION['usuario_rol_nombre'] = $usuario['rol_nombre'] ?? 'Cliente';

        if ($cliente) {
            $_SESSION['cliente_id'] = (int)$cliente['id'];
        }
        if ($vendedor) {
            $_SESSION['vendedor_id'] = (int)$vendedor['id'];
        }

        // Registrar huella digital de la sesión
        $_SESSION['ip_address'] = Security::getClientIP();
        $_SESSION['user_agent'] = $_SERVER['HTTP_USER_AGENT'] ?? '';
        $_SESSION['last_activity'] = time();
        $_SESSION['login_time'] = time();
    }

    /**
     * Cierra la sesión de forma segura
     */
    public static function logout(): void {
        self::init();
        
        // Limpiar todas las variables de sesión
        $_SESSION = array();
        
        // Destruir la cookie de sesión
        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $params["path"], $params["domain"],
                $params["secure"] ?? false, 
                true // httponly siempre true
            );
        }
        
        // Destruir la sesión en el servidor
        session_destroy();
    }

    /**
     * Verifica si el usuario tiene un rol específico
     */
    public static function hasRole(string $roleName): bool {
        $user = self::user();
        if (!$user) return false;
        return strtolower($user['rol_nombre']) === strtolower($roleName);
    }

    /**
     * Requiere autenticación, responde con error si no está autenticado
     */
    public static function requireAuth(): void {
        if (!self::check()) {
            Response::error('Acceso no autorizado. Debe iniciar sesión.', 401);
        }
    }
}
