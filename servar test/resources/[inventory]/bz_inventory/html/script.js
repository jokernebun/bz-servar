'use strict';

const inv     = document.getElementById('inventory');
const grid    = document.getElementById('inv-grid');
const tooltip = document.getElementById('item-tooltip');
const ctx     = document.getElementById('item-ctx');

let currentItem = null;

const ITEM_ICONS = {
    water: '💧', bread: '🍞', sandwich: '🥪', coffee: '☕', energy_drink: '⚡',
    bandage: '🩹', firstaid: '🏥', morphine: '💉', defib: '⚡', splint: '🦴',
    handcuffs: '⛓️', radio: '📻', taser: '⚡', ticket: '📄', evidence_bag: '🎒',
    wrench: '🔧', repair_kit: '🛠️', engine_oil: '🛢️', tire_kit: '🚗', fuel_can: '⛽',
    weed: '🌿', weed_seed: '🌱', cocaine: '❄️', cocaine_bag: '💊', meth: '🔮',
    iron_ore: '⛏️', iron_bar: '🔩', copper_ore: '🟠', copper_wire: '🔌',
    plastic: '🧴', spring: '🔩', steel: '⚙️', cloth: '🧵', electronics: '🔋',
    lockpick: '🔑', phone: '📱', id_card: '🪪', drivers_license: '🚗',
    screwdriver: '🔩', lighter: '🔥', rope: '🪢', garbage_bag: '🗑️', package: '📦',
    pizza: '🍕', burger: '🍔', cola: '🥤', beer: '🍺',
    gunpowder: '💥', pistol_parts: '🔫', ammo_9mm: '🔴', ammo_rifle: '🔴',
    default: '📦',
};

function getIcon(name) { return ITEM_ICONS[name] || ITEM_ICONS.default; }

function renderInventory(items, maxW, currentW, charName) {
    document.getElementById('inv-player').textContent = charName || '';
    const pct = Math.min(100, (currentW / maxW) * 100);
    document.getElementById('inv-weight-bar').style.width = pct + '%';
    document.getElementById('inv-weight-bar').style.background = pct > 80 ? '#e74c3c' : '#3498db';
    document.getElementById('inv-weight-text').textContent =
        `${(currentW/1000).toFixed(1)} kg / ${(maxW/1000).toFixed(0)} kg`;

    grid.innerHTML = '';

    // Sorteaza dupa slot
    const sorted = [...items].sort((a, b) => a.slot - b.slot);

    // Umple 36 slot-uri
    const SLOTS = 36;
    const slotMap = {};
    sorted.forEach(it => { slotMap[it.slot] = it; });

    for (let i = 1; i <= SLOTS; i++) {
        const item = slotMap[i];
        const div  = document.createElement('div');
        div.className = 'inv-slot' + (item ? ' has-item' + (item.illegal ? ' illegal' : '') : '');

        if (item) {
            div.innerHTML = `
                ${item.illegal ? '<div class="slot-illegal-badge">ILEGAL</div>' : ''}
                <div class="slot-icon">${getIcon(item.name)}</div>
                <div class="slot-label">${item.label}</div>
                <div class="slot-count">${item.count}</div>
            `;

            // Hover tooltip
            div.addEventListener('mouseenter', (e) => showTooltip(e, item));
            div.addEventListener('mousemove',  moveTooltip);
            div.addEventListener('mouseleave', hideTooltip);

            // Right click = context menu
            div.addEventListener('contextmenu', (e) => {
                e.preventDefault();
                showCtx(e, item);
            });
        }
        grid.appendChild(div);
    }
}

function showTooltip(e, item) {
    document.getElementById('tooltip-name').textContent   = item.label;
    document.getElementById('tooltip-desc').textContent   = item.description || '';
    document.getElementById('tooltip-weight').textContent = `Greutate: ${item.weight}g x${item.count} = ${item.weight * item.count}g`;
    tooltip.classList.remove('hidden');
    moveTooltip(e);
}
function moveTooltip(e) {
    tooltip.style.left = (e.clientX + 16) + 'px';
    tooltip.style.top  = (e.clientY - 10) + 'px';
}
function hideTooltip() { tooltip.classList.add('hidden'); }

function showCtx(e, item) {
    currentItem = item;
    ctx.style.left = e.clientX + 'px';
    ctx.style.top  = e.clientY + 'px';
    ctx.classList.remove('hidden');

    document.getElementById('ctx-use').style.display  = item.usable  ? '' : 'none';
    document.getElementById('ctx-drop').style.display = '';
}
function hideCtx() {
    ctx.classList.add('hidden');
    currentItem = null;
}

document.getElementById('ctx-use').addEventListener('click', () => {
    if (!currentItem) return;
    hideCtx();
    post('useItem', { name: currentItem.name });
});
document.getElementById('ctx-drop').addEventListener('click', () => {
    if (!currentItem) return;
    const count = parseInt(prompt(`Cate ${currentItem.label} vrei sa arunci? (max ${currentItem.count})`) || '1');
    if (isNaN(count) || count < 1) return;
    const final = Math.min(count, currentItem.count);
    hideCtx();
    post('dropItem', { name: currentItem.name, count: final });
});
document.getElementById('ctx-info').addEventListener('click', () => {
    if (!currentItem) return;
    hideCtx();
    alert(`${currentItem.label}\n\n${currentItem.description}\nGreutate: ${currentItem.weight}g`);
});

document.addEventListener('click', (e) => {
    if (!ctx.contains(e.target)) hideCtx();
});

function closeInventory() {
    post('closeInventory', {});
}

function post(name, data) {
    return fetch(`https://${GetParentResourceName()}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    });
}

window.addEventListener('message', (e) => {
    const d = e.data;
    if (d.action === 'open') {
        inv.classList.remove('hidden');
        renderInventory(d.items, d.maxWeight, d.weight, d.charName);
    } else if (d.action === 'close') {
        inv.classList.add('hidden');
        hideTooltip(); hideCtx();
    }
});

function GetParentResourceName() {
    return window.location.href.split('/')[2] || 'bz_inventory';
}
