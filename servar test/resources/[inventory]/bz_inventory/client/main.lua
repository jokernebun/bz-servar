-- ============================================================
-- BZ Inventory - Client
-- ============================================================

local invOpen    = false
local invItems   = {}
local useActions = {}  -- item name -> function

-- ============================================================
-- TOGGLE INVENTAR (F2)
-- ============================================================
AddEventHandler('bz:inventory:toggle', function()
    if not BZ.Loaded then return end
    if invOpen then
        CloseInventory()
    else
        OpenInventory()
    end
end)

function OpenInventory()
    TriggerServerEvent('bz:inventory:load')
end

function CloseInventory()
    invOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- ============================================================
-- PRIMESTE INVENTARUL DE LA SERVER
-- ============================================================
RegisterNetEvent('bz:inventory:receive', function(items)
    invItems = items
    invOpen  = true
    SetNuiFocus(true, true)

    -- Construieste lista cu informatii complete despre iteme
    local uiItems = {}
    for _, slot in ipairs(items) do
        local info = BZ.Items[slot.item] or { label = slot.item, weight = 0, description = '' }
        table.insert(uiItems, {
            slot        = slot.slot,
            name        = slot.item,
            label       = info.label,
            count       = slot.count,
            weight      = info.weight,
            description = info.description or '',
            usable      = info.usable or false,
            illegal     = info.illegal or false,
        })
    end

    local totalWeight = 0
    for _, s in ipairs(uiItems) do
        totalWeight = totalWeight + (s.weight * s.count)
    end

    SendNUIMessage({
        action    = 'open',
        items     = uiItems,
        maxWeight = 30000,  -- 30kg
        weight    = totalWeight,
        charName  = BZ.PlayerData.name or '',
    })
end)

-- ============================================================
-- NUI CALLBACKS
-- ============================================================

-- Foloseste un item
RegisterNUICallback('useItem', function(data, cb)
    cb('ok')
    local itemName = data.name
    if useActions[itemName] then
        useActions[itemName]()
    else
        TriggerServerEvent('bz:inventory:use', itemName)
    end
end)

-- Arunca item
RegisterNUICallback('dropItem', function(data, cb)
    cb('ok')
    TriggerServerEvent('bz:inventory:drop', data.name, tonumber(data.count))
end)

-- Inchide
RegisterNUICallback('closeInventory', function(_, cb)
    cb('ok')
    CloseInventory()
end)

-- ESC
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if invOpen and IsControlJustPressed(0, 322) then  -- ESC
            CloseInventory()
        end
    end
end)

-- ============================================================
-- INREGISTRARE ITEME USABLE (din alte resurse)
-- ============================================================

--- Inregistreaza o functie pentru un item usable
---@param itemName string
---@param cb function
function BZ.RegisterUsable(itemName, cb)
    useActions[itemName] = cb
end
exports('RegisterUsable', BZ.RegisterUsable)

-- ============================================================
-- ITEME IMPLICITE
-- ============================================================

-- Bandaj
BZ.RegisterUsable('bandage', function()
    local ped = PlayerPedId()
    local hp  = GetEntityHealth(ped)
    if hp < 200 then
        BZ.ProgressBar('Aplici bandajul...', 3000, function(ok)
            if ok then
                SetEntityHealth(ped, math.min(200, hp + 20))
                TriggerServerEvent('bz:inventory:use', 'bandage')
                TriggerEvent('bz:notifications:show', '+20 HP', 'success')
            end
        end)
    else
        TriggerEvent('bz:notifications:show', 'Esti deja sanatos!', 'warning')
    end
end)

-- Trusa prim ajutor
BZ.RegisterUsable('firstaid', function()
    local ped = PlayerPedId()
    BZ.ProgressBar('Aplici trusa de prim ajutor...', 5000, function(ok)
        if ok then
            SetEntityHealth(ped, 200)
            SetPedArmour(ped, 0)
            TriggerServerEvent('bz:inventory:use', 'firstaid')
            TriggerEvent('bz:notifications:show', 'HP refacut complet!', 'success')
        end
    end)
end)

-- Apa
BZ.RegisterUsable('water', function()
    TriggerServerEvent('bz:inventory:use', 'water')
    TriggerEvent('bz:notifications:show', 'Ai baut apa. Refreshing!', 'success')
end)

-- Mancare
BZ.RegisterUsable('bread', function()
    TriggerServerEvent('bz:inventory:use', 'bread')
    TriggerEvent('bz:notifications:show', 'Ai mancat o franzela.', 'success')
end)

BZ.RegisterUsable('sandwich', function()
    TriggerServerEvent('bz:inventory:use', 'sandwich')
    TriggerEvent('bz:notifications:show', 'Sandwich delicios!', 'success')
end)

BZ.RegisterUsable('coffee', function()
    TriggerServerEvent('bz:inventory:use', 'coffee')
    TriggerEvent('bz:notifications:show', 'Cafea buna dimineata!', 'success')
end)

-- Buletin
BZ.RegisterUsable('id_card', function()
    local p = BZ.PlayerData
    TriggerEvent('bz:menu:openInfo', {
        title = 'Carte de Identitate',
        rows  = {
            { label = 'Nume',    value = p.name or 'Necunoscut' },
            { label = 'Job',     value = p.job  or 'Somer' },
            { label = 'Cetatenie', value = 'Romana' },
        },
    })
end)

-- Permis auto
BZ.RegisterUsable('drivers_license', function()
    local p = BZ.PlayerData
    TriggerEvent('bz:menu:openInfo', {
        title = 'Permis de Conducere',
        rows  = {
            { label = 'Titular', value = p.name or 'Necunoscut' },
            { label = 'Categorie', value = 'B' },
            { label = 'Status', value = 'Valabil' },
        },
    })
end)
