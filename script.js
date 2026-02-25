'use strict';

/* ── GTA V Color Palette ── */
var GTA_COLORS = [
  {id:0,hex:'#0d1116',name:'Black'},{id:1,hex:'#1c1d21',name:'Graphite'},
  {id:3,hex:'#454b4f',name:'Dark Silver'},{id:4,hex:'#999da0',name:'Silver'},
  {id:7,hex:'#637380',name:'Shadow Silver'},{id:10,hex:'#444e54',name:'Gun Metal'},
  {id:11,hex:'#1d2129',name:'Anthracite'},{id:12,hex:'#13181f',name:'Matte Black'},
  {id:111,hex:'#f0f0f0',name:'White'},{id:112,hex:'#eaeaea',name:'Frost White'},
  {id:134,hex:'#ffffff',name:'Pure White'},{id:107,hex:'#f5ecd8',name:'Cream'},
  {id:131,hex:'#ebebeb',name:'Matte White'},{id:120,hex:'#d6d6d6',name:'Chrome'},
  {id:27,hex:'#c10000',name:'Red'},{id:28,hex:'#da0b00',name:'Torino Red'},
  {id:29,hex:'#b40400',name:'Formula Red'},{id:30,hex:'#d3362b',name:'Blaze Red'},
  {id:35,hex:'#881111',name:'Candy Red'},{id:150,hex:'#a2231d',name:'Lava Red'},
  {id:39,hex:'#cf1f21',name:'Matte Red'},{id:40,hex:'#732021',name:'Dark Red'},
  {id:31,hex:'#731827',name:'Graceful Red'},{id:143,hex:'#24121a',name:'Black Red'},
  {id:36,hex:'#d35f2b',name:'Sunrise Orange'},{id:38,hex:'#e57810',name:'Orange'},
  {id:138,hex:'#f67f11',name:'Bright Orange'},{id:41,hex:'#f78616',name:'Matte Orange'},
  {id:88,hex:'#f5a623',name:'Taxi Yellow'},{id:89,hex:'#daa520',name:'Race Yellow'},
  {id:91,hex:'#e8d735',name:'Yellow Bird'},{id:42,hex:'#edad0b',name:'Matte Yellow'},
  {id:92,hex:'#7ebd12',name:'Lime'},{id:158,hex:'#ddc42e',name:'Pure Gold'},
  {id:37,hex:'#b89048',name:'Classic Gold'},{id:159,hex:'#be9a49',name:'Brushed Gold'},
  {id:49,hex:'#132428',name:'Dark Green'},{id:50,hex:'#122e2b',name:'Racing Green'},
  {id:53,hex:'#155c2d',name:'Green'},{id:139,hex:'#10b981',name:'Emerald'},
  {id:125,hex:'#507045',name:'Securicor Green'},{id:128,hex:'#3b4e43',name:'Matte Green'},
  {id:144,hex:'#2d4034',name:'Hunter Green'},{id:55,hex:'#45561e',name:'Matte Lime'},
  {id:61,hex:'#0c1830',name:'Midnight Blue'},{id:62,hex:'#0f1e3d',name:'Dark Blue'},
  {id:64,hex:'#253044',name:'Blue'},{id:70,hex:'#0f5aab',name:'Bright Blue'},
  {id:73,hex:'#0b4ca5',name:'Ultra Blue'},{id:140,hex:'#316edc',name:'Royal Blue'},
  {id:157,hex:'#438ec1',name:'Epsilon Blue'},{id:67,hex:'#5288a7',name:'Diamond Blue'},
  {id:83,hex:'#1f2852',name:'Matte Blue'},{id:127,hex:'#5f809d',name:'Police Blue'},
  {id:145,hex:'#4b297c',name:'Purple'},{id:142,hex:'#1c1828',name:'Black Purple'},
  {id:148,hex:'#452b72',name:'Matte Purple'},{id:135,hex:'#f21f99',name:'Hot Pink'},
  {id:136,hex:'#f6a4a3',name:'Salmon Pink'},{id:137,hex:'#d64161',name:'Vermillion Pink'},
  {id:90,hex:'#685c2e',name:'Bronze'},{id:93,hex:'#bfae7b',name:'Champagne'},
  {id:96,hex:'#251b09',name:'Choco Brown'},{id:98,hex:'#60492c',name:'Light Brown'},
  {id:105,hex:'#c4b89b',name:'Beach Sand'},{id:129,hex:'#3d3124',name:'Matte Brown'},
  {id:117,hex:'#909696',name:'Brushed Steel'},{id:118,hex:'#4b5a5e',name:'Brushed Black Steel'},
  {id:119,hex:'#7a8382',name:'Brushed Aluminium'},{id:147,hex:'#050505',name:'Mod Black'},
];

