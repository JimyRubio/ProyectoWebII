<?php
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
        Response::success($this->model->getAll(), 'Listado de tiendas');
    }

    /**
     * Retorna detalle de una tienda
     */
    public function show(int $id): void {
        $tienda = $this->model->getById($id);
        if (!$tienda) {
            Response::error('Tienda no encontrada', 404);
        }
        Response::success($tienda, 'Detalle de la tienda');
    }

    /**
     * Retorna los productos pertenecientes a una tienda
     */
    public function productos(int $id): void {
        $productos = $this->model->getProductos($id);
        Response::success($productos, 'Productos de la tienda');
    }
}
