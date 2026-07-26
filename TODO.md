# Plan de Implementación - Mejoras MarketZone

## ✅ Step 1: Quitar imágenes predeterminadas de productos
- [x] Remove hardcoded Unsplash fallback URLs from `productos.js`
- [x] Remove from `catalogo.php` (renderCatalogoProducts)
- [x] Remove from `gestion.php` (renderGestionProductos)
- [x] Remove from `pos.php` (renderProductosPOS)
- [x] Remove from `carrito.js` (renderCarrito, showCartModal)
- [x] Remove from `detalle.js` (renderDetalleProducto)
- [x] Created placeholder SVG at `public/uploads/productos/placeholder.svg`

## ✅ Step 2: Solo administrador puede editar productos
- [x] Add `update` action in `api/productos.php`
- [x] Add `update()` + edit permission check (admin only) in `ProductoController`
- [x] Add edit button/modal UI in `gestion.php`

## ✅ Step 3: Paginación - botón siguiente y números funcionales
- [x] Fix `loadProductsByCategory()` to use proper limit + page parameter
- [x] `renderPagination()` in utils.js already had next/prev buttons working

## ✅ Step 4: POS - productos en fila vertical
- [x] Changed POS layout from grid (side-by-side) to single column stack (flex-direction: column)

## ✅ Step 5: POS - campo para aplicar cupón
- [x] Added coupon input + validate button in POS ticket sidebar
- [x] Validates via `api/promociones.php?action=validar`
- [x] Applies discount (percentage or fixed amount) to total

## ✅ Step 6: Mejorar gestión de ofertas y cupones
- [x] Fixed broken HTML structure in `promociones/gestion.php` (missing closing tags)
- [x] Added coupon validation modal
- [x] Improved form layout and styling

## ✅ Step 7: MarketZone muestre todos los productos
- [x] Changed `loadDestacados()` → `loadIndexProducts()` to load all products with pagination
- [x] Shows 12 products per page with pagination controls
- [x] Category filter buttons still work on index

## ✅ Step 8: Reseñas funcionales
- [x] Added `getResenas()` in `ProductoModel` (queries reseñas_productos table)
- [x] Added `createResena()` in `ProductoModel`
- [x] Added `resenas()` and `storeResena()` methods in `ProductoController`
- [x] Added `action=resenas` and `action=store_resena` routes in `api/productos.php`
- [x] Fixed `loadResenas()` JS to call correct endpoint
- [x] Form submit now sends data to API and reloads dynamically

## ✅ Step 9: Búsqueda - corregir error
- [x] Fixed duplicate `loadProducts()` vs `loadCatalogoProducts()` conflict
- [x] Removed `loadProducts()` call from catalog page
- [x] Search parameter properly passed to API via `loadCatalogoProducts()`

## ✅ Step 10: Fix subida de imágenes - finfo_close() deprecated + placeholder SVG + error_reporting
- [x] **`api/upload.php`**: Eliminada llamada a `finfo_close($finfo)` porque los objetos finfo se liberan automáticamente desde PHP 8.5+. La función está deprecated y emite un warning que rompe la respuesta JSON del endpoint.
- [x] **`config/config.php`**: Cambiado `error_reporting(E_ALL)` a `error_reporting(E_ALL & ~E_DEPRECATED & ~E_USER_DEPRECATED)` para filtrar deprecaciones de PHP 8.5+ que se imprimen como texto plano y rompen las respuestas JSON de las APIs.
- [x] **`public/uploads/productos/placeholder.svg`**: Creado archivo SVG placeholder válido para cuando un producto no tiene imagen. Antes referenciaba a un archivo inexistente causando imágenes rotas.