var NEON_COLORS = [
  {r:255,g:0,b:0,hex:'#ff0000',name:'Red'},
  {r:0,g:255,b:0,hex:'#00ff00',name:'Green'},
  {r:0,g:0,b:255,hex:'#0000ff',name:'Blue'},
  {r:255,g:255,b:0,hex:'#ffff00',name:'Yellow'},
  {r:255,g:0,b:255,hex:'#ff00ff',name:'Pink'},
  {r:0,g:255,b:255,hex:'#00ffff',name:'Cyan'},
  {r:255,g:128,b:0,hex:'#ff8000',name:'Orange'},
  {r:128,g:0,b:255,hex:'#8000ff',name:'Purple'},
  {r:255,g:255,b:255,hex:'#ffffff',name:'White'},
];

/* ── Category Definitions: părți principale în stânga (ca în imagine) ── */
var CATEGORIES = [
  {id:'spoiler',group:'EXTERIOR',label:'Spoilers',type:'modlist',dataKey:'spoilerMods',modType:'spoiler'},
  {id:'hood',group:'EXTERIOR',label:'Hood',type:'modlist',dataKey:'hoodMods',modType:'hood'},
  {id:'frontBumper',group:'EXTERIOR',label:'Bumper față',type:'modlist',dataKey:'frontBumpers',modType:'frontBumper'},
  {id:'rearBumper',group:'EXTERIOR',label:'Bumper spate',type:'modlist',dataKey:'rearBumpers',modType:'rearBumper'},
  {id:'sideSkirt',group:'EXTERIOR',label:'Skirts',type:'modlist',dataKey:'sideSkirts',modType:'sideSkirt'},
  {id:'exhaust',group:'EXTERIOR',label:'Exhaust',type:'modlist',dataKey:'exhaustMods',modType:'exhaust'},
  {id:'engine',group:'PERFORMANCE',label:'Engine',type:'performance',perfKey:'engine',maxKey:'numEngineMods'},
  {id:'brakes',group:'PERFORMANCE',label:'Brakes',type:'performance',perfKey:'brakes',maxKey:'numBrakeMods'},
  {id:'transmission',group:'PERFORMANCE',label:'Transmission',type:'performance',perfKey:'transmission',maxKey:'numTransmissionMods'},
  {id:'suspension',group:'PERFORMANCE',label:'Suspension',type:'performance',perfKey:'suspension',maxKey:'numSuspensionMods'},
  {id:'armor',group:'PERFORMANCE',label:'Armor',type:'performance',perfKey:'armor',maxKey:'numArmorMods'},
  {id:'wheels',group:'WHEELS',label:'Rims',type:'wheels'},
  {id:'grille',group:'EXTERIOR',label:'Grille',type:'modlist',dataKey:'grilleMods',modType:'grille'},
  {id:'roof',group:'EXTERIOR',label:'Roof',type:'modlist',dataKey:'roofMods',modType:'roof'},
  {id:'frame',group:'EXTERIOR',label:'Frame',type:'modlist',dataKey:'frameMods',modType:'frame'},
  {id:'leftFender',group:'EXTERIOR',label:'Left Fender',type:'modlist',dataKey:'leftFenderMods',modType:'leftFender'},
  {id:'rightFender',group:'EXTERIOR',label:'Right Fender',type:'modlist',dataKey:'rightFenderMods',modType:'rightFender'},
  {id:'primaryColor',group:'PAINT',label:'Primary Color',type:'color',colorKey:'selectedPrimary',applyType:'primaryColor'},
  {id:'secondaryColor',group:'PAINT',label:'Secondary Color',type:'color',colorKey:'selectedSecondary',applyType:'secondaryColor'},
  {id:'pearlColor',group:'PAINT',label:'Pearl',type:'color',colorKey:'selectedPearl',applyType:'pearlColor'},
  {id:'wheelColor',group:'PAINT',label:'Wheel Color',type:'color',colorKey:'selectedWheelColor',applyType:'wheelColor'},
  {id:'neon',group:'PAINT',label:'Neon',type:'neon'},
  {id:'seats',group:'INTERIOR',label:'Seats',type:'modlist',dataKey:'seatMods',modType:'seats'},
  {id:'steeringWheel',group:'INTERIOR',label:'Steering Wheel',type:'modlist',dataKey:'steeringMods',modType:'steeringWheel'},
  {id:'horn',group:'INTERIOR',label:'Horn',type:'modlist',dataKey:'hornMods',modType:'horn'},
  {id:'windowTint',group:'OTHER',label:'Window Tint',type:'tint'},
  {id:'plateStyle',group:'OTHER',label:'Plate Style',type:'plate'},
  {id:'livery',group:'OTHER',label:'Livery',type:'modlist',dataKey:'liveryMods',modType:'livery'},
  {id:'xenon',group:'EXTRAS',label:'Xenon Lights',type:'toggle',toggleKey:'xenon'},
  {id:'turbo',group:'EXTRAS',label:'Turbo',type:'toggle',toggleKey:'turbo'},
];

var GROUP_ORDER = ['PERFORMANCE','WHEELS','EXTERIOR','PAINT','INTERIOR','OTHER','EXTRAS'];

