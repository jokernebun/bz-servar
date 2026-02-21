-- ============================================================
-- BZ Core - Server Callbacks
-- ============================================================

BZ.Callbacks = {}

--- Inregistreaza un callback server-side
---@param name string
---@param cb function
function BZ.RegisterCallback(name, cb)
    BZ.Callbacks[name] = cb
end
exports('RegisterCallback', BZ.RegisterCallback)

--- Raspunde la un callback de la client
RegisterNetEvent('bz:core:callback', function(name, requestId, ...)
    local src = source
    if BZ.Callbacks[name] then
        BZ.Callbacks[name](src, function(...)
            TriggerClientEvent('bz:core:callbackResponse', src, requestId, ...)
        end, ...)
    else
        print('^1[BZ Core]^7 Callback necunoscut: ' .. tostring(name))
    end
end)

-- ============================================================
-- CALLBACKS STANDARD
-- ============================================================

BZ.RegisterCallback('bz:getPlayerData', function(src, cb)
    cb(GetPlayer(src))
end)

BZ.RegisterCallback('bz:getMoney', function(src, cb)
    local p = GetPlayer(src)
    if p then cb({ cash=p.cash, bank=p.bank, black=p.blackMoney })
    else      cb(nil) end
end)

BZ.RegisterCallback('bz:hasItem', function(src, cb, item, count)
    local p = GetPlayer(src)
    if not p then cb(false) return end
    HasItem(p.charId, item, count, function(has, total)
        cb(has, total)
    end)
end)

BZ.RegisterCallback('bz:getNearPlayers', function(src, cb, radius)
    radius = radius or 5.0
    local ped    = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local nearby = {}
    for id, p in pairs(GetPlayers()) do
        if id ~= src then
            local otherCoords = GetEntityCoords(GetPlayerPed(id))
            if #(coords - otherCoords) <= radius then
                table.insert(nearby, { source=id, name=p.name, job=p.job })
            end
        end
    end
    cb(nearby)
end)

BZ.RegisterCallback('bz:getCharacters', function(src, cb)
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifiers(src)[1]
    MySQL.query('SELECT * FROM characters WHERE license=? ORDER BY slot ASC', { license },
        function(result)
            cb(result or {})
        end)
end)
