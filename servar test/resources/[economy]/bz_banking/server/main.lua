-- ============================================================
-- BZ Banking - Server
-- ============================================================

-- Depune bani
RegisterNetEvent('bz:banking:deposit', function(amount)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        TriggerClientEvent('bz:core:notify', src, 'Suma invalida!', 'error') return
    end
    if p.cash < amount then
        TriggerClientEvent('bz:core:notify', src, 'Nu ai destul numerar!', 'error') return
    end

    exports['bz_core']:RemoveMoney(src, 'cash', amount)
    exports['bz_core']:AddMoney(src, 'bank', amount)

    MySQL.insert('INSERT INTO bank_transactions (char_id, type, amount, description) VALUES (?,?,?,?)',
        { p.charId, 'deposit', amount, 'Depunere numerar' })

    TriggerClientEvent('bz:banking:updateUI', src, {
        cash = exports['bz_core']:GetPlayer(src).cash,
        bank = exports['bz_core']:GetPlayer(src).bank,
    })
    TriggerClientEvent('bz:core:notify', src, 'Ai depus ' .. amount .. ' lei in cont.', 'success')
end)

-- Retrage bani
RegisterNetEvent('bz:banking:withdraw', function(amount)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        TriggerClientEvent('bz:core:notify', src, 'Suma invalida!', 'error') return
    end
    if p.bank < amount then
        TriggerClientEvent('bz:core:notify', src, 'Nu ai destui bani in cont!', 'error') return
    end

    exports['bz_core']:RemoveMoney(src, 'bank', amount)
    exports['bz_core']:AddMoney(src, 'cash', amount)

    MySQL.insert('INSERT INTO bank_transactions (char_id, type, amount, description) VALUES (?,?,?,?)',
        { p.charId, 'withdraw', amount, 'Retragere numerar' })

    TriggerClientEvent('bz:banking:updateUI', src, {
        cash = exports['bz_core']:GetPlayer(src).cash,
        bank = exports['bz_core']:GetPlayer(src).bank,
    })
    TriggerClientEvent('bz:core:notify', src, 'Ai retras ' .. amount .. ' lei.', 'success')
end)

-- Transfer bani
RegisterNetEvent('bz:banking:transfer', function(targetId, amount)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    local t   = exports['bz_core']:GetPlayer(tonumber(targetId))
    if not p or not t then
        TriggerClientEvent('bz:core:notify', src, 'Jucatorul nu este online!', 'error') return
    end
    if src == tonumber(targetId) then
        TriggerClientEvent('bz:core:notify', src, 'Nu te poti transfera tie insuti!', 'error') return
    end

    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        TriggerClientEvent('bz:core:notify', src, 'Suma invalida!', 'error') return
    end
    if p.bank < amount then
        TriggerClientEvent('bz:core:notify', src, 'Fonduri insuficiente!', 'error') return
    end

    exports['bz_core']:RemoveMoney(src, 'bank', amount)
    exports['bz_core']:AddMoney(tonumber(targetId), 'bank', amount)

    MySQL.insert('INSERT INTO bank_transactions (char_id, type, amount, description, from_char, to_char) VALUES (?,?,?,?,?,?)',
        { p.charId, 'transfer', amount, 'Transfer catre ' .. t.name, p.charId, t.charId })

    TriggerClientEvent('bz:core:notify', src, 'Transfer de ' .. amount .. ' lei catre ' .. t.name .. ' reusit!', 'success')
    TriggerClientEvent('bz:core:notify', tonumber(targetId), 'Ai primit ' .. amount .. ' lei de la ' .. p.name, 'money')
end)

-- Istoric tranzactii
RegisterNetEvent('bz:banking:getHistory', function()
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    MySQL.query('SELECT * FROM bank_transactions WHERE char_id=? ORDER BY created_at DESC LIMIT 20', { p.charId },
        function(rows)
            TriggerClientEvent('bz:banking:receiveHistory', src, rows or {})
        end)
end)

-- Deschide banca (cu toate datele)
RegisterNetEvent('bz:banking:open', function(isATM)
    local src = source
    local p   = exports['bz_core']:GetPlayer(src)
    if not p then return end

    MySQL.query('SELECT * FROM bank_transactions WHERE char_id=? ORDER BY created_at DESC LIMIT 10', { p.charId },
        function(rows)
            TriggerClientEvent('bz:banking:openUI', src, {
                cash    = p.cash,
                bank    = p.bank,
                name    = p.name,
                isATM   = isATM or false,
                history = rows or {},
            })
        end)
end)
