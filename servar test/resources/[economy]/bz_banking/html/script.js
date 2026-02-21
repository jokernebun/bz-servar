'use strict';
function post(n,d){return fetch(`https://${GetParentResourceName()}/${n}`,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(d||{})})}
function GetParentResourceName(){return window.location.href.split('/')[2]||'bz_banking'}
function fmt(n){return Math.floor(n||0).toLocaleString('ro-RO')+' lei'}

function showTab(name){
    document.querySelectorAll('.tab-pane').forEach(p=>p.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
    document.getElementById('t-'+name).classList.add('active');
    const tabs=document.querySelectorAll('.tab');
    const names=['deposit','withdraw','transfer','history'];
    tabs[names.indexOf(name)]?.classList.add('active');
    if(name==='history') post('getHistory');
}

function setAmt(id,val){document.getElementById(id).value=val}

function doDeposit(){
    const v=parseInt(document.getElementById('dep-amount').value);
    if(!v||v<1){alert('Suma invalida!');return}
    post('deposit',{amount:v});
    document.getElementById('dep-amount').value='';
}
function doWithdraw(){
    const v=parseInt(document.getElementById('with-amount').value);
    if(!v||v<1){alert('Suma invalida!');return}
    post('withdraw',{amount:v});
    document.getElementById('with-amount').value='';
}
function doTransfer(){
    const id=parseInt(document.getElementById('tr-id').value);
    const v=parseInt(document.getElementById('tr-amount').value);
    if(!id||!v||v<1){alert('Date invalide!');return}
    post('transfer',{targetId:id,amount:v});
    document.getElementById('tr-id').value='';
    document.getElementById('tr-amount').value='';
}
function closeBank(){post('closeBank')}

function renderHistory(rows){
    const list=document.getElementById('history-list');
    if(!rows||!rows.length){list.innerHTML='<div class="hist-empty">Nicio tranzactie recenta.</div>';return}
    list.innerHTML='';
    const typeLabel={deposit:'Depunere',withdraw:'Retragere',transfer:'Transfer',payment:'Plata'};
    rows.forEach(r=>{
        const isPlus=r.type==='deposit';
        const div=document.createElement('div');div.className='hist-row';
        div.innerHTML=`<div><div class="hist-type">${typeLabel[r.type]||r.type}</div><div class="hist-desc">${r.description||''}</div></div>
        <div class="hist-amount ${isPlus?'plus':'minus'}">${isPlus?'+':'-'}${fmt(r.amount)}</div>`;
        list.appendChild(div);
    });
}

window.addEventListener('message',e=>{
    const d=e.data;
    if(d.action==='open'){
        document.getElementById('bank-user').textContent=d.name||'';
        document.getElementById('bal-cash').textContent=fmt(d.cash);
        document.getElementById('bal-bank').textContent=fmt(d.bank);
        document.getElementById('tab-transfer').style.display=d.isATM?'none':'';
        renderHistory(d.history);
        showTab('deposit');
        document.getElementById('bank').classList.remove('hidden');
    }else if(d.action==='close'){
        document.getElementById('bank').classList.add('hidden');
    }else if(d.action==='updateBalances'){
        document.getElementById('bal-cash').textContent=fmt(d.cash);
        document.getElementById('bal-bank').textContent=fmt(d.bank);
    }else if(d.action==='updateHistory'){
        renderHistory(d.history);
    }
});
