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

    <div class="carrito-grid">
        <!-- Columna izquierda: Items del carrito -->
        <div class="carrito-main">
            <div id="carrito-container">
                <!-- Carga dinámica vía AJAX (carrito.js) -->
                <div style="text-align:center;padding:60px;">
                    <i class="fa-solid fa-spinner fa-spin" style="font-size:2rem;color:var(--text-secondary)"></i>
                    <p style="color:var(--text-secondary);margin-top:15px;">Cargando carrito...</p>
                </div>
            </div>
        </div>

        <!-- Columna derecha: Cupón y resumen -->
        <div class="carrito-sidebar">
            <!-- Sección de Cupón -->
            <div class="checkout-section" id="cupon-section-carrito">
                <h3><i class="fa-solid fa-tag"></i> ¿Tienes un cupón?</h3>
                <div id="cupon-form-carrito">
                    <div class="cupon-input-group">
                        <input type="text" id="cupon-codigo-carrito" class="form-control" placeholder="Ingresa el código del cupón" maxlength="50" style="flex:1;padding:10px 14px;border:1.5px solid var(--border-color);border-radius:8px;background:var(--bg-input);color:var(--text-primary);font-size:0.95rem;">
                        <button class="btn-primary" id="btn-aplicar-cupon-carrito" onclick="aplicarCuponCarrito()" style="padding:10px 18px;white-space:nowrap;">
                            <i class="fa-solid fa-check"></i> Aplicar
                        </button>
                    </div>
                    <div id="cupon-mensaje-carrito" style="margin-top:10px;font-size:0.85rem;"></div>
                </div>
                <div id="cupon-aplicado-carrito" style="display:none;">
                    <div class="cupon-aplicado-card">
                        <div class="cupon-info">
                            <span class="cupon-codigo-display" id="cupon-codigo-display-carrito"></span>
                            <span class="cupon-descuento-display" id="cupon-descuento-display-carrito"></span>
                        </div>
                        <button class="btn-remove-cupon" onclick="removerCuponCarrito()" title="Remover cupón">
                            <i class="fa-solid fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.carrito-grid {
    display: grid;
    grid-template-columns: 1.5fr 1fr;
    gap: 30px;
    align-items: start;
}

.carrito-main {
    min-width: 0;
}

.carrito-sidebar {
    min-width: 0;
}

.checkout-section {
    background: var(--bg-card);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 20px;
}

.checkout-section h3 {
    font-size: 1.1rem;
    font-weight: 600;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
    color: var(--text-primary);
}

.cupon-input-group {
    display: flex;
    gap: 10px;
    align-items: center;
}

.cupon-aplicado-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: rgba(16,185,129,0.1);
    border: 1px solid rgba(16,185,129,0.3);
    border-radius: 10px;
    padding: 12px 16px;
}

.cupon-aplicado-card .cupon-info {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.cupon-codigo-display {
    font-weight: 700;
    font-size: 0.95rem;
    color: var(--secondary-accent);
    letter-spacing: 1px;
}

.cupon-descuento-display {
    font-size: 0.85rem;
    color: var(--text-secondary);
}

.btn-remove-cupon {
    background: transparent;
    border: none;
    color: var(--text-secondary);
    font-size: 1.2rem;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 6px;
    transition: all 0.2s;
}

.btn-remove-cupon:hover {
    background: rgba(239,68,68,0.15);
    color: #EF4444;
}

#cupon-mensaje-carrito.success {
    color: #10B981;
}

#cupon-mensaje-carrito.error {
    color: #EF4444;
}

@media (max-width: 1024px) {
    .carrito-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

