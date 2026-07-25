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
        // Generar SKU automático formato código de barras: MKT-YYYYMMDD-XXXX
        $skuInput = Security::sanitizeString($_POST['sku'] ?? '');
        if (empty($skuInput)) {
            $datePart = date('Ymd');
            $randomPart = str_pad(mt_rand(1, 9999), 4, '0', STR_PAD_LEFT);
            $sku = 'MKT-' . $datePart . '-' . $randomPart;
        } else {
            $sku = $skuInput;
        }
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
     * Retorna la lista de categorías activas
     */
    public function categorias(): void {
        $categorias = $this->model->getCategorias();
        Response::success($categorias, 'Categorías obtenidas');
    }

    /**
     * Retorna productos relacionados (misma categoría, excluyendo el actual)
     */
    public function relacionados(): void {
        $categoriaId = isset($_GET['categoria_id']) ? (int)$_GET['categoria_id'] : 0;
        $excludeId = isset($_GET['exclude_id']) ? (int)$_GET['exclude_id'] : 0;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 4;

        if ($categoriaId <= 0) {
            Response::success([], 'No se especificó categoría');
            return;
        }

        $productos = $this->model->getRelacionados($categoriaId, $excludeId, $limit);
        Response::success($productos, 'Productos relacionados obtenidos');
    }

    /**
     * Actualiza un producto existente (solo administrador)
     */
    public function update(): void {
        AuthHelper::requireAuth();
        // Solo administrador puede editar productos
        if (!AuthHelper::hasRole('administrador') && !AuthHelper::hasRole('admin')) {
            Response::error('No tienes permisos para editar productos', 403);
        }

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        $id = (int)($_POST['id'] ?? 0);
        if ($id <= 0) {
            Response::error('ID de producto no válido', 400);
        }

        $data = [
            'categoria_id' => (int)($_POST['categoria_id'] ?? 1),
            'nombre' => Security::sanitizeString($_POST['nombre'] ?? ''),
            'descripcion_corta' => Security::sanitizeString($_POST['descripcion_corta'] ?? ''),
            'descripcion_larga' => Security::sanitizeString($_POST['descripcion_larga'] ?? ''),
            'precio' => (float)($_POST['precio'] ?? 0),
            'precio_oferta' => !empty($_POST['precio_oferta']) ? (float)$_POST['precio_oferta'] : null,
            'stock' => (int)($_POST['stock'] ?? 0),
            'estado' => Security::sanitizeString($_POST['estado'] ?? 'activo'),
            'destacado' => (int)($_POST['destacado'] ?? 0),
            'oferta' => (int)($_POST['oferta'] ?? 0)
        ];

        if (empty($data['nombre']) || $data['precio'] <= 0) {
            Response::error('El nombre y un precio válido son requeridos', 400);
        }

        try {
            if ($this->model->update($id, $data)) {
                Response::success(null, 'Producto actualizado exitosamente');
            } else {
                Response::error('Error al actualizar el producto', 500);
            }
        } catch (Exception $e) {
            Response::error('Error al actualizar el producto: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Obtiene las reseñas de un producto
     */
    public function resenas(): void {
        $productoId = isset($_GET['producto_id']) ? (int)$_GET['producto_id'] : 0;
        if ($productoId <= 0) {
            Response::error('ID de producto requerido', 400);
        }
        $resenas = $this->model->getResenas($productoId);
        Response::success($resenas, 'Reseñas obtenidas');
    }

    /**
     * Guarda una reseña de producto
     */
    public function storeResena(): void {
        AuthHelper::requireAuth();

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        $productoId = (int)($_POST['producto_id'] ?? 0);
        $calificacion = (int)($_POST['calificacion'] ?? 0);
        $comentario = Security::sanitizeString($_POST['comentario'] ?? '');
        $user = AuthHelper::user();

        if ($productoId <= 0 || $calificacion < 1 || $calificacion > 5) {
            Response::error('Datos de reseña inválidos', 400);
        }

        if (!$user['cliente_id']) {
            Response::error('Solo los clientes pueden dejar reseñas', 403);
        }

        try {
            $data = [
                'producto_id' => $productoId,
                'cliente_id' => $user['cliente_id'],
                'calificacion' => $calificacion,
                'comentario' => $comentario
            ];
            $result = $this->model->createResena($data);
            Response::success($result, 'Reseña enviada exitosamente');
        } catch (Exception $e) {
            Response::error('Error al guardar la reseña: ' . $e->getMessage(), 500);
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
