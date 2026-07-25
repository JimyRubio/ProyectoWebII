<?php
$is_auth_page = true;
$page_title = "Restablecer Contraseña - MarketZone";
$module_js = "auth.js";
require_once '../../config/config.php';
require_once '../../views/layouts/header.php';

$token = isset($_GET['token']) ? Security::sanitizeString($_GET['token']) : '';
if (empty($token)) {
    header('Location: forgot_password.php');
    exit;
}
?>

<div class="container auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Restablecer Contraseña</h2>
            <p>Ingresa tu nueva contraseña para acceder a tu cuenta.</p>
        </div>

        <form id="form-reset-password">
            <div class="form-group">
                <label for="token_input">Token de Recuperación</label>
                <div class="input-container">
                    <i class="fa-solid fa-key input-icon"></i>
                    <input type="text" id="token_input" name="token" class="form-control" value="<?php echo $token; ?>" placeholder="Pega aquí el token recibido" style="font-family:monospace;font-size:0.85rem;" required>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Nueva Contraseña</label>
                <div class="input-container">
                    <i class="fa-solid fa-key input-icon"></i>
                    <input type="password" id="reset-password" name="password" class="form-control" placeholder="Mín. 6 caracteres" required minlength="6">
                    <button type="button" class="toggle-password" onclick="togglePassword('reset-password', 'icon-reset-pass')">
                        <i id="icon-reset-pass" class="fa-regular fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="form-group">
                <label for="confirm_password">Confirmar Nueva Contraseña</label>
                <div class="input-container">
                    <i class="fa-solid fa-key input-icon"></i>
                    <input type="password" id="reset-confirm" name="confirm_password" class="form-control" placeholder="Repite la contraseña" required>
                    <button type="button" class="toggle-password" onclick="togglePassword('reset-confirm', 'icon-reset-confirm')">
                        <i id="icon-reset-confirm" class="fa-regular fa-eye"></i>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn-primary">
                <i class="fa-solid fa-check-circle"></i> Restablecer Contraseña
            </button>
        </form>

        <div class="switch-auth" style="margin-top:20px;">
            <a href="login.php"><i class="fa-solid fa-arrow-left"></i> Volver a Iniciar Sesión</a>
        </div>
    </div>
</div>

<script>
function togglePassword(inputId, iconId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(iconId);
    if (input.type === "password") {
        input.type = "text";
        icon.classList.replace("fa-eye", "fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.replace("fa-eye-slash", "fa-eye");
    }
}
</script>

<?php
require_once '../../views/layouts/footer.php';
?>

