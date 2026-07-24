<?php
require_once __DIR__ . '/../../config/database.php';

abstract class Model {
    protected PDO $db;

    public function __construct() {
        $this->db = Database::getInstance();
    }

    /**
     * Inicia una transacción PDO
     */
    public function beginTransaction(): bool {
        return $this->db->beginTransaction();
    }

    /**
     * Confirma la transacción
     */
    public function commit(): bool {
        return $this->db->commit();
    }

    /**
     * Revierte la transacción
     */
    public function rollBack(): bool {
        return $this->db->rollBack();
    }
}
