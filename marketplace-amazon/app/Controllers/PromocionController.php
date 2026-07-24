<?php
require_once __DIR__ . '/../Models/PromocionModel.php';

class PromocionController {
    private PromocionModel $model;

    public function __construct() {
        $this->model = new PromocionModel();
    }

    /**
     * Retorna lista de promociones vigentes
     */
    public function index(): void {
        Response::success($this->model->getActivas(), 'Promociones y ofertas activas');
    }

    /**
     * Retorna todas las promociones (admin/vendedor)
     */
    public function all(): void {
        AuthHelper::requireAuth();
        Response::success($this->model->getAll(), 'Todas las promociones');
    }

    /**
     * Crea una nueva promoción
     */
    public function store(): void {
        AuthHelper::requireAuth();

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        $nombre = Security::sanitizeString($_POST['nombre'] ?? '');
        $tipo = Security::sanitizeString($_POST['tipo'] ?? '');
        $valor = (float)($_POST['valor'] ?? 0);
        $fechaInicio = $_POST['fecha_inicio'] ?? '';
        $fechaFin = $_POST['fecha_fin'] ?? '';

        if (empty($nombre) || empty($tipo) || $valor <= 0 || empty($fechaInicio) || empty($fechaFin)) {
            Response::error('Nombre, tipo, valor, fecha inicio y fecha fin son requeridos', 400);
        }

        $data = [
            'codigo' => !empty($_POST['codigo']) ? strtoupper(trim($_POST['codigo'])) : null,
            'nombre' => $nombre,
            'descripcion' => Security::sanitizeString($_POST['descripcion'] ?? ''),
            'tipo' => $tipo,
            'valor' => $valor,
            'minimo_compra' => (float)($_POST['minimo_compra'] ?? 0),
            'maximo_descuento' => !empty($_POST['maximo_descuento']) ? (float)$_POST['maximo_descuento'] : null,
            'usa_veces' => (int)($_POST['usa_veces'] ?? 1),
            'usa_por_cliente' => (int)($_POST['usa_por_cliente'] ?? 1),
            'fecha_inicio' => $fechaInicio,
            'fecha_fin' => $fechaFin
        ];

        try {
            $id = $this->model->create($data);
            Response::success(['id' => $id], 'Promoción creada exitosamente', 201);
        } catch (Exception $e) {
            Response::error('Error al crear promoción: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Actualiza una promoción
     */
    public function update(): void {
        AuthHelper::requireAuth();
        $id = (int)($_POST['id'] ?? 0);
        if ($id <= 0) Response::error('ID de promoción no válido', 400);

        $data = [
            'codigo' => !empty($_POST['codigo']) ? strtoupper(trim($_POST['codigo'])) : null,
            'nombre' => Security::sanitizeString($_POST['nombre'] ?? ''),
            'descripcion' => Security::sanitizeString($_POST['descripcion'] ?? ''),
            'tipo' => Security::sanitizeString($_POST['tipo'] ?? ''),
            'valor' => (float)($_POST['valor'] ?? 0),
            'minimo_compra' => (float)($_POST['minimo_compra'] ?? 0),
            'fecha_inicio' => $_POST['fecha_inicio'] ?? '',
            'fecha_fin' => $_POST['fecha_fin'] ?? ''
        ];

        if ($this->model->update($id, $data)) {
            Response::success(null, 'Promoción actualizada');
        } else {
            Response::error('Error al actualizar', 500);
        }
    }

    /**
     * Elimina una promoción
     */
    public function delete(int $id): void {
        AuthHelper::requireAuth();
        if ($this->model->delete($id)) {
            Response::success(null, 'Promoción eliminada');
        } else {
            Response::error('Error al eliminar promoción', 500);
        }
    }

    /**
     * Valida un código de cupón
     */
    public function validarCupon(): void {
        $codigo = Security::sanitizeString($_POST['codigo'] ?? $_GET['codigo'] ?? '');
        if (empty($codigo)) {
            Response::error('Código de cupón requerido', 400);
        }

        $cupon = $this->model->validarCupon($codigo);
        if (!$cupon) {
            Response::error('El cupón no es válido o ha expirado', 404);
        }

        Response::success($cupon, 'Cupón válido aplicado');
    }
}
