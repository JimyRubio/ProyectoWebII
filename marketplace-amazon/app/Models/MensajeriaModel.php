<?php
require_once __DIR__ . '/Model.php';

class MensajeriaModel extends Model {
    public function getConversaciones(int $clienteId): array {
        $stmt = $this->db->prepare("SELECT * FROM conversaciones WHERE cliente_id = :cliente_id ORDER BY updated_at DESC");
        $stmt->execute([':cliente_id' => $clienteId]);
        return $stmt->fetchAll();
    }
}
