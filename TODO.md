# TODO - Conservar página actual al editar productos

## Pasos
- [x] Modificar enlace de edición en `views/productos/gestion.php` para incluir `page`
- [x] Leer parámetro `page` en `views/productos/editar.php`
- [x] Usar `page` en todas las redirecciones de vuelta a gestión en `editar.php`
- [x] Cargar la página desde `?page=` en `gestion.php` al volver de editar
- [ ] Probar el flujo de edición desde página 8

# Corrección de paginación por categoría en inicio

## Cambios realizados
- [x] Actualizar `loadProductsByCategory` en `public/js/modules/productos.js` para aceptar y conservar el número de página solicitado.
- [x] Enviar `page` junto con `categoria_id` en la petición AJAX para que el servidor devuelva el segmento correcto de productos.
- [x] Conectar los botones del paginador con la página seleccionada, manteniendo activa la categoría actual.

## Verificación pendiente
- [ ] Probar en el navegador una categoría con más de 12 productos y confirmar la navegación entre todas sus páginas.
