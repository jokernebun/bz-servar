-- ============================================================
-- BZ Core - Server Player Management
-- ============================================================

-- ============================================================
-- MULTICHAR - Listare si creare personaje
-- ============================================================

RegisterNetEvent('bz:core:getCharacters', function()
    local src     = source
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifiers(src)[1]

    MySQL.query('SELECT * FROM characters WHERE license = ? ORDER BY slot ASC', { license },
        function(result)
            TriggerClientEvent('bz:multichar:receiveChars', src, result or {})
        end)
end)

RegisterNetEvent('bz:core:createCharacter', function(data)
    local src     = source
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifiers(src)[1]

    -- Verifica limitele
    MySQL.scalar('SELECT COUNT(*) FROM characters WHERE license = ?', { license }, function(count)
        if count >= BZ.Config.MaxChars then
            TriggerClientEvent('bz:core:notify', src, 'Ai atins limita de ' .. BZ.Config.MaxChars .. ' personaje!', 'error')
            return
        end

        -- Gaseste slotul liber
        MySQL.query('SELECT slot FROM characters WHERE license = ? ORDER BY slot ASC', { license },
            function(slots)
                local used = {}
                for _, v in ipairs(slots) do used[v.slot] = true end
                local freeSlot = 1
                for i = 1, BZ.Config.MaxChars do
                    if not used[i] then freeSlot = i break end
                end

                -- Validare date
                if BZ.IsEmpty(data.firstname) or BZ.IsEmpty(data.lastname) then
                    TriggerClientEvent('bz:core:notify', src, 'Completati numele si prenumele!', 'error')
                    return
                end

                local spawn = BZ.Config.SpawnPoints[BZ.Config.DefaultSpawn]

                MySQL.insert(
                    'INSERT INTO characters (license, slot, firstname, lastname, dateofbirth, sex, cash, bank, coords, heading, job, job_grade, gang, gang_grade) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                    {
                        license, freeSlot,
                        data.firstname, data.lastname,
                        data.dob or '01/01/2000',
                        data.sex or 'male',
                        BZ.Config.StartCash,
                        BZ.Config.StartBank,
                        json.encode({ x = spawn.x, y = spawn.y, z = spawn.z }),
                        spawn.h,
                        'unemployed', 0, 'none', 0,
                    },
                    function(charId)
                        if charId then
                            -- Da-i buletinul si telefonul
                            MySQL.insert('INSERT INTO character_inventory (char_id, item, count, slot) VALUES (?,?,?,?)',
                                { charId, 'id_card', 1, 1 })
                            MySQL.insert('INSERT INTO character_inventory (char_id, item, count, slot) VALUES (?,?,?,?)',
                                { charId, 'phone', 1, 2 })

                            TriggerClientEvent('bz:core:notify', src, 'Personaj creat cu succes!', 'success')
                            -- Reincarca lista
                            TriggerEvent('bz:core:getCharacters', src)
                            -- Emite evenimentul pe sursa
                            TriggerClientEvent('bz:core:charCreated', src, charId)
                        end
                    end)
            end)
    end)
end)

RegisterNetEvent('bz:core:deleteCharacter', function(charId)
    local src     = source
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifiers(src)[1]

    MySQL.scalar('SELECT id FROM characters WHERE id = ? AND license = ?', { charId, license },
        function(id)
            if not id then
                TriggerClientEvent('bz:core:notify', src, 'Personaj invalid!', 'error')
                return
            end
            MySQL.update('DELETE FROM characters WHERE id = ?', { charId })
            MySQL.update('DELETE FROM character_inventory WHERE char_id = ?', { charId })
            MySQL.update('DELETE FROM character_vehicles WHERE char_id = ?', { charId })
            TriggerClientEvent('bz:core:notify', src, 'Personajul a fost sters.', 'info')
            TriggerClientEvent('bz:core:charDeleted', src)
        end)
end)

-- ============================================================
-- INVENTAR - Logica server
-- ============================================================

