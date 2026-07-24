<?php
$page_title = "Carrito de Compras - MarketZone";
$module_css = "carrito.css";
$module_js = "carrito.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="container carrito-page">
    <div class="carrito-header">
        <h2><i class="fa-solid fa-cart-shopping"></i> Mi Carrito de Compras</h2>
        <a href="<?php echo BASE_URL; ?>" class="btn-primary" style="width:auto;padding:10px 20px;text-decoration:none;display:inline-block;">
            <i class="fa-solid fa-arrow-left"></i> Seguir Comprando
        </a>
    </div>

    <div id="carrito-container">
        <!-- Carga dinámica vía AJAX (carrito.js) -->
        <div style="text-align:center;padding:60px;">
            <i class="fa-solid fa-spinner fa-spin" style="font-size:2rem;color:var(--text-secondary)"></i>
            <p style="color:var(--text-secondary);margin-top:15px;">Cargando carrito...</p>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