/* ── State ── */
var state = {
  data: null, cash: 0, card: 0,
  activeCat: null,
  selectedPrimary: 0, selectedSecondary: 0, selectedPearl: 0, selectedWheelColor: 0,
  selectedTint: 0, selectedPlate: 0,
  selectedWheelType: 0, selectedFrontWheel: -1, selectedBackWheel: -1,
  xenon: false, turbo: false,
  engine: -1, brakes: -1, transmission: -1, suspension: -1, armor: -1,
  neonEnabled: [false,false,false,false], neonColor: {r:255,g:0,b:0},
  pricePerMod: 500,
  initial: {},
  exteriorSelections: {},
};

/* ── NUI Communication ── */
function sendNUI(name, payload) {
  fetch('https://apex_tuning/' + name, {
    method: 'POST', headers: {'Content-Type':'application/json'},
    body: JSON.stringify(payload || {})
  }).catch(function(){});
}

function applyMod(type, value, extra) {
  var p = {type:type, value:value};
  if (extra) { if (extra.pos !== undefined) p.pos = extra.pos; if (extra.r !== undefined) { p.r=extra.r; p.g=extra.g; p.b=extra.b; } }
  sendNUI('applyMod', p);
}

/* ── Helpers ── */
function formatPrice(n) { return '$ ' + Number(n).toLocaleString(); }

function getEquippedId(modList) {
  if (!modList) return -1;
  for (var i = 0; i < modList.length; i++) { if (modList[i].equipped) return modList[i].id; }
  return -1;
}

function getCatDef(catId) {
  for (var i = 0; i < CATEGORIES.length; i++) { if (CATEGORIES[i].id === catId) return CATEGORIES[i]; }
  return null;
}

function getModCount(cat) {
  var d = state.data; if (!d) return 0;
  if (cat.type === 'modlist') return (d[cat.dataKey] || []).length;
  if (cat.type === 'performance') return d[cat.maxKey] || 0;
  if (cat.type === 'wheels') return Math.max(d.numFrontWheels||0, d.numBackWheels||0);
  if (cat.type === 'color') return GTA_COLORS.length;
  if (cat.type === 'tint') return (d.windowTints||[]).length;
  if (cat.type === 'plate') return (d.plateStyles||[]).length;
  if (cat.type === 'neon') return NEON_COLORS.length;
  if (cat.type === 'toggle') return 1;
  return 0;
}

function getCatStatus(cat) {
  var d = state.data; if (!d) return '';
  if (cat.type === 'performance') {
    var cur = state[cat.perfKey]; var max = d[cat.maxKey] || 0;
    if (cur === -1) return 'Stock';
    return 'Stage ' + (cur+1) + '/' + max;
  }
  if (cat.type === 'toggle') return state[cat.toggleKey] ? 'ON' : 'OFF';
  if (cat.type === 'modlist') {
    var count = (d[cat.dataKey]||[]).length;
    return count > 1 ? (count-1) + ' opts' : 'Stock';
  }
  if (cat.type === 'wheels') return (d.wheelCategories||{})[state.selectedWheelType] || '';
  return '';
}

/* ── Initialize State from Vehicle Data ── */
function initStateFromData() {
  var d = state.data; if (!d) return;
  state.selectedPrimary = d.primaryColor;
  state.selectedSecondary = d.secondaryColor;
  state.selectedPearl = d.pearlColor;
  state.selectedWheelColor = d.wheelColor;
  state.selectedTint = d.windowTint;
  state.selectedPlate = d.plateStyle;
  state.selectedWheelType = d.wheelType;
  state.selectedFrontWheel = d.frontWheelMod;
  state.selectedBackWheel = d.backWheelMod;
  state.xenon = !!d.xenon;
  state.turbo = !!d.turbo;
  state.engine = d.engine;
  state.brakes = d.brakes;
  state.transmission = d.transmission;
  state.suspension = d.suspension;
  state.armor = d.armor;
  state.neonEnabled = d.neonEnabled ? d.neonEnabled.slice() : [false,false,false,false];
  state.neonColor = d.neonColor ? {r:d.neonColor.r,g:d.neonColor.g,b:d.neonColor.b} : {r:255,g:0,b:0};

  // Save initial state for price tracking
  state.initial = {
    engine:d.engine, brakes:d.brakes, transmission:d.transmission,
    suspension:d.suspension, armor:d.armor,
    xenon:!!d.xenon, turbo:!!d.turbo,
    primaryColor:d.primaryColor, secondaryColor:d.secondaryColor,
    pearlColor:d.pearlColor, wheelColor:d.wheelColor,
    windowTint:d.windowTint, plateStyle:d.plateStyle,
    wheelType:d.wheelType, frontWheel:d.frontWheelMod, backWheel:d.backWheelMod,
  };

  // Track initial exterior mod selections
  state.exteriorSelections = {};
  CATEGORIES.forEach(function(cat) {
    if (cat.type === 'modlist') {
      var eqId = getEquippedId(d[cat.dataKey]);
      state.exteriorSelections[cat.id] = eqId;
      state.initial[cat.id] = eqId;
    }
  });
}

