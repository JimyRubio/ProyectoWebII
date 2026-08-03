<?php
$page_title = "Checkout - MarketZone";
$module_css = "carrito.css";
$module_js = "pagos.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div id="checkout-container">
    <div class="welcome-section" style="margin-bottom:30px;">
        <h1><i class="fa-solid fa-credit-card"></i> Finalizar Compra</h1>
        <p>Revisa tu pedido y selecciona el método de pago.</p>
    </div>

    <div class="checkout-grid">
        <!-- Columna izquierda: Datos de envío y pago -->
        <div class="checkout-left">
            <!-- Dirección de envío -->
            <div class="checkout-section">
                <h3><i class="fa-solid fa-location-dot"></i> Dirección de Envío</h3>
                <div id="direcciones-envio">
                    <!-- Carga dinámica vía AJAX -->
                </div>
            </div>

            <!-- Método de pago -->
            <div class="checkout-section" id="metodo-pago-section">
                <h3><i class="fa-regular fa-credit-card"></i> Método de Pago</h3>
                <div id="metodos-pago-container">
                    <!-- Carga dinámica vía AJAX -->
                </div>
                <!-- Botón Siguiente: avanza al formulario del método seleccionado -->
                <button class="btn-primary" id="btn-siguiente" onclick="irAlFormulario()" style="width:100%;padding:14px;font-size:1rem;margin-top:15px;display:none;">
                    <i class="fa-solid fa-arrow-right"></i> Siguiente
                </button>
            </div>

            <!-- Datos de la Tarjeta de Crédito/Débito -->
            <div class="checkout-section payment-form-section" id="card-form-section" style="display:none;">
                <h3><i class="fa-regular fa-credit-card"></i> Datos de la Tarjeta</h3>
                <div class="card-form">
                    <div class="form-group">
                        <label>Número de Tarjeta</label>
                        <div class="input-container">
                            <i class="fa-regular fa-credit-card input-icon"></i>
                            <input type="text" id="card_number" class="form-control card-input" placeholder="1234 5678 9012 3456" maxlength="19" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Titular de la Tarjeta</label>
                        <div class="input-container">
                            <i class="fa-regular fa-user input-icon"></i>
                            <input type="text" id="card_name" class="form-control" placeholder="JUAN PÉREZ" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Fecha de Expiración</label>
                            <div class="input-container">
                                <i class="fa-regular fa-calendar input-icon"></i>
                                <input type="text" id="card_expiry" class="form-control" placeholder="MM/YY" maxlength="5" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>CVV</label>
                            <div class="input-container">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <input type="text" id="card_cvv" class="form-control" placeholder="123" maxlength="4" required>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Datos de PayPal -->
            <div class="checkout-section payment-form-section" id="paypal-form-section" style="display:none;">
                <h3><i class="fa-brands fa-paypal"></i> Datos de PayPal</h3>
                <div class="card-form">
                    <div class="form-group">
                        <label>Correo Electrónico de PayPal</label>
                        <div class="input-container">
                            <i class="fa-regular fa-envelope input-icon"></i>
                            <input type="email" id="paypal_email" class="form-control" placeholder="tucorreo@paypal.com" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Contraseña de PayPal</label>
                        <div class="input-container">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" id="paypal_password" class="form-control" placeholder="••••••••" required>
                        </div>
                    </div>
                </div>
            </div>

            <div id="btn-pagar-container" style="display:none;">
                <button class="btn-primary" id="btn-procesar-pago" onclick="procesarPago()" style="width:100%;padding:16px;font-size:1.1rem;margin-top:20px;">
                    <i class="fa-solid fa-check-circle"></i> Confirmar y Pagar
                </button>
            </div>

            <!-- Botón Volver (regresa a selección de método) -->
            <div id="btn-volver-container" style="display:none;">
                <button class="btn-secondary" id="btn-volver" onclick="volverAMetodos()" style="width:100%;padding:12px;font-size:1rem;margin-top:10px;">
                    <i class="fa-solid fa-arrow-left"></i> Volver a métodos de pago
                </button>
            </div>
        </div>

