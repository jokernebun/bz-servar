-- ============================================================
-- BZ Crafting - Client
-- ============================================================

local craftOpen    = false
local currentTable = nil

-- ============================================================
-- BLIP-URI PE HARTA
-- ============================================================
CreateThread(function()
    Wait(3000)
    for tableId, tbl in pairs(BZ.Crafting.Tables) do
        if tbl.blip ~= false then
            local blip = AddBlipForCoord(tbl.location.x, tbl.location.y, tbl.location.z)
            SetBlipSprite(blip, 566)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 47)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(tbl.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- ============================================================
-- DETECTIE PROXIMITATE MASA DE CRAFTING
-- ============================================================
CreateThread(function()
    while true do
        Wait(1000)
        if not BZ.Loaded then goto continue end

        local ped    = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for tableId, tbl in pairs(BZ.Crafting.Tables) do
            local loc = tbl.location
            local dist = #(coords - vector3(loc.x, loc.y, loc.z))

            if dist < 2.0 then
                -- Afiseaza textul de interactie
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('[E] - ' .. tbl.label)
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustPressed(0, 38) then -- E
                    OpenCraftingTable(tableId, tbl)
                end
            end
        end

        ::continue::
    end
end)

-- ============================================================
-- DESCHIDE MASA DE CRAFTING
-- ============================================================
function OpenCraftingTable(tableId, tbl)
    -- Verifica job-ul daca e necesar
    if tbl.jobRequired and BZ.PlayerData.job ~= tbl.jobRequired then
        TriggerEvent('bz:notifications:show', 'Trebuie sa fii ' .. BZ.Jobs[tbl.jobRequired].label .. '!', 'error')
        return
    end

    currentTable = tableId
    craftOpen    = true

    -- Cere inventarul de la server (pentru a vedea ce ingrediente ai)
    TriggerServerEvent('bz:inventory:load')

    -- Trimite retetele la UI
    SetNuiFocus(true, true)
    SendNUIMessage({
        action  = 'open',
        tableId = tableId,
        label   = tbl.label,
        icon    = tbl.icon or '🔨',
        recipes = tbl.recipes,
    })
end

-- ============================================================
-- NUI CALLBACKS
-- ============================================================

RegisterNUICallback('craftItem', function(data, cb)
    cb('ok')
    local recipeIdx = tonumber(data.recipeIdx)
    local tbl       = BZ.Crafting.Tables[currentTable]
    if not tbl or not tbl.recipes[recipeIdx] then return end

    local recipe = tbl.recipes[recipeIdx]
    CloseCrafting()

    -- Progress bar
    BZ.ProgressBar('Se fabrica: ' .. recipe.label, recipe.time or 5000, function(success)
        if success then
            TriggerServerEvent('bz:crafting:craft', currentTable, recipeIdx)
        else
            TriggerEvent('bz:notifications:show', 'Crafting anulat!', 'warning')
        end
    end, true)
end)

RegisterNUICallback('closeCrafting', function(_, cb)
    cb('ok')
    CloseCrafting()
end)

function CloseCrafting()
    craftOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- Update inventar in crafting UI
RegisterNetEvent('bz:inventory:receive', function(items)
    if craftOpen then
        local have = {}
        for _, slot in ipairs(items) do
            have[slot.item] = (have[slot.item] or 0) + slot.count
        end
        SendNUIMessage({ action = 'updateInventory', inventory = have })
    end
end, true)  -- allow overwrite
