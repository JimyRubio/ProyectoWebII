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
        $sql = "SELECT u.id, u.email, u.nombre, u.apellido, u.telefono, u.direccion, 
                       c.id as cliente_id, c.tipo_cliente, c.puntos_lealtad, c.total_compras, c.total_pedidos
                FROM usuarios u
                INNER JOIN clientes c ON c.usuario_id = u.id
                WHERE u.id = :usuario_id";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':usuario_id' => $usuarioId]);
        $profile = $stmt->fetch();
        return $profile ?: null;
    }
}