/* ── Count Price Changes ── */
function countChanges() {
  var n = 0, ini = state.initial;
  if (state.engine !== ini.engine) n++;
  if (state.brakes !== ini.brakes) n++;
  if (state.transmission !== ini.transmission) n++;
  if (state.suspension !== ini.suspension) n++;
  if (state.armor !== ini.armor) n++;
  if (state.xenon !== ini.xenon) n++;
  if (state.turbo !== ini.turbo) n++;
  if (state.selectedPrimary !== ini.primaryColor) n++;
  if (state.selectedSecondary !== ini.secondaryColor) n++;
  if (state.selectedPearl !== ini.pearlColor) n++;
  if (state.selectedWheelColor !== ini.wheelColor) n++;
  if (state.selectedTint !== ini.windowTint) n++;
  if (state.selectedPlate !== ini.plateStyle) n++;
  if (state.selectedWheelType !== ini.wheelType) n++;
  if (state.selectedFrontWheel !== ini.frontWheel) n++;
  CATEGORIES.forEach(function(cat) {
    if (cat.type === 'modlist' && state.exteriorSelections[cat.id] !== ini[cat.id]) n++;
  });
  return n;
}

function updateTotal() {
  var total = countChanges() * state.pricePerMod;
  var el = document.getElementById('totalPrice');
  if (el) el.textContent = formatPrice(total);
}

/* ── HP, km/h și clasă impozit din vehicle.lua + modificări motor/frane/turbo ── */
function computeEffectiveStats() {
  var d = state.data; if (!d) return { hp: 0, speed: 0, tax: 1 };
  var baseHp = Number(d.baseHp) || 100;
  var baseSpeed = Number(d.baseSpeed) || 200;
  var numE = d.numEngineMods || 0, numB = d.numBrakeMods || 0, numT = d.numTransmissionMods || 0, numS = d.numSuspensionMods || 0;
  var engineStage = state.engine < 0 ? 0 : state.engine + 1;
  var brakeStage = state.brakes < 0 ? 0 : state.brakes + 1;
  var transStage = state.transmission < 0 ? 0 : state.transmission + 1;
  var hpBonus = engineStage * 20 + brakeStage * 5 + (state.turbo ? 50 : 0);
  var speedBonus = engineStage * 2 + transStage * 1 + (state.turbo ? 5 : 0);
  var effectiveHp = baseHp + hpBonus;
  var effectiveSpeed = baseSpeed + speedBonus;
  var power = 0;
  if (numE > 0) power += Math.floor(((state.engine + 1) / numE) * 25);
  if (numB > 0) power += Math.floor(((state.brakes + 1) / numB) * 20);
  if (numT > 0) power += Math.floor(((state.transmission + 1) / numT) * 25);
  if (numS > 0) power += Math.floor(((state.suspension + 1) / numS) * 15);
  if (state.turbo) power += 15;
  power = Math.min(100, power);
  var tax = Math.max(1, Math.min(5, Math.floor(power / 20) + 1));
  return { hp: effectiveHp, speed: effectiveSpeed, tax: tax };
}

function updateVehicleStatsDisplay() {
  var v = computeEffectiveStats();
  var elHp = document.getElementById('vehicleHp');
  var elSpeed = document.getElementById('vehicleSpeed');
  var elTax = document.getElementById('taxClass');
  if (elHp) elHp.textContent = Math.round(v.hp);
  if (elSpeed) elSpeed.textContent = Math.round(v.speed);
  if (elTax) elTax.textContent = v.tax;
}

/* ── Left Panel: Category List (show all for custom vehicles; right shows "No options" when 0) ── */
function renderLeftPanel() {
  var el = document.getElementById('leftList');
  if (!el || !state.data) return;
  el.innerHTML = '';
  var lastGroup = '';

  CATEGORIES.forEach(function(cat) {
    var count = getModCount(cat);
    if (cat.type === 'performance' && (state.data[cat.maxKey] || 0) === 0) return;

    /* Toate părțile exterior (spoiler, capotă, bumper, lip/skirts, evacuare, etc.) apar în stânga și dreapta */

    // Group header
    if (cat.group !== lastGroup) {
      lastGroup = cat.group;
      var gh = document.createElement('div');
      gh.className = 'cat-group-label';
      gh.textContent = cat.group;
      el.appendChild(gh);
    }

    var div = document.createElement('div');
    div.className = 'cat-item' + (state.activeCat === cat.id ? ' active' : '');
    var statusText = getCatStatus(cat);
    var badge = '';
    if (cat.type === 'modlist') {
      var c = (state.data[cat.dataKey]||[]).length;
      badge = c > 1 ? (c-1) + ' items' : '';
    } else if (cat.type === 'toggle') {
      badge = state[cat.toggleKey] ? 'ON' : 'OFF';
    }

    var iconChar = getIconForCat(cat);
    div.innerHTML = '<div class="cat-item-icon">' + iconChar + '</div>' +
      '<div class="cat-item-body"><div class="cat-item-label cat-item-label-uc">' + cat.label + '</div>' +
      (statusText ? '<div class="cat-item-sub">' + statusText + '</div>' : '') +
      '</div>' +
      (badge ? '<span class="cat-item-badge">' + badge + '</span>' : '') +
      '<div class="cat-item-underline"></div>';

    div.addEventListener('click', (function(c) {
      return function() {
        state.activeCat = c.id;
        renderLeftPanel();
        renderRightPanel();
      };
    })(cat));

    el.appendChild(div);
  });
}

