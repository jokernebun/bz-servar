-- ============================================================
-- BZ Ambulance - Server
-- ============================================================
local onDuty = {}

RegisterNetEvent('bz:ambulance:setDuty', function(state) onDuty[source] = state end)

RegisterNetEvent('bz:ambulance:revive', function(targetSrc)
    local src = source
    if not exports['bz_core']:HasJob(src, 'ambulance') then return end
    local p  = exports['bz_core']:GetPlayer(src)
    local tp = exports['bz_core']:GetPlayer(targetSrc)
    if not tp then TriggerClientEvent('bz:core:notify', src, 'Jucatorul nu este online!', 'error') return end

    TriggerClientEvent('bz:ambulance:doRevive', targetSrc)
    TriggerClientEvent('bz:core:notify', src, 'Ai resuscitat pe ' .. tp.name .. '!', 'success')
    TriggerClientEvent('bz:core:notify', targetSrc, p.name .. ' te-a resuscitat!', 'success')

    -- Plateste medicul
    exports['bz_core']:AddMoney(src, 'cash', 500)
    TriggerClientEvent('bz:core:notify', src, '+500 lei pentru interventie', 'money')
end)

RegisterNetEvent('bz:ambulance:giveItem', function(item, count)
    local src = source
    if not exports['bz_core']:HasJob(src, 'ambulance') then return end
    if not onDuty[src] then TriggerClientEvent('bz:core:notify', src, 'Nu esti in serviciu!', 'error') return end
    local p = exports['bz_core']:GetPlayer(src)
    if not p then return end
    exports['bz_core']:AddItem(p.charId, item, count, function()
        TriggerClientEvent('bz:inventory:load', src)
        TriggerClientEvent('bz:core:notify', src, 'Echipament primit.', 'success')
    end)
end)

RegisterNetEvent('bz:ambulance:spawnVehicle', function(model)
    local src = source
    if not exports['bz_core']:HasJob(src, 'ambulance') then return end
    if not onDuty[src] then TriggerClientEvent('bz:core:notify', src, 'Nu esti in serviciu!', 'error') return end
    TriggerClientEvent('bz:ambulance:spawnVeh', src, model)
end)

AddEventHandler('playerDropped', function() onDuty[source] = nil end)
