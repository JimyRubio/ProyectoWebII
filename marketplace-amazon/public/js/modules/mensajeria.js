/* ==========================================================================
   MARKETPLACE AMAZON - MÓDULO JS DE MENSAJERÍA (mensajeria.js)
   ========================================================================== */

let conversacionActiva = null;

$(document).ready(function () {
    if ($('#chat-container').length) {
        loadConversaciones();
    }

    // Enviar mensaje
    $('#btn-enviar-mensaje').on('click', function (e) {
        e.preventDefault();
        enviarMensaje();
    });

    $('#mensaje-input').on('keypress', function (e) {
        if (e.which === 13 && !e.shiftKey) {
            e.preventDefault();
            enviarMensaje();
        }
    });
});

function loadConversaciones() {
    App.ajax({
        url: App.baseUrl + 'api/mensajeria.php',
        method: 'GET',
        success: function (response) {
            if (response.success && response.data) {
                renderConversaciones(response.data);
            }
        }
    });
}

function renderConversaciones(conversaciones) {
    const $list = $('#conversaciones-list');
    if (!$list.length) return;

    if (!conversaciones || conversaciones.length === 0) {
        $list.html('<div class="empty-conv"><p style="color:var(--text-secondary);text-align:center;padding:20px;">No tienes conversaciones activas</p></div>');
        return;
    }

    let html = '';
    conversaciones.forEach(c => {
        const isActive = conversacionActiva && conversacionActiva.id === c.id;
        html += `
            <div class="conversacion-item ${isActive ? 'active' : ''}" data-id="${c.id}">
                <div class="conv-avatar">
                    <i class="fa-solid fa-store"></i>
                </div>
                <div class="conv-info">
                    <strong>${c.vendedor_nombre || c.cliente_nombre + ' ' + c.cliente_apellido}</strong>
                    <p class="conv-last-msg">${c.ultimo_mensaje || 'Sin mensajes'}</p>
                    <span class="conv-time">${c.updated_at}</span>
                </div>
                <div class="conv-status">
                    <span class="status-dot ${c.estado}"></span>
                </div>
            </div>
        `;
    });

    $list.html(html);

    $('.conversacion-item').on('click', function () {
        const id = $(this).data('id');
        const conv = conversaciones.find(c => c.id === id);
        if (conv) {
            conversacionActiva = conv;
            $('.conversacion-item').removeClass('active');
            $(this).addClass('active');
            loadMensajes(id);
        }
    });

    // Cargar primera conversación
    if (conversaciones.length > 0 && !conversacionActiva) {
        conversacionActiva = conversaciones[0];
        $('.conversacion-item:first').addClass('active');
        loadMensajes(conversaciones[0].id);
    }
}

function loadMensajes(conversacionId) {
    App.ajax({
        url: App.baseUrl + 'api/mensajeria.php?action=mensajes',
        method: 'GET',
        data: { conversacion_id: conversacionId },
        success: function (response) {
            if (response.success && response.data) {
                renderMensajes(response.data);
            }
        }
    });
}

function renderMensajes(mensajes) {
    const $chat = $('#chat-messages');
    if (!$chat.length) return;

    if (!mensajes || mensajes.length === 0) {
        $chat.html('<div class="empty-chat-msg"><p style="color:var(--text-secondary);text-align:center;padding:40px;">Inicia la conversación enviando un mensaje</p></div>');
        return;
    }

    let html = '';
    mensajes.forEach(m => {
        const isMine = m.remitente_tipo === 'cliente';
        html += `
            <div class="message ${isMine ? 'sent' : 'received'}">
                <div class="message-content">
                    <p>${m.mensaje}</p>
                    <span class="message-time">${m.created_at}</span>
                </div>
            </div>
        `;
    });

    $chat.html(html);
    $chat.scrollTop($chat[0].scrollHeight);
}

function enviarMensaje() {
    const $input = $('#mensaje-input');
    const mensaje = $input.val().trim();

    if (!mensaje) return;
    if (!conversacionActiva) {
        App.notify('Selecciona una conversación primero', 'error');
        return;
    }

    App.ajax({
        url: App.baseUrl + 'api/mensajeria.php',
        method: 'POST',
        data: {
            action: 'enviar',
            conversacion_id: conversacionActiva.id,
            mensaje: mensaje
        },
        success: function (response) {
            if (response.success) {
                $input.val('');
                loadMensajes(conversacionActiva.id);
            }
        }
    });
}

