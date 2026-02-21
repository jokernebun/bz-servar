-- ============================================================
-- BZ Trucker - Server
-- ============================================================
local onDuty = {}

RegisterNetEvent('bz:trucker:setDuty', function(state) onDuty[source] = state end)

RegisterNetEvent('bz:trucker:completeJob', function(pay, cargo)
    local src = source
    if not exports['bz_core']:HasJob(src, 'trucker') then return end
    pay = math.max(0, math.min(pay, 10000))  -- sanity check

    exports['bz_core']:AddMoney(src, 'bank', pay)
    TriggerClientEvent('bz:core:notify', src, 'Salariu livrare primit: +' .. pay .. ' lei in cont!', 'money')

    -- Salveaza in DB
    local p = exports['bz_core']:GetPlayer(src)
    if p then
        MySQL.insert('INSERT INTO trucker_jobs (char_id, cargo, pay, completed) VALUES (?,?,?,1)',
            { p.charId, cargo, pay })
    end
end)

RegisterNetEvent('bz:trucker:spawnTruck', function()
    local src = source
    if not exports['bz_core']:HasJob(src, 'trucker') then return end
    if not onDuty[src] then TriggerClientEvent('bz:core:notify', src, 'Nu esti in serviciu!', 'error') return end

    local models = { 'hauler', 'packer', 'phantom', 'mule', 'pounder' }
    local model  = models[math.random(#models)]
    TriggerClientEvent('bz:trucker:spawnedTruck', src, model)
end)

AddEventHandler('playerDropped', function() onDuty[source] = nil end)
