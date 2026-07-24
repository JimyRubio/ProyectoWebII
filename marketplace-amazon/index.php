<?php
$page_title = "MarketZone - Tu Marketplace Multivendedor";
$module_js = "productos.js";
require_once 'config/config.php';
require_once 'views/layouts/header.php';
?>

<div class="welcome-section">
    <h1>Bienvenido a MarketZone</h1>
    <p>Explora la experiencia de compra de próxima generación con tecnología multi-vendedor y ofertas exclusivas.</p>
</div>

<h2 class="section-title">Productos Destacados</h2>

<div id="productos-destacados" class="product-grid">
    <!-- Carga dinámica vía AJAX (productos.js) -->
</div>

<div id="productos-pagination">
    <!-- Paginador dinámico renderizado por utils.js -->
</div>

<?php
require_once 'views/layouts/footer.php';
?>