function getIconForCat(cat) {
  var icons = {
    engine:'\u26A1', brakes:'\u29BF', transmission:'\u2699', suspension:'\u2261',
    armor:'\u26CA', wheels:'\u25CE', spoiler:'\u25B2', hood:'\u25A0',
    frontBumper:'\u25AC', rearBumper:'\u25AC', sideSkirt:'\u2502', exhaust:'\u2248',
    grille:'\u25A6', roof:'\u2302', frame:'\u25A1', leftFender:'\u25C2', rightFender:'\u25B8',
    primaryColor:'\u25CF', secondaryColor:'\u25CF', pearlColor:'\u2726', wheelColor:'\u25CE',
    neon:'\u2600', seats:'\u25A3', steeringWheel:'\u25CE', horn:'\u266B',
    windowTint:'\u25A8', plateStyle:'\u25AD', livery:'\u2691',
    xenon:'\u2600', turbo:'\u2B06',
  };
  return icons[cat.id] || '\u25CF';
}

/* ── Right Panel: Options for Selected Category ── */
function renderRightPanel() {
  var titleEl = document.getElementById('rightTitle');
  var subEl = document.getElementById('rightSubTabs');
  var listEl = document.getElementById('rightList');
  if (!titleEl || !subEl || !listEl || !state.data) return;

  subEl.innerHTML = '';
  listEl.innerHTML = '';

  var cat = getCatDef(state.activeCat);
  if (!cat) {
    titleEl.innerHTML = 'Select a <span class="accent">Part</span>';
    listEl.innerHTML = '<p class="empty-msg">Choose a category from the left panel</p>';
    return;
  }

  titleEl.innerHTML = cat.label + ' <span class="accent">Options</span>';

  if (cat.type === 'performance') renderPerfOptions(cat, listEl);
  else if (cat.type === 'modlist') renderModlistOptions(cat, listEl);
  else if (cat.type === 'wheels') renderWheelOptions(cat, subEl, listEl);
  else if (cat.type === 'color') renderColorOptions(cat, listEl);
  else if (cat.type === 'neon') renderNeonOptions(listEl);
  else if (cat.type === 'tint') renderTintOptions(listEl);
  else if (cat.type === 'plate') renderPlateOptions(listEl);
  else if (cat.type === 'toggle') renderToggleOptions(cat, listEl);
}

function renderPerfOptions(cat, listEl) {
  var d = state.data;
  var max = d[cat.maxKey] || 0;
  var current = state[cat.perfKey];

  for (var i = -1; i < max; i++) {
    var name = i === -1 ? 'Stock' : 'Stage ' + (i+1);
    var eq = current === i;
    var div = document.createElement('div');
    div.className = 'mod-item' + (eq ? ' equipped' : '');
    div.innerHTML = '<div class="mod-item-icon">' + (i === -1 ? '\u2212' : (i+1)) + '</div>' +
      '<div class="mod-item-body"><div class="mod-item-name">' + name + '</div>' +
      '<div class="mod-item-desc">' + (i === -1 ? 'Factory default' : 'Upgrade level ' + (i+1)) + '</div></div>' +
      (eq ? '<span class="mod-item-equipped">Equipped</span>' : '<span class="mod-item-price">' + formatPrice(state.pricePerMod) + '</span>');
    div.addEventListener('click', (function(level, key) {
      return function() {
        state[key] = level;
        applyMod(key, level);
        renderRightPanel();
        renderLeftPanel();
        renderBottomBar();
        updateTotal();
        updateVehicleStatsDisplay();
      };
    })(i, cat.perfKey));
    listEl.appendChild(div);
  }
  if (max === 0) listEl.innerHTML = '<p class="empty-msg">No upgrades available for this vehicle</p>';
}

function renderModlistOptions(cat, listEl) {
  var d = state.data;
  var mods = d[cat.dataKey] || [];
  if (mods.length === 0) { listEl.innerHTML = '<p class="empty-msg">Nicio opțiune pentru acest vehicul</p>'; return; }

  var currentSel = state.exteriorSelections[cat.id];
  if (currentSel === undefined) currentSel = getEquippedId(mods);
  mods.forEach(function(item) {
    var eq = item.id === currentSel;
    var div = document.createElement('div');
    div.className = 'mod-item' + (eq ? ' equipped' : '');
    div.innerHTML = '<div class="mod-item-icon">' + (item.id === -1 ? '\u2212' : (item.id+1)) + '</div>' +
      '<div class="mod-item-body"><div class="mod-item-name">' + (item.name || 'Option ' + (item.id+1)) + '</div></div>' +
      (eq ? '<span class="mod-item-equipped">Equipped</span>' : '<span class="mod-item-price">' + formatPrice(state.pricePerMod) + '</span>');
    div.addEventListener('click', (function(modId) {
      return function() {
        state.exteriorSelections[cat.id] = modId;
        applyMod(cat.modType, modId);
        renderRightPanel();
        updateTotal();
      };
    })(item.id));
    listEl.appendChild(div);
  });
}

