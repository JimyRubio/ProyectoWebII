d<?php
require_once __DIR__ . '/../Models/TiendaModel.php';

class TiendaController {
    private TiendaModel $model;

    public function __construct() {
        $this->model = new TiendaModel();
    }

/**
     * Retorna todas las tiendas activas
     */
    public function index(): void {
        try {
            Response::success($this->model->getAll(), 'Listado de tiendas');
        } catch (Exception $e) {
            error_log("Error en TiendaController::index: " . $e->getMessage());
            Response::error('Error al obtener las tiendas', 500);
        }
    }

    /**
     * Retorna detalle de una tienda
     */
    public function show(int $id): void {
        try {
            $tienda = $this->model->getById($id);
            if (!$tienda) {
                Response::error('Tienda no encontrada', 404);
            }
            Response::success($tienda, 'Detalle de la tienda');
        } catch (Exception $e) {
            error_log("Error en TiendaController::show: " . $e->getMessage());
            Response::error('Error al obtener el detalle de la tienda', 500);
        }
    }

    /**
     * Retorna los productos pertenecientes a una tienda
     */
    public function productos(int $id): void {
        try {
            $productos = $this->model->getProductos($id);
            Response::success($productos, 'Productos de la tienda');
        } catch (Exception $e) {
            error_log("Error en TiendaController::productos: " . $e->getMessage());
            Response::error('Error al obtener los productos de la tienda', 500);
        }
    }
}
