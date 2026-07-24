<?php 
require_once __DIR__ . '/../../config/config.php';
$is_auth_page = $is_auth_page ?? false;
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="<?php echo Security::generateCsrfToken(); ?>">
    <title><?php echo isset($page_title) ? $page_title : APP_NAME; ?></title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS Globales -->
    <link rel="stylesheet" href="<?php echo BASE_URL; ?>public/css/main.css">
    <link rel="stylesheet" href="<?php echo BASE_URL; ?>public/css/layout.css">

    <?php if (isset($module_css) && !empty($module_css)): ?>
        <!-- CSS Módulo Específico -->
        <link rel="stylesheet" href="<?php echo BASE_URL; ?>public/css/modules/<?php echo $module_css; ?>">
    <?php endif; ?>
</head>
<body>
    <header class="main-header">
        <div class="logo">
            <a href="<?php echo BASE_URL; ?>">
                <h2>Market<span>Zone</span></h2>
            </a>
        </div>

        <?php if (!$is_auth_page): ?>
            <!-- Barra de búsqueda -->
            <div class="search-bar">
                <input type="text" id="global-search-input" placeholder="Buscar productos, marcas, SKU...">
                <button id="global-search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>

            <!-- Navegación del usuario -->
            <nav class="user-nav">
                <!-- Menú para Admin -->
                <div class="nav-dropdown" id="admin-menu" style="display:none;">
                    <a href="#" class="nav-link dropdown-trigger"><i class="fa-solid fa-shield-hooded"></i> Admin ▾</a>
                    <div class="dropdown-content">
                        <a href="<?php echo BASE_URL; ?>views/analytics/dashboard.php"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
                        <a href="<?php echo BASE_URL; ?>views/productos/gestion.php"><i class="fa-solid fa-boxes"></i> Productos</a>
                        <a href="<?php echo BASE_URL; ?>views/admin/usuarios.php"><i class="fa-solid fa-users-gear"></i> Usuarios</a>
                    </div>
                </div>

                <!-- Menú para Vendedor -->
                <div class="nav-dropdown" id="seller-menu" style="display:none;">
                    <a href="#" class="nav-link dropdown-trigger"><i class="fa-solid fa-store"></i> Vendedor ▾</a>
                    <div class="dropdown-content">
                        <a href="<?php echo BASE_URL; ?>views/vendedores/dashboard.php"><i class="fa-solid fa-chart-simple"></i> Dashboard</a>
                        <a href="<?php echo BASE_URL; ?>views/vendedores/pos.php"><i class="fa-solid fa-cash-register"></i> Punto de Venta</a>
                        <a href="<?php echo BASE_URL; ?>views/productos/gestion.php"><i class="fa-solid fa-box"></i> Mis Productos</a>
                        <a href="<?php echo BASE_URL; ?>views/pedidos/historial.php"><i class="fa-solid fa-receipt"></i> Pedidos</a>
                        <a href="<?php echo BASE_URL; ?>views/promociones/gestion.php"><i class="fa-solid fa-tags"></i> Promociones</a>
                    </div>
                </div>

                <!-- Menú para Cliente -->
                <div class="nav-dropdown" id="client-menu" style="display:none;">
                    <a href="#" class="nav-link dropdown-trigger"><i class="fa-regular fa-user"></i> Mi Cuenta ▾</a>
                    <div class="dropdown-content">
                        <a href="<?php echo BASE_URL; ?>views/clientes/perfil.php"><i class="fa-regular fa-id-card"></i> Mi Perfil</a>
                        <a href="<?php echo BASE_URL; ?>views/pedidos/historial.php"><i class="fa-solid fa-clock-rotate-left"></i> Mis Pedidos</a>
                        <a href="<?php echo BASE_URL; ?>views/clientes/historial.php"><i class="fa-solid fa-receipt"></i> Historial</a>
                    </div>
                </div>

                <!-- Botón carrito -->
                <a href="<?php echo BASE_URL; ?>views/carrito/index.php" id="open-cart-btn" class="cart-btn">
                    <i class="fa-solid fa-cart-shopping"></i> Carrito
                    <span class="badge" id="global-cart-badge">0</span>
                </a>

                <!-- Botón Iniciar Sesión (visible solo cuando no hay sesión) -->
                <a href="<?php echo BASE_URL; ?>views/auth/login.php" id="nav-user-account" class="nav-link">
                    <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
                </a>

                <!-- Botón Cerrar Sesión (visible solo cuando hay sesión) -->
                <a href="#" id="btn-logout" class="nav-link" style="display:none;color:#EF4444;">
                    <i class="fa-solid fa-sign-out-alt"></i> Salir
                </a>
            </nav>
        <?php else: ?>
            <!-- Páginas de autenticación -->
            <nav class="user-nav">
                <a href="<?php echo BASE_URL; ?>" class="nav-link"><i class="fa-solid fa-house"></i> Volver a la Tienda</a>
            </nav>
        <?php endif; ?>
    </header>
    <main class="container">