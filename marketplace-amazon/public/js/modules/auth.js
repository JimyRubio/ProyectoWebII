/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE AUTENTICACIÓN (auth.js)
   ========================================================================== */

$(document).ready(function () {
    // Interceptar envío de formulario de Login
    $('.auth-card form[action="login.php"]').on('submit', function (e) {
        e.preventDefault();
        const $form = $(this);
        const emailOrUser = $form.find('input[name="email_or_user"]').val();
        const password = $form.find('input[name="password"]').val();

        App.ajax({
            url: App.baseUrl + 'api/auth.php?action=login',
            method: 'POST',
            data: {
                email_or_user: emailOrUser,
                password: password
            },
            success: function (response) {
                if (response.success) {
                    App.notify('Bienvenido de nuevo: ' + response.data.user.nombre, 'success');
                    setTimeout(function () {
                        window.location.href = App.baseUrl;
                    }, 1000);
                }
            }
        });
    });

    // Interceptar envío de formulario de Registro
    $('.auth-card form[action="register.php"]').on('submit', function (e) {
        e.preventDefault();
        const $form = $(this);
        const fullName = $form.find('input[name="full_name"]').val();
        const email = $form.find('input[name="email"]').val();
        const password = $form.find('input[name="password"]').val();
        const confirm = $form.find('input[name="confirm_password"]').val();

        if (password !== confirm) {
            App.notify('Las contraseñas no coinciden', 'error');
            return;
        }

        App.ajax({
            url: App.baseUrl + 'api/auth.php?action=register',
            method: 'POST',
            data: {
                full_name: fullName,
                email: email,
                password: password,
                confirm_password: confirm
            },
            success: function (response) {
                if (response.success) {
                    App.notify('Cuenta registrada con éxito', 'success');
                    setTimeout(function () {
                        window.location.href = App.baseUrl;
                    }, 1000);
                }
            }
        });
    });

    // Interceptar envío de formulario de Olvidé Contraseña
    $('#form-forgot-password').on('submit', function (e) {
        e.preventDefault();
        const email = $('#forgot-email').val();

        App.ajax({
            url: App.baseUrl + 'api/auth.php?action=forgot_password',
            method: 'POST',
            data: { email: email },
            success: function (response) {
                if (response.success) {
                    $('#form-forgot-password').hide();
                    
                    // Si el correo se envió exitosamente via SMTP
                    if (response.data && response.data.email_sent) {
                        var successHtml = '<i class="fa-solid fa-check-circle" style="font-size:2.5rem;color:var(--price-color);display:block;margin-bottom:10px;"></i>';
                        successHtml += '<p style="color:var(--text-primary);font-weight:600;">Correo enviado exitosamente</p>';
                        successHtml += '<p style="color:var(--text-secondary);font-size:0.9rem;margin-top:5px;">Revisa tu bandeja de entrada (' + htmlspecialchars(email) + ') para restablecer tu contraseña.</p>';
                        successHtml += '<p style="color:var(--text-secondary);font-size:0.85rem;margin-top:15px;">⏰ El enlace expirará en 1 hora. Si no lo encuentras, revisa tu carpeta de spam.</p>';
                        $('#forgot-success-msg').html(successHtml).show();
                    } 
                    // Si el servidor devuelve un token (fallo en el envío de correo, modo depuración)
                    else if (response.data && response.data.token) {
                        var fallbackHtml = '<i class="fa-solid fa-exclamation-triangle" style="font-size:2.5rem;color:var(--warning-color,#f59e0b);display:block;margin-bottom:10px;"></i>';
                        fallbackHtml += '<p style="color:var(--text-primary);font-weight:600;">No se pudo enviar el correo</p>';
                        fallbackHtml += '<p style="color:var(--text-secondary);font-size:0.9rem;margin-top:5px;">Pero puedes usar el token manualmente para restablecer tu contraseña.</p>';
                        
                        fallbackHtml += '<div style="margin-top:20px;padding:16px;background:rgba(99,102,241,0.1);border:1px solid rgba(99,102,241,0.3);border-radius:12px;">';
                        fallbackHtml += '<p style="font-size:0.85rem;color:var(--text-secondary);margin-bottom:8px;">🔑 Token de recuperación (copia este token y pégalo en la página de restablecer):</p>';
                        fallbackHtml += '<div style="display:flex;gap:10px;align-items:center;">';
                        fallbackHtml += '<input type="text" id="token-display" value="' + response.data.token + '" readonly style="flex:1;padding:10px;background:var(--bg-primary);border:1px solid var(--border-color);border-radius:8px;color:var(--text-primary);font-family:monospace;font-size:0.9rem;text-align:center;">';
                        fallbackHtml += '<button onclick="navigator.clipboard.writeText(document.getElementById(\'token-display\').value).then(function(){App.notify(\'Token copiado al portapapeles\',\'success\')})" class="btn-primary" style="width:auto;padding:10px 16px;"><i class="fa-solid fa-copy"></i></button>';
                        fallbackHtml += '</div>';
                        fallbackHtml += '<a href="reset_password.php?token=' + response.data.token + '" class="btn-primary" style="display:inline-block;margin-top:12px;text-decoration:none;padding:10px 20px;"><i class="fa-solid fa-arrow-right"></i> Ir a Restablecer Contraseña</a>';
                        fallbackHtml += '</div>';
                        
                        if (response.data.email_error) {
                            fallbackHtml += '<div style="margin-top:15px;padding:10px;background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);border-radius:8px;">';
                            fallbackHtml += '<p style="font-size:0.8rem;color:#ef4444;margin:0;">Error: ' + response.data.email_error + '</p>';
                            fallbackHtml += '</div>';
                        }
                        
                        $('#forgot-success-msg').html(fallbackHtml).show();
                    } else {
                        // Caso genérico: usuario no encontrado (por seguridad)
                        var genericHtml = '<i class="fa-solid fa-check-circle" style="font-size:2.5rem;color:var(--price-color);display:block;margin-bottom:10px;"></i>';
                        genericHtml += '<p style="color:var(--text-primary);font-weight:600;">Solicitud procesada</p>';
                        genericHtml += '<p style="color:var(--text-secondary);font-size:0.9rem;margin-top:5px;">Si el correo está registrado, recibirás instrucciones para restablecer tu contraseña.</p>';
                        $('#forgot-success-msg').html(genericHtml).show();
                    }
                }
            }
        });
    });
    
    // Función auxiliar para escapar HTML
    function htmlspecialchars(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;').replace(/</g, '<').replace(/>/g, '>').replace(/"/g, '"').replace(/'/g, '&#039;');
    }

    // Interceptar envío de formulario de Resetear Contraseña
    $('#form-reset-password').on('submit', function (e) {
        e.preventDefault();
        const $form = $(this);
        const token = $form.find('input[name="token"]').val();
        const password = $form.find('input[name="password"]').val();
        const confirm = $form.find('input[name="confirm_password"]').val();

        if (password !== confirm) {
            App.notify('Las contraseñas no coinciden', 'error');
            return;
        }

        App.ajax({
            url: App.baseUrl + 'api/auth.php?action=reset_password',
            method: 'POST',
            data: {
                token: token,
                password: password,
                confirm_password: confirm
            },
            success: function (response) {
                if (response.success) {
                    App.notify('Contraseña restablecida exitosamente', 'success');
                    setTimeout(function () {
                        window.location.href = App.baseUrl + 'views/auth/login.php';
                    }, 1500);
                }
            }
        });
    });
});
