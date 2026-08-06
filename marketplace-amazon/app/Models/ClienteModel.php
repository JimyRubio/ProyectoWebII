<?php
require_once __DIR__ . '/Model.php';

class ClienteModel extends Model {

    /**
     * Busca un usuario por correo electrónico
     */
    public function findByEmail(string $email): ?array {
        $sql = "SELECT u.*, r.nombre as rol_nombre, c.id as cliente_id, v.id as vendedor_id
                FROM usuarios u
                INNER JOIN roles r ON u.rol_id = r.id
                LEFT JOIN clientes c ON c.usuario_id = u.id
                LEFT JOIN vendedores v ON v.usuario_id = u.id
                WHERE u.email = :email AND u.activo = 1";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':email' => $email]);
        $user = $stmt->fetch();
        return $user ?: null;
    }

    /**
     * Registra un nuevo usuario cliente en una transacción
     */
    public function registerUser(array $data): int {
        $this->beginTransaction();
        try {
            // 1. Insertar Usuario
            $sqlUser = "INSERT INTO usuarios (email, password_hash, nombre, apellido, rol_id, activo, created_at)
                        VALUES (:email, :password_hash, :nombre, :apellido, :rol_id, 1, NOW())";
            
            $stmtUser = $this->db->prepare($sqlUser);
            $stmtUser->execute([
                ':email' => $data['email'],
                ':password_hash' => Security::hashPassword($data['password']),
                ':nombre' => $data['nombre'],
                ':apellido' => $data['apellido'] ?? '',
                ':rol_id' => $data['rol_id'] ?? 3 // 3 = Cliente
            ]);

            $usuarioId = (int)$this->db->lastInsertId();

            // 2. Insertar Registro en la tabla clientes
            $sqlCliente = "INSERT INTO clientes (usuario_id, tipo_cliente, fecha_registro)
                           VALUES (:usuario_id, 'regular', NOW())";
            $stmtCliente = $this->db->prepare($sqlCliente);
            $stmtCliente->execute([':usuario_id' => $usuarioId]);

            // 3. Inicializar Carrito para el cliente
            $clienteId = (int)$this->db->lastInsertId();
            $sqlCart = "INSERT INTO carritos (cliente_id) VALUES (:cliente_id)";
            $stmtCart = $this->db->prepare($sqlCart);
            $stmtCart->execute([':cliente_id' => $clienteId]);

            $this->commit();
            return $usuarioId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }

    /**
     * Obtiene el perfil completo del cliente por usuario_id
     */
public function getProfile(int $usuarioId): ?array {
        $sql = "SELECT u.id, u.email, u.nombre, u.apellido, u.telefono, u.direccion, u.genero, u.fecha_nacimiento, u.avatar,
                       c.id as cliente_id, c.tipo_cliente, c.puntos_lealtad,
                       GREATEST(
                           COALESCE((SELECT SUM(total) FROM pedidos WHERE cliente_id = c.id AND estado = 'entregado'), 0),
                           COALESCE(c.total_compras, 0)
                       ) as total_compras,
                       GREATEST(
                           COALESCE((SELECT COUNT(*) FROM pedidos WHERE cliente_id = c.id AND estado IN ('entregado', 'enviado', 'confirmado')), 0),
                           COALESCE(c.total_pedidos, 0)
                       ) as total_pedidos
                FROM usuarios u
                INNER JOIN clientes c ON c.usuario_id = u.id
                WHERE u.id = :usuario_id";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':usuario_id' => $usuarioId]);
        $profile = $stmt->fetch();
        return $profile ?: null;
    }

    /**
     * Actualiza la información personal del usuario
     */
    public function updateProfile(int $usuarioId, array $data): bool {
        $sql = "UPDATE usuarios 
                SET nombre = :nombre, apellido = :apellido, telefono = :telefono, direccion = :direccion
                WHERE id = :usuario_id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':nombre' => $data['nombre'],
            ':apellido' => $data['apellido'] ?? '',
            ':telefono' => $data['telefono'] ?? '',
            ':direccion' => $data['direccion'] ?? '',
            ':usuario_id' => $usuarioId
        ]);
    }