function renderWheelOptions(cat, subEl, listEl) {
  var d = state.data;
  var wheelCats = d.wheelCategories || {};

  Object.keys(wheelCats).forEach(function(id) {
    var btn = document.createElement('button');
    btn.className = 'subtab-btn' + (state.selectedWheelType === parseInt(id) ? ' active' : '');
    btn.textContent = wheelCats[id];
    btn.addEventListener('click', function() {
      state.selectedWheelType = parseInt(id);
      applyMod('wheelType', state.selectedWheelType);
      renderRightPanel();
      renderLeftPanel();
      updateTotal();
    });
    subEl.appendChild(btn);
  });

  var counts = d.wheelCountByType && d.wheelCountByType[state.selectedWheelType];
  var n = counts ? Math.max(counts.front||0, counts.back||0) : Math.max(d.numFrontWheels||0, d.numBackWheels||0);
  var names = (d.wheelNamesByType && d.wheelNamesByType[state.selectedWheelType]) || {};

  for (var w = -1; w < n; w++) {
    var name = w === -1 ? 'Stock' : (names[w] || 'Rim ' + (w+1));
    var eq = state.selectedFrontWheel === w;
    var div = document.createElement('div');
    div.className = 'mod-item' + (eq ? ' equipped' : '');
    div.innerHTML = '<div class="mod-item-icon">\u25CE</div>' +
      '<div class="mod-item-body"><div class="mod-item-name">' + name + '</div></div>' +
      (eq ? '<span class="mod-item-equipped">Equipped</span>' : '<span class="mod-item-price">' + formatPrice(state.pricePerMod) + '</span>');
    div.addEventListener('click', (function(wi) {
      return function() {
        state.selectedFrontWheel = wi;
        state.selectedBackWheel = wi;
        applyMod('frontWheel', wi);
        applyMod('backWheel', wi);
        renderRightPanel();
        updateTotal();
      };
    })(w));
    listEl.appendChild(div);
  }
  if (n <= 0) listEl.innerHTML = '<p class="empty-msg">No rims available for this type</p>';
}

function renderColorOptions(cat, listEl) {
  var currentId = state[cat.colorKey];
  var grid = document.createElement('div');
  grid.className = 'color-grid';
  GTA_COLORS.forEach(function(c) {
    var dot = document.createElement('div');
    dot.className = 'color-dot' + (currentId === c.id ? ' selected' : '');
    dot.style.backgroundColor = c.hex;
    dot.title = c.name;
    dot.addEventListener('click', function() {
      state[cat.colorKey] = c.id;
      applyMod(cat.applyType, c.id);
      renderRightPanel();
      updateTotal();
    });
    grid.appendChild(dot);
  });
  listEl.appendChild(grid);
}

function renderNeonOptions(listEl) {
  var positions = ['Left','Right','Front','Back'];
  var header = document.createElement('div');
  header.className = 'color-section-label';
  header.textContent = 'NEON POSITIONS';
  listEl.appendChild(header);

  for (var i = 0; i < 4; i++) {
    var row = document.createElement('div');
    row.className = 'neon-row';
    var isOn = state.neonEnabled[i];
    row.innerHTML = '<span class="neon-label">' + positions[i] + '</span>' +
      '<div class="neon-toggle ' + (isOn ? 'on' : '') + '"><div class="neon-toggle-dot"></div></div>';
    row.addEventListener('click', (function(pos) {
      return function() {
        state.neonEnabled[pos] = !state.neonEnabled[pos];
        applyMod('neonToggle', state.neonEnabled[pos] ? 1 : 0, {pos:pos});
        renderRightPanel();
        updateTotal();
      };
    })(i));
    listEl.appendChild(row);
  }

  var colorHeader = document.createElement('div');
  colorHeader.className = 'color-section-label';
  colorHeader.textContent = 'NEON COLOR';
  colorHeader.style.marginTop = '12px';
  listEl.appendChild(colorHeader);

  var grid = document.createElement('div');
  grid.className = 'color-grid';
  NEON_COLORS.forEach(function(c) {
    var dot = document.createElement('div');
    dot.className = 'color-dot';
    dot.style.backgroundColor = c.hex;
    dot.title = c.name;
    if (state.neonColor.r === c.r && state.neonColor.g === c.g && state.neonColor.b === c.b) dot.classList.add('selected');
    dot.addEventListener('click', function() {
      state.neonColor = {r:c.r, g:c.g, b:c.b};
      applyMod('neonColor', 0, {r:c.r, g:c.g, b:c.b});
      renderRightPanel();
    });
    grid.appendChild(dot);
  });
  listEl.appendChild(grid);
}

