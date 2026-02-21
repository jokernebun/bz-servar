-- ============================================================
-- BZ Mechanic - Client
-- ============================================================

local onDuty = false
local GARAGE = { x = -352.0, y = -133.0, z = 39.0 }

CreateThread(function()
    Wait(1000)
    local blip = AddBlipForCoord(GARAGE.x, GARAGE.y, GARAGE.z)
    SetBlipSprite(blip, 446)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Atelier Mecanic')
    EndTextCommandSetBlipName(blip)
end)

AddEventHandler('bz:job:openMenu', function()
    if not BZ.IsJob('mechanic') then return end
    BZ.OpenMenu({
        {
            label = onDuty and '🟥 Iesire din serviciu' or '🟩 Intrare in serviciu',
            cb = function()
                onDuty = not onDuty
                TriggerEvent('bz:notifications:show', onDuty and 'In serviciu!' or 'Iesit.', onDuty and 'success' or 'info')
                TriggerServerEvent('bz:mechanic:setDuty', onDuty)
            end,
        },
        { label='🔧 Repara Vehicul Apropiat',  disabled=not onDuty, description='Repara vehiculul din apropiere',  cb=function() RepairNearestVehicle() end },
        { label='🚗 Repara Anvelope',          disabled=not onDuty, description='Repara anvelopele vehiculului',   cb=function() FixTires() end },
        { label='⛽ Umple Rezervor',           disabled=not onDuty, cb=function() RefuelVehicle() end },
        { label='🛠️ Ia Scule',                 disabled=not onDuty, cb=function() TriggerServerEvent('bz:mechanic:giveTools') end },
        { label='📦 Stash Atelier',            cb=function() TriggerServerEvent('bz:inventory:loadStash', 'mechanic_stash') end },
    }, 'Meniu Mecanic', BZ.Jobs['mechanic'] and BZ.Jobs['mechanic'].grades[BZ.PlayerData.jobGrade or 0] and BZ.Jobs['mechanic'].grades[BZ.PlayerData.jobGrade].label or '')
end)

function RepairNearestVehicle()
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh    = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    if not DoesEntityExist(veh) then
        TriggerEvent('bz:notifications:show', 'Nu exista vehicul in apropiere!', 'warning') return
    end

    BZ.ProgressBar('Se repara vehiculul...', 10000, function(ok)
        if ok then
            SetVehicleFixed(veh)
            SetVehicleDirtLevel(veh, 0.0)
            TriggerEvent('bz:notifications:show', 'Vehicul reparat complet!', 'success')
            TriggerServerEvent('bz:mechanic:chargeRepair', GetPlayerServerId(GetPedSourcePlayer(GetVehicleDriver(veh))), 500)
        end
    end)
end

function FixTires()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    if not DoesEntityExist(veh) then TriggerEvent('bz:notifications:show', 'Fara vehicul!', 'warning') return end
    BZ.ProgressBar('Repara anvelopele...', 6000, function(ok)
        if ok then
            for i = 0, 7 do SetVehicleTyreFixy(veh, i, true) end
            TriggerEvent('bz:notifications:show', 'Anvelope reparate!', 'success')
        end
    end)
end

function RefuelVehicle()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        TriggerEvent('bz:notifications:show', 'Trebuie sa fii in vehicul!', 'warning') return
    end
    local veh = GetVehiclePedIsIn(ped, false)
    BZ.ProgressBar('Se umple rezervorul...', 8000, function(ok)
        if ok then
            SetVehicleFuelLevel(veh, 100.0)
            TriggerEvent('bz:notifications:show', 'Rezervor plin!', 'success')
        end
    end)
end

RegisterNetEvent('bz:mechanic:receiveTools', function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey('WEAPON_HAMMER'), 1, false, true)
    TriggerEvent('bz:notifications:show', 'Scule primite!', 'success')
end)
