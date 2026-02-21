-- ============================================================
-- BZ HUD - Client
-- ============================================================

local hudVisible = false
local lastSent   = {}

-- Ascunde HUD-ul nativ GTA
AddEventHandler('bz:hud:show', function()
    hudVisible = true
    DisplayHud(false)
    DisplayRadar(true)
    SendNUIMessage({ action = 'show' })
end)

AddEventHandler('bz:hud:hide', function()
    hudVisible = false
    SendNUIMessage({ action = 'hide' })
end)

-- Update bani
AddEventHandler('bz:hud:updateMoney', function(data)
    SendNUIMessage({
        action = 'updateMoney',
        cash   = data.cash,
        bank   = data.bank,
    })
end)

-- Update job
AddEventHandler('bz:hud:updateJob', function(data)
    SendNUIMessage({
        action     = 'updateJob',
        jobLabel   = data.label      or 'Somer',
        gradeLabel = data.gradeLabel or '',
    })
end)

-- Thread principal - update stats
CreateThread(function()
    while true do
        Wait(500)
        if not hudVisible then goto continue end

        local ped    = PlayerPedId()
        local health = math.max(0, GetEntityHealth(ped) - 100)   -- 0-100
        local armor  = GetPedArmour(ped)                          -- 0-100
        local hunger = GetPlayerMaxStamina(PlayerId()) or 100
        local thirst = 80  -- placeholder

        -- Viteza vehicul
        local speed   = 0
        local inVeh   = IsPedInAnyVehicle(ped, false)
        if inVeh then
            local veh = GetVehiclePedIsIn(ped, false)
            speed = math.floor(GetEntitySpeed(veh) * 3.6)  -- km/h
        end

        -- Trimitere la UI (doar daca s-a schimbat)
        local data = {
            action = 'updateStats',
            health = health,
            armor  = armor,
            speed  = speed,
            inVeh  = inVeh,
            cash   = BZ.PlayerData.cash or 0,
            bank   = BZ.PlayerData.bank or 0,
            job    = BZ.PlayerData.job  or 'unemployed',
        }

        if data.health ~= lastSent.health or data.armor ~= lastSent.armor or data.speed ~= lastSent.speed then
            SendNUIMessage(data)
            lastSent = data
        end

        ::continue::
    end
end)

-- Update job la schimbare
AddEventHandler('bz:core:jobChanged', function(jobData)
    if type(jobData) == 'table' then
        local jobDef = BZ.Jobs[jobData.job or jobData]
        SendNUIMessage({
            action     = 'updateJob',
            jobLabel   = jobDef and jobDef.label or 'Somer',
            gradeLabel = jobData.gradeLabel or '',
        })
    end
end)

-- Ready
AddEventHandler('bz:core:playerReady', function(data)
    local jobDef = BZ.Jobs[data.job or 'unemployed']
    SendNUIMessage({
        action     = 'init',
        cash       = data.cash  or 0,
        bank       = data.bank  or 0,
        jobLabel   = jobDef and jobDef.label or 'Somer',
        gradeLabel = (jobDef and jobDef.grades[data.jobGrade or 0]) and jobDef.grades[data.jobGrade].label or '',
        name       = data.name  or '',
    })
end)
