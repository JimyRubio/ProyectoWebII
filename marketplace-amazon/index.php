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

<!-- Botones de filtro por categorías -->
<h2 class="section-title">Categorías</h2>
<div id="categorias-filter-container" class="categorias-filter" style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:25px;justify-content:center;">
    <!-- Carga dinámica vía AJAX (productos.js) -->
</div>

<h2 class="section-title">Productos Destacados</h2>

<div id="productos-destacados" class="product-grid">
    <!-- Carga dinámica vía AJAX (productos.js) -->
</div>

<div id="productos-pagination">
    <!-- Paginador dinámico renderizado por utils.js -->
</div>

<style>
.categorias-filter .cat-btn {
    padding: 10px 22px;
    border: 1px solid var(--card-border);
    background: var(--card-bg);
    color: var(--text-primary);
    border-radius: 30px;
    cursor: pointer;
    font-size: 0.9rem;
    font-weight: 500;
    transition: all 0.3s ease;
}
.categorias-filter .cat-btn:hover {
    border-color: var(--secondary-accent);
    color: var(--secondary-accent);
}
.categorias-filter .cat-btn.active {
    background: var(--accent-gradient);
    color: #fff;
    border-color: transparent;
}
</style>

<?php
require_once 'views/layouts/footer.php';
?>
