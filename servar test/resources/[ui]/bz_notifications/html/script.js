'use strict';

const container = document.getElementById('notifications-container');

const ICONS = {
    success: '✅',
    error:   '❌',
    warning: '⚠️',
    info:    'ℹ️',
    police:  '🚔',
    medic:   '🏥',
    money:   '💰',
};

const TITLES = {
    success: 'Succes',
    error:   'Eroare',
    warning: 'Atentie',
    info:    'Informatie',
    police:  'Politie',
    medic:   'SMURD',
    money:   'Tranzactie',
};

function createNotification(message, type, duration) {
    const el = document.createElement('div');
    el.className = `notification ${type}`;

    const icon  = ICONS[type]  || 'ℹ️';
    const title = TITLES[type] || 'Notificare';

    el.innerHTML = `
        <div class="notification-icon">${icon}</div>
        <div class="notification-body">
            <div class="notification-title">${title}</div>
            <div class="notification-msg">${message}</div>
        </div>
        <div class="notification-progress" style="animation-duration:${duration}ms"></div>
    `;

    container.appendChild(el);

    setTimeout(() => {
        el.classList.add('hide');
        setTimeout(() => el.remove(), 400);
    }, duration);
}

window.addEventListener('message', (e) => {
    const data = e.data;
    if (data.action === 'show') {
        createNotification(data.message, data.type || 'info', data.duration || 4000);
    }
});