/**
     * Actualiza el avatar (foto de perfil) del usuario
     */
    public function updateAvatar(int $usuarioId, string $avatarUrl): bool {
        $sql = "UPDATE usuarios SET avatar = :avatar WHERE id = :usuario_id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':avatar' => $avatarUrl,
            ':usuario_id' => $usuarioId
        ]);
    }

    /**
     * Obtiene todas las direcciones de un cliente
     */
    public function getDirecciones(int $clienteId): array {
        $sql = "SELECT * FROM direcciones WHERE cliente_id = :cliente_id ORDER BY predeterminada DESC, id DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':cliente_id' => $clienteId]);
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Registra una nueva dirección para el cliente
     */
    public function addDireccion(int $clienteId, array $data): int {
        if (!empty($data['predeterminada'])) {
            $this->db->prepare("UPDATE direcciones SET predeterminada = 0 WHERE cliente_id = :cliente_id")
                     ->execute([':cliente_id' => $clienteId]);
        }

        $sql = "INSERT INTO direcciones (cliente_id, tipo, calle, numero, colonia, ciudad, estado, pais, codigo_postal, referencia, predeterminada)
                VALUES (:cliente_id, :tipo, :calle, :numero, :colonia, :ciudad, :estado, :pais, :codigo_postal, :referencia, :predeterminada)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            ':cliente_id' => $clienteId,
            ':tipo' => $data['tipo'] ?? 'ambos',
            ':calle' => $data['calle'],
            ':numero' => $data['numero'] ?? '',
            ':colonia' => $data['colonia'] ?? '',
            ':ciudad' => $data['ciudad'],
            ':estado' => $data['estado'],
            ':pais' => $data['pais'] ?? 'México',
            ':codigo_postal' => $data['codigo_postal'],
            ':referencia' => $data['referencia'] ?? '',
            ':predeterminada' => !empty($data['predeterminada']) ? 1 : 0
        ]);
        return (int)$this->db->lastInsertId();
    }

