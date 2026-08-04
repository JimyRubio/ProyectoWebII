<?php
require_once __DIR__ . '/../Models/VendedorModel.php';

class VendedorController {
    private VendedorModel $model;

    public function __construct() {
        $this->model = new VendedorModel();
    }

/**
     * Lista todos los vendedores del marketplace
     */
    public function index(): void {
        try {
            Response::success($this->model->getAll(), 'Lista de vendedores');
        } catch (Exception $e) {
            error_log("Error en VendedorController::index: " . $e->getMessage());
            Response::error('Error al obtener los vendedores', 500);
        }
    }

    /**
     * Obtiene el perfil de un vendedor
     */
    public function profile(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $vendedorId = $user['vendedor_id'] ?? 1;

        try {
            $vendedor = $this->model->getProfile($vendedorId);
            if (!$vendedor) {
                Response::error('Vendedor no encontrado', 404);
            }
            Response::success($vendedor, 'Perfil del vendedor');
        } catch (Exception $e) {
            error_log("Error en VendedorController::profile: " . $e->getMessage());
            Response::error('Error al obtener el perfil del vendedor', 500);
        }
    }

    /**
     * Retorna métricas del vendedor para el Seller Dashboard
     */
    public function dashboard(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $vendedorId = $user['vendedor_id'] ?? 1;

        try {
            $metrics = $this->model->getDashboardMetrics($vendedorId);
            Response::success($metrics, 'Métricas Seller Central');
        } catch (Exception $e) {
            error_log("Error en VendedorController::dashboard: " . $e->getMessage());
            Response::error('Error al obtener las métricas del vendedor', 500);
        }
    }
}
