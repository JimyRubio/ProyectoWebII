<?php
$page_title = "Cupones de Descuento - Vendedor";
$module_css = "productos.css";
$module_js = "cupon_vendedor.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-ticket"></i> Cupones de Descuento</h1>
    <p style="color:var(--text-secondary);font-size:0.95rem;">Estos son los cupones activos creados por el administrador. Se pueden aplicar en el Punto de Venta.</p>
</div>

<!-- Tabla de cupones activos -->
<div class="gestion-table-wrapper">
    <table class="gestion-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Código</th>
                <th>Descripción</th>
                <th>Tipo</th>
                <th>Valor</th>
                <th>Mínimo de Compra</th>
                <th>Vigencia</th>
                <th>Estado</th>
            </tr>
        </thead>
        <tbody id="lista-cupones-vendedor-body">
            <!-- Carga dinámica vía AJAX -->
        </tbody>
    </table>
</div>

<style>
.badge-success {
    background: rgba(16,185,129,0.15);
    color: #10B981;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 0.75rem;
    font-weight: 600;
}
.badge-secondary {
    background: rgba(148,163,184,0.15);
    color: #94A3B8;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 0.75rem;
    font-weight: 600;
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
