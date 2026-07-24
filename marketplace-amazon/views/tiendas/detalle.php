<?php
$page_title = "Detalle de Tienda - MarketZone";
$module_css = "productos.css";
$module_js = "tiendas.js";
require_once __DIR__ . '/../layouts/header.php';

$tiendaId = isset($_GET['id']) ? (int)$_GET['id'] : 0;
?>

<div id="tienda-detalle-container" data-id="<?php echo $tiendaId; ?>">
    <!-- Carga dinámica vía AJAX -->
</div>

<h2 class="section-title" style="margin-top:40px;">Productos de esta Tienda</h2>
<div id="productos-tienda-grid" class="product-grid">
    <!-- Carga dinámica vía AJAX -->
</div>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

