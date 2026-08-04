# TODO - Auditoría y Reescritura de Endpoints PHP (Arquitectura 3 Capas)

## Bugs Críticos (rompen JSON)
- [x] 1. `app/Models/ProductoModel.php` - Corregir `getAll()` (bindValue PARAM_INT para LIMIT/OFFSET)
- [x] 2. `app/Models/AnalyticsModel.php` - Corregir `getSalesTrendFromOrders()` (only_full_group_by)

## Arquitectura de 3 capas (SQL fuera de capa de Presentación)
- [x] 3. `api/admin_register.php` - Refactorizar SQL crudo a `ClienteModel::registerUserByRole()`
- [x] 4. `app/Models/ClienteModel.php` - Agregar `registerUserByRole()`, `listaUsuarios()`, `toggleUsuario()`
- [x] 5. `app/Controllers/ClienteController.php` - Mover SQL a Modelo + try-catch
- [x] 6. `app/Controllers/AuthController.php` - Mover SQL de tokens a Modelo + try-catch

## Manejo de errores (Try-Catch para JSON válido)
- [x] 7. `app/Controllers/ProductoController.php` - try-catch en `delete()` + CSRF
- [x] 8. `app/Controllers/CarritoController.php` - Validar autenticación en `add()`
- [x] 9. `app/Controllers/VendedorController.php` - try-catch
- [x] 10. `app/Controllers/TiendaController.php` - try-catch
- [x] 11. `app/Controllers/CuponController.php` - try-catch
- [x] 12. `app/Controllers/PagoController.php` - try-catch
- [x] 13. `app/Controllers/PromocionController.php` - try-catch
- [x] 14. `app/Controllers/MensajeriaController.php` - try-catch

## Verificación
- [ ] 15. Verificación sintáctica con `php -l`
- [ ] 16. Re-auditoría final para confirmar que todo se completó
