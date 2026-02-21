-- ============================================================
-- BZ Core - Client Main
-- ============================================================

BZ.PlayerData = {}
BZ.Loaded     = false

-- ============================================================
-- PLAYER LOADED
-- ============================================================
RegisterNetEvent('bz:core:playerLoaded', function(data)
    BZ.PlayerData = data
    BZ.Loaded     = true
    TriggerEvent('bz:core:playerReady', data)
    TriggerEvent('bz:inventory:load')
    TriggerEvent('bz:hud:show')
    print('^2[BZ Core]^7 Personaj incarcat: ' .. data.name)
end)

-- ============================================================
-- UPDATE MONEY
-- ============================================================
RegisterNetEvent('bz:core:updateMoney', function(moneyData)
    BZ.PlayerData.cash = moneyData.cash
    BZ.PlayerData.bank = moneyData.bank
    TriggerEvent('bz:hud:updateMoney', moneyData)
end)

-- ============================================================
-- UPDATE JOB
-- ============================================================
RegisterNetEvent('bz:core:updateJob', function(jobData)
    BZ.PlayerData.job      = jobData.job
    BZ.PlayerData.jobGrade = jobData.grade
    TriggerEvent('bz:hud:updateJob', jobData)
    TriggerEvent('bz:core:jobChanged', jobData)
end)

-- ============================================================
-- NOTIFICARI
-- ============================================================
RegisterNetEvent('bz:core:notify', function(msg, type, duration)
    TriggerEvent('bz:notifications:show', msg, type, duration)
end)

-- ============================================================
-- SHOW LIST (admin, players list)
-- ============================================================
RegisterNetEvent('bz:core:showList', function(title, list)
    -- Afiseaza o lista simpla ca notificare
    local msg = title .. '\n'
    for _, v in ipairs(list) do
        msg = msg .. v .. '\n'
    end
    TriggerEvent('bz:notifications:show', msg, 'info', 8000)
end)

-- ============================================================
-- ADMIN CLIENT COMMANDS
-- ============================================================
RegisterNetEvent('bz:admin:toggleNoclip', function()
    local ped    = PlayerPedId()
    local active = LocalPlayer.state.noclip or false
    LocalPlayer.state:set('noclip', not active, true)
    if not active then
        SetEntityCollision(ped, false, false)
        TriggerEvent('bz:notifications:show', 'Noclip: ON', 'info')
        CreateThread(function()
            while LocalPlayer.state.noclip do
                Wait(0)
                local speed = 0.5
                if IsControlPressed(0, 21) then speed = 2.0 end  -- SHIFT
                local x,y,z = GetEntityCoords(ped)
                local forward = GetEntityForwardVector(ped)

                if IsControlPressed(0, 32) then -- W
                    SetEntityCoords(ped, x + forward.x*speed, y + forward.y*speed, z, false, false, false, false)
                end
                if IsControlPressed(0, 33) then -- S
                    SetEntityCoords(ped, x - forward.x*speed, y - forward.y*speed, z, false, false, false, false)
                end
                if IsControlPressed(0, 44) then -- Q
                    SetEntityCoords(ped, x, y, z + speed*0.5, false, false, false, false)
                end
                if IsControlPressed(0, 38) then -- E
                    SetEntityCoords(ped, x, y, z - speed*0.5, false, false, false, false)
                end
            end
        end)
    else
        SetEntityCollision(ped, true, true)
        TriggerEvent('bz:notifications:show', 'Noclip: OFF', 'info')
    end
end)

RegisterNetEvent('bz:admin:toggleGod', function()
    local ped    = PlayerPedId()
    local active = LocalPlayer.state.godmode or false
    LocalPlayer.state:set('godmode', not active, true)
    SetEntityInvincible(ped, not active)
    TriggerEvent('bz:notifications:show', 'God Mode: ' .. (not active and 'ON' or 'OFF'), 'info')
end)

RegisterNetEvent('bz:admin:teleport', function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, false)
end)

RegisterNetEvent('bz:admin:freeze', function(frozen)
    FreezeEntityPosition(PlayerPedId(), frozen)
end)

RegisterNetEvent('bz:admin:revive', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    NetworkResurrectLocalPlayer(GetEntityCoords(ped))
    TriggerEvent('bz:notifications:show', 'Ai fost resuscitat!', 'success')
end)

-- ============================================================
-- FUNCTII CLIENT PUBLICE
-- ============================================================

--- Ascunde/arata HUD-ul nativ GTA
---@param show boolean
function BZ.ShowNativeHUD(show)
    DisplayHud(show)
    DisplayRadar(show)
end

--- Returneaza PlayerData curent
function BZ.GetPlayerData()
    return BZ.PlayerData
end
exports('GetPlayerData', BZ.GetPlayerData)

--- Dezactiveaza controluri (cutscene, etc)
---@param disabled boolean
function BZ.DisableControls(disabled)
    if disabled then
        DisableAllControlActions(0)
    else
        EnableAllControlActions(0)
    end
end
