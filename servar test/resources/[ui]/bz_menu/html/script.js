'use strict';

// ============================================================
// CONTEXT MENU
// ============================================================
const menuOverlay = document.getElementById('menu-overlay');
const menuTitle   = document.getElementById('menu-title');
const menuSub     = document.getElementById('menu-subtitle');
const menuList    = document.getElementById('menu-list');

function openMenu(data) {
    menuTitle.textContent = data.title    || 'Meniu';
    menuSub.textContent   = data.subtitle || '';
    menuList.innerHTML    = '';

    data.options.forEach(opt => {
        const item = document.createElement('div');
        item.className = 'menu-item' + (opt.disabled ? ' disabled' : '');

        item.innerHTML = `
            <div class="menu-item-icon">${opt.icon || ''}</div>
            <div class="menu-item-body">
                <div class="menu-item-label">${opt.label}</div>
                ${opt.description ? `<div class="menu-item-desc">${opt.description}</div>` : ''}
            </div>
            ${opt.price != null ? `<div class="menu-item-price">${opt.price} lei</div>` : ''}
        `;

        if (!opt.disabled) {
            item.addEventListener('click', () => {
                fetch(`https://${GetParentResourceName()}/selectOption`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ id: opt.id }),
                });
            });
        }
        menuList.appendChild(item);
    });

    menuOverlay.classList.remove('hidden');
}

function closeMenu() {
    menuOverlay.classList.add('hidden');
}

// ESC to close
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        if (!menuOverlay.classList.contains('hidden')) {
            fetch(`https://${GetParentResourceName()}/closeMenu`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({}),
            });
            closeMenu();
        }
        if (!inputOverlay.classList.contains('hidden')) {
            cancelInput();
        }
    }
});

// ============================================================
// INPUT DIALOG
// ============================================================
const inputOverlay = document.getElementById('input-overlay');
const inputTitle   = document.getElementById('input-title');
const inputFields  = document.getElementById('input-fields');

let currentFields = [];

function openInput(data) {
    inputTitle.textContent = data.title || 'Completati';
    inputFields.innerHTML  = '';
    currentFields = data.fields || [];

    currentFields.forEach((field, i) => {
        const div = document.createElement('div');
        div.className = 'input-field';

        if (field.type === 'select') {
            const opts = (field.options || []).map(o =>
                `<option value="${o.value}">${o.label}</option>`
            ).join('');
            div.innerHTML = `<label>${field.label}</label><select id="field_${i}">${opts}</select>`;
        } else {
            div.innerHTML = `
                <label>${field.label}${field.required ? ' *' : ''}</label>
                <input id="field_${i}" type="${field.type || 'text'}"
                    placeholder="${field.placeholder || ''}"
                    ${field.required ? 'required' : ''} />
            `;
        }
        inputFields.appendChild(div);
    });

    inputOverlay.classList.remove('hidden');
    const first = inputFields.querySelector('input, select');
    if (first) first.focus();
}

function submitInput() {
    const values = {};
    let valid = true;

    currentFields.forEach((field, i) => {
        const el = document.getElementById('field_' + i);
        if (field.required && (!el || el.value.trim() === '')) {
            el.style.borderColor = '#e74c3c';
            valid = false;
        } else {
            if (el) values[field.name || ('field_' + i)] = el.value;
        }
    });

    if (!valid) return;

    fetch(`https://${GetParentResourceName()}/submitInput`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ values }),
    });
    inputOverlay.classList.add('hidden');
}

function cancelInput() {
    fetch(`https://${GetParentResourceName()}/cancelInput`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({}),
    });
    inputOverlay.classList.add('hidden');
}

document.getElementById('input-submit').addEventListener('click', submitInput);
document.getElementById('input-cancel').addEventListener('click', cancelInput);

// ============================================================
// PROGRESS BAR
// ============================================================
const progressOverlay = document.getElementById('progress-overlay');
const progressLabel   = document.getElementById('progress-label');
const progressFill    = document.getElementById('progress-fill');
let progressInterval  = null;

function startProgress(data) {
    progressLabel.textContent = data.label   || 'Se incarca...';
    progressFill.style.width  = '0%';
    document.getElementById('progress-hint').style.display = data.canCancel ? 'block' : 'none';
    progressOverlay.classList.remove('hidden');

    let elapsed = 0;
    const duration = data.duration || 3000;
    const step = 50;
    clearInterval(progressInterval);

    progressInterval = setInterval(() => {
        elapsed += step;
        const pct = Math.min((elapsed / duration) * 100, 100);
        progressFill.style.width = pct + '%';
        if (elapsed >= duration) {
            clearInterval(progressInterval);
            progressOverlay.classList.add('hidden');
        }
    }, step);
}

function cancelProgress() {
    clearInterval(progressInterval);
    progressOverlay.classList.add('hidden');
    progressFill.style.width = '0%';
}

// ============================================================
// MESSAGE HANDLER
// ============================================================
window.addEventListener('message', (e) => {
    const d = e.data;
    switch (d.action) {
        case 'open':          openMenu(d);        break;
        case 'close':         closeMenu();         break;
        case 'openInput':     openInput(d);        break;
        case 'closeInput':    inputOverlay.classList.add('hidden'); break;
        case 'progressBar':   startProgress(d);    break;
        case 'cancelProgress':cancelProgress();    break;
    }
});

function GetParentResourceName() {
    return window.location.href.split('/')[2] || 'bz_menu';
}