function renderTintOptions(listEl) {
  var tints = state.data.windowTints || [];
  tints.forEach(function(t) {
    var eq = state.selectedTint === t.id;
    var div = document.createElement('div');
    div.className = 'mod-item' + (eq ? ' equipped' : '');
    div.innerHTML = '<div class="mod-item-icon">\u25A8</div>' +
      '<div class="mod-item-body"><div class="mod-item-name">' + (t.name||'Tint '+t.id) + '</div></div>' +
      (eq ? '<span class="mod-item-equipped">Equipped</span>' : '<span class="mod-item-price">' + formatPrice(state.pricePerMod) + '</span>');
    div.addEventListener('click', function() {
      state.selectedTint = t.id;
      applyMod('windowTint', t.id);
      renderRightPanel();
      updateTotal();
    });
    listEl.appendChild(div);
  });
}

function renderPlateOptions(listEl) {
  var plates = state.data.plateStyles || [];
  plates.forEach(function(p) {
    var eq = state.selectedPlate === p.id;
    var div = document.createElement('div');
    div.className = 'mod-item' + (eq ? ' equipped' : '');
    div.innerHTML = '<div class="mod-item-icon">\u25AD</div>' +
      '<div class="mod-item-body"><div class="mod-item-name">' + (p.name||'Plate '+p.id) + '</div></div>' +
      (eq ? '<span class="mod-item-equipped">Equipped</span>' : '<span class="mod-item-price">' + formatPrice(state.pricePerMod) + '</span>');
    div.addEventListener('click', function() {
      state.selectedPlate = p.id;
      applyMod('plateStyle', p.id);
      renderRightPanel();
      updateTotal();
    });
    listEl.appendChild(div);
  });
}

function renderToggleOptions(cat, listEl) {
  var isOn = state[cat.toggleKey];
  var div = document.createElement('div');
  div.className = 'toggle-item ' + (isOn ? 'on' : '');
  div.innerHTML = '<span class="toggle-label">' + cat.label + '</span>' +
    '<span class="toggle-pill ' + (isOn ? 'on' : 'off') + '">' + (isOn ? 'ON' : 'OFF') + '</span>';
  div.addEventListener('click', function() {
    state[cat.toggleKey] = !state[cat.toggleKey];
    applyMod(cat.toggleKey, state[cat.toggleKey] ? 1 : 0);
    renderRightPanel();
    renderLeftPanel();
    renderBottomBar();
    updateTotal();
  });
  listEl.appendChild(div);
}

/* ── Bottom Bar: Performance Bars + Money ── */
function renderBottomBar() {
  var container = document.getElementById('bottomPerf');
  if (!container || !state.data) return;
  container.innerHTML = '';
  var d = state.data;

  var perfItems = [
    {key:'engine',label:'Engine',max:d.numEngineMods||0},
    {key:'brakes',label:'Brakes',max:d.numBrakeMods||0},
    {key:'transmission',label:'Trans.',max:d.numTransmissionMods||0},
    {key:'suspension',label:'Susp.',max:d.numSuspensionMods||0},
  ];

  perfItems.forEach(function(p) {
    if (p.max === 0) return;
    var cur = state[p.key];
    var pct = cur === -1 ? 0 : Math.round(((cur+1) / p.max) * 100);
    var stageText = cur === -1 ? 'Stock' : 'Stage ' + (cur+1) + '/' + p.max;

    var item = document.createElement('div');
    item.className = 'perf-item';
    item.innerHTML = '<div class="perf-top"><span class="perf-icon">\u25CF</span><span class="perf-label">' + p.label + '</span></div>' +
      '<div class="perf-bar"><div class="perf-bar-fill ' + (cur === -1 ? 'stock' : '') + '" style="width:' + (cur === -1 ? 5 : pct) + '%"></div></div>' +
      '<div class="perf-stage">' + stageText + '</div>';
    item.addEventListener('click', (function(key) {
      return function() {
        state.activeCat = key;
        renderLeftPanel();
        renderRightPanel();
      };
    })(p.key));
    container.appendChild(item);
  });

  // Turbo & Xenon toggles in bottom bar
  var toggles = [{key:'turbo',label:'Turbo'},{key:'xenon',label:'Xenon'}];
  toggles.forEach(function(t) {
    var isOn = state[t.key];
    var pill = document.createElement('div');
    pill.className = 'perf-toggle';
    pill.innerHTML = '<span class="perf-toggle-label">' + t.label + '</span>' +
      '<span class="perf-toggle-pill ' + (isOn ? 'on' : 'off') + '">' + (isOn ? 'ON' : 'OFF') + '</span>';
    pill.addEventListener('click', (function(tk) {
      return function() {
        state[tk] = !state[tk];
        applyMod(tk, state[tk] ? 1 : 0);
        renderBottomBar();
        if (state.activeCat === tk) renderRightPanel();
        renderLeftPanel();
        updateTotal();
        updateVehicleStatsDisplay();
      };
    })(t.key));
    container.appendChild(pill);
  });

  updateVehicleStatsDisplay();
}

