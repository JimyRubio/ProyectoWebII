# TODO - Plan de Mejora MarketZone ✅

## Completado:

### 1. 🔐 Sistema de Roles y Navegación por Rol ✅
- Header.php con menús desplegables según rol (Admin/Vendedor/Cliente)
- main.js detecta rol vía API auth.php y muestra menú correspondiente
- Logout funcional en header

### 2. 🛒 Carrito de Compras - Cantidad Selectable ✅
- Input number para cantidad en cada tarjeta de producto
- función addToCart() envía cantidad seleccionada
- API update_qty creada para actualizar cantidades
- Botones + y - en carrito funcionan con update_qty

### 3. 💳 Checkout y Pago con Tarjeta ✅
- Formulario completo de tarjeta (número, titular, expiración, CVV)
- Auto-formateo de número (espacios cada 4 dígitos)
- Auto-formateo de fecha (MM/YY)
- Validaciones del lado cliente (largo, formato, CVV)
- Validaciones del lado servidor en PagoController
- Creación de pedido + pago + vaciar carrito en transacción

### 4. 👤 Vista de Cliente ✅
- Perfil con datos personales y direcciones (clientes.js)
- Historial de pedidos (clientes.js)
- Rastreo de pedidos (pedidos.js + rastreo.php)

### 5. 🛠️ Vista de Administrador ✅
- Dashboard analytics con métricas globales
- Gestión de productos con tabla y paginación
- Admin ve menú de admin + vendedor + cliente

### 6. 🏪 Vista de Vendedor ✅
- Seller Dashboard con enlaces rápidos
- Gestión de productos desde vista vendedor

### 7. 🔄 Cerrar Sesión ✅
- Botón de logout visible solo cuando autenticado
- Función confirm() antes de cerrar sesión
- Redirección a home después de logout

### 8. 🔍 Botón Carrito y Barra de Búsqueda ✅
- Barra de búsqueda redirige a catálogo con query
- Botón carrito redirige a página de carrito

### 9. 💰 Moneda en Lempiras (HNL) ✅
- config.php: CURRENCY_SYMBOL = 'L.', CURRENCY_CODE = 'HNL'
- utils.js: formatCurrency devuelve 'L. 1,234.56'
- Sin doble símbolo (solamente 'L. ' al inicio)

### 10. 📸 Subida de Imágenes para Productos
- [ ] Crear endpoint para upload de imágenes
- [ ] Modificar formulario de gestión de productos para usar file input
- [ ] Guardar imágenes en public/uploads/
- [ ] Mostrar preview de imagen antes de subir

