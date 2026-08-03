# TODO - Sistema de Cupones Funcional + CRUD Admin

## Plan Aprobado - COMPLETADO ✅

### Objetivo
Hacer funcional el sistema de cupones del marketplace: sembrar datos de ejemplo, crear CRUD de cupones en el panel admin y mejorar la validación.

### Pasos Realizados

#### 1. Modelo de Cupones (CRUD)
- [x] **app/Models/CuponModel.php**: Creado modelo con métodos:
  - `getAll()` - listar todos los cupones
  - `getById(int $id)` - obtener un cupón por ID
  - `getActivos()` - listar cupones activos y vigentes
  - `create(array $data)` - crear cupón
  - `update(int $id, array $data)` - actualizar cupón
  - `delete(int $id)` - eliminar cupón
  - `toggleActivo(int $id)` - activar/desactivar
  - `validarCupon(string $codigo)` - validar código (activo + fechas)

#### 2. Mejorar validación de fechas en PromocionModel
- [x] **app/Models/PromocionModel.php**: Modificado `validarCupon()` para validar también `fecha_inicio <= NOW()`

#### 3. API de Cupones
- [x] **api/cupones.php**: Creado endpoint con acciones:
  - GET `all` - listar todos (admin, requiere auth)
  - GET `activos` - listar cupones activos (público)
  - GET/POST `validar` - validar cupón (público)
  - POST `store` - crear cupón
  - POST `update` - actualizar cupón
  - POST `delete` - eliminar cupón
  - POST `toggle` - activar/desactivar cupón

#### 4. Controlador de Cupones
- [x] **app/Controllers/CuponController.php**: Controlador con validaciones de datos, fechas y CSRF

#### 5. Vista Admin de Cupones
- [x] **views/admin/cupones.php**: Vista con tabla de cupones + formulario crear/editar + botones de acción (editar, toggle, eliminar)

#### 6. JS del módulo de cupones
- [x] **public/js/modules/cupones.js**: Lógica AJAX para CRUD de cupones en admin

#### 7. Agregar enlace en menú Admin
- [x] **views/layouts/header.php**: Agregado link "Cupones" en dropdown del menú Admin

#### 8. Sembrar datos en SQL
- [x] **DB_marketplace.sql**: Agregados INSERT de cupones de ejemplo después de la Tabla 33
- [x] **Base de datos local**: Insertados 4 cupones de ejemplo (BIENVENIDO10, VERANO25, DESCUENTO50, FREESHIP)

#### 9. Pruebas realizadas
- [x] Validación de sintaxis PHP de todos los archivos nuevos/modificados (sin errores)
- [x] Servidor PHP iniciado en localhost:8080 (responde 200)
- [x] API `promociones.php?action=validar` → Cupón BIENVENIDO10 válido ✅
- [x] API `cupones.php?action=validar` → Cupón VERANO25 válido ✅
- [x] API `cupones.php?action=activos` → Devuelve 4 cupones activos ✅
- [x] API `cupones.php?action=all` sin sesión → 401 (protegido correctamente) ✅
- [x] Vista admin cupones → Carga correctamente ✅
- [x] Prueba integral: agregar producto al carrito + aplicar cupón 10% → descuento correcto (1999.98 → 200) ✅

#### 10. Limpieza
- [x] Eliminados scripts temporales (`check_db.php`, `seed_cupones.php`, `test_flujo_cupon.php`)