RegisterNetEvent('bz:inventory:give', function(targetSrc, item, count)
    local src = source
    local p   = GetPlayer(src)
    local t   = GetPlayer(targetSrc)
    if not p or not t then return end
    count = math.max(1, math.floor(count))

    -- Ia din inventarul sursei
    MySQL.scalar('SELECT count FROM character_inventory WHERE char_id=? AND item=?', { p.charId, item },
        function(have)
            if not have or have < count then
                TriggerClientEvent('bz:core:notify', src, 'Nu ai suficiente!', 'error')
                return
            end
            RemoveItem(p.charId, item, count, function()
                AddItem(t.charId, item, count, function()
                    local itemData = BZ.Items[item]
                    TriggerClientEvent('bz:core:notify', src,    'Ai dat ' .. count .. 'x ' .. (itemData and itemData.label or item), 'info')
                    TriggerClientEvent('bz:core:notify', targetSrc, 'Ai primit ' .. count .. 'x ' .. (itemData and itemData.label or item), 'success')
                end)
            end)
        end)
end)

--- Adauga item in inventarul unui personaj
---@param charId number
---@param item string
---@param count number
---@param cb function|nil
function AddItem(charId, item, count, cb)
    if not BZ.Items[item] then if cb then cb(false) end return end
    MySQL.scalar('SELECT id FROM character_inventory WHERE char_id=? AND item=? LIMIT 1', { charId, item },
        function(existId)
            if existId and BZ.Items[item].stackable then
                MySQL.update('UPDATE character_inventory SET count=count+? WHERE id=?', { count, existId },
                    function() if cb then cb(true) end end)
            else
                MySQL.scalar('SELECT COALESCE(MAX(slot),0)+1 FROM character_inventory WHERE char_id=?', { charId },
                    function(nextSlot)
                        MySQL.insert('INSERT INTO character_inventory (char_id, item, count, slot) VALUES (?,?,?,?)',
                            { charId, item, count, nextSlot or 1 },
                            function() if cb then cb(true) end end)
                    end)
            end
        end)
end
exports('AddItem', AddItem)

--- Scoate item din inventarul unui personaj
---@param charId number
---@param item string
---@param count number
---@param cb function|nil
function RemoveItem(charId, item, count, cb)
    MySQL.query('SELECT id, count FROM character_inventory WHERE char_id=? AND item=?', { charId, item },
        function(rows)
            if not rows or #rows == 0 then if cb then cb(false) end return end
            local total = 0
            for _, r in ipairs(rows) do total = total + r.count end
            if total < count then if cb then cb(false) end return end

            local left = count
            for _, r in ipairs(rows) do
                if left <= 0 then break end
                if r.count <= left then
                    MySQL.update('DELETE FROM character_inventory WHERE id=?', { r.id })
                    left = left - r.count
                else
                    MySQL.update('UPDATE character_inventory SET count=count-? WHERE id=?', { left, r.id })
                    left = 0
                end
            end
            if cb then cb(true) end
        end)
end
exports('RemoveItem', RemoveItem)

--- Verifica daca un personaj are un item
---@param charId number
---@param item string
---@param count number
---@param cb function
function HasItem(charId, item, count, cb)
    count = count or 1
    MySQL.scalar('SELECT COALESCE(SUM(count),0) FROM character_inventory WHERE char_id=? AND item=?',
        { charId, item }, function(total)
            cb(total and total >= count, total or 0)
        end)
end
exports('HasItem', HasItem)

-- ============================================================
-- CALLBACK: Obtine inventarul personajului
-- ============================================================
RegisterNetEvent('bz:inventory:load', function()
    local src = source
    local p   = GetPlayer(src)
    if not p then return end

    MySQL.query('SELECT * FROM character_inventory WHERE char_id=? ORDER BY slot ASC', { p.charId },
        function(rows)
            TriggerClientEvent('bz:inventory:receive', src, rows or {})
        end)
end)