<!-- Columna derecha: Resumen -->
        <div class="checkout-right">
            <!-- Sección de Cupón -->
            <div class="checkout-section" id="cupon-section">
                <h3><i class="fa-solid fa-tag"></i> ¿Tienes un cupón?</h3>
<div id="cupon-form">
                    <div class="cupon-input-group">
                        <input type="text" id="cupon-codigo" class="form-control" placeholder="Ingresa el código del cupón" maxlength="50" style="width:100%;padding:14px 16px;border:1.5px solid var(--border-color);border-radius:8px;background:var(--bg-input);color:var(--text-primary);font-size:1rem;box-sizing:border-box;">
                        <button class="btn-primary" id="btn-aplicar-cupon" onclick="aplicarCupon()" style="width:100%;padding:14px;font-size:1rem;white-space:nowrap;">
                            <i class="fa-solid fa-check"></i> Aplicar
                        </button>
                    </div>
                    <div id="cupon-mensaje" style="margin-top:10px;font-size:0.85rem;"></div>
                </div>
                <div id="cupon-aplicado" style="display:none;">
                    <div class="cupon-aplicado-card">
                        <div class="cupon-info">
                            <span class="cupon-codigo-display" id="cupon-codigo-display"></span>
                            <span class="cupon-descuento-display" id="cupon-descuento-display"></span>
                        </div>
                        <button class="btn-remove-cupon" onclick="removerCupon()" title="Remover cupón">
                            <i class="fa-solid fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div id="resumen-compra" class="checkout-section">
                <!-- Carga dinámica vía AJAX (pagos.js) -->
            </div>
        </div>
    </div>
</div>

<style>
.checkout-grid {
    display: grid;
    grid-template-columns: 1.5fr 1fr;
    gap: 30px;
    align-items: start;
}

.checkout-section {
    background: var(--card-bg);
    border: 1px solid var(--card-border);
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

.metodo-pago-card {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 14px 18px;
    border: 1px solid var(--card-border);
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.2s;
    margin-bottom: 10px;
}

.metodo-pago-card:hover,
.metodo-pago-card input:checked + .metodo-pago-info {
    border-color: var(--primary-accent);
    background: rgba(59,130,246,0.05);
}

.metodo-pago-card input[type="radio"] {
    accent-color: var(--secondary-accent);
}

.metodo-pago-info {
    display: flex;
    flex-direction: column;
}

.metodo-nombre {
    font-weight: 600;
    font-size: 0.95rem;
}

.metodo-desc {
    font-size: 0.8rem;
    color: var(--text-secondary);
}

.direccion-envio-card {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 14px 18px;
    border: 1px solid var(--card-border);
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.2s;
    margin-bottom: 10px;
}

.direccion-envio-card:hover,
.direccion-envio-card.selected {
    border-color: var(--primary-accent);
    background: rgba(59,130,246,0.05);
}

.direccion-envio-card input[type="radio"] {
    accent-color: var(--secondary-accent);
    margin-top: 3px;
}

.direccion-envio-info {
    display: flex;
    flex-direction: column;
    gap: 3px;
}

.direccion-envio-info strong {
    font-size: 0.9rem;
}

.direccion-envio-info span {
    font-size: 0.8rem;
    color: var(--text-secondary);
}

.resumen-items {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-bottom: 20px;
}

.resumen-item {
    display: flex;
    justify-content: space-between;
    font-size: 0.9rem;
    padding: 8px 0;
    border-bottom: 1px solid rgba(255,255,255,0.04);
}

.resumen-totals {
    border-top: 1px solid var(--card-border);
    padding-top: 15px;
}

.cupon-input-group {
    display: flex;
    flex-direction: column;
    gap: 10px;
    width: 100%;
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

#cupon-mensaje.success {
    color: #10B981;
}

#cupon-mensaje.error {
    color: #EF4444;
}

@media (max-width: 1024px) {
    .checkout-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

