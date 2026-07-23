<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión</title>
    
    <!-- Enlaces corregidos a la carpeta public -->
    <link rel="stylesheet" href="../../public/css/layout.css">
    <link rel="stylesheet" href="../../public/css/main.css">
    
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <!-- Header del proyecto -->
    <header class="main-header">
        <div class="logo">
            <h2>SISTEMA <span>STORE</span></h2>
        </div>
        <div class="user-nav">
            <a href="register.php" class="nav-link"><i class="fa-solid fa-user-plus"></i> Registrarse</a>
        </div>
    </header>

    <!-- Formulario de Login -->
    <div class="container auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Bienvenido de nuevo</h2>
                <p>Ingresa tus credenciales para acceder</p>
            </div>

            <form action="login.php" method="POST">
                <!-- Usuario / Correo -->
                <div class="form-group">
                    <label for="email_or_user">Correo o Usuario</label>
                    <div class="input-container">
                        <i class="fa-regular fa-envelope input-icon"></i>
                        <input type="text" id="email_or_user" name="email_or_user" class="form-control" placeholder="usuario@ejemplo.com" required>
                    </div>
                </div>

                <!-- Contraseña -->
                <div class="form-group">
                    <label for="password">Contraseña</label>
                    <div class="input-container">
                        <i class="fa-solid fa-key input-icon"></i>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                        <button type="button" class="toggle-password" onclick="togglePassword('password', 'icon-pass')">
                            <i id="icon-pass" class="fa-regular fa-eye"></i>
                        </button>
                    </div>
                </div>

                <!-- Opciones -->
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember"> Recordar mi sesión
                    </label>
                    <a href="#" class="forgot-link">¿Olvidaste tu contraseña?</a>
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
                </button>
            </form>

            <div class="switch-auth">
                ¿No tienes una cuenta? <a href="register.php">Regístrate aquí</a>
            </div>
        </div>
    </div>

    <!-- Footer del proyecto -->
    <footer class="main-footer">
        <p>&copy; 2026 Todos los derechos reservados.</p>
    </footer>

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
</body>
</html>