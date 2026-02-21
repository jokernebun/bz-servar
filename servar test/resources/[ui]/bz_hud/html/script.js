'use strict';

const hud       = document.getElementById('hud');
const speedo    = document.getElementById('speedometer');

function fmt(n) {
    return Math.floor(n || 0).toLocaleString('ro-RO');
}

function update(d) {
    // Health
    const hp = Math.min(100, Math.max(0, d.health ?? 100));
    document.getElementById('fill-health').style.width = hp + '%';
    document.getElementById('val-health').textContent  = hp;

    // Armor
    const ar = Math.min(100, Math.max(0, d.armor ?? 0));
    document.getElementById('fill-armor').style.width = ar + '%';
    document.getElementById('val-armor').textContent  = ar;

    // Speed
    if (d.inVeh) {
        speedo.classList.remove('hidden');
        document.getElementById('speed-value').textContent = d.speed ?? 0;
    } else {
        speedo.classList.add('hidden');
    }

    // Money
    if (d.cash != null) document.getElementById('val-cash').textContent = fmt(d.cash);
    if (d.bank != null) document.getElementById('val-bank').textContent = fmt(d.bank);
}

window.addEventListener('message', (e) => {
    const d = e.data;
    switch (d.action) {
        case 'show':
            hud.classList.remove('hidden');
            break;
        case 'hide':
            hud.classList.add('hidden');
            break;
        case 'init':
            document.getElementById('val-cash').textContent  = fmt(d.cash);
            document.getElementById('val-bank').textContent  = fmt(d.bank);
            document.getElementById('job-label').textContent  = d.jobLabel  || 'Somer';
            document.getElementById('grade-label').textContent= d.gradeLabel || '';
            hud.classList.remove('hidden');
            break;
        case 'updateStats':
            update(d);
            break;
        case 'updateMoney':
            if (d.cash != null) document.getElementById('val-cash').textContent = fmt(d.cash);
            if (d.bank != null) document.getElementById('val-bank').textContent = fmt(d.bank);
            break;
        case 'updateJob':
            document.getElementById('job-label').textContent   = d.jobLabel   || 'Somer';
            document.getElementById('grade-label').textContent = d.gradeLabel || '';
            break;
    }
});
