<?php

class Security {
    /**
     * Genera o recupera el token CSRF para la sesión actual
     * Regenera el token periódicamente (cada hora) para prevenir ataques de long-lived CSRF
     */
    public static function generateCsrfToken(): string {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        $regenerateTime = 3600; // 1 hora
        if (empty($_SESSION['csrf_token']) || empty($_SESSION['csrf_token_time']) || 
            (time() - $_SESSION['csrf_token_time'] > $regenerateTime)) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
            $_SESSION['csrf_token_time'] = time();
        }
        return $_SESSION['csrf_token'];
    }

    /**
     * Verifica que un token CSRF provisto sea válido
     */
    public static function verifyCsrfToken(?string $token): bool {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        if (empty($_SESSION['csrf_token']) || empty($token)) {
            return false;
        }
        // Comparación timing-safe para prevenir timing attacks
        return hash_equals($_SESSION['csrf_token'], $token) && !self::isCsrfExpired();
    }

    /**
     * Verifica si el token CSRF ha expirado (> 2 horas)
     */
    private static function isCsrfExpired(): bool {
        $maxAge = 7200; // 2 horas
        return !empty($_SESSION['csrf_token_time']) && (time() - $_SESSION['csrf_token_time'] > $maxAge);
    }

    /**
     * Sanitiza una cadena de texto contra ataques XSS
     */
    public static function sanitizeString(?string $data): string {
        if ($data === null) return '';
        return htmlspecialchars(trim($data), ENT_QUOTES, 'UTF-8');
    }

    /**
     * Sanitiza recursivamente arreglos o valores individuales
     */
    public static function sanitizeInput($input) {
        if (is_array($input)) {
            foreach ($input as $key => $value) {
                $input[$key] = self::sanitizeInput($value);
            }
            return $input;
        }
        return is_string($input) ? self::sanitizeString($input) : $input;
    }

    /**
     * Genera un hash seguro para contraseñas usando Bcrypt
     */
    public static function hashPassword(string $password): string {
        return password_hash($password, PASSWORD_BCRYPT, ['cost' => PASSWORD_COST]);
    }

    /**
     * Verifica una contraseña plana contra su hash encriptado
     */
    public static function verifyPassword(string $password, string $hash): bool {
        return password_verify($password, $hash);
    }

    /**
     * =============================================
     * PROTECCIÓN CONTRA FUERZA BRUTA
     * =============================================
     */

    /**
     * Verifica si un usuario ha excedido el límite de intentos fallidos
     * y si su tiempo de bloqueo ha expirado
     * 
     * @param PDO $db Conexión a BD
     * @param string $email Email del usuario
     * @return array ['blocked' => bool, 'remaining_time' => int (segundos), 'attempts' => int]
     */
    public static function checkBruteForce(PDO $db, string $email): array {
        $stmt = $db->prepare(
            "SELECT intentos_fallidos, ultimo_intento, bloqueado, razon_bloqueo 
             FROM usuarios WHERE email = :email"
        );
        $stmt->execute([':email' => $email]);
        $user = $stmt->fetch();

        if (!$user) {
            return ['blocked' => false, 'remaining_time' => 0, 'attempts' => 0];
        }

        $attempts = (int)($user['intentos_fallidos'] ?? 0);

        // Si está bloqueado permanentemente por admin
        if (!empty($user['bloqueado']) && $user['bloqueado'] == 1) {
            return ['blocked' => true, 'remaining_time' => -1, 'attempts' => $attempts];
        }

        // Verificar si excede el límite de intentos
        if ($attempts >= MAX_LOGIN_ATTEMPTS && !empty($user['ultimo_intento'])) {
            $lastAttempt = strtotime($user['ultimo_intento']);
            $elapsed = time() - $lastAttempt;
            $remaining = LOGIN_BLOCK_TIME - $elapsed;

            if ($remaining > 0) {
                return ['blocked' => true, 'remaining_time' => $remaining, 'attempts' => $attempts];
            } else {
                // El bloqueo expiró, resetear contador
                self::resetFailedAttempts($db, $email);
                return ['blocked' => false, 'remaining_time' => 0, 'attempts' => 0];
            }
        }

        return ['blocked' => false, 'remaining_time' => 0, 'attempts' => $attempts];
    }

    /**
     * Incrementa el contador de intentos fallidos para un email
     */
    public static function incrementFailedAttempts(PDO $db, string $email): void {
        $stmt = $db->prepare(
            "UPDATE usuarios SET 
                intentos_fallidos = intentos_fallidos + 1, 
                ultimo_intento = NOW() 
             WHERE email = :email"
        );
        $stmt->execute([':email' => $email]);
    }

    /**
     * Resetea el contador de intentos fallidos (después de login exitoso o bloqueo expirado)
     */
    public static function resetFailedAttempts(PDO $db, string $email): void {
        $stmt = $db->prepare(
            "UPDATE usuarios SET 
                intentos_fallidos = 0, 
                ultimo_intento = NULL 
             WHERE email = :email"
        );
        $stmt->execute([':email' => $email]);
    }

    /**
     * =============================================
     * VALIDACIONES DE CONTRASEÑA
     * =============================================
     */

    /**
     * Valida la fortaleza de una contraseña
     * Retorna array ['valid' => bool, 'message' => string]
     */
    public static function validatePasswordStrength(string $password): array {
        if (strlen($password) < 8) {
            return ['valid' => false, 'message' => 'La contraseña debe tener al menos 8 caracteres'];
        }
        if (!preg_match('/[A-Z]/', $password)) {
            return ['valid' => false, 'message' => 'La contraseña debe contener al menos una letra mayúscula'];
        }
        if (!preg_match('/[a-z]/', $password)) {
            return ['valid' => false, 'message' => 'La contraseña debe contener al menos una letra minúscula'];
        }
        if (!preg_match('/[0-9]/', $password)) {
            return ['valid' => false, 'message' => 'La contraseña debe contener al menos un número'];
        }
        return ['valid' => true, 'message' => ''];
    }

    /**
     * =============================================
     * VALIDACIÓN Y NORMALIZACIÓN DE EMAIL
     * =============================================
     */

    /**
     * Valida y normaliza un email (previene Email Injection)
     */
    public static function validateEmail(string $email): ?string {
        $email = trim($email);
        $email = filter_var($email, FILTER_SANITIZE_EMAIL);
        
        // Prevenir Email Header Injection
        if (preg_match('/[\r\n\t\f\v]/', $email)) {
            return null;
        }
        
        return filter_var($email, FILTER_VALIDATE_EMAIL) ? $email : null;
    }

    /**
     * =============================================
     * LOG SEGURO DE ACTIVIDAD
     * =============================================
     */

    /**
     * Registra un intento de acceso en la tabla logs_acceso
     */
    public static function logAccess(?int $usuarioId, string $accion, string $resultado): void {
        try {
            $db = Database::getInstance();
            $stmt = $db->prepare(
                "INSERT INTO logs_acceso (usuario_id, ip_address, user_agent, accion, resultado) 
                 VALUES (:usuario_id, :ip, :ua, :accion, :resultado)"
            );
            $stmt->execute([
                ':usuario_id' => $usuarioId,
                ':ip' => self::getClientIP(),
                ':ua' => $_SERVER['HTTP_USER_AGENT'] ?? '',
                ':accion' => $accion,
                ':resultado' => $resultado
            ]);
        } catch (Exception $e) {
            error_log("Error logging access: " . $e->getMessage());
        }
    }

    /**
     * Obtiene la IP real del cliente considerando proxies
     */
    public static function getClientIP(): string {
        $headers = [
            'HTTP_X_FORWARDED_FOR',
            'HTTP_X_REAL_IP',
            'HTTP_CLIENT_IP',
            'HTTP_X_FORWARDED',
            'HTTP_FORWARDED_FOR',
            'HTTP_FORWARDED',
            'REMOTE_ADDR'
        ];
        
        foreach ($headers as $header) {
            if (!empty($_SERVER[$header])) {
                $ip = $_SERVER[$header];
                // Si es una lista de IPs, tomar la primera
                if (strpos($ip, ',') !== false) {
                    $ip = trim(explode(',', $ip)[0]);
                }
                // Validar que sea una IP válida
                if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)) {
                    return $ip;
                }
            }
        }
        
        return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
    }
}
