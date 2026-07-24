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
        $sql = "SELECT u.id, u.email, u.nombre, u.apellido, u.telefono, u.direccion, u.genero, u.fecha_nacimiento,
                       c.id as cliente_id, c.tipo_cliente, c.puntos_lealtad, c.total_compras, c.total_pedidos
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
}
