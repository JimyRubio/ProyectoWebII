<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro | Sistema</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-900 min-h-screen flex items-center justify-center p-4">

    <!-- Contenedor Principal -->
    <div class="w-full max-w-lg bg-slate-800/80 backdrop-blur-md border border-slate-700/50 rounded-2xl shadow-2xl p-8 space-y-6">
        
        <!-- Encabezado / Logo -->
        <div class="text-center space-y-2">
            <div class="inline-flex items-center justify-center w-12 h-12 rounded-xl bg-indigo-600 text-white shadow-lg shadow-indigo-500/30 mb-2">
                <i class="fa-solid fa-user-plus text-xl"></i>
            </div>
            <h2 class="text-2xl font-bold text-white tracking-wide">Crear una cuenta</h2>
            <p class="text-sm text-slate-400">Ingresa tus datos para registrarte en la plataforma</p>
        </div>

        <!-- Formulario -->
        <form action="register.php" method="POST" class="space-y-4">
            
            <!-- Nombre Completo -->
            <div>
                <label for="full_name" class="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-2">Nombre Completo</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                        <i class="fa-regular fa-user"></i>
                    </span>
                    <input type="text" id="full_name" name="full_name" required 
                        class="w-full pl-10 pr-4 py-2.5 bg-slate-900/60 border border-slate-700 rounded-xl text-white placeholder-slate-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                        placeholder="Juan Pérez">
                </div>
            </div>

            <!-- Correo Electrónico -->
            <div>
                <label for="email" class="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-2">Correo Electrónico</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                        <i class="fa-regular fa-envelope"></i>
                    </span>
                    <input type="email" id="email" name="email" required 
                        class="w-full pl-10 pr-4 py-2.5 bg-slate-900/60 border border-slate-700 rounded-xl text-white placeholder-slate-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                        placeholder="usuario@ejemplo.com">
                </div>
            </div>

            <!-- Contraseña y Confirmación -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="reg_password" class="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-2">Contraseña</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                            <i class="fa-solid fa-key"></i>
                        </span>
                        <input type="password" id="reg_password" name="password" required 
                            class="w-full pl-10 pr-4 py-2.5 bg-slate-900/60 border border-slate-700 rounded-xl text-white placeholder-slate-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                            placeholder="••••••••">
                    </div>
                </div>

                <div>
                    <label for="confirm_password" class="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-2">Confirmar</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                            <i class="fa-solid fa-shield"></i>
                        </span>
                        <input type="password" id="confirm_password" name="confirm_password" required 
                            class="w-full pl-10 pr-4 py-2.5 bg-slate-900/60 border border-slate-700 rounded-xl text-white placeholder-slate-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all"
                            placeholder="••••••••">
                    </div>
                </div>
            </div>

            <!-- Aceptar Términos -->
            <div class="flex items-center pt-2">
                <input type="checkbox" id="terms" name="terms" required class="w-4 h-4 text-indigo-600 bg-slate-900 border-slate-700 rounded focus:ring-indigo-500 focus:ring-offset-slate-800">
                <label for="terms" class="ml-2 text-xs text-slate-300 select-none">Acepto los <a href="#" class="text-indigo-400 hover:underline">términos y condiciones</a></label>
            </div>

            <!-- Botón de Envío -->
            <button type="submit" class="w-full py-3 px-4 bg-indigo-600 hover:bg-indigo-500 text-white font-medium text-sm rounded-xl shadow-lg shadow-indigo-600/30 transition-all transform active:scale-[0.98] mt-2">
                Crear cuenta
            </button>
        </form>

        <!-- Pie de tarjeta -->
        <p class="text-center text-xs text-slate-400">
            ¿Ya tienes una cuenta? 
            <a href="login.php" class="text-indigo-400 font-semibold hover:text-indigo-300 hover:underline">Inicia sesión</a>
        </p>
    </div>

</body>
</html>