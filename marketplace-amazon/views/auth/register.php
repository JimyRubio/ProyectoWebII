<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta</title>
    
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
            <a href="login.php" class="nav-link"><i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión</a>
        </div>
    </header>

    <!-- Formulario de Registro -->
    <div class="container auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Crear una Cuenta</h2>
                <p>Ingresa tus datos para registrarte</p>
            </div>

            <form action="register.php" method="POST">
                <div class="form-group">
                    <label for="full_name">Nombre Completo</label>
                    <div class="input-container">
                        <i class="fa-regular fa-user input-icon"></i>
                        <input type="text" id="full_name" name="full_name" class="form-control" placeholder="Juan Pérez" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Correo Electrónico</label>
                    <div class="input-container">
                        <i class="fa-regular fa-envelope input-icon"></i>
                        <input type="email" id="email" name="email" class="form-control" placeholder="usuario@ejemplo.com" required>
                    </div>
                </div>

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

    <!-- Footer del proyecto -->
    <footer class="main-footer">
        <p>&copy; 2026 Todos los derechos reservados.</p>
    </footer>

</body>
</html>