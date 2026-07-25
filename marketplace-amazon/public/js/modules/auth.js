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
                    var successHtml = '<i class="fa-solid fa-check-circle" style="font-size:2.5rem;color:var(--price-color);display:block;margin-bottom:10px;"></i>';
                    successHtml += '<p style="color:var(--text-primary);font-weight:600;">Correo enviado exitosamente</p>';
                    successHtml += '<p style="color:var(--text-secondary);font-size:0.9rem;margin-top:5px;">Revisa tu bandeja de entrada para restablecer tu contraseña.</p>';
                    
                    // Si el servidor devuelve un token (modo desarrollo), lo mostramos
                    if (response.data && response.data.token) {
                        successHtml += '<div style="margin-top:20px;padding:16px;background:rgba(99,102,241,0.1);border:1px solid rgba(99,102,241,0.3);border-radius:12px;">';
                        successHtml += '<p style="font-size:0.85rem;color:var(--text-secondary);margin-bottom:8px;">🔑 Token de recuperación (copia este token y pégalo en la página de restablecer):</p>';
                        successHtml += '<div style="display:flex;gap:10px;align-items:center;">';
                        successHtml += '<input type="text" id="token-display" value="' + response.data.token + '" readonly style="flex:1;padding:10px;background:var(--bg-primary);border:1px solid var(--border-color);border-radius:8px;color:var(--text-primary);font-family:monospace;font-size:0.9rem;text-align:center;">';
                        successHtml += '<button onclick="navigator.clipboard.writeText(document.getElementById(\'token-display\').value).then(function(){App.notify(\'Token copiado al portapapeles\',\'success\')})" class="btn-primary" style="width:auto;padding:10px 16px;"><i class="fa-solid fa-copy"></i></button>';
                        successHtml += '</div>';
                        successHtml += '<a href="reset_password.php?token=' + response.data.token + '" class="btn-primary" style="display:inline-block;margin-top:12px;text-decoration:none;padding:10px 20px;"><i class="fa-solid fa-arrow-right"></i> Ir a Restablecer Contraseña</a>';
                        successHtml += '</div>';
                    }
                    
                    $('#forgot-success-msg').html(successHtml).show();
                }
            }
        });
    });

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
