<?php
require_once __DIR__ . '/Model.php';

class MensajeriaModel extends Model {

    /**
     * Obtiene conversaciones de un cliente o vendedor
     */
    public function getConversaciones(int $clienteId): array {
        $sql = "SELECT c.*, v.nombre_empresa as vendedor_nombre, u.nombre as cliente_nombre, u.apellido as cliente_apellido
                FROM conversaciones c
                LEFT JOIN vendedores v ON v.id = c.vendedor_id
                LEFT JOIN clientes cl ON cl.id = c.cliente_id
                LEFT JOIN usuarios u ON u.id = cl.usuario_id
                WHERE c.cliente_id = :cliente_id
                ORDER BY c.updated_at DESC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':cliente_id' => $clienteId]);
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Obtiene mensajes de una conversación
     */
    public function getMensajes(int $conversacionId): array {
        $sql = "SELECT m.*, u.nombre as remitente_nombre
                FROM mensajes m
                LEFT JOIN usuarios u ON u.id = m.remitente_id
                WHERE m.conversacion_id = :conversacion_id
                ORDER BY m.created_at ASC";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':conversacion_id' => $conversacionId]);
        return $stmt->fetchAll() ?: [];
    }

    /**
     * Envía un nuevo mensaje en una conversación
     */
    public function enviarMensaje(int $conversacionId, int $remitenteId, string $remitenteTipo, string $mensaje): int {
        $this->beginTransaction();
        try {
            $sql = "INSERT INTO mensajes (conversacion_id, remitente_id, remitente_tipo, mensaje, created_at)
                    VALUES (:conversacion_id, :remitente_id, :remitente_tipo, :mensaje, NOW())";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([
                ':conversacion_id' => $conversacionId,
                ':remitente_id' => $remitenteId,
                ':remitente_tipo' => $remitenteTipo,
                ':mensaje' => $mensaje
            ]);

            $mensajeId = (int)$this->db->lastInsertId();

            // Actualizar ultimo mensaje de conversación
            $sqlUpdate = "UPDATE conversaciones SET ultimo_mensaje = :mensaje, updated_at = NOW() WHERE id = :id";
            $stmtUpdate = $this->db->prepare($sqlUpdate);
            $stmtUpdate->execute([':mensaje' => $mensaje, ':id' => $conversacionId]);

            $this->commit();
            return $mensajeId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }

    /**
     * Inicia una nueva conversación si no existe
     */
    public function crearConversacion(int $clienteId, int $vendedorId, string $asunto, string $mensajeInicial): int {
        $this->beginTransaction();
        try {
            $sql = "INSERT INTO conversaciones (cliente_id, vendedor_id, asunto, ultimo_mensaje, estado)
                    VALUES (:cliente_id, :vendedor_id, :asunto, :mensaje, 'abierta')";
            $stmt = $this->db->prepare($sql);
            $stmt->execute([
                ':cliente_id' => $clienteId,
                ':vendedor_id' => $vendedorId,
                ':asunto' => $asunto,
                ':mensaje' => $mensajeInicial
            ]);

            $conversacionId = (int)$this->db->lastInsertId();

            $sqlMsg = "INSERT INTO mensajes (conversacion_id, remitente_id, remitente_tipo, mensaje, created_at)
                       VALUES (:conversacion_id, :remitente_id, 'cliente', :mensaje, NOW())";
            $stmtMsg = $this->db->prepare($sqlMsg);
            $stmtMsg->execute([
                ':conversacion_id' => $conversacionId,
                ':remitente_id' => $clienteId,
                ':mensaje' => $mensajeInicial
            ]);

            $this->commit();
            return $conversacionId;
        } catch (Exception $e) {
            $this->rollBack();
            throw $e;
        }
    }
}
