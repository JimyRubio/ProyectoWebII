<?php

class AuthHelper {
    public static function init(): void {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }

    public static function check(): bool {
        self::init();
        return !empty($_SESSION['usuario_id']);
    }

    public static function user(): ?array {
        self::init();
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

    public static function login(array $usuario, ?array $cliente = null, ?array $vendedor = null): void {
        self::init();
        $_SESSION['usuario_id'] = $usuario['id'];
        $_SESSION['usuario_nombre'] = $usuario['nombre'];
        $_SESSION['usuario_apellido'] = $usuario['apellido'];
        $_SESSION['usuario_email'] = $usuario['email'];
        $_SESSION['usuario_rol_id'] = $usuario['rol_id'];
        $_SESSION['usuario_rol_nombre'] = $usuario['rol_nombre'] ?? 'Cliente';

        if ($cliente) {
            $_SESSION['cliente_id'] = $cliente['id'];
        }
        if ($vendedor) {
            $_SESSION['vendedor_id'] = $vendedor['id'];
        }
    }

    public static function logout(): void {
        self::init();
        $_SESSION = array();
        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $params["path"], $params["domain"],
                $params["secure"], $params["httponly"]
            );
        }
        session_destroy();
    }

    public static function hasRole(string $roleName): bool {
        $user = self::user();
        if (!$user) return false;
        return strtolower($user['rol_nombre']) === strtolower($roleName);
    }

    public static function requireAuth(): void {
        if (!self::check()) {
            Response::error('Acceso no autorizado. Debe iniciar sesión.', 401);
        }
    }
}
