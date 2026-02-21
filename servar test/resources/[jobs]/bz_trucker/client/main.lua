-- ============================================================
-- BZ Trucker - Client
-- ============================================================

local onDuty      = false
local activeJob   = nil
local deliveryBlip= nil

local DEPOT = { x = 14.0, y = -1896.0, z = 24.0 }

-- Rute de livrare disponibile
local ROUTES = {
    {
        pickup   = { x = 14.0,    y = -1896.0, z = 24.0,   label = 'Depozit Port LS' },
        delivery = { x = 1736.0,  y = 4658.0,  z = 42.0,   label = 'Sandy Shores' },
        cargo    = 'Containere',
        minPay   = 2500, maxPay = 4000,
    },
    {
        pickup   = { x = 14.0,    y = -1896.0, z = 24.0,   label = 'Depozit Port LS' },
        delivery = { x = -1155.0, y = -1461.0, z = 4.0,    label = 'Aeroport' },
        cargo    = 'Marfa Perisabila',
        minPay   = 1500, maxPay = 2500,
    },
    {
        pickup   = { x = -2076.0, y = 2914.0,  z = 32.0,   label = 'Fabrica Paleto' },
        delivery = { x = -1393.0, y = -617.0,  z = 30.0,   label = 'Del Perro' },
        cargo    = 'Materiale Constructii',
        minPay   = 3000, maxPay = 5000,
    },
    {
        pickup   = { x = 2676.0,  y = 3280.0,  z = 55.0,   label = 'Mina Grapeseed' },
        delivery = { x = 224.0,   y = -967.0,  z = 30.0,   label = 'Centru LS' },
        cargo    = 'Minereuri',
        minPay   = 4000, maxPay = 6500,
    },
}

CreateThread(function()
    Wait(1000)
    local blip = AddBlipForCoord(DEPOT.x, DEPOT.y, DEPOT.z)
    SetBlipSprite(blip, 477)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 47)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Baza Camioane')
    EndTextCommandSetBlipName(blip)
end)

-- ============================================================
-- MENIU JOB
-- ============================================================
AddEventHandler('bz:job:openMenu', function()
    if not BZ.IsJob('trucker') then return end
    BZ.OpenMenu({
        {
            label = onDuty and '🟥 Iesire din serviciu' or '🟩 Intrare in serviciu',
            cb = function()
                onDuty = not onDuty
                TriggerEvent('bz:notifications:show', onDuty and 'In serviciu!' or 'Iesit.', onDuty and 'success' or 'info')
                TriggerServerEvent('bz:trucker:setDuty', onDuty)
            end,
        },
        {
            label = '📋 Ia Ruta de Livrare',
            disabled = not onDuty or activeJob ~= nil,
            description = activeJob and 'Ai deja o ruta activa!' or 'Preia o comanda noua',
            cb = function() OpenRouteMenu() end,
        },
        {
            label = '❌ Anuleaza Ruta Curenta',
            disabled = activeJob == nil,
            cb = function() CancelRoute() end,
        },
        {
            label = '🚛 Ia Camion',
            disabled = not onDuty,
            cb = function() TriggerServerEvent('bz:trucker:spawnTruck') end,
        },
    }, 'Meniu Sofer TIR', BZ.Jobs['trucker'] and BZ.Jobs['trucker'].grades[BZ.PlayerData.jobGrade or 0] and BZ.Jobs['trucker'].grades[BZ.PlayerData.jobGrade].label or '')
end)

function OpenRouteMenu()
    local opts = {}
    for i, route in ipairs(ROUTES) do
        table.insert(opts, {
            label       = '🚛 ' .. route.cargo,
            description = route.pickup.label .. ' → ' .. route.delivery.label,
            price       = math.random(route.minPay, route.maxPay),
            cb          = function()
                local pay = math.random(route.minPay, route.maxPay)
                StartRoute(route, pay)
            end,
        })
    end
    BZ.OpenMenu(opts, 'Rute Disponibile', 'Selecteaza o comanda')
end

function StartRoute(route, pay)
    activeJob = { route = route, pay = pay, phase = 'pickup' }

    -- Blip punct ridicare
    if deliveryBlip then RemoveBlip(deliveryBlip) end
    deliveryBlip = AddBlipForCoord(route.pickup.x, route.pickup.y, route.pickup.z)
    SetBlipSprite(deliveryBlip, 478)
    SetBlipColour(deliveryBlip, 47)
    SetBlipRoute(deliveryBlip, true)
    SetBlipRouteColour(deliveryBlip, 47)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Punct ridicare: ' .. route.pickup.label)
    EndTextCommandSetBlipName(deliveryBlip)

    TriggerEvent('bz:notifications:show',
        'Ruta preluata! Mergi la: ' .. route.pickup.label .. '\nMarfa: ' .. route.cargo .. '\nPlata: ' .. pay .. ' lei',
        'success', 8000)

    MonitorRoute()
end

function MonitorRoute()
    CreateThread(function()
        while activeJob do
            Wait(1000)
            local ped    = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local phase  = activeJob.phase
            local target = phase == 'pickup' and activeJob.route.pickup or activeJob.route.delivery
            local dist   = #(coords - vector3(target.x, target.y, target.z))

            if dist < 15.0 then
                BeginTextCommandDisplayHelp('STRING')
                if phase == 'pickup' then
                    AddTextComponentSubstringPlayerName('[E] - Incarca marfa: ' .. activeJob.route.cargo)
                else
                    AddTextComponentSubstringPlayerName('[E] - Livreaza marfa la ' .. target.label)
                end
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustPressed(0, 38) then
                    if phase == 'pickup' then
                        -- Merge la livrare
                        activeJob.phase = 'delivery'
                        RemoveBlip(deliveryBlip)
                        deliveryBlip = AddBlipForCoord(activeJob.route.delivery.x, activeJob.route.delivery.y, activeJob.route.delivery.z)
                        SetBlipSprite(deliveryBlip, 478)
                        SetBlipColour(deliveryBlip, 2)
                        SetBlipRoute(deliveryBlip, true)
                        TriggerEvent('bz:notifications:show', 'Marfa incarcata! Livreaza la: ' .. activeJob.route.delivery.label, 'success')
                    else
                        -- Livrare finalizata
                        CompleteRoute()
                    end
                end
            end
        end
    end)
end

function CompleteRoute()
    if not activeJob then return end
    local pay = activeJob.pay
    TriggerServerEvent('bz:trucker:completeJob', pay, activeJob.route.cargo)
    if deliveryBlip then RemoveBlip(deliveryBlip) deliveryBlip = nil end
    TriggerEvent('bz:notifications:show', 'Livrare finalizata! Ai primit ' .. pay .. ' lei', 'success', 6000)
    activeJob = nil
end

function CancelRoute()
    if deliveryBlip then RemoveBlip(deliveryBlip) deliveryBlip = nil end
    activeJob = nil
    TriggerEvent('bz:notifications:show', 'Ruta anulata.', 'warning')
end

RegisterNetEvent('bz:trucker:spawnedTruck', function(model)
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do Wait(100) end
    local veh = CreateVehicle(GetHashKey(model), coords.x+5, coords.y, coords.z, GetEntityHeading(ped), true, false)
    SetPedIntoVehicle(ped, veh, -1)
    TriggerEvent('bz:notifications:show', 'Camion spawnat!', 'success')
end)
