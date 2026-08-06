# TODO - Tarea: Quitar Promociones del vendedor y arreglar bug de productos inactivos

## Pasos
- [x] 1. Leer archivos relevantes (header, dashboard, gestion, ProductoModel, ProductoController, api/productos)
- [x] 2. Plan aprobado por el usuario

## Implementación
- [x] 3. `views/layouts/header.php`: quitar enlace "Promociones" del menú de vendedor
- [x] 4. `views/vendedores/dashboard.php`: quitar tarjeta quick-link "Promociones"
- [x] 5. `app/Models/ProductoModel.php`: agregar parámetro `$allEstados` a `getAll()` y `countFiltered()`
- [x] 6. `app/Controllers/ProductoController.php`: agregar método `gestion()`
- [x] 7. `api/productos.php`: agregar ruta `action=gestion`
- [x] 8. `views/productos/gestion.php`: usar `action=gestion` en `loadGestionProductos()`

## Verificación
- [x] 9. Verificación de sintaxis PHP de todos los archivos modificados (sin errores)
- [ ] 10. Probar en navegador que los productos inactivos/descontinuados aparecen en gestión
- [ ] 11. Confirmar que catálogo público solo muestra activos
