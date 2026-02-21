'use strict';

const mc         = document.getElementById('multichar');
const charList   = document.getElementById('char-list');
const createForm = document.getElementById('create-form');

let maxChars = 3;
let chars    = [];

function post(name, data) {
    return fetch(`https://${GetParentResourceName()}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data || {}),
    });
}

function renderChars() {
    charList.innerHTML = '';
    chars.forEach(char => {
        const div = document.createElement('div');
        div.className = 'char-card';
        div.innerHTML = `
            <div class="char-name">${char.firstname} ${char.lastname}</div>
            <div class="char-job">Job: ${char.job || 'Somer'}</div>
            <div class="char-money">💰 ${Math.floor(char.cash || 0).toLocaleString('ro-RO')} lei numerar</div>
            <div class="char-actions">
                <button class="btn-play" onclick="selectChar(${char.id})">▶ Joaca</button>
                <button class="btn-delete" onclick="deleteChar(${char.id}, event)">🗑</button>
            </div>
        `;
        charList.appendChild(div);
    });

    // Adauga slot-uri goale
    for (let i = chars.length; i < maxChars; i++) {
        const div = document.createElement('div');
        div.className = 'char-empty';
        div.innerHTML = `<div>＋ Creeaza Personaj</div><div style="font-size:11px;margin-top:4px">Slot ${i+1}</div>`;
        div.addEventListener('click', showCreate);
        charList.appendChild(div);
    }
}

function selectChar(charId) {
    post('selectCharacter', { charId });
}

function deleteChar(charId, e) {
    e.stopPropagation();
    if (!confirm('Esti sigur ca vrei sa stergi acest personaj? Aceasta actiune este IREVERSIBILA!')) return;
    post('deleteCharacter', { charId });
}

function showCreate() {
    createForm.classList.remove('hidden');
}
function hideCreate() {
    createForm.classList.add('hidden');
}

function submitCreate() {
    const firstname = document.getElementById('inp-firstname').value.trim();
    const lastname  = document.getElementById('inp-lastname').value.trim();
    const dob       = document.getElementById('inp-dob').value;
    const sex       = document.getElementById('inp-sex').value;

    if (!firstname || !lastname) {
        alert('Completeaza prenumele si numele!');
        return;
    }

    post('createCharacter', { firstname, lastname, dob, sex });
    hideCreate();
}

function disconnect() {
    post('disconnect');
}

window.addEventListener('message', (e) => {
    const d = e.data;
    if (d.action === 'show') {
        maxChars = d.maxChars || 3;
        chars    = d.characters || [];
        renderChars();
        mc.classList.remove('hidden');
    } else if (d.action === 'hide') {
        mc.classList.add('hidden');
        createForm.classList.add('hidden');
    } else if (d.action === 'refresh') {
        chars = d.characters || [];
        renderChars();
    }
});

function GetParentResourceName() {
    return window.location.href.split('/')[2] || 'bz_multichar';
}
