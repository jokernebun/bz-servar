-- ============================================================
-- BZ Banking - Client
-- ============================================================

local bankOpen = false

-- ============================================================
-- BLIP-URI BANCA SI ATM
-- ============================================================
CreateThread(function()
    Wait(2000)
    -- Banci
    for _, bank in ipairs(BZ.Config.Banks) do
        local blip = AddBlipForCoord(bank.x, bank.y, bank.z)
        SetBlipSprite(blip, 108)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(bank.label)
        EndTextCommandSetBlipName(blip)
    end

    -- ATM-uri
    for _, atm in ipairs(BZ.Config.ATMs) do
        local blip = AddBlipForCoord(atm.x, atm.y, atm.z)
        SetBlipSprite(blip, 277)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('ATM')
        EndTextCommandSetBlipName(blip)
    end
end)

-- ============================================================
-- DETECTIE PROXIMITATE
-- ============================================================
CreateThread(function()
    while true do
        Wait(1000)
        if not BZ.Loaded then goto continue end

        local ped    = PlayerPedId()
        local coords = GetEntityCoords(ped)

        -- Banci
        for _, bank in ipairs(BZ.Config.Banks) do
            if #(coords - vector3(bank.x, bank.y, bank.z)) < 3.0 then
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('[E] - Intra la banca')
                EndTextCommandDisplayHelp(0, false, true, -1)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('bz:banking:open', false)
                end
            end
        end

        -- ATM-uri
        for _, atm in ipairs(BZ.Config.ATMs) do
            if #(coords - vector3(atm.x, atm.y, atm.z)) < 1.5 then
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('[E] - Foloseste ATM')
                EndTextCommandDisplayHelp(0, false, true, -1)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('bz:banking:open', true)
                end
            end
        end

        ::continue::
    end
end)

-- ============================================================
-- DESCHIDE UI
-- ============================================================
RegisterNetEvent('bz:banking:openUI', function(data)
    bankOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action  = 'open',
        cash    = data.cash,
        bank    = data.bank,
        name    = data.name,
        isATM   = data.isATM,
        history = data.history,
    })
end)

RegisterNetEvent('bz:banking:updateUI', function(data)
    SendNUIMessage({
        action = 'updateBalances',
        cash   = data.cash,
        bank   = data.bank,
    })
end)

RegisterNetEvent('bz:banking:receiveHistory', function(history)
    SendNUIMessage({ action = 'updateHistory', history = history })
end)

-- ============================================================
-- NUI CALLBACKS
-- ============================================================
RegisterNUICallback('deposit',  function(d, cb) cb('ok') TriggerServerEvent('bz:banking:deposit',  d.amount) end)
RegisterNUICallback('withdraw', function(d, cb) cb('ok') TriggerServerEvent('bz:banking:withdraw', d.amount) end)
RegisterNUICallback('transfer', function(d, cb) cb('ok') TriggerServerEvent('bz:banking:transfer', d.targetId, d.amount) end)
RegisterNUICallback('getHistory', function(_, cb) cb('ok') TriggerServerEvent('bz:banking:getHistory') end)

RegisterNUICallback('closeBank', function(_, cb)
    cb('ok')
    bankOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end)
