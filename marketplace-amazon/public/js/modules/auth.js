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
});
