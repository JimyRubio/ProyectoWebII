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
        Response::success($this->model->getAll(), 'Lista de vendedores');
    }

    /**
     * Obtiene el perfil de un vendedor
     */
    public function profile(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $vendedorId = $user['vendedor_id'] ?? 1;

        $vendedor = $this->model->getProfile($vendedorId);
        if (!$vendedor) {
            Response::error('Vendedor no encontrado', 404);
        }
        Response::success($vendedor, 'Perfil del vendedor');
    }

    /**
     * Retorna métricas del vendedor para el Seller Dashboard
     */
    public function dashboard(): void {
        AuthHelper::requireAuth();
        $user = AuthHelper::user();
        $vendedorId = $user['vendedor_id'] ?? 1;

        $metrics = $this->model->getDashboardMetrics($vendedorId);
        Response::success($metrics, 'Métricas Seller Central');
    }
}
