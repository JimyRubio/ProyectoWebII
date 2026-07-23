<?php require_once __DIR__ . '/../../config/config.php'; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo APP_NAME; ?></title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS Globales -->
    <link rel="stylesheet" href="../../public/css/main.css">
    <link rel="stylesheet" href="../../public/css/layout.css">
</head>
<body>
    <header class="main-header">
        <div class="logo">
            <a href="<?php echo BASE_URL; ?>">
                <h2>Market<span>Zone</span></h2>
            </a>
        </div>
        <div class="search-bar">
            <input type="text" placeholder="Buscar productos, marcas...">
            <button><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <nav class="user-nav">
            <a href="#" class="nav-link"><i class="fa-regular fa-user"></i> Mi Cuenta</a>
            <a href="#" class="cart-btn">
                <i class="fa-solid fa-cart-shopping"></i> Carrito
                <span class="badge">0</span>
            </a>
        </nav>
    </header>
    <main class="container">