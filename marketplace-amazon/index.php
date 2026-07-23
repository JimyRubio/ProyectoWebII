<?php
require_once 'config/config.php';
require_once 'views/layouts/header.php';
?>

<div class="welcome-section">
    <h1>Bienvenido a MarketZone</h1>
    <p>Explora la experiencia de compra de próxima generación con tecnología multi-vendedor.</p>
</div>

<h2 class="section-title">Productos Destacados</h2>

<div id="productos-destacados" class="product-grid">
    <!-- Tarjeta de Prueba 1 -->
    <div class="product-card">
        <span class="product-badge">Oferta</span>
        <img src="https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?w=500&q=80" alt="Control Xbox Elite Series 2">
        <h3>Control Xbox Elite Series 2</h3>
        <p class="price">179.99</p>
        <button class="btn-primary"><i class="fa-solid fa-cart-plus"></i> Agregar al Carrito</button>
    </div>

    <!-- Tarjeta de Prueba 2 -->
    <div class="product-card">
        <span class="product-badge">Nuevo</span>
        <img src="https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&q=80" alt="MacBook Pro 16 M3 Max">
        <h3>MacBook Pro 16" M3 Max</h3>
        <p class="price">2,499.00</p>
        <button class="btn-primary"><i class="fa-solid fa-cart-plus"></i> Agregar al Carrito</button>
    </div>

    <!-- Tarjeta de Prueba 3 -->
    <div class="product-card">
        <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80" alt="Audífonos Sony WH-1000XM5">
        <h3>Audífonos Sony WH-1000XM5</h3>
        <p class="price">398.00</p>
        <button class="btn-primary"><i class="fa-solid fa-cart-plus"></i> Agregar al Carrito</button>
    </div>
</div>

<?php
require_once 'views/layouts/footer.php';
?>