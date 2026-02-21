-- ============================================================
-- BZ Core - Admin Commands
-- ============================================================

-- /noclip
RegisterCommand('noclip', function(src)
    TriggerClientEvent('bz:admin:toggleNoclip', src)
end, true)

-- /god
RegisterCommand('god', function(src)
    TriggerClientEvent('bz:admin:toggleGod', src)
end, true)

-- /tp [x] [y] [z]
RegisterCommand('tp', function(src, args)
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if not x or not y or not z then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /tp [x] [y] [z]', 'error')
        return
    end
    TriggerClientEvent('bz:admin:teleport', src, x, y, z)
end, true)

-- /bring [id]
RegisterCommand('bring', function(src, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /bring [id]', 'error')
        return
    end
    local ped    = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    TriggerClientEvent('bz:admin:teleport', targetId, coords.x + 1.0, coords.y, coords.z)
    TriggerClientEvent('bz:core:notify', src, 'Jucatorul a fost adus.', 'success')
end, true)

-- /freeze [id]
RegisterCommand('freeze', function(src, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /freeze [id]', 'error')
        return
    end
    TriggerClientEvent('bz:admin:freeze', targetId, true)
    TriggerClientEvent('bz:core:notify', src, 'Jucatorul a fost inghetat.', 'success')
end, true)

-- /revive [id?]
RegisterCommand('revive', function(src, args)
    local targetId = tonumber(args[1]) or src
    TriggerClientEvent('bz:admin:revive', targetId)
    TriggerClientEvent('bz:core:notify', src, 'Jucatorul a fost resuscitat.', 'success')
end, true)

-- /setjob [id] [job] [grade]
RegisterCommand('setjob', function(src, args)
    local targetId = tonumber(args[1])
    local job      = args[2]
    local grade    = tonumber(args[3]) or 0
    if not targetId or not job then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /setjob [id] [job] [grade]', 'error')
        return
    end
    local ok = SetJob(targetId, job, grade)
    if ok then
        TriggerClientEvent('bz:core:notify', src, 'Job setat cu succes!', 'success')
        TriggerClientEvent('bz:core:notify', targetId, 'Jobul tau a fost schimbat la: ' .. job, 'info')
    else
        TriggerClientEvent('bz:core:notify', src, 'Job invalid sau jucator offline!', 'error')
    end
end, true)

-- /setmoney [id] [type] [amount]
RegisterCommand('setmoney', function(src, args)
    local targetId = tonumber(args[1])
    local mtype    = args[2]
    local amount   = tonumber(args[3])
    if not targetId or not mtype or not amount then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /setmoney [id] [cash/bank] [suma]', 'error')
        return
    end
    local p = GetPlayer(targetId)
    if not p then
        TriggerClientEvent('bz:core:notify', src, 'Jucatorul nu este online!', 'error')
        return
    end
    if mtype == 'cash'  then p.cash = amount
    elseif mtype == 'bank' then p.bank = amount
    end
    TriggerClientEvent('bz:core:updateMoney', targetId, { cash=p.cash, bank=p.bank })
    TriggerClientEvent('bz:core:notify', src, 'Bani setati cu succes!', 'success')
end, true)

-- /giveitem [id] [item] [count]
RegisterCommand('giveitem', function(src, args)
    local targetId = tonumber(args[1])
    local item     = args[2]
    local count    = tonumber(args[3]) or 1
    if not targetId or not item then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /giveitem [id] [item] [cantitate]', 'error')
        return
    end
    if not BZ.Items[item] then
        TriggerClientEvent('bz:core:notify', src, 'Item invalid: ' .. item, 'error')
        return
    end
    local p = GetPlayer(targetId)
    if not p then
        TriggerClientEvent('bz:core:notify', src, 'Jucatorul nu este online!', 'error')
        return
    end
    AddItem(p.charId, item, count, function(ok)
        if ok then
            TriggerClientEvent('bz:inventory:load', targetId)
            TriggerClientEvent('bz:core:notify', src, 'Item dat cu succes!', 'success')
            TriggerClientEvent('bz:core:notify', targetId, 'Ai primit ' .. count .. 'x ' .. BZ.Items[item].label, 'success')
        end
    end)
end, true)

-- /kick [id] [motiv]
RegisterCommand('kick', function(src, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /kick [id] [motiv]', 'error')
        return
    end
    local reason = table.concat(args, ' ', 2) or 'Fara motiv'
    DropPlayer(targetId, 'Ai fost dat afara. Motiv: ' .. reason)
    TriggerClientEvent('bz:core:notify', src, 'Jucatorul a fost dat afara.', 'success')

    MySQL.insert('INSERT INTO admin_logs (admin_license, admin_name, action, target, reason) VALUES (?,?,?,?,?)',
        { GetPlayerIdentifierByType(src,'license'), GetPlayerName(src), 'kick', GetPlayerName(targetId), reason })
end, true)

-- /ban [id] [motiv]
RegisterCommand('ban', function(src, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('bz:core:notify', src, 'Folosire: /ban [id] [motiv]', 'error')
        return
    end
    local reason  = table.concat(args, ' ', 2) or 'Fara motiv'
    local license = GetPlayerIdentifierByType(targetId, 'license')
    MySQL.update('UPDATE players SET banned=1, ban_reason=? WHERE license=?', { reason, license })
    DropPlayer(targetId, 'Ai fost banat. Motiv: ' .. reason)
    TriggerClientEvent('bz:core:notify', src, 'Jucatorul a fost banat.', 'success')

    MySQL.insert('INSERT INTO admin_logs (admin_license, admin_name, action, target, reason) VALUES (?,?,?,?,?)',
        { GetPlayerIdentifierByType(src,'license'), GetPlayerName(src), 'ban', license, reason })
end, true)

-- /players - lista jucatori online
RegisterCommand('players', function(src)
    local list = {}
    for id, p in pairs(GetPlayers()) do
        table.insert(list, string.format('[%d] %s | Job: %s', id, p.name, p.job))
    end
    TriggerClientEvent('bz:core:showList', src, 'Jucatori Online (' .. #list .. ')', list)
end, false)
