(function () {
    const container = document.getElementById('garage-container');
    const listEl = document.getElementById('vehicle-list');
    const infoCard = document.getElementById('info-card');
    const infoClass = document.getElementById('info-class');
    const infoName = document.getElementById('info-name');
    const infoFuelPct = document.getElementById('info-fuel-pct');
    const infoFuelBar = document.getElementById('info-fuel-bar');
    const infoEngine = document.getElementById('info-engine');
    const infoBody = document.getElementById('info-body');
    const infoTax = document.getElementById('info-tax');
    const infoCardBg = document.getElementById('info-card-bg');
    const btnClose = document.getElementById('btn-close');

    let state = {
        garageKey: '',
        accessPointIndex: 1,
        vehicles: [],
        garageType: ''
    };

    function getResourceName() {
        if (typeof GetParentResourceName === 'function') return GetParentResourceName();
        var m = window.location.href.match(/\/([^/]+)\/nui/);
        return m ? m[1] : 'garaje';
    }

    /* La fel ca în showroom: nui:// ca imaginile din resource să se încarce */
    var IMAGE_BASE = getResourceName() ? ('nui://' + getResourceName() + '/html/images/vehicles/') : 'images/vehicles/';

    function pct(val, max) {
        if (max == null || max === 0) return 100;
        return Math.min(100, Math.max(0, Math.round((val / max) * 100)));
    }

    function vehicleImagePath(modelName) {
        if (!modelName || typeof modelName !== 'string') return '';
        var slug = (modelName + '').toLowerCase().replace(/\s+/g, '');
        return IMAGE_BASE + slug + '.webp';
    }

    function showDetails(v) {
        if (!v) return;
        const enginePct = pct(v.engineHealth, 1000);
        const bodyPct = pct(v.bodyHealth, 1000);
        const fuelPct = v.fuelLevel != null ? Math.min(100, Math.max(0, Math.round(v.fuelLevel))) : 100;
        const taxDisplay = (v.depotPrice != null && v.depotPrice > 0) ? ('$' + Number(v.depotPrice).toLocaleString()) : '—';

        infoClass.textContent = 'AUTO';
        infoName.textContent = v.label || v.modelName || 'Vehicul';
        infoFuelPct.textContent = fuelPct + '%';
        infoFuelBar.style.width = fuelPct + '%';
        infoEngine.textContent = enginePct + '%';
        infoBody.textContent = bodyPct + '%';
        infoTax.textContent = taxDisplay;
        var imgPath = vehicleImagePath(v.modelName);
        if (imgPath) {
            infoCardBg.style.backgroundImage = "url('" + imgPath + "')";
        } else {
            infoCardBg.style.backgroundImage = 'none';
        }
        infoCard.classList.add('visible');
    }

    function hideDetails() {
        infoCard.classList.remove('visible');
        if (infoCardBg) infoCardBg.style.backgroundImage = 'none';
    }

    function takeOutVehicle(v) {
        const canTakeOut = v.state === 1 || (v.state === 0 && state.garageType === 'depot');
        if (!canTakeOut) return;
        nuiPost('takeOutVehicle', {
            vehicleId: v.id,
            garageName: state.garageKey,
            accessPointIndex: state.accessPointIndex
        });
        hide();
    }

    function renderList() {
        listEl.innerHTML = '';
        state.vehicles.forEach(function (v) {
            const item = document.createElement('div');
            item.className = 'vehicle-item glass';
            item.dataset.id = v.id;
            item.innerHTML =
                '<div class="vehicle-item-inner">' +
                '<div class="vehicle-icon"><i class="fa-solid fa-car"></i></div>' +
                '<div class="vehicle-text">' +
                '<h3>' + (v.label || v.modelName || 'Vehicul').replace(/</g, '&lt;') + '</h3>' +
                '<p class="plate">' + (v.plate || '—') + '</p>' +
                '</div></div>';
            item.addEventListener('mouseenter', function () { showDetails(v); });
            item.addEventListener('mouseleave', hideDetails);
            item.addEventListener('click', function () { takeOutVehicle(v); });
            listEl.appendChild(item);
        });
    }

    function show(data) {
        state.garageKey = data.garageKey || data.garageName || '';
        state.accessPointIndex = data.accessPointIndex != null ? data.accessPointIndex : 1;
        state.vehicles = Array.isArray(data.vehicles) ? data.vehicles : [];
        state.garageType = data.garageType || '';
        container.classList.add('visible');
        hideDetails();
        renderList();
    }

    function hide() {
        container.classList.remove('visible');
        hideDetails();
        state.vehicles = [];
    }

    function nuiPost(endpoint, body) {
        fetch('https://' + getResourceName() + '/' + endpoint, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body || {})
        }).catch(function () {});
    }

    btnClose.addEventListener('click', function () {
        nuiPost('closeGarage', {});
        hide();
    });

    window.addEventListener('message', function (e) {
        var d = e.data;
        if (d.action === 'showGarage') show(d);
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && container.classList.contains('visible')) {
            nuiPost('closeGarage', {});
            hide();
        }
    });
})();