/* ── Build Apply-All Payload ── */
function buildApplyAllPayload() {
  var mods = [
    {type:'primaryColor', value:state.selectedPrimary},
    {type:'secondaryColor', value:state.selectedSecondary},
    {type:'pearlColor', value:state.selectedPearl},
    {type:'wheelColor', value:state.selectedWheelColor},
    {type:'windowTint', value:state.selectedTint},
    {type:'plateStyle', value:state.selectedPlate},
    {type:'wheelType', value:state.selectedWheelType},
    {type:'frontWheel', value:state.selectedFrontWheel},
    {type:'backWheel', value:state.selectedBackWheel},
    {type:'xenon', value:state.xenon ? 1 : 0},
    {type:'turbo', value:state.turbo ? 1 : 0},
    {type:'engine', value:state.engine},
    {type:'brakes', value:state.brakes},
    {type:'transmission', value:state.transmission},
    {type:'suspension', value:state.suspension},
    {type:'armor', value:state.armor},
  ];
  // Add exterior selections
  CATEGORIES.forEach(function(cat) {
    if (cat.type === 'modlist' && state.exteriorSelections[cat.id] !== undefined) {
      mods.push({type:cat.modType, value:state.exteriorSelections[cat.id]});
    }
  });
  return mods;
}

/* ── Message Handling ── */
window.addEventListener('message', function(e) {
  var msg = e.data;
  if (msg.type === 'open' && msg.data) {
    state.data = msg.data;
    state.cash = msg.cash || 0;
    state.card = msg.card || 0;
    initStateFromData();
    state.activeCat = 'engine';
    var firstVisible = null;
    CATEGORIES.forEach(function(cat) {
      if (firstVisible) return;
      var count = getModCount(cat);
      if (cat.type === 'modlist' && count <= 1 && cat.id !== 'livery') return;
      if (cat.type === 'performance' && (state.data[cat.maxKey] || 0) === 0) return;
      firstVisible = cat.id;
    });
    if (firstVisible) state.activeCat = firstVisible;

    var vn = document.getElementById('vehicleName');
    if (vn) vn.textContent = state.data.name || '—';
    var pc = document.getElementById('playerCash');
    if (pc) pc.textContent = formatPrice(state.cash);
    var pcard = document.getElementById('playerCard');
    if (pcard) pcard.textContent = formatPrice(state.card);

    renderLeftPanel();
    renderRightPanel();
    renderBottomBar();
    updateTotal();
    updateVehicleStatsDisplay();
    document.getElementById('app').classList.add('visible');
  } else if (msg.type === 'updateMoney') {
    state.cash = msg.cash || 0;
    state.card = msg.card || 0;
    var pc = document.getElementById('playerCash');
    if (pc) pc.textContent = formatPrice(state.cash);
    var pcard = document.getElementById('playerCard');
    if (pcard) pcard.textContent = formatPrice(state.card);
  } else if (msg.type === 'close') {
    document.getElementById('app').classList.remove('visible');
  }
});

/* ── Event Listeners ── */
function closeMenu() {
  document.getElementById('app').classList.remove('visible');
  sendNUI('close', {});
}

document.getElementById('closeBtn').addEventListener('click', closeMenu);

document.getElementById('buyBtn').addEventListener('click', function() {
  var mods = buildApplyAllPayload();
  var total = countChanges() * state.pricePerMod;
  sendNUI('applyAllMods', {mods:mods});
  sendNUI('buy', {total:total});
  closeMenu();
});

/* Rotire mașină cu mouse-ul (click stânga ținut + drag pe zona liberă) */
var rotateActive = false;

document.addEventListener('contextmenu', function(e) {
  var app = document.getElementById('app');
  if (app && app.classList.contains('visible')) {
    e.preventDefault();
  }
});

document.addEventListener('mousedown', function(e) {
  var app = document.getElementById('app');
  if (!app || !app.classList.contains('visible')) return;
  // button 0 = click stânga
  if (e.button !== 0) return;
  // Nu roti când interacționezi cu UI (panouri/butoane/opțiuni)
  var t = e.target;
  if (t && t.closest && t.closest('#leftPanel, #rightPanel, .bottom-bar, button, input, select, textarea, .mod-item, .cat-item, .subtab-btn, .color-dot, .toggle-item')) {
    rotateActive = false;
    return;
  }
  rotateActive = true;
  e.preventDefault();
});

document.addEventListener('mouseup', function(e) {
  if (e.button === 0) {
    rotateActive = false;
  }
});

document.addEventListener('mousemove', function(e) {
  var app = document.getElementById('app');
  if (!app || !app.classList.contains('visible')) return;
  if (!rotateActive) return;
  var dx = e.movementX != null ? e.movementX : 0;
  var dy = e.movementY != null ? e.movementY : 0;
  if (dx !== 0 || dy !== 0) {
    sendNUI('mouseMove', { dx: dx, dy: dy });
  }
});
