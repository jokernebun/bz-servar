-- ============================================================
-- BZ Police - Client
-- ============================================================

local onDuty   = false
local cuffed   = false

-- Locatii politie
local POLICE_HQ = { x = 441.0, y = -981.0, z = 30.0 }

-- ============================================================
-- BLIP SECTIE POLITIE
-- ============================================================
CreateThread(function()
    Wait(1000)
    local blip = AddBlipForCoord(POLICE_HQ.x, POLICE_HQ.y, POLICE_HQ.z)
    SetBlipSprite(blip, 60)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Sectia de Politie')
    EndTextCommandSetBlipName(blip)
end)

-- ============================================================
-- MENIU JOB (F6)
-- ============================================================
AddEventHandler('bz:job:openMenu', function()
    if not BZ.IsJob('police') then return end

    BZ.OpenMenu({
        {
            label = onDuty and '🟥 Iesire din serviciu' or '🟩 Intrare in serviciu',
            description = onDuty and 'Inchei tura' or 'Incepi tura',
            cb = function()
                onDuty = not onDuty
                TriggerEvent('bz:notifications:show',
                    onDuty and 'Esti acum in serviciu!' or 'Ai iesit din serviciu.',
                    onDuty and 'success' or 'info')
                TriggerServerEvent('bz:police:setDuty', onDuty)
            end,
        },
        {
            label = '🔫 Armurerie',
            description = 'Ia echipament din armurerie',
            disabled = not onDuty,
            cb = function() OpenArmory() end,
        },
        {
            label = '🚗 Garaj Politie',
            description = 'Acceseaza vehiculele de serviciu',
            disabled = not onDuty,
            cb = function() OpenPoliceGarage() end,
        },
        {
            label = '📋 MDT - Terminal',
            description = 'Cauta persoane si vehicule',
            disabled = not onDuty,
            cb = function() OpenMDT() end,
        },
        {
            label = '📦 Stash Personal',
            description = 'Acceseaza inventarul personal',
            cb = function()
                TriggerServerEvent('bz:inventory:loadStash', 'police_' .. GetPlayerServerId(PlayerId()))
            end,
        },
    }, 'Meniu Politie', BZ.Jobs['police'] and BZ.Jobs['police'].grades[BZ.PlayerData.jobGrade or 0] and BZ.Jobs['police'].grades[BZ.PlayerData.jobGrade].label or '')
end)

-- ============================================================
-- CATUSE
-- ============================================================

-- Pus catuse la jucatorul din apropiere
RegisterCommand('cuff', function()
    if not BZ.IsJob('police') then return end
    if not onDuty then TriggerEvent('bz:notifications:show', 'Nu esti in serviciu!', 'error') return end

    local ped      = PlayerPedId()
    local coords   = GetEntityCoords(ped)
    local nearest  = nil
    local minDist  = 2.5

    for _, pid in ipairs(GetActivePlayers()) do
        local tPed = GetPlayerPed(pid)
        if pid ~= PlayerId() then
            local d = #(coords - GetEntityCoords(tPed))
            if d < minDist then minDist = d nearest = GetPlayerServerId(pid) end
        end
    end

    if nearest then
        TriggerServerEvent('bz:police:cuff', nearest)
    else
        TriggerEvent('bz:notifications:show', 'Nu este nimeni in apropiere!', 'warning')
    end
end, false)

-- ============================================================
-- ARMURERIE
-- ============================================================
function OpenArmory()
    if not BZ.IsJob('police') then return end
    BZ.OpenMenu({
        { label = '🔫 Pistol de serviciu',  description = 'WEAPON_PISTOL',  price=0, cb = function() TriggerServerEvent('bz:police:giveWeapon', 'WEAPON_PISTOL', 100) end },
        { label = '⚡ Taser',               description = 'Imobilizare',    price=0, cb = function() TriggerServerEvent('bz:police:giveWeapon', 'WEAPON_STUNGUN', 50) end },
        { label = '🔫 Pusca semiautomata',  description = 'Grade 3+',       price=0,
          disabled = (BZ.PlayerData.jobGrade or 0) < 3,
          cb = function() TriggerServerEvent('bz:police:giveWeapon', 'WEAPON_CARBINERIFLE', 200) end },
        { label = '⛓️ Catuse',              description = '5 catuse',       price=0, cb = function() TriggerServerEvent('bz:police:giveItem', 'handcuffs', 5) end },
        { label = '🩹 Trusa Medicala',      description = 'Prim ajutor',    price=0, cb = function() TriggerServerEvent('bz:police:giveItem', 'firstaid', 1) end },
        { label = '📻 Radio',               description = 'Radio politie',  price=0, cb = function() TriggerServerEvent('bz:police:giveItem', 'radio', 1) end },
    }, 'Armurerie Politie', 'Selecteaza echipamentul')
end

-- ============================================================
-- GARAJ POLITIE
-- ============================================================
function OpenPoliceGarage()
    BZ.OpenMenu({
        { label = '🚔 Police Cruiser',   cb = function() TriggerServerEvent('bz:police:spawnVehicle', 'police') end },
        { label = '🚓 Police Interceptor', cb = function() TriggerServerEvent('bz:police:spawnVehicle', 'police2') end },
        { label = '🚁 Politie Elicopter', disabled = (BZ.PlayerData.jobGrade or 0) < 4,
          cb = function() TriggerServerEvent('bz:police:spawnVehicle', 'polmav') end },
    }, 'Garaj Politie', 'Selecteaza vehiculul')
end

-- ============================================================
-- MDT (simplu)
-- ============================================================
function OpenMDT()
    BZ.OpenInput({
        { label='Cauta Jucator', name='query', type='text', placeholder='Nume sau ID server', required=true }
    }, 'MDT - Terminal Politie', function(values)
        if not values then return end
        TriggerServerEvent('bz:police:mdtSearch', values.query)
    end)
end

-- ============================================================
-- EVENTS DE LA SERVER
-- ============================================================

RegisterNetEvent('bz:police:setCuffed', function(state)
    cuffed = state
    local ped = PlayerPedId()
    if state then
        SetPedCurrentWeaponVisible(ped, false, true, true, true)
        FreezeEntityPosition(ped, true)
        TriggerEvent('bz:notifications:show', 'Ai fost incatust!', 'error')
    else
        FreezeEntityPosition(ped, false)
        TriggerEvent('bz:notifications:show', 'Ai fost eliberat din catuse.', 'success')
    end
end)

RegisterNetEvent('bz:police:mdtResult', function(data)
    if not data or #data == 0 then
        TriggerEvent('bz:notifications:show', 'Niciun rezultat gasit.', 'warning')
        return
    end
    local opts = {}
    for _, char in ipairs(data) do
        table.insert(opts, {
            label = char.firstname .. ' ' .. char.lastname,
            description = 'Job: ' .. char.job .. ' | Grad: ' .. char.job_grade,
            disabled = true,
        })
    end
    BZ.OpenMenu(opts, 'Rezultate MDT', #data .. ' rezultate')
end)

RegisterNetEvent('bz:police:receiveWeapon', function(weapon, ammo)
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey(weapon), ammo, false, true)
    TriggerEvent('bz:notifications:show', 'Ai primit ' .. weapon, 'success')
end)
