-- ============================================================
-- BZ Ambulance - Client
-- ============================================================

local onDuty = false
local HOSPITAL = { x = 299.0, y = -584.0, z = 43.3 }

CreateThread(function()
    Wait(1000)
    local blip = AddBlipForCoord(HOSPITAL.x, HOSPITAL.y, HOSPITAL.z)
    SetBlipSprite(blip, 61)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Spital')
    EndTextCommandSetBlipName(blip)
end)

AddEventHandler('bz:job:openMenu', function()
    if not BZ.IsJob('ambulance') then return end
    BZ.OpenMenu({
        {
            label = onDuty and '🟥 Iesire din serviciu' or '🟩 Intrare in serviciu',
            cb = function()
                onDuty = not onDuty
                TriggerEvent('bz:notifications:show', onDuty and 'In serviciu!' or 'Iesit din serviciu.', onDuty and 'success' or 'info')
                TriggerServerEvent('bz:ambulance:setDuty', onDuty)
            end,
        },
        { label='🏥 Echipament Medical', disabled=not onDuty, cb=function() OpenMedSupplies() end },
        { label='🚑 Garaj Ambulanta',   disabled=not onDuty, cb=function() TriggerServerEvent('bz:ambulance:spawnVehicle', 'ambulance') end },
        { label='💊 Revive Jucator',    disabled=not onDuty, cb=function() ReviveNearest() end },
        { label='📦 Stash Medical',     cb=function() TriggerServerEvent('bz:inventory:loadStash', 'ambulance_'..GetPlayerServerId(PlayerId())) end },
    }, 'Meniu SMURD', BZ.Jobs['ambulance'] and BZ.Jobs['ambulance'].grades[BZ.PlayerData.jobGrade or 0] and BZ.Jobs['ambulance'].grades[BZ.PlayerData.jobGrade].label or '')
end)

function OpenMedSupplies()
    BZ.OpenMenu({
        { label='🩹 Bandaje (x5)',         price=0, cb=function() TriggerServerEvent('bz:ambulance:giveItem','bandage',5) end },
        { label='🏥 Trusa Prim Ajutor',    price=0, cb=function() TriggerServerEvent('bz:ambulance:giveItem','firstaid',2) end },
        { label='💉 Morfina (x2)',          price=0, cb=function() TriggerServerEvent('bz:ambulance:giveItem','morphine',2) end },
        { label='⚡ Defibrilator',          price=0, cb=function() TriggerServerEvent('bz:ambulance:giveItem','defib',1) end },
    }, 'Echipament Medical', 'Selecteaza')
end

function ReviveNearest()
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local nearest = nil
    local minDist = 5.0

    for _, pid in ipairs(GetActivePlayers()) do
        if pid ~= PlayerId() then
            local tPed = GetPlayerPed(pid)
            local d    = #(coords - GetEntityCoords(tPed))
            if d < minDist and IsEntityDead(tPed) then
                minDist = d
                nearest = GetPlayerServerId(pid)
            end
        end
    end

    if nearest then
        BZ.ProgressBar('Resuscitezi jucatorul...', 8000, function(ok)
            if ok then TriggerServerEvent('bz:ambulance:revive', nearest) end
        end)
    else
        TriggerEvent('bz:notifications:show', 'Nu exista jucatori raniti in apropiere!', 'warning')
    end
end

RegisterNetEvent('bz:ambulance:doRevive', function()
    local ped = PlayerPedId()
    NetworkResurrectLocalPlayer(GetEntityCoords(ped))
    SetEntityHealth(ped, 150)
    TriggerEvent('bz:notifications:show', 'Ai fost resuscitat de SMURD!', 'success')
end)

RegisterNetEvent('bz:ambulance:spawnVeh', function(model)
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do Wait(100) end
    local veh = CreateVehicle(GetHashKey(model), coords.x+3, coords.y, coords.z, GetEntityHeading(ped), true, false)
    SetVehicleNumberPlateText(veh, 'SMURD')
    SetPedIntoVehicle(ped, veh, -1)
    TriggerEvent('bz:notifications:show', 'Ambulanta spawned!', 'success')
end)
