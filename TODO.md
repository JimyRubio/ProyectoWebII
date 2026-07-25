# Project Fixes - COMPLETED

## ✅ Step 1: Create `catalogo.php` (was empty 0 bytes) - DONE
- [x] Built full catalog page with search input, category select filter, product grid, and pagination
- [x] Supports search query parameter from URL (?search=...)
- [x] Loads products dynamically via AJAX with search, category filters

## ✅ Step 2: Fix `ProductoModel.getAll()` - Filter inactive products - DONE
- [x] Added `p.estado = 'activo'` to getAll() - inactive products hidden from public
- [x] Added same filter to countFiltered() for consistent pagination

## ✅ Step 3: Add category dropdown to `gestion.php` - DONE
- [x] Added category `<select>` in product creation form with required validation
- [x] Loads categories dynamically via AJAX from API
- [x] Added validation to ensure category is selected before submit

## ✅ Step 4: Fix image upload paths - DONE
- [x] Changed upload.php URL from absolute (BASE_URL) to relative path `/public/uploads/productos/`
- [x] This ensures images work regardless of the server domain/port

## ✅ Step 5: Fix Cliente profile total_compras query - DONE
- [x] Improved getProfile() to use GREATEST() between subquery from pedidos and c.total_compras column
- [x] Falls back to the clientes.total_compras field updated by DB triggers

## ✅ Step 6: Fix admin dashboard buttons - DONE
- [x] Added working CSV export functionality to analytics.js
- [x] Made filter tabs functional (show/hide sections based on view selection)

## Fixes Summary
| Issue | Fix Applied |
|-------|------------|
| Total compras 0.0 | Improved query to use both pedidos SUM and clientes.total_compras |
| Búsqueda no funciona | Created catalogo.php from scratch (was empty) |
| Dashboard admin botones | Added CSV export and filter tab functionality |
| Imágenes no cargan | Changed to relative URL paths |
| Productos inactivos visibles | Added estado='activo' filter to getAll() |
| Seleccionar categoría | Added category dropdown with AJAX loading |

