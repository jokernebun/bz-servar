'use strict';

// ─── State ────────────────────────────────────────────────────────────────────
let state = {
    data: null,
    currentCat: 'wheels',
    currentPaintTab: 'primary',
    currentWheelCat: 0,
    currentExtSub: 'spoiler',
    currentIntSub: 'seats',
    xenon: false,
    turbo: false,
    neonEnabled: [false, false, false, false],
    neonColor: { r: 0, g: 255, b: 255 },
    selectedPrimary: 0,
    selectedSecondary: 0,
    selectedPearl: 0,
    selectedWheelColor: 0,
    selectedTint: 0,
    selectedPlate: 0,
    selectedWheelType: 0,
    selectedFrontWheel: -1,
    selectedBackWheel: -1,
};

// ─── NUI communicate ─────────────────────────────────────────────────────────
function sendNUI(type, data) {
    fetch(`https://apex_tuning/${type}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data)
    });
}

function applyMod(type, value, extra) {
    const payload = { type, value };
    if (extra) Object.assign(payload, extra);
    sendNUI('applyMod', payload);
}

// ─── Open / Close ─────────────────────────────────────────────────────────────
window.addEventListener('message', function(e) {
    const msg = e.data;
    if (msg.type === 'open') {
        state.data = msg.data;
        initState();
        renderAll();
        document.getElementById('app').classList.add('visible');
    } else if (msg.type === 'close') {
        document.getElementById('app').classList.remove('visible');
    }
});

function closeMenu() {
    document.getElementById('app').classList.remove('visible');
    sendNUI('close', {});
}

document.getElementById('closeBtn').addEventListener('click', closeMenu);
document.getElementById('closeBtnBottom').addEventListener('click', closeMenu);

// ─── Init state from data ─────────────────────────────────────────────────────
function initState() {
    const d = state.data;
    state.xenon = d.xenon;
    state.turbo = d.turbo;
    state.neonEnabled = d.neonEnabled;
    state.neonColor = d.neonColor;
    state.selectedPrimary = d.primaryColor;
    state.selectedSecondary = d.secondaryColor;
    state.selectedPearl = d.pearlColor;
    state.selectedWheelColor = d.wheelColor;
    state.selectedTint = d.windowTint;
    state.selectedPlate = d.plateStyle;
    state.selectedWheelType = d.wheelType;
    state.selectedFrontWheel = d.frontWheelMod;
    state.selectedBackWheel = d.backWheelMod;
    document.getElementById('vehicleName').textContent = d.name || '—';
}

// ─── Category switching ───────────────────────────────────────────────────────
document.querySelectorAll('.cat-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const cat = btn.dataset.cat;
        switchCategory(cat);
    });
});

function switchCategory(cat) {
    state.currentCat = cat;

    // Update bottom nav
    document.querySelectorAll('.cat-btn').forEach(b => b.classList.toggle('active', b.dataset.cat === cat));

    // Show/hide panels
    document.querySelectorAll('.cat-panel').forEach(p => p.classList.add('hidden'));
    document.querySelectorAll('.cat-right').forEach(p => p.classList.add('hidden'));

    const leftPanel = document.getElementById('panel-' + cat);
    const rightPanel = document.getElementById('right-' + cat);
    if (leftPanel) leftPanel.classList.remove('hidden');
    if (rightPanel) rightPanel.classList.remove('hidden');

    renderCategory(cat);
}

// ─── Render dispatcher ────────────────────────────────────────────────────────
function renderAll() {
    renderCategory(state.currentCat);
    renderPerfDetail();
    renderExtrasDetail();
    renderPaintRight();
}

function renderCategory(cat) {
    switch (cat) {
        case 'wheels':      renderWheels(); break;
        case 'paint':       renderPaintLeft(); renderPaintRight(); break;
        case 'performance': renderPerf(); renderPerfDetail(); break;
        case 'exterior':    renderExteriorTabs(); break;
        case 'interior':    renderInteriorTabs(); break;
        case 'extras':      renderExtrasLeft(); renderExtrasDetail(); break;
    }
}

// ─── WHEELS ───────────────────────────────────────────────────────────────────
const wheelCatIcons = ['fa-car', 'fa-truck', 'fa-arrow-down', 'fa-truck-monster', 'fa-mountain', 'fa-bolt', 'fa-motorcycle', 'fa-star'];

function renderWheels() {
    const d = state.data;
    const tabsEl = document.getElementById('wheelCatTabs');
    const listEl = document.getElementById('wheelList');
    const cats = d.wheelCategories;

    tabsEl.innerHTML = '';
    Object.entries(cats).forEach(([id, name]) => {
        const btn = document.createElement('button');
        const active = parseInt(id) === state.selectedWheelType;
        btn.className = `flex-1 min-w-[48px] py-1.5 rounded-lg text-[10px] font-bold uppercase transition-all ${active ? 'bg-green-500 text-black' : 'text-slate-400 hover:text-white'}`;
        btn.textContent = name;
        btn.onclick = () => {
            state.selectedWheelType = parseInt(id);
            applyMod('wheelType', parseInt(id));
            renderWheels();
            renderWheelSides();
        };
        tabsEl.appendChild(btn);
    });

    // No item list in left panel for wheels — managed via right panel
    listEl.innerHTML = '<p class="text-[10px] text-slate-500 text-center mt-4 uppercase tracking-widest">Select wheel style →</p>';
    renderWheelSides();
}

function renderWheelSides() {
    const d = state.data;
    const frontEl = document.getElementById('frontWheelList');
    const backEl = document.getElementById('backWheelList');

    function buildList(container, count, selected, modType) {
        container.innerHTML = '';
        // Stock option
        const stockDiv = buildModItem({ id: -1, name: 'Stock', equipped: selected === -1 }, () => {
            if (modType === 'frontWheel') {
                state.selectedFrontWheel = -1;
                applyMod('frontWheel', -1);
            } else {
                state.selectedBackWheel = -1;
                applyMod('backWheel', -1);
            }
            renderWheelSides();
        });
        container.appendChild(stockDiv);

        for (let i = 0; i < count; i++) {
            const div = buildModItem({ id: i, name: 'Rim ' + (i + 1), equipped: selected === i }, () => {
                if (modType === 'frontWheel') {
                    state.selectedFrontWheel = i;
                    applyMod('frontWheel', i);
                } else {
                    state.selectedBackWheel = i;
                    applyMod('backWheel', i);
                }
                renderWheelSides();
            });
            container.appendChild(div);
        }
    }

    buildList(frontEl, d.numFrontWheels, state.selectedFrontWheel, 'frontWheel');
    buildList(backEl, d.numBackWheels, state.selectedBackWheel, 'backWheel');
}

// ─── PAINT ────────────────────────────────────────────────────────────────────
function renderPaintLeft() {
    const tabs = document.querySelectorAll('.paint-tab');
    tabs.forEach(t => {
        const active = t.dataset.tab === state.currentPaintTab;
        t.classList.toggle('text-white', active);
        t.classList.toggle('border-b-2', active);
        t.classList.toggle('border-green-500', active);
        t.classList.toggle('-mb-[9px]', active);
        t.classList.toggle('text-slate-400', !active);
    });
    tabs.forEach(t => {
        t.onclick = () => {
            state.currentPaintTab = t.dataset.tab;
            renderPaintLeft();
            renderColorGrid();
        };
    });
    renderColorGrid();
}

function renderColorGrid() {
    const grid = document.getElementById('colorGrid');
    const colors = state.data.colors;
    const tab = state.currentPaintTab;

    let selectedId = state.selectedPrimary;
    if (tab === 'secondary') selectedId = state.selectedSecondary;
    if (tab === 'pearl')     selectedId = state.selectedPearl;
    if (tab === 'wheel')     selectedId = state.selectedWheelColor;

    let html = `<p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest mb-3">
        ${tab === 'primary' ? 'Primary Color' : tab === 'secondary' ? 'Secondary Color' : tab === 'pearl' ? 'Pearlescent' : 'Wheel Color'}
    </p>
    <div class="grid grid-cols-6 gap-2">`;

    colors.forEach(c => {
        const sel = c.id === selectedId;
        html += `<div class="color-dot w-8 h-8 rounded-full border-2 ${sel ? 'border-white selected' : 'border-transparent'}"
            style="background:${c.hex}" title="${c.name}"
            onclick="selectColor(${c.id}, '${tab}')"></div>`;
    });

    html += `</div>`;
    grid.innerHTML = html;
}

window.selectColor = function(id, tab) {
    if (tab === 'primary')   { state.selectedPrimary   = id; applyMod('primaryColor',   id); }
    if (tab === 'secondary') { state.selectedSecondary = id; applyMod('secondaryColor', id); }
    if (tab === 'pearl')     { state.selectedPearl     = id; applyMod('pearlColor',     id); }
    if (tab === 'wheel')     { state.selectedWheelColor = id; applyMod('wheelColor',    id); }
    renderColorGrid();
};

// ─── PAINT RIGHT (Neon + Tint + Plate) ───────────────────────────────────────
const neonColors = [
    { r:0,   g:255, b:255, hex:'#00ffff' },
    { r:255, g:0,   b:255, hex:'#ff00ff' },
    { r:0,   g:255, b:0,   hex:'#00ff00' },
    { r:255, g:255, b:0,   hex:'#ffff00' },
    { r:255, g:100, b:0,   hex:'#ff6400' },
    { r:255, g:0,   b:100, hex:'#ff0064' },
    { r:100, g:0,   b:255, hex:'#6400ff' },
    { r:255, g:255, b:255, hex:'#ffffff' },
    { r:255, g:0,   b:0,   hex:'#ff0000' },
    { r:0,   g:100, b:255, hex:'#0064ff' },
    { r:255, g:165, b:0,   hex:'#ffa500' },
    { r:0,   g:200, b:100, hex:'#00c864' },
];

const neonPos = ['Left', 'Right', 'Front', 'Back'];

function renderPaintRight() {
    // Neon toggles
    const neonEl = document.getElementById('neonToggles');
    neonEl.innerHTML = '';
    neonPos.forEach((name, i) => {
        const on = state.neonEnabled[i];
        neonEl.innerHTML += `
        <div class="flex items-center justify-between bg-slate-900/50 rounded-xl px-3 py-2 border border-slate-800">
            <span class="text-[10px] font-bold uppercase tracking-widest text-slate-300">${name}</span>
            <div class="toggle-track ${on ? 'on' : ''} w-8 h-4 rounded-full relative border border-slate-600 cursor-pointer"
                 onclick="toggleNeon(${i})">
                <div class="toggle-thumb w-3 h-3 ${on ? 'bg-black' : 'bg-slate-400'} rounded-full absolute top-0.5 ${on ? 'left-4' : 'left-0.5'}"></div>
            </div>
        </div>`;
    });

    // Neon color grid
    const neonColorEl = document.getElementById('neonColorGrid');
    neonColorEl.innerHTML = '';
    neonColors.forEach(c => {
        const sel = state.neonColor.r === c.r && state.neonColor.g === c.g && state.neonColor.b === c.b;
        neonColorEl.innerHTML += `<div class="color-dot w-8 h-8 rounded-full border-2 ${sel ? 'border-white selected' : 'border-transparent'} cursor-pointer"
            style="background:${c.hex}" onclick="selectNeonColor(${c.r},${c.g},${c.b})"></div>`;
    });

    // Window tint
    const tintEl = document.getElementById('tintList');
    tintEl.innerHTML = '';
    state.data.windowTints.forEach(t => {
        const sel = t.id === state.selectedTint;
        tintEl.innerHTML += buildSmallItem(t.name, sel, `selectTint(${t.id})`);
    });

    // Plate style
    const plateEl = document.getElementById('plateList');
    plateEl.innerHTML = '';
    state.data.plateStyles.forEach(p => {
        const sel = p.id === state.selectedPlate;
        plateEl.innerHTML += buildSmallItem(p.name, sel, `selectPlate(${p.id})`);
    });
}

window.toggleNeon = function(pos) {
    state.neonEnabled[pos] = !state.neonEnabled[pos];
    applyMod('neonToggle', state.neonEnabled[pos] ? 1 : 0, { pos });
    renderPaintRight();
};

window.selectNeonColor = function(r, g, b) {
    state.neonColor = { r, g, b };
    applyMod('neonColor', 0, { r, g, b });
    renderPaintRight();
};

window.selectTint = function(id) {
    state.selectedTint = id;
    applyMod('windowTint', id);
    renderPaintRight();
};

window.selectPlate = function(id) {
    state.selectedPlate = id;
    applyMod('plateStyle', id);
    renderPaintRight();
};

// ─── PERFORMANCE ──────────────────────────────────────────────────────────────
const perfCategories = [
    { key: 'engine',       label: 'Engine',       icon: 'fa-gauge-high',     modKey: 'numEngineMods',       stateKey: 'engine' },
    { key: 'brakes',       label: 'Brakes',        icon: 'fa-circle-stop',    modKey: 'numBrakeMods',        stateKey: 'brakes' },
    { key: 'transmission', label: 'Transmission',  icon: 'fa-gears',          modKey: 'numTransmissionMods', stateKey: 'transmission' },
    { key: 'suspension',   label: 'Suspension',    icon: 'fa-truck-monster',  modKey: 'numSuspensionMods',   stateKey: 'suspension' },
    { key: 'armor',        label: 'Armor',         icon: 'fa-shield-halved',  modKey: 'numArmorMods',        stateKey: 'armor' },
];

function renderPerf() {
    const d = state.data;
    const el = document.getElementById('perfList');
    el.innerHTML = '';

    perfCategories.forEach(cat => {
        const total = d[cat.modKey] || 0;
        const current = d[cat.stateKey];
        const pct = total > 0 ? Math.round(((current + 1) / total) * 100) : 0;
        const label = current === -1 ? 'Stock' : `Level ${current + 1} / ${total}`;

        el.innerHTML += `
        <div class="bg-slate-900/30 rounded-2xl border border-slate-800 p-4 cursor-pointer group hover:border-green-500/50 transition-all">
            <div class="flex items-center gap-3 mb-2">
                <i class="fa-solid ${cat.icon} text-slate-400 group-hover:text-green-500 transition-all"></i>
                <span class="text-[10px] font-bold uppercase tracking-widest text-slate-300">${cat.label}</span>
            </div>
            <div class="w-full bg-slate-800 h-1.5 rounded-full overflow-hidden">
                <div class="perf-bar-fill bg-green-500 h-full" style="width:${pct}%"></div>
            </div>
            <p class="text-[9px] text-slate-500 mt-1 italic text-right">${label}</p>
        </div>`;
    });
}

function renderPerfDetail() {
    const d = state.data;
    const el = document.getElementById('perfDetail');
    el.innerHTML = '';

    perfCategories.forEach(cat => {
        const total = d[cat.modKey] || 0;
        if (total === 0) return;
        const current = d[cat.stateKey];

        let html = `<div>
            <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest mb-2">${cat.label}</p>
            <div class="flex flex-col gap-1">`;

        // Stock
        const stockSel = current === -1;
        html += `<button class="stage-btn ${stockSel ? 'active' : 'bg-slate-900/40 text-slate-400 hover:text-white'} text-left px-3 py-2 rounded-xl text-xs font-bold border ${stockSel ? 'border-green-500' : 'border-slate-800'} transition-all"
            onclick="applyPerfMod('${cat.key}', -1)">Stock</button>`;

        for (let i = 0; i < total; i++) {
            const sel = current === i;
            html += `<button class="stage-btn ${sel ? 'active' : 'bg-slate-900/40 text-slate-400 hover:text-white'} text-left px-3 py-2 rounded-xl text-xs font-bold border ${sel ? 'border-green-500' : 'border-slate-800'} transition-all"
                onclick="applyPerfMod('${cat.key}', ${i})">Level ${i + 1}</button>`;
        }

        html += `</div></div>`;
        el.innerHTML += html;
    });
}

window.applyPerfMod = function(key, val) {
    const cat = perfCategories.find(c => c.key === key);
    if (!cat) return;
    state.data[cat.stateKey] = val;
    applyMod(key, val);
    renderPerf();
    renderPerfDetail();
};

// ─── EXTERIOR ─────────────────────────────────────────────────────────────────
const extSubcats = [
    { key: 'spoiler',     label: 'Spoiler',     dataKey: 'spoilerMods',   modType: 'spoiler'     },
    { key: 'frontBumper', label: 'Fr. Bumper',  dataKey: 'frontBumpers',  modType: 'frontBumper' },
    { key: 'rearBumper',  label: 'Rr. Bumper',  dataKey: 'rearBumpers',   modType: 'rearBumper'  },
    { key: 'sideSkirt',   label: 'Skirts',      dataKey: 'sideSkirts',    modType: 'sideSkirt'   },
    { key: 'exhaust',     label: 'Exhaust',     dataKey: 'exhaustMods',   modType: 'exhaust'     },
    { key: 'hood',        label: 'Hood',        dataKey: 'hoodMods',      modType: 'hood'        },
    { key: 'grille',      label: 'Grille',      dataKey: 'grilleMods',    modType: 'grille'      },
    { key: 'roof',        label: 'Roof',        dataKey: 'roofMods',      modType: 'roof'        },
];

function renderExteriorTabs() {
    const tabsEl = document.getElementById('extSubTabs');
    tabsEl.innerHTML = '';
    extSubcats.forEach(cat => {
        const active = cat.key === state.currentExtSub;
        const btn = document.createElement('button');
        btn.className = `px-2 py-1 rounded-lg text-[9px] font-bold uppercase tracking-wider transition-all ${active ? 'bg-green-500 text-black' : 'bg-slate-800 text-slate-400 hover:text-white'}`;
        btn.textContent = cat.label;
        btn.onclick = () => { state.currentExtSub = cat.key; renderExteriorTabs(); };
        tabsEl.appendChild(btn);
    });
    renderExtSubList();
}

function renderExtSubList() {
    const cat = extSubcats.find(c => c.key === state.currentExtSub);
    if (!cat) return;

    const items = state.data[cat.dataKey] || [];
    const listEl = document.getElementById('extList');
    const detailEl = document.getElementById('extDetailList');
    const titleEl = document.getElementById('extDetailTitle');

    titleEl.textContent = cat.label + ' options';
    listEl.innerHTML = '';
    detailEl.innerHTML = '';

    items.forEach(item => {
        const div = buildModItem(item, () => {
            state.data[cat.dataKey].forEach(i => i.equipped = (i.id === item.id));
            applyMod(cat.modType, item.id);
            renderExtSubList();
        });
        listEl.appendChild(div);

        const dDiv = buildSmallItemEl(item.name, item.equipped, () => {
            state.data[cat.dataKey].forEach(i => i.equipped = (i.id === item.id));
            applyMod(cat.modType, item.id);
            renderExtSubList();
        });
        detailEl.appendChild(dDiv);
    });
}

// ─── INTERIOR ─────────────────────────────────────────────────────────────────
const intSubcats = [
    { key: 'seats',        label: 'Seats',   dataKey: 'seatMods',      modType: 'seats'        },
    { key: 'steeringWheel',label: 'Wheel',   dataKey: 'steeringMods',  modType: 'steeringWheel'},
    { key: 'dashboard',    label: 'Dash',    dataKey: 'dashboardMods', modType: 'dashboard'    },
    { key: 'dial',         label: 'Gauges',  dataKey: 'dialMods',      modType: 'dial'         },
];

function renderInteriorTabs() {
    const tabsEl = document.getElementById('intSubTabs');
    tabsEl.innerHTML = '';
    intSubcats.forEach(cat => {
        const active = cat.key === state.currentIntSub;
        const btn = document.createElement('button');
        btn.className = `px-2 py-1 rounded-lg text-[9px] font-bold uppercase tracking-wider transition-all ${active ? 'bg-green-500 text-black' : 'bg-slate-800 text-slate-400 hover:text-white'}`;
        btn.textContent = cat.label;
        btn.onclick = () => { state.currentIntSub = cat.key; renderInteriorTabs(); };
        tabsEl.appendChild(btn);
    });
    renderIntSubList();
}

function renderIntSubList() {
    const cat = intSubcats.find(c => c.key === state.currentIntSub);
    if (!cat) return;

    const items = state.data[cat.dataKey] || [];
    const listEl = document.getElementById('intList');
    const detailEl = document.getElementById('intDetailList');
    const titleEl = document.getElementById('intDetailTitle');

    titleEl.textContent = cat.label + ' options';
    listEl.innerHTML = '';
    detailEl.innerHTML = '';

    items.forEach(item => {
        const div = buildModItem(item, () => {
            state.data[cat.dataKey].forEach(i => i.equipped = (i.id === item.id));
            applyMod(cat.modType, item.id);
            renderIntSubList();
        });
        listEl.appendChild(div);

        const dDiv = buildSmallItemEl(item.name, item.equipped, () => {
            state.data[cat.dataKey].forEach(i => i.equipped = (i.id === item.id));
            applyMod(cat.modType, item.id);
            renderIntSubList();
        });
        detailEl.appendChild(dDiv);
    });
}

// ─── EXTRAS LEFT ──────────────────────────────────────────────────────────────
function renderExtrasLeft() {
    const el = document.getElementById('extrasList');
    const d = state.data;

    el.innerHTML = `
    <div class="bg-slate-900/30 rounded-2xl border border-slate-800 p-4">
        <div class="flex items-center gap-3 mb-1">
            <i class="fa-solid fa-lightbulb text-slate-400"></i>
            <span class="text-[10px] font-bold uppercase tracking-widest text-slate-300">Xenon Lights</span>
        </div>
        <p class="text-xs text-slate-500 italic">${state.xenon ? 'Installed' : 'Not installed'}</p>
    </div>

    <div class="bg-slate-900/30 rounded-2xl border border-slate-800 p-4">
        <div class="flex items-center gap-3 mb-1">
            <i class="fa-solid fa-wind text-slate-400"></i>
            <span class="text-[10px] font-bold uppercase tracking-widest text-slate-300">Turbo</span>
        </div>
        <p class="text-xs text-slate-500 italic">${state.turbo ? 'Installed' : 'Not installed'}</p>
    </div>

    <div class="bg-slate-900/30 rounded-2xl border border-slate-800 p-4">
        <div class="flex items-center gap-3 mb-1">
            <i class="fa-solid fa-car-side text-slate-400"></i>
            <span class="text-[10px] font-bold uppercase tracking-widest text-slate-300">Plate</span>
        </div>
        <p class="text-xs text-slate-500 italic">${d.plate}</p>
    </div>`;
}

// ─── EXTRAS DETAIL ────────────────────────────────────────────────────────────
function renderExtrasDetail() {
    updateToggleEl('xenonToggle', state.xenon);
    updateToggleEl('turboToggle', state.turbo);
}

function updateToggleEl(id, on) {
    const el = document.getElementById(id);
    if (!el) return;
    const thumb = el.querySelector('.toggle-thumb');
    el.classList.toggle('on', on);
    if (thumb) {
        thumb.style.left = on ? '1.25rem' : '0.125rem';
        thumb.classList.toggle('bg-black', on);
        thumb.classList.toggle('bg-slate-400', !on);
    }
}

window.toggleXenon = function() {
    state.xenon = !state.xenon;
    applyMod('xenon', state.xenon ? 1 : 0);
    updateToggleEl('xenonToggle', state.xenon);
    renderExtrasLeft();
};

window.toggleTurbo = function() {
    state.turbo = !state.turbo;
    applyMod('turbo', state.turbo ? 1 : 0);
    updateToggleEl('turboToggle', state.turbo);
    renderExtrasLeft();
};

// ─── DOM helpers ──────────────────────────────────────────────────────────────
function buildModItem(item, onClick) {
    const div = document.createElement('div');
    div.className = `mod-item ${item.equipped ? 'equipped' : ''} flex items-center gap-4 p-4 rounded-2xl border border-slate-800 bg-slate-900/30 cursor-pointer`;

    const iconDiv = document.createElement('div');
    iconDiv.className = `w-10 h-10 rounded-full flex items-center justify-center transition-all ${item.equipped ? 'bg-green-500 text-black' : 'bg-slate-800 text-slate-400'}`;
    iconDiv.innerHTML = '<i class="fa-solid fa-compact-disc text-lg"></i>';

    const infoDiv = document.createElement('div');
    infoDiv.className = 'flex-1 min-w-0';
    infoDiv.innerHTML = `<h3 class="text-sm font-bold leading-none truncate ${item.equipped ? 'text-white' : 'text-slate-300'}">${item.name}</h3>`;

    const badge = document.createElement('p');
    badge.className = `text-[10px] font-black uppercase tracking-wider flex-shrink-0 ${item.equipped ? 'accent-green' : 'text-slate-600'}`;
    badge.textContent = item.equipped ? 'Equipped' : '';

    div.appendChild(iconDiv);
    div.appendChild(infoDiv);
    div.appendChild(badge);
    div.onclick = onClick;
    return div;
}

function buildSmallItem(name, selected, onclickStr) {
    return `<div class="flex items-center justify-between px-3 py-2 rounded-xl border cursor-pointer transition-all
        ${selected ? 'border-green-500 bg-green-500/10 text-white' : 'border-slate-800 bg-slate-900/30 text-slate-400 hover:text-white hover:border-slate-600'}"
        onclick="${onclickStr}">
        <span class="text-xs font-bold">${name}</span>
        ${selected ? '<i class="fa-solid fa-check text-green-500 text-[10px]"></i>' : ''}
    </div>`;
}

function buildSmallItemEl(name, selected, onClick) {
    const div = document.createElement('div');
    div.className = `flex items-center justify-between px-3 py-2 rounded-xl border cursor-pointer transition-all ${selected ? 'border-green-500 bg-green-500/10 text-white' : 'border-slate-800 bg-slate-900/30 text-slate-400 hover:text-white hover:border-slate-600'}`;
    div.innerHTML = `<span class="text-xs font-bold">${name}</span>${selected ? '<i class="fa-solid fa-check text-green-500 text-[10px]"></i>' : ''}`;
    div.onclick = onClick;
    return div;
}

// ─── Init on load ─────────────────────────────────────────────────────────────
// For testing outside FiveM: postMessage to simulate open
if (window.location.href.includes('file://') || window.location.href.includes('localhost')) {
    // No simulation needed — FiveM will send the message
}
