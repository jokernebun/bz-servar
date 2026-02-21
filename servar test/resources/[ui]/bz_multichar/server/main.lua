-- ============================================================
-- BZ Multichar - Server
-- ============================================================

-- La conectare: trimite lista de personaje
AddEventHandler('playerConnecting', function()
    -- Handled by bz_core
end)

-- Dupa ce playerul s-a conectat complet, arata selectia de personaje
AddEventHandler('playerJoining', function()
    local src = source
    Wait(2000)
    TriggerClientEvent('bz:multichar:show', src)
end)

-- Afiseaza multichar (folosit si la iesire din personaj)
RegisterNetEvent('bz:multichar:requestShow', function()
    TriggerClientEvent('bz:multichar:show', source)
end)
