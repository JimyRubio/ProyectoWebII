<?php
$is_auth_page = true;
$page_title = "Recuperar Contraseña - MarketZone";
$module_js = "auth.js";
require_once '../../config/config.php';
require_once '../../views/layouts/header.php';
?>

<div class="container auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Recuperar Contraseña</h2>
            <p>Ingresa tu correo electrónico y te enviaremos instrucciones para restablecer tu contraseña.</p>
        </div>

        <form id="form-forgot-password">
            <div class="form-group">
                <label for="email">Correo Electrónico</label>
                <div class="input-container">
                    <i class="fa-regular fa-envelope input-icon"></i>
                    <input type="email" id="forgot-email" name="email" class="form-control" placeholder="usuario@ejemplo.com" required>
                </div>
            </div>

            <button type="submit" class="btn-primary">
                <i class="fa-solid fa-paper-plane"></i> Enviar Instrucciones
            </button>
        </form>

        <div id="forgot-success-msg" style="display:none;text-align:center;padding:20px;">
            <i class="fa-solid fa-check-circle" style="font-size:2.5rem;color:var(--price-color);display:block;margin-bottom:10px;"></i>
            <p style="color:var(--text-primary);font-weight:600;">Correo enviado exitosamente</p>
            <p style="color:var(--text-secondary);font-size:0.9rem;margin-top:5px;">Revisa tu bandeja de entrada para restablecer tu contraseña.</p>
        </div>

        <div class="switch-auth" style="margin-top:20px;">
            <a href="login.php"><i class="fa-solid fa-arrow-left"></i> Volver a Iniciar Sesión</a>
        </div>
    </div>
</div>

<style>
#form-forgot-password .form-group {
    margin-bottom: 20px;
}
#forgot-success-msg {
    animation: fadeIn 0.5s ease;
}
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>

<?php
require_once '../../views/layouts/footer.php';
?>

