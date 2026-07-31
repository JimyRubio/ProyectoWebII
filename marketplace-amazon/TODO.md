# TODO - Correcciones de Pago y Cupones

## ✅ Plan Aprobado - COMPLETADO

### 1. Arreglar error del Stored Procedure `procesar_pedido`
- [x] **PedidoModel.php**: Reemplazar `procesarPedidoSP()` con lógica PHP inline
  - Actualizar estado del pedido a 'confirmado' + fecha_confirmacion
  - Actualizar stock de cada producto (UPDATE directo)
  - Actualizar `total_vendidos` en productos
  - Insertar en historial_estados_pedido
  - Registrar en auditoría
  - Manejo de transacciones y rollback en caso de error

### 2. Incluir descuento del cupón al crear el pedido
- [x] **PedidoModel.php**: Modificar `createOrder()` para aceptar y aplicar descuentos (nuevo parámetro `$descuentos = 0.00`)
- [x] **PagoController.php**: Pasar `$cart['descuentos']` del carrito al `createOrder()`

### 3. Verificar caja de texto de cupón visible
- [x] **checkout.php**: Confirmar que el input `#cupon-codigo` existe y está visible
  - El input `<input type="text" id="cupon-codigo">` ya está presente en el DOM
  - El botón "Aplicar" ya está conectado a `aplicarCupon()`
  - La función `aplicarCupon()` en `pagos.js` funciona correctamente
  - El cupón ya se persiste en el carrito vía `CarritoModel::applyCoupon()`

---

# 🚀 Reemplazo de `confirm()` nativo por Modal Profesional con CSS y Animaciones

## ✅ Plan Aprobado - COMPLETADO

### Objetivo
Reemplazar todas las llamadas a `confirm()` de JavaScript por un modal animado y profesional llamado `App.confirm()`, que retorna una Promise para mantener el flujo asíncrono.

### Cambios realizados

#### 1. `public/js/utils.js` - Nueva función `App.confirm()`
- [x] Crea dinámicamente un modal overlay con animación bounceIn
- [x] Soporta tipo de acción (`danger`, `warning`, `info`) con colores e iconos personalizados
- [x] Botones "Confirmar" y "Cancelar" con estilos consistentes del tema
- [x] Retorna una Promise que resuelve a `true`/`false`
- [x] Se limpia del DOM automáticamente al resolver
- [x] Cierra con tecla Escape o click en overlay

#### 2. `public/css/main.css` - Estilos del modal de confirmación
- [x] Overlay con backdrop-filter blur
- [x] Card con efecto glassmorphism y tema dark/light
- [x] Animación bounceIn en la entrada
- [x] Icono animado con float según el tipo
- [x] Botones con los estilos existentes del theme

#### 3. `public/js/main.js:68` - Cerrar sesión
- [x] Reemplazado `confirm('¿Cerrar sesión?')` por `App.confirm(...)` con tipo `warning`

#### 4. `public/js/modules/carrito.js:175` - Vaciar carrito
- [x] Reemplazado `confirm('¿Vaciar el carrito por completo?')` por `App.confirm(...)` con tipo `danger`

#### 5. `public/js/modules/promociones.js:167` - Eliminar promoción
- [x] Reemplazado `confirm('¿Estás seguro de eliminar esta promoción?')` por `App.confirm(...)` con tipo `danger`

#### 6. `views/admin/usuarios.php:260` - Cambiar estado de usuario
- [x] Reemplazado `confirm('¿Cambiar estado de este usuario?')` por `App.confirm(...)` con tipo `warning`

#### 7. `views/productos/gestion.php:279` - Eliminar producto
- [x] Reemplazado `confirm('¿Eliminar este producto?')` por `App.confirm(...)` con tipo `danger`

#### 8. `views/vendedores/pos.php:214` - Limpiar ticket
- [x] Reemplazado `confirm('¿Limpiar ticket actual?')` por `App.confirm(...)` con tipo `warning`
