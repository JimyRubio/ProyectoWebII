<?php
require_once 'config/config.php';
require_once 'views/layouts/header.php';
?>

<div class="welcome-section">
    <h1>Bienvenido a MarketZone</h1>
    <p>Explora la experiencia de compra de próxima generación con tecnología multi-vendedor.</p>
</div>

<h2 style="margin-bottom: 20px; font-weight: 600;">Productos Destacados</h2>

<div id="productos-destacados" class="product-grid">
    <!-- Tarjeta de Prueba 1 -->
    <div class="product-card">
        <img src="https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg" alt="Producto">
        <h3>Control Xbox Elite Series 2</h3>
        <p class="price">$179.99</p>
        <button class="btn-primary"><i class="fa-solid fa-cart-plus"></i> Agregar al Carrito</button>
    </div>

    <!-- Tarjeta de Prueba 2 -->
    <div class="product-card">
        <img src="https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg" alt="Producto">
        <h3>MacBook Pro 16" M3 Max</h3>
        <p class="price">$2,499.00</p>
        <button class="btn-primary"><i class="fa-solid fa-cart-plus"></i> Agregar al Carrito</button>
    </div>

    <!-- Tarjeta de Prueba 3 -->
    <div class="product-card">
        <img src="https://m.media-amazon.com/images/I/71ZpT-bMAtL._AC_SL1500_.jpg" alt="Producto">
        <h3>Audífonos Sony WH-1000XM5</h3>
        <p class="price">$398.00</p>
        <button class="btn-primary"><i class="fa-solid fa-cart-plus"></i> Agregar al Carrito</button>
    </div>
</div>

<?php
require_once 'views/layouts/footer.php';
?>