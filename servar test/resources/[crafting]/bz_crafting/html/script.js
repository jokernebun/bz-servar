'use strict';

let recipes    = [];
let inventory  = {};
let selectedIdx= null;

const ITEM_LABELS = {
    water:'Apa',bandage:'Bandaj',cloth:'Panza',iron_bar:'Bara Fier',
    plastic:'Plastic',spring:'Arc',copper_wire:'Sarma Cupru',steel:'Otel',
    glass:'Sticla',electronics:'Electronice',meth_ingredient:'Ingrediente Meth',
    cocaine_bag:'Punga Cocaina',weed_seed:'Samanta Iarba',gunpowder:'Praf Pusca',
    firstaid:'Trusa PJ',rope:'Franghie',repair_kit:'Kit Reparatie',tire_kit:'Kit Anvelope',
    fuel_can:'Bidon Combustibil',screwdriver:'Surubelnita',phone:'Telefon',
    ammo_9mm:'Munitie 9mm',ammo_rifle:'Munitie Pusca',lockpick:'Spargator',
    weed:'Iarba',cocaine:'Cocaina',meth:'Meth',
};
function iLabel(name) { return ITEM_LABELS[name] || name; }

function canCraft(recipe) {
    for (const ing of recipe.ingredients) {
        if (ing.count > 0 && (inventory[ing.item] || 0) < ing.count) return false;
    }
    return true;
}

function renderList(filtered) {
    const list = document.getElementById('recipe-list');
    list.innerHTML = '';
    filtered.forEach((recipe, idx) => {
        const can   = canCraft(recipe);
        const div   = document.createElement('div');
        div.className = 'recipe-item ' + (can ? 'can-craft' : 'cannot-craft') + (recipe.illegal ? ' illegal' : '');
        div.innerHTML = `
            <div class="ri-icon">${recipe.icon || '📦'}</div>
            <div class="ri-body">
                <div class="ri-name">${recipe.label} ${recipe.illegal ? '<span class="ri-badge">ILEGAL</span>' : ''}</div>
                <div class="ri-desc">${recipe.description || ''}</div>
            </div>
            <div class="ri-right">
                <div class="ri-result">x${recipe.resultCount || 1}</div>
                <div class="ri-time">⏱ ${((recipe.time || 5000)/1000).toFixed(0)}s</div>
            </div>
        `;
        div.addEventListener('click', () => showDetail(recipe, idx));
        list.appendChild(div);
    });

    if (filtered.length === 0) {
        list.innerHTML = '<div style="text-align:center;padding:30px;color:rgba(255,255,255,0.2)">Nicio reteta gasita.</div>';
    }
}

function filterRecipes() {
    const q = document.getElementById('craft-search').value.toLowerCase();
    const f = recipes.filter(r => r.label.toLowerCase().includes(q) || (r.description||'').toLowerCase().includes(q));
    renderList(f);
}

function showDetail(recipe, idx) {
    selectedIdx = idx;
    document.getElementById('detail-icon').textContent  = recipe.icon || '📦';
    document.getElementById('detail-name').textContent  = recipe.label;
    document.getElementById('detail-desc').textContent  = recipe.description || '';
    document.getElementById('detail-time').textContent  = `Timp: ${((recipe.time||5000)/1000).toFixed(0)} secunde`;
    document.getElementById('result-icon').textContent  = recipe.icon || '';
    document.getElementById('result-count').textContent = `Obtii: ${recipe.resultCount || 1}x ${recipe.label}`;

    const ingList = document.getElementById('ingredients-list');
    ingList.innerHTML = '';
    let canMake = true;

    recipe.ingredients.forEach(ing => {
        if (ing.count <= 0) return;
        const have = inventory[ing.item] || 0;
        const ok   = have >= ing.count;
        if (!ok) canMake = false;
        const row = document.createElement('div');
        row.className = 'ing-row';
        row.innerHTML = `
            <div class="ing-label">${iLabel(ing.item)}</div>
            <div class="ing-have ${ok ? 'ok' : 'bad'}">${have} / ${ing.count} ${ok ? '✅' : '❌'}</div>
        `;
        ingList.appendChild(row);
    });

    const btn = document.getElementById('btn-craft');
    btn.disabled = !canMake;

    document.getElementById('recipe-detail').classList.remove('hidden');
}

function clearDetail() {
    document.getElementById('recipe-detail').classList.add('hidden');
    selectedIdx = null;
}

function craftSelected() {
    if (selectedIdx === null) return;
    post('craftItem', { recipeIdx: selectedIdx + 1 });
    clearDetail();
}

function close() {
    post('closeCrafting', {});
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
        recipes = d.recipes || [];
        document.getElementById('craft-icon').textContent   = d.icon  || '🔨';
        document.getElementById('craft-title').textContent  = d.label || 'Crafting';
        document.getElementById('crafting').classList.remove('hidden');
        clearDetail();
        document.getElementById('craft-search').value = '';
        renderList(recipes);
    } else if (d.action === 'close') {
        document.getElementById('crafting').classList.add('hidden');
    } else if (d.action === 'updateInventory') {
        inventory = d.inventory || {};
        filterRecipes();
    }
});

function GetParentResourceName() {
    return window.location.href.split('/')[2] || 'bz_crafting';
}
