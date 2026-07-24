<?php
$page_title = "Mensajería - MarketZone";
$module_js = "mensajeria.js";
require_once __DIR__ . '/../layouts/header.php';
?>

<div id="chat-container" class="chat-layout">
    <!-- Panel de conversaciones -->
    <div class="chat-sidebar">
        <div class="chat-sidebar-header">
            <h3><i class="fa-regular fa-comments"></i> Conversaciones</h3>
        </div>
        <div id="conversaciones-list" class="conversaciones-list">
            <!-- Carga dinámica vía AJAX -->
        </div>
    </div>

    <!-- Panel de chat activo -->
    <div class="chat-main">
        <div id="chat-messages" class="chat-messages">
            <div class="empty-chat-msg">
                <p style="color:var(--text-secondary);text-align:center;padding:40px;">
                    <i class="fa-regular fa-message" style="font-size:2rem;display:block;margin-bottom:10px;"></i>
                    Selecciona una conversación para empezar a chatear
                </p>
            </div>
        </div>
        <div class="chat-input-area">
            <textarea id="mensaje-input" class="form-control" placeholder="Escribe un mensaje..." rows="2" style="resize:none;"></textarea>
            <button id="btn-enviar-mensaje" class="btn-primary" style="width:auto;padding:10px 20px;">
                <i class="fa-solid fa-paper-plane"></i> Enviar
            </button>
        </div>
    </div>
</div>

<style>
.chat-layout {
    display: grid;
    grid-template-columns: 320px 1fr;
    gap: 0;
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 16px;
    overflow: hidden;
    min-height: 70vh;
}

.chat-sidebar {
    border-right: 1px solid var(--card-border);
    display: flex;
    flex-direction: column;
}

.chat-sidebar-header {
    padding: 20px;
    border-bottom: 1px solid var(--card-border);
}

.chat-sidebar-header h3 {
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    gap: 8px;
}

.conversaciones-list {
    flex: 1;
    overflow-y: auto;
}

.conversacion-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 15px 20px;
    cursor: pointer;
    border-bottom: 1px solid rgba(255,255,255,0.04);
    transition: background 0.2s;
}

.conversacion-item:hover,
.conversacion-item.active {
    background: rgba(255,255,255,0.05);
}

.conv-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: rgba(59,130,246,0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--primary-accent);
    flex-shrink: 0;
}

.conv-info {
    flex: 1;
    min-width: 0;
}

.conv-info strong {
    display: block;
    font-size: 0.9rem;
    margin-bottom: 3px;
}

.conv-last-msg {
    font-size: 0.8rem;
    color: var(--text-secondary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.conv-time {
    font-size: 0.7rem;
    color: var(--text-secondary);
}

.conv-status .status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    display: inline-block;
}

.status-dot.abierta { background: #34D399; }
.status-dot.cerrada { background: #9CA3AF; }
.status-dot.archivada { background: #F59E0B; }

.chat-main {
    display: flex;
    flex-direction: column;
}

.chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.message {
    display: flex;
    max-width: 75%;
}

.message.sent {
    align-self: flex-end;
}

.message.received {
    align-self: flex-start;
}

.message-content {
    padding: 12px 16px;
    border-radius: 12px;
    font-size: 0.9rem;
}

.message.sent .message-content {
    background: var(--accent-gradient);
    color: #fff;
    border-bottom-right-radius: 4px;
}

.message.received .message-content {
    background: rgba(255,255,255,0.05);
    border: 1px solid var(--card-border);
    border-bottom-left-radius: 4px;
}

.message-time {
    font-size: 0.7rem;
    opacity: 0.7;
    display: block;
    margin-top: 4px;
}

.chat-input-area {
    display: flex;
    gap: 12px;
    padding: 15px 20px;
    border-top: 1px solid var(--card-border);
    align-items: flex-end;
}

.chat-input-area .form-control {
    padding: 10px 14px;
}

@media (max-width: 768px) {
    .chat-layout {
        grid-template-columns: 1fr;
    }
    .chat-sidebar {
        display: none;
    }
}
</style>

<?php require_once __DIR__ . '/../layouts/footer.php'; ?>

