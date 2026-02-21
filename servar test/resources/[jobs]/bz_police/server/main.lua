-- ============================================================
-- BZ Police - Server
-- ============================================================

local onDuty = {}

RegisterNetEvent('bz:police:setDuty', function(state)
    onDuty[source] = state
    TriggerEvent('bz:police:dutyChanged', source, state)
end)

-- Catuse
RegisterNetEvent('bz:police:cuff', function(targetSrc)
    local src = source
    if not exports['bz_core']:HasJob(src, 'police') then return end
    if not onDuty[src] then return end

    local p    = exports['bz_core']:GetPlayer(src)
    local srcPed = GetPlayerPed(src)
    local tPed   = GetPlayerPed(targetSrc)

    if #(GetEntityCoords(srcPed) - GetEntityCoords(tPed)) > 3.0 then
        TriggerClientEvent('bz:core:notify', src, 'Prea departe!', 'error')
        return
    end

    -- Toggle catuse
    local isCuffed = LocalPlayer and true or false  -- simplificat
    TriggerClientEvent('bz:police:setCuffed', targetSrc, true)
    TriggerClientEvent('bz:core:notify', src, 'Ai pus catusele.', 'success')
    TriggerClientEvent('bz:core:notify', targetSrc, GetPlayerName(src) .. ' ti-a pus catuse!', 'error')
end)

-- Decatuse
RegisterNetEvent('bz:police:uncuff', function(targetSrc)
    local src = source
    if not exports['bz_core']:HasJob(src, 'police') then return end
    TriggerClientEvent('bz:police:setCuffed', targetSrc, false)
    TriggerClientEvent('bz:core:notify', src, 'Ai scos catusele.', 'success')
end)

-- Inchisoare
RegisterNetEvent('bz:police:jail', function(targetSrc, time)
    local src = source
    if not exports['bz_core']:HasJob(src, 'police', 2) then
        TriggerClientEvent('bz:core:notify', src, 'Nu ai permisiunea!', 'error')
        return
    end
    time = math.max(1, math.min(time or 5, 60))  -- 1-60 minute

    local t = exports['bz_core']:GetPlayer(targetSrc)
    if not t then return end

    MySQL.update('UPDATE characters SET jail_time=? WHERE id=?', { time * 60, t.charId })
    TriggerClientEvent('bz:police:sendToJail', targetSrc, time)
    TriggerClientEvent('bz:core:notify', src, GetPlayerName(targetSrc) .. ' a fost trimis la puscarie pentru ' .. time .. ' min.', 'success')

    -- Log
    MySQL.insert('INSERT INTO admin_logs (admin_license, admin_name, action, target, reason) VALUES (?,?,?,?,?)',
        { GetPlayerIdentifierByType(src,'license'), GetPlayerName(src), 'jail',
          GetPlayerName(targetSrc), time .. ' minute' })
end)

-- Cautare MDT
RegisterNetEvent('bz:police:mdtSearch', function(query)
    local src = source
    if not exports['bz_core']:HasJob(src, 'police') then return end

    MySQL.query(
        'SELECT * FROM characters WHERE CONCAT(firstname," ",lastname) LIKE ? OR id=? LIMIT 5',
        { '%' .. query .. '%', tonumber(query) or -1 },
        function(rows)
            TriggerClientEvent('bz:police:mdtResult', src, rows or {})
        end)
end)

-- Da arma din armurerie
RegisterNetEvent('bz:police:giveWeapon', function(weapon, ammo)
    local src = source
    if not exports['bz_core']:HasJob(src, 'police') then return end
    if not onDuty[src] then TriggerClientEvent('bz:core:notify', src, 'Nu esti in serviciu!', 'error') return end

    TriggerClientEvent('bz:police:receiveWeapon', src, weapon, ammo)
end)

-- Da item din armurerie
RegisterNetEvent('bz:police:giveItem', function(item, count)
    local src = source
    if not exports['bz_core']:HasJob(src, 'police') then return end
    if not onDuty[src] then TriggerClientEvent('bz:core:notify', src, 'Nu esti in serviciu!', 'error') return end

    local p = exports['bz_core']:GetPlayer(src)
    if not p then return end
    exports['bz_core']:AddItem(p.charId, item, count, function()
        TriggerClientEvent('bz:inventory:load', src)
        TriggerClientEvent('bz:core:notify', src, 'Item primit din armurerie.', 'success')
    end)
end)

-- Spawn vehicul politie
RegisterNetEvent('bz:police:spawnVehicle', function(model)
    local src = source
    if not exports['bz_core']:HasJob(src, 'police') then return end
    if not onDuty[src] then TriggerClientEvent('bz:core:notify', src, 'Nu esti in serviciu!', 'error') return end

    TriggerClientEvent('bz:police:spawnVeh', src, model)
end)

-- Spawn vehicle client side
RegisterNetEvent('bz:police:spawnVeh', function(model)
    Wait(0)
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading= GetEntityHeading(ped)

    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do Wait(100) end

    local veh = CreateVehicle(GetHashKey(model),
        coords.x + 3.0, coords.y, coords.z,
        heading, true, false)

    SetVehicleNumberPlateText(veh, 'POLITIE')
    SetPedIntoVehicle(ped, veh, -1)
    SetEntityAsMissionEntity(veh, true, true)
    TriggerEvent('bz:notifications:show', 'Vehicul de serviciu spawnat!', 'success')
end)

-- La disconnect, scoate din duty
AddEventHandler('playerDropped', function()
    onDuty[source] = nil
end)
