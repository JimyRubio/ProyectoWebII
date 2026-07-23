<?php 
require_once dirname(__DIR__, 2) . '/config/config.php'; 
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo APP_NAME; ?></title>
    
    <!-- Fuente Google Fonts: Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- CSS Globales -->
    <link rel="stylesheet" href="<?php echo BASE_URL; ?>public/css/main.css">
    <link rel="stylesheet" href="<?php echo BASE_URL; ?>public/css/layout.css">
    
    <!-- FontAwesome para Íconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <!-- Header / Navbar Principal -->
    <header class="main-header">
        <div class="logo">
            <a href="<?php echo BASE_URL; ?>">
                <h2>Market<span>Zone</span></h2>
            </a>
        </div>
        
        <div class="search-bar">
            <input type="text" id="global-search" placeholder="Buscar productos, marcas, ofertas exclusivas...">
            <button type="button"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>

        <nav class="user-nav">
            <a href="<?php echo BASE_URL; ?>views/auth/login.php" class="nav-link"><i class="fa-solid fa-user"></i> Mi Cuenta</a>
            <a href="<?php echo BASE_URL; ?>views/carrito/index.php" class="cart-btn">
                <i class="fa-solid fa-cart-shopping"></i> Carrito
                <span id="cart-counter" class="badge">0</span>
            </a>
        </nav>
    </header>

    <main class="container">