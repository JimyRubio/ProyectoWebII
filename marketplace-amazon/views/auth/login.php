<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | Sistema</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-900 min-h-screen flex items-center justify-center p-4">

    <!-- Contenedor Principal -->
    <div class="w-full max-w-md bg-slate-800/80 backdrop-blur-md border border-slate-700/50 rounded-2xl shadow-2xl p-8 space-y-6">
        
        <!-- Encabezado / Logo -->
        <div class="text-center space-y-2">
            <div class="inline-flex items-center justify-center w-12 h-12 rounded-xl bg-indigo-600 text-white shadow-lg shadow-indigo-500/30 mb-2">
                <i class="fa-solid fa-lock text-xl"></i>
            </div>
            <h2 class="text-2xl font-bold text-white tracking-wide">Bienvenido de nuevo</h2>
            <p class="text-sm text-slate-400">Ingresa tus credenciales para acceder</p>
        </div>

        <!-- Formulario -->
        <form action="login.php" method="POST" class="space-y-5">
            
            <!-- Campo: Email o Usuario -->
            <div>
                <label for="email_or_user" class="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-2">Correo o Usuario</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                        <i class="fa-regular fa-envelope"></i>
                    </span>
                    <input type="text" id="email_or_user" name="email_or_user" required 
                        class="w-full pl-10 pr-4 py-2.5 bg-slate-900/60 border border-slate-700 rounded-xl text-white placeholder-slate-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                        placeholder="usuario@ejemplo.com">
                </div>
            </div>

            <!-- Campo: Contraseña -->
            <div>
                <div class="flex justify-between items-center mb-2">
                    <label for="password" class="block text-xs font-semibold text-slate-300 uppercase tracking-wider">Contraseña</label>
                    <a href="#" class="text-xs text-indigo-400 hover:text-indigo-300 hover:underline">¿Olvidaste tu contraseña?</a>
                </div>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                        <i class="fa-solid fa-key"></i>
                    </span>
                    <input type="password" id="password" name="password" required 
                        class="w-full pl-10 pr-10 py-2.5 bg-slate-900/60 border border-slate-700 rounded-xl text-white placeholder-slate-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                        placeholder="••••••••">
                    <button type="button" onclick="togglePassword('password', 'icon-pass')" class="absolute inset-y-0 right-0 flex items-center pr-3 text-slate-400 hover:text-slate-200">
                        <i id="icon-pass" class="fa-regular fa-eye"></i>
                    </button>
                </div>
            </div>

            <!-- Opción: Recordarme -->
            <div class="flex items-center">
                <input type="checkbox" id="remember" name="remember" class="w-4 h-4 text-indigo-600 bg-slate-900 border-slate-700 rounded focus:ring-indigo-500 focus:ring-offset-slate-800">
                <label for="remember" class="ml-2 text-xs text-slate-300 select-none">Recordar mi sesión</label>
            </div>

            <!-- Botón de Envío -->
            <button type="submit" class="w-full py-3 px-4 bg-indigo-600 hover:bg-indigo-500 text-white font-medium text-sm rounded-xl shadow-lg shadow-indigo-600/30 transition-all transform active:scale-[0.98]">
                Iniciar Sesión
            </button>
        </form>

        <!-- Pie de tarjeta -->
        <p class="text-center text-xs text-slate-400">
            ¿No tienes una cuenta? 
            <a href="register.php" class="text-indigo-400 font-semibold hover:text-indigo-300 hover:underline">Regístrate aquí</a>
        </p>
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
</body>
</html>