-- ============================================================
-- BZ Crafting - Server
-- ============================================================

RegisterNetEvent('bz:crafting:craft', function(tableId, recipeIdx)
    local src    = source
    local player = exports['bz_core']:GetPlayer(src)
    if not player then return end

    local tbl    = BZ.Crafting.Tables[tableId]
    if not tbl   then return end
    local recipe = tbl.recipes[recipeIdx]
    if not recipe then return end

    -- Verifica job
    if tbl.jobRequired then
        if not exports['bz_core']:HasJob(src, tbl.jobRequired) then
            TriggerClientEvent('bz:core:notify', src, 'Nu ai permisiunea!', 'error')
            return
        end
    end

    -- Verifica ingredientele
    local charId = player.charId
    local needed = {}
    for _, ing in ipairs(recipe.ingredients) do
        if ing.count > 0 then
            needed[ing.item] = (needed[ing.item] or 0) + ing.count
        end
    end

    -- Verifica stocul
    local checkCount  = 0
    local checkTotal  = 0
    local missingItem = nil
    for item, count in pairs(needed) do checkTotal = checkTotal + 1 end

    if checkTotal == 0 then
        -- Niciun ingredient necesar, fabrica direct
        Docraft(src, charId, recipe)
        return
    end

    for item, count in pairs(needed) do
        exports['bz_core']:HasItem(charId, item, count, function(has, total)
            checkCount = checkCount + 1
            if not has then missingItem = item end
            if checkCount >= checkTotal then
                if missingItem then
                    local itemData = BZ.Items[missingItem]
                    TriggerClientEvent('bz:core:notify', src,
                        'Nu ai destule: ' .. (itemData and itemData.label or missingItem), 'error')
                    return
                end
                -- Scoate ingredientele si fabrica
                local removeCount = 0
                local removeTotal = 0
                for k, _ in pairs(needed) do removeTotal = removeTotal + 1 end

                for ing_item, ing_count in pairs(needed) do
                    exports['bz_core']:RemoveItem(charId, ing_item, ing_count, function()
                        removeCount = removeCount + 1
                        if removeCount >= removeTotal then
                            Docraft(src, charId, recipe)
                        end
                    end)
                end
            end
        end)
    end
end)

function Docraft(src, charId, recipe)
    local count = recipe.resultCount or 1
    exports['bz_core']:AddItem(charId, recipe.result, count, function(ok)
        if ok then
            TriggerClientEvent('bz:inventory:load', src)
            TriggerClientEvent('bz:core:notify', src,
                'Ai fabricat: ' .. count .. 'x ' .. recipe.label, 'success')
        else
            TriggerClientEvent('bz:core:notify', src, 'Eroare la crafting!', 'error')
        end
    end)
end
