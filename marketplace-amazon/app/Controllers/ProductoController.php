<?php
require_once __DIR__ . '/../Models/ProductoModel.php';

class ProductoController {
    private ProductoModel $model;

    public function __construct() {
        $this->model = new ProductoModel();
    }

    /**
     * Retorna lista paginada de productos en JSON para AJAX
     */
    public function index(): void {
        $page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
        $limit = isset($_GET['limit']) ? max(1, (int)$_GET['limit']) : 10;
        $search = isset($_GET['search']) ? Security::sanitizeString($_GET['search']) : '';
        $categoriaId = isset($_GET['categoria_id']) ? (int)$_GET['categoria_id'] : null;
        $tiendaId = isset($_GET['tienda_id']) ? (int)$_GET['tienda_id'] : null;

        $offset = ($page - 1) * $limit;

        $productos = $this->model->getAll($limit, $offset, $search, $categoriaId, $tiendaId);
        $total = $this->model->countFiltered($search, $categoriaId, $tiendaId);
        $totalPages = ceil($total / $limit);

        Response::success([
            'productos' => $productos,
            'pagination' => [
                'current_page' => $page,
                'limit' => $limit,
                'total_records' => $total,
                'total_pages' => $totalPages
            ]
        ], 'Productos obtenidos correctamente');
    }

    /**
     * Retorna productos destacados para la página principal
     */
    public function destacados(): void {
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 6;
        $destacados = $this->model->getDestacados($limit);
        Response::success($destacados, 'Productos destacados obtenidos');
    }

    /**
     * Obtiene el detalle de un producto
     */
    public function show(int $id): void {
        $producto = $this->model->getById($id);
        if (!$producto) {
            Response::error('Producto no encontrado', 404);
        }
        Response::success($producto, 'Detalle del producto');
    }

    /**
     * Crea un nuevo producto (requiere CSRF y autenticación)
     */
    public function store(): void {
        AuthHelper::requireAuth();

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        $nombre = Security::sanitizeString($_POST['nombre'] ?? '');
        $precio = (float)($_POST['precio'] ?? 0);
        $sku = Security::sanitizeString($_POST['sku'] ?? ('SKU-' . rand(1000, 9999)));
        $categoriaId = (int)($_POST['categoria_id'] ?? 1);
        $tiendaId = (int)($_POST['tienda_id'] ?? 1);

        if (empty($nombre) || $precio <= 0) {
            Response::error('El nombre y un precio válido son requeridos', 400);
        }

        $data = [
            'tienda_id' => $tiendaId,
            'categoria_id' => $categoriaId,
            'nombre' => $nombre,
            'slug' => strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $nombre))),
            'sku' => $sku,
            'precio' => $precio,
            'precio_oferta' => !empty($_POST['precio_oferta']) ? (float)$_POST['precio_oferta'] : null,
            'stock' => (int)($_POST['stock'] ?? 10),
            'descripcion_corta' => Security::sanitizeString($_POST['descripcion_corta'] ?? ''),
            'descripcion_larga' => Security::sanitizeString($_POST['descripcion_larga'] ?? ''),
            'imagen_url' => Security::sanitizeString($_POST['imagen_url'] ?? '')
        ];

        try {
            $productoId = $this->model->create($data);
            Response::success(['id' => $productoId], 'Producto creado exitosamente', 201);
        } catch (Exception $e) {
            Response::error('Error al guardar el producto: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Actualiza el stock de un producto usando Stored Procedure
     */
    public function updateStock(): void {
        AuthHelper::requireAuth();

        $productoId = (int)($_POST['producto_id'] ?? 0);
        $cantidad = (int)($_POST['cantidad'] ?? 0);
        $tipo = Security::sanitizeString($_POST['tipo'] ?? 'salida');

        if ($productoId <= 0 || $cantidad <= 0) {
            Response::error('ID de producto y cantidad requeridos', 400);
        }

        try {
            $result = $this->model->updateStockSP($productoId, $cantidad, $tipo);
            Response::success($result, 'Stock actualizado correctamente mediante Stored Procedure');
        } catch (Exception $e) {
            Response::error('Error al ejecutar SP actualizar_stock: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Elimina un producto
     */
    public function delete(int $id): void {
        AuthHelper::requireAuth();
        if ($this->model->delete($id)) {
            Response::success(null, 'Producto eliminado');
        } else {
            Response::error('Error al eliminar producto', 500);
        }
    }
}
