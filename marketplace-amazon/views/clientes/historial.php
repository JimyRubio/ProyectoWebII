<?php
$page_title = "Historial de Pedidos - MarketZone";
$module_css = "carrito.css";
$module_js = "clientes.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="container">
    <div class="catalogo-header">
        <h2><i class="fa-solid fa-clock-rotate-left"></i> Historial de Pedidos</h2>
    </div>

    <div id="historial-pedidos-container">
        <!-- Carga dinámica vía AJAX (clientes.js) -->
        <div style="text-align:center;padding:60px;">
            <i class="fa-solid fa-spinner fa-spin" style="font-size:2rem;color:var(--text-secondary)"></i>
            <p style="color:var(--text-secondary);margin-top:15px;">Cargando historial...</p>
        </div>
    </div>
</div>

<style>
.pedidos-table-wrapper {
    overflow-x: auto;
}

.pedidos-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    color: var(--text-primary);
}

.pedidos-table th {
    background: rgba(255,255,255,0.03);
    color: var(--text-secondary);
    font-weight: 600;
    font-size: 0.8rem;
    text-transform: uppercase;
    padding: 14px 16px;
    text-align: left;
    border-bottom: 1px solid var(--card-border);
}

.pedidos-table td {
    padding: 14px 16px;
    border-bottom: 1px solid rgba(255,255,255,0.04);
    vertical-align: middle;
}

.pedidos-table tr:hover td {
    background: rgba(255,255,255,0.03);
}

.badge-success {
    background: rgba(16,185,129,0.1);
    color: #34D399;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 600;
}

.badge-warning {
    background: rgba(245,158,11,0.1);
    color: #FBBF24;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 600;
}

.badge-danger {
    background: rgba(239,68,68,0.1);
    color: #F87171;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 600;
}

.badge-info {
    background: rgba(59,130,246,0.1);
    color: #60A5FA;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 600;
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

