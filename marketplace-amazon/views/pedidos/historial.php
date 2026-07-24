<?php
$page_title = "Historial de Pedidos - MarketZone";
$module_js = "clientes.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="welcome-section">
    <h1><i class="fa-solid fa-receipt"></i> Mis Pedidos</h1>
    <p>Historial completo de todas tus compras realizadas en el marketplace.</p>
</div>

<div id="historial-pedidos-container">
    <!-- Carga dinámica vía AJAX (clientes.js) -->
</div>

<style>
.pedidos-table-wrapper {
    overflow-x: auto;
    margin-top: 20px;
}

.pedidos-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    color: var(--text-primary);
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 14px;
    overflow: hidden;
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
}

.pedidos-table tr:hover td {
    background: rgba(255,255,255,0.03);
}

.pedidos-table tr:last-child td {
    border-bottom: none;
}

.badge-success {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    background: rgba(16,185,129,0.1);
    color: #34D399;
}

.badge-warning {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    background: rgba(245,158,11,0.1);
    color: #F59E0B;
}

.badge-danger {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    background: rgba(239,68,68,0.1);
    color: #F87171;
}

.badge-info {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    background: rgba(59,130,246,0.1);
    color: #60A5FA;
}

.badge-primary {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    background: rgba(255,153,0,0.1);
    color: var(--secondary-accent);
}

.badge-secondary {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    background: rgba(156,163,175,0.1);
    color: #9CA3AF;
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

