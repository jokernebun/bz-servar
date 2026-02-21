-- ============================================================
-- BZ Mechanic - Server
-- ============================================================
local onDuty = {}

RegisterNetEvent('bz:mechanic:setDuty', function(state) onDuty[source] = state end)

RegisterNetEvent('bz:mechanic:giveTools', function()
    local src = source
    if not exports['bz_core']:HasJob(src, 'mechanic') then return end
    if not onDuty[src] then TriggerClientEvent('bz:core:notify', src, 'Nu esti in serviciu!', 'error') return end
    local p = exports['bz_core']:GetPlayer(src)
    if not p then return end
    exports['bz_core']:AddItem(p.charId, 'wrench', 1, function()
        TriggerClientEvent('bz:inventory:load', src)
        TriggerClientEvent('bz:mechanic:receiveTools', src)
    end)
end)

RegisterNetEvent('bz:mechanic:chargeRepair', function(driverSrc, amount)
    local src = source
    if not exports['bz_core']:HasJob(src, 'mechanic') then return end
    -- Plateste mecanicul
    exports['bz_core']:AddMoney(src, 'cash', amount)
    TriggerClientEvent('bz:core:notify', src, '+' .. amount .. ' lei pentru reparatie', 'money')
    if driverSrc and driverSrc > 0 then
        TriggerClientEvent('bz:core:notify', driverSrc, 'Vehiculul a fost reparat. Cost: ' .. amount .. ' lei', 'info')
    end
end)

AddEventHandler('playerDropped', function() onDuty[source] = nil end)
