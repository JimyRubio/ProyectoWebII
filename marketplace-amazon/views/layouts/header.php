<?php require_once __DIR__ . '/../../config/config.php'; ?>
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

        <?php if (!isset($is_auth_page) || !$is_auth_page): ?>
            <!-- Elementos visibles en la tienda principal -->
            <div class="search-bar">
                <input type="text" id="global-search-input" placeholder="Buscar productos, marcas, SKU...">
                <button id="global-search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
            <nav class="user-nav">
                <a href="<?php echo BASE_URL; ?>views/analytics/dashboard.php" class="nav-link"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
                <a href="<?php echo BASE_URL; ?>views/auth/login.php" id="nav-user-account" class="nav-link"><i class="fa-regular fa-user"></i> Mi Cuenta</a>
                <a href="#" id="open-cart-btn" class="cart-btn">
                    <i class="fa-solid fa-cart-shopping"></i> Carrito
                    <span class="badge" id="global-cart-badge">0</span>
                </a>
            </nav>
        <?php else: ?>
            <!-- Elementos visibles en páginas de Login / Registro -->
            <nav class="user-nav">
                <a href="<?php echo BASE_URL; ?>" class="nav-link"><i class="fa-solid fa-house"></i> Volver a la Tienda</a>
            </nav>
        <?php endif; ?>
    </header>
    <main class="container">