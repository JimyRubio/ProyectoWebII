<?php
$page_title = "Gestión de Promociones - MarketZone";
$module_js = "promociones.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div class="welcome-section">
    <h1>Gestión de Promociones y Cupones</h1>
    <p>Administra las ofertas globales y descuentos del marketplace.</p>
</div>

<div class="promo-toolbar">
    <div class="promo-actions">
        <button class="btn-primary" id="btn-nueva-promo">
            <i class="fa-solid fa-plus"></i> Nueva Promoción
        </button>
        <button class="btn-primary" id="btn-validar-cupon" style="background: var(--blue-gradient);">
            <i class="fa-solid fa-ticket"></i> Validar Cupón
        </button>
    </div>

<!-- Formulario nueva promoción -->
<div id="form-nueva-promo" class="producto-form" style="display:none;margin-bottom:30px;">
    <h3><i class="fa-solid fa-tag"></i> Crear Nueva Promoción</h3>
    <form id="form-create-promo">
        <div class="form-section">
            <div class="form-row">
                <div class="form-group">
                    <label>Nombre *</label>
                    <input type="text" name="nombre" class="form-control" placeholder="Ej: Oferta de Verano" required>
                </div>
                <div class="form-group">
                    <label>Código (opcional)</label>
                    <input type="text" name="codigo" class="form-control" placeholder="Ej: VERANO25">
                </div>
            <div class="form-group">
                <label>Descripción</label>
                <textarea name="descripcion" class="form-control" rows="2" placeholder="Describe la promoción..."></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Tipo *</label>
                    <select name="tipo" class="form-control" required>
                        <option value="porcentaje">% Porcentaje de Descuento</option>
                        <option value="monto_fijo">💰 Monto Fijo</option>
                        <option value="envio_gratis">🚚 Envío Gratis</option>
                        <option value="combo">📦 Combo</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Valor *</label>
                    <input type="number" step="0.01" name="valor" class="form-control" placeholder="Ej: 25 (para 25%)" required>
                </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Fecha Inicio *</label>
                    <input type="datetime-local" name="fecha_inicio" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Fecha Fin *</label>
                    <input type="datetime-local" name="fecha_fin" class="form-control" required>
                </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Mínimo de Compra</label>
                    <input type="number" step="0.01" name="minimo_compra" class="form-control" value="0">
                </div>
                <div class="form-group">
                    <label>Usos por Cliente</label>
                    <input type="number" name="usa_por_cliente" class="form-control" value="1">
                </div>
        </div>
        <button type="submit" class="btn-primary">
            <i class="fa-solid fa-save"></i> Guardar Promoción
        </button>
    </form>
</div>

<!-- Grid de Promociones Activas -->
<h2 class="section-title">Promociones Vigentes</h2>
<div id="promociones-grid" class="promo-grid">
    <!-- Carga dinámica vía AJAX -->
</div>

<!-- Modal Validar Cupón -->
<div id="cupon-modal" class="modal-overlay" style="display:none;">
    <div class="modal-content">
        <span class="modal-close">&times;</span>
        <h3><i class="fa-solid fa-ticket"></i> Validar Cupón de Descuento</h3>
        <div class="form-group">
            <label>Código del Cupón</label>
            <input type="text" id="cupon-codigo-input" class="form-control" placeholder="Ej: BIENVENIDO10">
        </div>
        <div id="cupon-result"></div>
        <button class="btn-primary" id="btn-verificar-cupon">
            <i class="fa-solid fa-check"></i> Verificar Cupón
        </button>
    </div>

<style>
.promo-toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    gap: 15px;
    flex-wrap: wrap;
}

.promo-actions {
    display: flex;
    gap: 12px;
}

.promo-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.promo-card {
    background: var(--card-bg);
    backdrop-filter: blur(10px);
    border: 1px solid var(--card-border);
    border-radius: 14px;
    padding: 24px;
    transition: all 0.3s ease;
}

.promo-card:hover {
    transform: translateY(-4px);
    border-color: rgba(255, 153, 0, 0.3);
}

.promo-card .promo-tag {
    display: inline-block;
    background: var(--accent-gradient);
    color: #fff;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    margin-bottom: 12px;
}

.promo-card h3 {
    font-size: 1.15rem;
    margin-bottom: 8px;
}

.promo-card .promo-desc {
    color: var(--text-secondary);
    font-size: 0.9rem;
    margin-bottom: 15px;
}

.promo-card .promo-meta {
    display: flex;
    justify-content: space-between;
    font-size: 0.85rem;
    color: var(--text-secondary);
    border-top: 1px solid var(--card-border);
    padding-top: 12px;
}

.promo-card .promo-value {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--price-color);
    margin-bottom: 10px;
}

.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.7);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2000;
}

.modal-content {
    background: var(--card-bg);
    backdrop-filter: blur(12px);
    border: 1px solid var(--card-border);
    border-radius: 16px;
    padding: 30px;
    width: 90%;
    max-width: 480px;
    animation: fadeIn 0.3s ease;
}

.modal-close {
    float: right;
    font-size: 1.8rem;
    cursor: pointer;
    color: var(--text-secondary);
}

.modal-content h3 {
    margin-bottom: 20px;
    color: var(--text-primary);
}

#cupon-result {
    margin: 15px 0;
    padding: 12px;
    border-radius: 8px;
    display: none;
}

#cupon-result.success {
    display: block;
    background: rgba(16, 185, 129, 0.1);
    border: 1px solid rgba(16, 185, 129, 0.3);
    color: #34D399;
}

#cupon-result.error {
    display: block;
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #F87171;
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>
