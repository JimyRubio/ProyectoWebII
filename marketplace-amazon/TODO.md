# ✅ COMPLETADO: Gestión de Promociones y Cupones - Correcciones

## Paso 1: Arreglar `api/promociones.php` - Eximir validar cupón del CSRF ✅
- [x] Hacer que la acción `validar` no requiera CSRF token
- [x] Eliminar la validación CSRF global para POST, moverla solo a las acciones que la necesitan

## Paso 2: Arreglar `PromocionModel.php` - Generar código automático ✅
- [x] Si no se proporciona `codigo`, se genera uno automáticamente (PROMO-XXXXXXXX)
- [x] Se respeta la restricción UNIQUE NOT NULL de la BD

## Paso 3: Eliminar script inline duplicado de `gestion.php` ✅
- [x] Remover el bloque `<script>` completo al final del archivo
- [x] Mantener solo el script externo `promociones.js` (evita conflictos)

## Paso 4: Arreglar `promociones.js` - Reparar HTML y mejorar ✅
- [x] Cerrar el `</div>` faltante en cada promo-card
- [x] Agregar `App.escapeHtml()` para prevenir XSS
- [x] Mejorar manejo de errores (error callback en loadPromociones)
- [x] Limpiar input y focus al abrir modal de validar cupón
- [x] Mostrar mínimo de compra en resultado de validación
- [x] Enviar `action` como POST data en delete (no en URL)

## Paso 5: Agregar `escapeHtml` a `utils.js` ✅
- [x] Nueva función `App.escapeHtml()` para sanitizar texto en HTML

## ✅ PRÓXIMOS PASOS (Opcionales)
- Si no existe la tabla `cupones` en la BD, ejecutar el script SQL
- Insertar algunos cupones de prueba manualmente para probar validación

---

# ✅ COMPLETADO: Añadir selección de cupón en el checkout

## Paso 1: Agregar métodos de cupón en `CarritoModel.php` ✅
- [x] Agregar método `applyCoupon(int $clienteId, array $cupon)` para aplicar descuento al carrito
- [x] Agregar método `removeCoupon(int $clienteId)` para limpiar el descuento del carrito
- [x] `getCartByClienteId()` ya recalcula total con descuento desde campo `descuentos`

## Paso 2: Agregar endpoints de cupón en `CarritoController.php` ✅
- [x] Agregar método `applyCoupon()` que valida el cupón vía PromocionModel y aplica descuento al carrito
- [x] Agregar método `removeCoupon()` que limpia el descuento del carrito

## Paso 3: Agregar rutas de cupón en `api/carrito.php` ✅
- [x] Agregar action `apply_coupon` y `remove_coupon` en el switch POST

## Paso 4: Agregar sección de cupón en `checkout.php` ✅
- [x] Agregar input de código de cupón con botón "Aplicar" en la columna derecha del resumen
- [x] Agregar contenedor para mostrar cupón aplicado con opción de remover
- [x] Agregar estilos CSS para la sección de cupón

## Paso 5: Agregar lógica JS de cupón en `pagos.js` ✅
- [x] Agregar función `aplicarCupon()` que llama a la API y aplica el descuento
- [x] Agregar función `removerCupon()` que limpia el descuento
- [x] Modificar `renderResumenCompra()` para mostrar descuento si aplica
- [x] Soporte para tecla Enter en el input de cupón
