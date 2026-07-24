<?php
$page_title = "Detalle de Producto - MarketZone";
$module_css = "productos.css";
$module_js = "productos.js";
require_once __DIR__ . '/../layouts/header.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
if ($id <= 0) {
    header('Location: ' . BASE_URL);
    exit;
}
?>

<div class="container">
    <div class="producto-detalle" id="producto-detalle-container" data-id="<?php echo $id; ?>">
        <!-- Carga dinámica vía AJAX -->
        <div style="text-align:center;padding:60px;grid-column:1/-1;">
            <i class="fa-solid fa-spinner fa-spin" style="font-size:2rem;color:var(--text-secondary)"></i>
            <p style="color:var(--text-secondary);margin-top:15px;">Cargando detalle del producto...</p>
        </div>
    </div>

    <!-- Sección de reseñas -->
    <div class="producto-resenas" style="margin-top:40px;">
        <h3><i class="fa-solid fa-star"></i> Reseñas de Clientes</h3>
        <div id="resenas-container" style="margin-top:20px;">
            <p style="color:var(--text-secondary)">Las reseñas se cargarán dinámicamente.</p>
        </div>
    </div>

    <!-- Productos relacionados -->
    <div style="margin-top:40px;">
        <h3 class="section-title">Productos Relacionados</h3>
        <div id="productos-relacionados" class="product-grid" style="margin-top:20px;">
            <!-- Carga dinámica vía AJAX -->
       
