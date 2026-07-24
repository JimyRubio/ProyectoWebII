<?php
$page_title = "Mi Perfil - MarketZone";
$module_css = "carrito.css";
$module_js = "clientes.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="container">
    <h2 style="margin-bottom:25px;"><i class="fa-regular fa-user"></i> Mi Perfil</h2>
    <div id="perfil-container">
        <!-- Carga dinámica vía AJAX (clientes.js) -->
        <div style="text-align:center;padding:60px;">
            <i class="fa-solid fa-spinner fa-spin" style="font-size:2rem;color:var(--text-secondary)"></i>
            <p style="color:var(--text-secondary);margin-top:15px;">Cargando perfil...</p>
        </div>
    </div>
</div>

<style>
.perfil-header {
    display: flex;
    align-items: center;
    gap: 30px;
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 16px;
    padding: 30px;
    margin-bottom: 30px;
    flex-wrap: wrap;
}

.perfil-stats {
    display: flex;
    gap: 25px;
    margin-left: auto;
}

.stat-item {
    text-align: center;
}

.stat-value {
    display: block;
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--text-primary);
}

.stat-label {
    font-size: 0.8rem;
    color: var(--text-secondary);
}

.perfil-form-section,
.perfil-direcciones-section {
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 16px;
    padding: 25px;
    margin-bottom: 25px;
}

.perfil-form-section h3,
.perfil-direcciones-section h3 {
    margin-bottom: 20px;
    font-size: 1.15rem;
    display: flex;
    align-items: center;
    gap: 10px;
}

.direcciones-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 15px;
}

.direccion-card {
    background: rgba(255,255,255,0.03);
    border: 1px solid var(--card-border);
    border-radius: 12px;
    padding: 18px;
    position: relative;
}

.direccion-card.default {
    border-color: rgba(59,130,246,0.4);
}

.badge-default {
    position: absolute;
    top: 10px;
    right: 10px;
    background: rgba(59,130,246,0.1);
    color: #60A5FA;
    padding: 2px 10px;
    border-radius: 12px;
    font-size: 0.7rem;
    font-weight: 700;
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

