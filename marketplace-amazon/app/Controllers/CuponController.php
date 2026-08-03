<?php
require_once __DIR__ . '/../Models/CuponModel.php';

class CuponController {
    private CuponModel $model;

    public function __construct() {
        $this->model = new CuponModel();
    }

    /**
     * Retorna todos los cupones (admin)
     */
    public function all(): void {
        AuthHelper::requireAuth();
        Response::success($this->model->getAll(), 'Todos los cupones');
    }

    /**
     * Retorna cupones activos y vigentes
     */
    public function activos(): void {
        Response::success($this->model->getActivos(), 'Cupones activos');
    }

    /**
     * Valida un código de cupón (público - usado en carrito/checkout)
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

        Response::success($cupon, 'Cupón válido');
    }

    /**
     * Crea un nuevo cupón
     */
    public function store(): void {
        AuthHelper::requireAuth();

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        $codigo = strtoupper(trim(Security::sanitizeString($_POST['codigo'] ?? '')));
        $tipoDescuento = Security::sanitizeString($_POST['tipo_descuento'] ?? '');
        $valor = (float)($_POST['valor'] ?? 0);
        $fechaInicio = $_POST['fecha_inicio'] ?? '';
        $fechaFin = $_POST['fecha_fin'] ?? '';

        if (empty($codigo) || empty($tipoDescuento) || $valor <= 0 || empty($fechaInicio) || empty($fechaFin)) {
            Response::error('Código, tipo de descuento, valor, fecha inicio y fecha fin son requeridos', 400);
        }

        if (!in_array($tipoDescuento, ['porcentaje', 'monto_fijo'])) {
            Response::error('Tipo de descuento inválido', 400);
        }

        if ($tipoDescuento === 'porcentaje' && $valor > 100) {
            Response::error('El porcentaje de descuento no puede ser mayor a 100', 400);
        }

        // Validar fechas
        try {
            $inicio = new DateTime($fechaInicio);
            $fin = new DateTime($fechaFin);
            if ($fin <= $inicio) {
                Response::error('La fecha fin debe ser posterior a la fecha inicio', 400);
            }
        } catch (Exception $e) {
            Response::error('Formato de fechas inválido', 400);
        }

        $data = [
            'codigo'               => $codigo,
            'descripcion'          => Security::sanitizeString($_POST['descripcion'] ?? ''),
            'tipo_descuento'       => $tipoDescuento,
            'valor'                => $valor,
            'minimo_compra'        => (float)($_POST['minimo_compra'] ?? 0),
            'maximo_descuento'     => !empty($_POST['maximo_descuento']) ? (float)$_POST['maximo_descuento'] : null,
            'productos_aplicables' => null,
            'categorias_aplicables'=> null,
            'fecha_inicio'         => $fechaInicio,
            'fecha_fin'            => $fechaFin,
            'usa_veces'            => (int)($_POST['usa_veces'] ?? 1),
            'usa_por_cliente'      => (int)($_POST['usa_por_cliente'] ?? 1),
            'activo'               => isset($_POST['activo']) ? (int)$_POST['activo'] : 1
        ];

        try {
            $id = $this->model->create($data);
            Response::success(['id' => $id], 'Cupón creado exitosamente', 201);
        } catch (Exception $e) {
            // Error de código duplicado u otro
            Response::error('Error al crear cupón: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Actualiza un cupón existente
     */
    public function update(): void {
        AuthHelper::requireAuth();

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        $id = (int)($_POST['id'] ?? 0);
        if ($id <= 0) {
            Response::error('ID de cupón no válido', 400);
        }

        $codigo = strtoupper(trim(Security::sanitizeString($_POST['codigo'] ?? '')));
        $tipoDescuento = Security::sanitizeString($_POST['tipo_descuento'] ?? '');
        $valor = (float)($_POST['valor'] ?? 0);
        $fechaInicio = $_POST['fecha_inicio'] ?? '';
        $fechaFin = $_POST['fecha_fin'] ?? '';

        if (empty($codigo) || empty($tipoDescuento) || $valor <= 0 || empty($fechaInicio) || empty($fechaFin)) {
            Response::error('Código, tipo de descuento, valor, fecha inicio y fecha fin son requeridos', 400);
        }

        $data = [
            'codigo'               => $codigo,
            'descripcion'          => Security::sanitizeString($_POST['descripcion'] ?? ''),
            'tipo_descuento'       => $tipoDescuento,
            'valor'                => $valor,
            'minimo_compra'        => (float)($_POST['minimo_compra'] ?? 0),
            'maximo_descuento'     => !empty($_POST['maximo_descuento']) ? (float)$_POST['maximo_descuento'] : null,
            'productos_aplicables' => null,
            'categorias_aplicables'=> null,
            'fecha_inicio'         => $fechaInicio,
            'fecha_fin'            => $fechaFin,
            'usa_veces'            => (int)($_POST['usa_veces'] ?? 1),
            'usa_por_cliente'      => (int)($_POST['usa_por_cliente'] ?? 1),
            'activo'               => isset($_POST['activo']) ? (int)$_POST['activo'] : 1
        ];

        try {
            if ($this->model->update($id, $data)) {
                Response::success(null, 'Cupón actualizado exitosamente');
            } else {
                Response::error('No se pudo actualizar el cupón', 500);
            }
        } catch (Exception $e) {
            Response::error('Error al actualizar cupón: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Elimina un cupón
     */
    public function delete(int $id): void {
        AuthHelper::requireAuth();

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        if ($this->model->delete($id)) {
            Response::success(null, 'Cupón eliminado');
        } else {
            Response::error('Error al eliminar cupón', 500);
        }
    }

    /**
     * Activa o desactiva un cupón
     */
    public function toggle(): void {
        AuthHelper::requireAuth();

        $token = $_POST['csrf_token'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? null;
        if (!Security::verifyCsrfToken($token)) {
            Response::error('Token CSRF no válido o expirado', 403);
        }

        $id = (int)($_POST['id'] ?? $_GET['id'] ?? 0);
        if ($id <= 0) {
            Response::error('ID de cupón no válido', 400);
        }

        if ($this->model->toggleActivo($id)) {
            Response::success(null, 'Estado del cupón actualizado');
        } else {
            Response::error('Error al cambiar estado del cupón', 500);
        }
    }
}

