-- ============================================================
-- BZ Inventory - Server
-- ============================================================

-- Use item
RegisterNetEvent('bz:inventory:use', function(itemName)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    if not BZ.Items[itemName] or not BZ.Items[itemName].usable then
        TriggerClientEvent('bz:core:notify', src, 'Itemul nu poate fi folosit!', 'error')
        return
    end

    exports['bz_core']:RemoveItem(p.charId, itemName, 1, function(ok)
        if ok then
            TriggerClientEvent('bz:inventory:load', src)
        else
            TriggerClientEvent('bz:core:notify', src, 'Nu ai acel item!', 'error')
        end
    end)
end)

-- Drop item (arunca pe jos)
RegisterNetEvent('bz:inventory:drop', function(itemName, count)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    count = math.max(1, math.min(count, 999))

    exports['bz_core']:RemoveItem(p.charId, itemName, count, function(ok)
        if ok then
            TriggerClientEvent('bz:inventory:load', src)
            TriggerClientEvent('bz:core:notify', src, 'Ai aruncat ' .. count .. 'x item.', 'info')

            -- Spawn prop pe jos (optional, doar visual)
            local ped    = GetPlayerPed(src)
            local coords = GetEntityCoords(ped)
            TriggerClientEvent('bz:inventory:spawnDrop', src, coords, itemName, count)
        else
            TriggerClientEvent('bz:core:notify', src, 'Nu ai destule!', 'error')
        end
    end)
end)

-- Load inventar
RegisterNetEvent('bz:inventory:load', function()
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    MySQL.query('SELECT * FROM character_inventory WHERE char_id=? ORDER BY slot ASC', { p.charId },
        function(rows)
            TriggerClientEvent('bz:inventory:receive', src, rows or {})
        end)
end)

-- Stash - load
RegisterNetEvent('bz:inventory:loadStash', function(stashId)
    local src = source
    MySQL.query('SELECT * FROM stashes WHERE stash_id=? ORDER BY slot ASC', { stashId },
        function(rows)
            TriggerClientEvent('bz:inventory:receiveStash', src, stashId, rows or {})
        end)
end)

-- Stash - pune item
RegisterNetEvent('bz:inventory:stashPut', function(stashId, itemName, count)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    exports['bz_core']:RemoveItem(p.charId, itemName, count, function(ok)
        if not ok then
            TriggerClientEvent('bz:core:notify', src, 'Nu ai destule!', 'error')
            return
        end

        MySQL.scalar('SELECT id FROM stashes WHERE stash_id=? AND item=? LIMIT 1', { stashId, itemName },
            function(existId)
                if existId then
                    MySQL.update('UPDATE stashes SET count=count+? WHERE id=?', { count, existId })
                else
                    MySQL.scalar('SELECT COALESCE(MAX(slot),0)+1 FROM stashes WHERE stash_id=?', { stashId },
                        function(nextSlot)
                            MySQL.insert('INSERT INTO stashes (stash_id, item, count, slot) VALUES (?,?,?,?)',
                                { stashId, itemName, count, nextSlot or 1 })
                        end)
                end
                TriggerClientEvent('bz:inventory:load', src)
                TriggerClientEvent('bz:core:notify', src, 'Item pus in stash.', 'success')
            end)
    end)
end)

-- Stash - ia item
RegisterNetEvent('bz:inventory:stashTake', function(stashId, itemName, count)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    MySQL.query('SELECT id, count FROM stashes WHERE stash_id=? AND item=?', { stashId, itemName },
        function(rows)
            if not rows or #rows == 0 then
                TriggerClientEvent('bz:core:notify', src, 'Item inexistent in stash!', 'error')
                return
            end

            local available = rows[1].count
            count = math.min(count, available)

            if available - count <= 0 then
                MySQL.update('DELETE FROM stashes WHERE id=?', { rows[1].id })
            else
                MySQL.update('UPDATE stashes SET count=count-? WHERE id=?', { count, rows[1].id })
            end

            exports['bz_core']:AddItem(p.charId, itemName, count, function()
                TriggerClientEvent('bz:inventory:load', src)
                TriggerClientEvent('bz:core:notify', src, 'Item luat din stash.', 'success')
            end)
        end)
end)
