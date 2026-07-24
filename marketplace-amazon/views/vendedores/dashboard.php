<?php
$page_title = "Seller Dashboard - MarketZone";
$module_css = "analytics.css";
$module_js = "vendedores.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="analytics-header-wrapper">
    <div class="analytics-title-group">
        <h1>
            <i class="fa-solid fa-store"></i> Seller Central Dashboard
            <span class="live-indicator">
                <span class="pulse-dot"></span> Panel de Vendedor
            </span>
        </h1>
        <p>Monitorea tus ventas, productos y desempeño como vendedor.</p>
    </div>
</div>

<div id="seller-dashboard-container">
    <!-- Carga dinámica vía AJAX (vendedores.js) -->
</div>

<h2 class="section-title" style="margin-top:40px;">Enlaces Rápidos</h2>
<div class="quick-links" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:15px;margin-top:15px;">
    <a href="<?php echo BASE_URL; ?>views/productos/gestion.php" class="kpi-card" style="text-decoration:none;padding:20px;display:flex;align-items:center;gap:15px;">
        <i class="fa-solid fa-box" style="font-size:2rem;color:var(--primary-accent)"></i>
        <div>
            <strong style="font-size:1.1rem;">Gestionar Productos</strong>
            <p style="color:var(--text-secondary);font-size:0.85rem;">Agrega, edita y administra tu inventario</p>
        </div>
    </a>
    <a href="<?php echo BASE_URL; ?>views/pedidos/historial.php" class="kpi-card" style="text-decoration:none;padding:20px;display:flex;align-items:center;gap:15px;">
        <i class="fa-solid fa-receipt" style="font-size:2rem;color:var(--secondary-accent)"></i>
        <div>
            <strong style="font-size:1.1rem;">Mis Pedidos</strong>
            <p style="color:var(--text-secondary);font-size:0.85rem;">Revisa pedidos recibidos y su estado</p>
        </div>
    </a>
    <a href="<?php echo BASE_URL; ?>views/promociones/gestion.php" class="kpi-card" style="text-decoration:none;padding:20px;display:flex;align-items:center;gap:15px;">
        <i class="fa-solid fa-tags" style="font-size:2rem;color:var(--price-color)"></i>
        <div>
            <strong style="font-size:1.1rem;">Promociones</strong>
            <p style="color:var(--text-secondary);font-size:0.85rem;">Crea ofertas y descuentos especiales</p>
        </div>
    </a>
    <a href="<?php echo BASE_URL; ?>views/mensajeria/chat.php" class="kpi-card" style="text-decoration:none;padding:20px;display:flex;align-items:center;gap:15px;">
        <i class="fa-regular fa-comments" style="font-size:2rem;color:var(--chart-purple)"></i>
        <div>
            <strong style="font-size:1.1rem;">Mensajería</strong>
            <p style="color:var(--text-secondary);font-size:0.85rem;">Chatea con tus clientes</p>
        </div>
    </a>
</div>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