/**
     * Elimina una dirección
     */
    public function deleteDireccion(int $direccionId, int $clienteId): bool {
        $sql = "DELETE FROM direcciones WHERE id = :id AND cliente_id = :cliente_id";
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([':id' => $direccionId, ':cliente_id' => $clienteId]);
    }

    /**
     * Registra un usuario con un rol específico desde el panel de administración
     * Crea los registros dependientes según el rol (cliente+carrito, vendedor+tienda)
     *
     * @param array $data Datos del usuario (nombre, apellido, email, password, rol_id, etc.)
     * @return int ID del usuario creado
     */
    public function registerUserByRole(array $data): int {
        $this->beginTransaction();
        try {
            // 1. Insertar usuario
            $sqlUser = "INSERT INTO usuarios (email, password_hash, nombre, apellido, telefono, genero, fecha_nacimiento, direccion, rol_id, activo, created_at)
                        VALUES (:email, :password_hash, :nombre, :apellido, :telefono, :genero, :fecha_nacimiento, :direccion, :rol_id, 1, NOW())";
            $stmtUser = $this->db->prepare($sqlUser);
            $stmtUser->execute([
                ':email' => $data['email'],
                ':password_hash' => Security::hashPassword($data['password']),
                ':nombre' => $data['nombre'],
                ':apellido' => $data['apellido'] ?? '',
                ':telefono' => $data['telefono'] ?? null,
                ':genero' => $data['genero'] ?? null,
                ':fecha_nacimiento' => $data['fecha_nacimiento'] ?? null,
                ':direccion' => $data['direccion'] ?? null,
                ':rol_id' => (int)$data['rol_id']
            ]);

            $usuarioId = (int)$this->db->lastInsertId();

            // 2. Crear registros dependientes según el rol
            if ($data['rol_id'] == 3) {
                // Cliente + Carrito
                $sqlCliente = "INSERT INTO clientes (usuario_id, tipo_cliente, fecha_registro) VALUES (:uid, 'regular', NOW())";
                $this->db->prepare($sqlCliente)->execute([':uid' => $usuarioId]);
                $clienteId = (int)$this->db->lastInsertId();
                $this->db->prepare("INSERT INTO carritos (cliente_id) VALUES (:cid)")->execute([':cid' => $clienteId]);
            } elseif ($data['rol_id'] == 2) {
                // Vendedor + Tienda
                $nombreEmpresa = $data['nombre_empresa'] ?? ($data['nombre'] . ' Store');
                $sqlVendedor = "INSERT INTO vendedores (usuario_id, nombre_empresa, fecha_registro) VALUES (:uid, :empresa, NOW())";
                $this->db->prepare($sqlVendedor)->execute([':uid' => $usuarioId, ':empresa' => $nombreEmpresa]);
                $vendedorId = (int)$this->db->lastInsertId();

                $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $nombreEmpresa))) . '-' . $vendedorId;
                $sqlTienda = "INSERT INTO tiendas (vendedor_id, nombre_tienda, slug, activa, fecha_creacion) VALUES (:vid, :nombre, :slug, 1, NOW())";
                $this->db->prepare($sqlTienda)->execute([':vid' => $vendedorId, ':nombre' => $nombreEmpresa, ':slug' => $slug]);
            }
            // Admin (rol 1) no necesita tablas adicionales

            $this->commit();
            return $usuarioId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }

    /**
     * Obtiene la lista de todos los usuarios con su rol (para administración)
     */
    public function listaUsuarios(): array {
        $sql = "SELECT u.id, u.nombre, u.apellido, u.email, u.rol_id, r.nombre as rol_nombre, u.activo, u.created_at
                FROM usuarios u
                INNER JOIN roles r ON u.rol_id = r.id
                ORDER BY u.id ASC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene un usuario por ID con su rol
     */
    public function getUsuarioById(int $usuarioId): ?array {
        $sql = "SELECT id, activo, rol_id FROM usuarios WHERE id = :id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':id' => $usuarioId]);
        $usuario = $stmt->fetch();
        return $usuario ?: null;
    }

/**
     * Activa o desactiva un usuario según su estado actual
     * @return array ['activo' => bool, 'id' => int]
     */
    public function toggleUsuario(int $usuarioId): array {
        $nuevoEstado = $this->db->prepare("SELECT activo FROM usuarios WHERE id = :id");
        $nuevoEstado->execute([':id' => $usuarioId]);
        $row = $nuevoEstado->fetch();
        $activo = $row ? (int)$row['activo'] : 0;

        $nuevoValor = $activo ? 0 : 1;
        $stmtUpd = $this->db->prepare("UPDATE usuarios SET activo = :activo WHERE id = :id");
        $stmtUpd->execute([':activo' => $nuevoValor, ':id' => $usuarioId]);

        return ['activo' => (bool)$nuevoValor, 'id' => $usuarioId];
    }

    /**
     * Marca todos los tokens de recuperación de contraseña no usados como usados
     */
    public function invalidarTokensReset(int $usuarioId): void {
        $stmt = $this->db->prepare("UPDATE tokens_autenticacion SET usado = 1 WHERE usuario_id = :uid AND tipo = 'reset_password' AND usado = 0");
        $stmt->execute([':uid' => $usuarioId]);
    }

    /**
     * Crea un token de recuperación de contraseña para un usuario
     */
    public function crearTokenReset(int $usuarioId, string $token, string $expiry): void {
        $stmt = $this->db->prepare("INSERT INTO tokens_autenticacion (usuario_id, token, tipo, expira_en, usado, ip_creacion, user_agent) VALUES (:uid, :token, 'reset_password', :expira, 0, :ip, :ua)");
        $stmt->execute([
            ':uid' => $usuarioId,
            ':token' => $token,
            ':expira' => $expiry,
            ':ip' => Security::getClientIP(),
            ':ua' => $_SERVER['HTTP_USER_AGENT'] ?? ''
        ]);
    }

    /**
     * Busca un usuario por token de reset válido y no expirado
     */
    public function findUsuarioByToken(string $token): ?array {
        $sql = "SELECT ta.usuario_id as id FROM tokens_autenticacion ta 
                WHERE ta.token = :token AND ta.tipo = 'reset_password' 
                AND ta.expira_en > NOW() AND ta.usado = 0";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':token' => $token]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Marca un token específico como usado
     */
    public function marcarTokenUsado(string $token): void {
        $stmt = $this->db->prepare("UPDATE tokens_autenticacion SET usado = 1 WHERE token = :token");
        $stmt->execute([':token' => $token]);
    }

    /**
     * Actualiza la contraseña de un usuario
     */
    public function updatePassword(int $usuarioId, string $passwordHash): void {
        $stmt = $this->db->prepare("UPDATE usuarios SET password_hash = :password_hash WHERE id = :id");
        $stmt->execute([
            ':password_hash' => $passwordHash,
            ':id' => $usuarioId
        ]);
    }
}
