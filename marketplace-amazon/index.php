<?php
require_once 'config/config.php';
require_once 'views/layouts/header.php';
?>

<div class="welcome-section">
    <h1>Bienvenido a Marketplace Amazon</h1>
    <p>La plataforma multi-vendedor con catálogo de productos, carrito de compras y más.</p>
</div>

<!-- Aquí luego conectaremos dinámicamente el catálogo de productos con AJAX -->
<div id="productos-destacados" class="product-grid">
    <p>Cargando productos destacados...</p>
</div>

<?php
require_once 'views/layouts/footer.php';
?>