<?php
$is_auth_page = true; // Oculta el buscador y carrito en esta página
$module_js = "auth.js";
require_once '../../config/config.php';
require_once '../../views/layouts/header.php';
?>

<div class="container auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Crear una Cuenta</h2>
            <p>Ingresa tus datos para registrarte</p>
        </div>

        <form action="register.php" method="POST">
            <!-- Nombre Completo -->
            <div class="form-group">
                <label for="full_name">Nombre Completo</label>
                <div class="input-container">
                    <i class="fa-regular fa-user input-icon"></i>
                    <input type="text" id="full_name" name="full_name" class="form-control" placeholder="Juan Pérez" required>
                </div>
            </div>

            <!-- Correo Electrónico -->
            <div class="form-group">
                <label for="email">Correo Electrónico</label>
                <div class="input-container">
                    <i class="fa-regular fa-envelope input-icon"></i>
                    <input type="email" id="email" name="email" class="form-control" placeholder="usuario@ejemplo.com" required>
                </div>
            </div>

            <!-- Contraseñas -->
            <div class="form-row">
                <div class="form-group">
                    <label for="reg_password">Contraseña</label>
                    <div class="input-container">
                        <i class="fa-solid fa-key input-icon"></i>
                        <input type="password" id="reg_password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirm_password">Confirmar</label>
                    <div class="input-container">
                        <i class="fa-solid fa-shield input-icon"></i>
                        <input type="password" id="confirm_password" name="confirm_password" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>
            </div>

            <!-- Términos -->
            <label class="terms-container">
                <input type="checkbox" name="terms" required> Acepto los <a href="#">términos y condiciones</a>
            </label>

            <button type="submit" class="btn-primary">
                <i class="fa-solid fa-user-plus"></i> Registrar Cuenta
            </button>
        </form>

        <div class="switch-auth">
            ¿Ya tienes una cuenta? <a href="login.php">Inicia sesión</a>
        </div>
    </div>
</div>

<?php
require_once '../../views/layouts/footer.php';
?>