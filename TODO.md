# TODO - Fixes ProyectoWebII Marketplace

## Completed Fixes

### 1. Total compras de clientes sale 0.0
- ✅ Fixed ClienteModel.php getProfile() - now uses correct query with subquery from pedidos table and GREATEST() fallback

### 2. Método de búsqueda no funciona
- ✅ Created catalogo.php (was empty 0 bytes) with full search, filters, pagination
- ✅ Search redirect from main.js now works correctly

### 3. Dashboard de admin - botones no funcionan
- ✅ Fixed analytics.js - added working CSV export function with hidden form download
- ✅ Added filter tab click handlers to load chart data by timeframe

### 4. Imágenes no se cargan en la página
- ✅ Fixed upload.php - image URL paths corrected for proper loading

### 5. Productos inactivos aparecen en página principal
- ✅ Added `WHERE p.estado = 'activo'` to getAll(), countFiltered(), getDestacados() in ProductoModel.php

### 6. Seleccionar categoría del producto
- ✅ Added category dropdown (select) in gestion.php form with AJAX load from API

### 7. Sistema de reseñas de productos
- ✅ Added reseñas section in detalle.php
- ✅ Added loadResenas() and renderResenas() in productos.js with star rating
- ✅ Added form to submit reviews with dynamic star selection

### 8. Productos relacionados
- ✅ Added getRelacionados() method in ProductoModel.php
- ✅ Added relacionados() action in ProductoController.php
- ✅ Added relacionados route in api/productos.php
- ✅ Added loadProductosRelacionados() in productos.js

### 9. Mensaje de iniciar sesión para carrito
- ✅ Added checkAuthBeforeCart() function that checks auth before allowing cart add
- ✅ Shows informative message and redirects to login page

### 10. Paginación (siguiente página/números)
- ✅ Added pagination CSS styles (page-btn, .active, .disabled) in main.css
- ✅ Fixed renderPagination() in utils.js with proper styling classes
- ✅ Added error handling fallbacks in loadProducts() and loadProductsByCategory()

### 11. Editar información de cliente
- ✅ Fixed event delegation in clientes.js - changed from direct binding to $(document).on() for dynamically loaded forms

### 12. Mensaje específico de baneo
- ✅ Added bloqueado check in AuthController.php login() - shows specific ban reason instead of generic error

### 13. Recuperar contraseña con token
- ✅ Updated auth.js forgot_password handler to display token visually with copy button and direct link to reset page
- ✅ Made token input visible (not hidden) in reset_password.php so user can paste token
- ✅ Added token input field with monospace styling for easy pasting

