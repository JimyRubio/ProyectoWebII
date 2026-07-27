# Plan de Implementación - Corrección SSL PHPMailer

## ✅ Step 1: Crear carpeta `certs/` con bundle de certificados CA
- [ ] Crear directorio `marketplace-amazon/certs/`
- [ ] Descargar/crear `cacert.pem` (bundle de certificados CA)

## ✅ Step 2: Configurar `php.ini` para usar los certificados
- [ ] Configurar `openssl.cafile` apuntando al `cacert.pem`
- [ ] Configurar `curl.cainfo` apuntando al `cacert.pem`

## ✅ Step 3: Mejorar `MailHelper.php`
- [ ] Usar rutas absolutas basadas en `__DIR__` para incluir PHPMailer
- [ ] Agregar opciones SSL adicionales (verify_depth, crypto_method)
- [ ] Mejorar manejo de errores con logging detallado
- [ ] Fallback robusto para restablecimiento de contraseña

## ✅ Step 4: Crear `CertHelper.php` para auto-descarga de certificados
- [ ] Script que descargue `cacert.pem` automáticamente si no existe

## ✅ Step 5: Actualizar `start.bat`
- [ ] Asegurar que funcione desde cualquier ubicación donde se clone el proyecto

