-- Plată tuning: scade banii jucătorului când apasă "Install Upgrades"
-- Folosește Qbox (qbx_core) pentru GetMoney / RemoveMoney
-- Comanda /tuning doar pentru staff/fondator (ace: apex_tuning.staff)

-- Comandă /tuning – doar pentru staff sau fondator (setează în server.cfg: add_ace group.fondator apex_tuning.staff allow)
RegisterCommand('tuning', function(source, _args, _rawCommand)
    if source == 0 then return end
    local ace = Config and Config.StaffAcePermission or 'apex_tuning.staff'
    if IsPlayerAceAllowed(source, ace) then
        TriggerClientEvent('apex_tuning:open', source, true)
    else
        local msg = Config and Config.Messages and Config.Messages.NotAllowed or 'Nu ai acces la comanda /tuning.'
        exports.qbx_core:Notify(source, msg, 'error')
    end
end, false)

-- Date vehicul din vehicle.lua (qbx_core shared): hp, km/h, clasă impozit
RegisterNetEvent('apex_tuning:getVehicleInfo', function(vehicleHash)
    local source = source
    local hash = tonumber(vehicleHash)
    local info = { hp = 100, speed = 200, class = 'D' }
    if hash then
        local ok, v = pcall(function()
            return exports.qbx_core:GetVehiclesByHash(hash)
        end)
        if ok and v and type(v) == 'table' and not v[1] then
            info.hp = tonumber(v.hp or v.horsepower) or 100
            info.speed = tonumber(v.speed or v.topSpeed) or 200
            info.class = tostring(v.class or 'D')
        end
    end
    TriggerClientEvent('apex_tuning:receiveVehicleInfo', source, info)
end)

RegisterNetEvent('apex_tuning:getMoney', function()
    local source = source
    local cash = 0
    local card = 0
    local ok1, c = pcall(function() return exports.qbx_core:GetMoney(source, 'cash') end)
    local ok2, d = pcall(function() return exports.qbx_core:GetMoney(source, 'bank') end)
    if ok1 and c then cash = c end
    if ok2 and d then card = d end
    TriggerClientEvent('apex_tuning:receiveMoney', source, { cash = cash, card = card })
end)

RegisterNetEvent('apex_tuning:pay', function(amount)
    local source = source
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return end

    local ok, current = pcall(function()
        return exports.qbx_core:GetMoney(source, 'cash')
    end)
    if not ok or not current or current < amount then
        exports.qbx_core:Notify(source, 'Nu ai suficienți bani. (' .. amount .. '$)', 'error')
        return
    end

    local success = pcall(function()
        exports.qbx_core:RemoveMoney(source, 'cash', amount, 'apex_tuning')
    end)
    if success then
        exports.qbx_core:Notify(source, 'Ai plătit ' .. amount .. '$ pentru tuning.', 'success')
        -- Cere clientului să trimită props vehicul și să închidă meniul; server salvează mods la player_vehicles
        TriggerClientEvent('apex_tuning:sendPropsThenClose', source)
    else
        exports.qbx_core:Notify(source, 'Plata a eșuat.', 'error')
    end
end)

-- Salvare moduri vehicul în baza de date (dacă vehiculul e deținut) - ca în qbx_customs
local function isVehicleOwned(plate)
    if not plate or plate == '' then return false end
    local ok, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM player_vehicles WHERE plate = ?', { plate })
    return ok and result ~= nil
end

RegisterNetEvent('apex_tuning:saveVehicleProps', function(vehicleProps)
    local source = source
    if not vehicleProps or not vehicleProps.plate then return end
    if isVehicleOwned(vehicleProps.plate) then
        MySQL.update.await('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {
            json.encode(vehicleProps),
            vehicleProps.plate
        })
    end
end)
