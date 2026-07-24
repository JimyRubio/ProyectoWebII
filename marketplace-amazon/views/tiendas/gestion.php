<?php
$page_title = "Gestión de Tiendas - MarketZone";
$module_css = "productos.css";
$module_js = "tiendas.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="gestion-header">
    <h1><i class="fa-solid fa-store"></i> Gestión de Tiendas</h1>
</div>

<div id="gestion-tiendas-container">
    <!-- Carga dinámica vía AJAX -->
</div>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

