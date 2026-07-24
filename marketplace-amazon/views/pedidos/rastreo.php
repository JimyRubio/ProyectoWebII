<?php
$page_title = "Rastreo de Pedido - MarketZone";
$module_js = "pedidos.js";
require_once __DIR__ . '/../layouts/header.php';

$pedidoId = isset($_GET['id']) ? (int)$_GET['id'] : 0;
?>

<div class="welcome-section">
    <h1><i class="fa-solid fa-truck"></i> Rastreo de Pedido</h1>
    <p>Sigue el estado de tu pedido en tiempo real.</p>
</div>

<div id="rastreo-container" data-id="<?php echo $pedidoId; ?>">
    <!-- Carga dinámica vía AJAX (pedidos.js) -->
</div>

<style>
.timeline {
    position: relative;
    padding-left: 30px;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 10px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: rgba(255,255,255,0.1);
}

.timeline-item {
    position: relative;
    padding-bottom: 30px;
}

.timeline-item:last-child {
    padding-bottom: 0;
}

.timeline-marker {
    position: absolute;
    left: -22px;
    top: 4px;
    width: 14px;
    height: 14px;
    border-radius: 50%;
    background: var(--card-border);
    border: 2px solid var(--text-secondary);
}

.timeline-item.active .timeline-marker {
    background: var(--price-color);
    border-color: var(--price-color);
    box-shadow: 0 0 10px rgba(16,185,129,0.4);
}

.timeline-content {
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 10px;
    padding: 15px 20px;
}

.timeline-content h4 {
    font-size: 0.95rem;
    font-weight: 600;
    margin-bottom: 4px;
    color: var(--text-primary);
}

.timeline-content p {
    font-size: 0.85rem;
    color: var(--text-secondary);
}

.timeline-date {
    font-size: 0.75rem;
    color: var(--text-secondary);
    margin-top: 6px;
    display: block;
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

