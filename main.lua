-- Garaje server: standalone – gestionează vehiculele folosind qbx_vehicles (fără qbx_garages)

local State = {
    OUT = 0,
    GARAGED = 1,
    IMPOUNDED = 2,
}

local function getPlayer(source)
    return exports.qbx_core:GetPlayer(source)
end

-- Lista de garaje disponibilă pe server
local Garages = Config.Garages or {}

-- Callback: vehiculele jucătorului pentru un garaj
lib.callback.register('garaje:server:getGarageVehicles', function(source, garageName)
    local player = getPlayer(source)
    if not player then return end

    local garage = Garages[garageName]
    if not garage then return end

    local citizenid = player.PlayerData.citizenid
    local filters = {
        citizenid = citizenid,
        states = garage.states or State.GARAGED,
    }

    if not garage.skipGarageCheck then
        filters.garage = garageName
    end

    local vehicles = exports.qbx_vehicles:GetPlayerVehicles(filters)
    if not vehicles or not vehicles[1] then return end
    return vehicles
end)

-- Callback: spawn vehicul din garaj
lib.callback.register('garaje:server:spawnVehicle', function(source, vehicleId, garageName, accessPointIndex)
    local player = getPlayer(source)
    if not player then return end

    local garage = Garages[garageName]
    if not garage then return end

    local accessPoints = garage.accessPoints or {}
    local ap = accessPoints[accessPointIndex or 1]
    if not ap or not ap.coords then return end

    local spawn = ap.spawn or ap.coords
    local ped = GetPlayerPed(source)
    if #(GetEntityCoords(ped) - vec3(ap.coords.x, ap.coords.y, ap.coords.z)) > 5.0 then
        exports.qbx_core:Notify(source, 'Ești prea departe de garaj.', 'error')
        return
    end

    local nearVeh = lib.getClosestVehicle(vec3(spawn.x, spawn.y, spawn.z), 4.0, false)
    if nearVeh then
        exports.qbx_core:Notify(source, 'Nu este loc liber pentru spawn.', 'error')
        return
    end

    local playerVehicle = exports.qbx_vehicles:GetPlayerVehicle(vehicleId)
    if not playerVehicle or not playerVehicle.props then
        exports.qbx_core:Notify(source, 'Vehicul invalid sau nu îți aparține.', 'error')
        return
    end

    local warpPed = ped
    local netId, veh = qbx.spawnVehicle({
        spawnSource = spawn,
        model = playerVehicle.props.model,
        props = playerVehicle.props,
        warp = warpPed,
    })

    if not veh or veh == 0 then
        exports.qbx_core:Notify(source, 'Nu s-a putut spawna vehiculul.', 'error')
        return
    end

    Entity(veh).state:set('vehicleid', vehicleId, false)
    exports.qbx_vehicles:SaveVehicle(veh, {
        state = State.OUT,
        garage = garageName,
        coords = spawn,
    })

    return netId
end)

-- Callback: parcare vehicul în garaj
lib.callback.register('garaje:server:parkVehicle', function(source, netId, props, garageName)
    local player = getPlayer(source)
    if not player then return false end

    local garage = Garages[garageName]
    if not garage then return false end

    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or not DoesEntityExist(veh) then return false end

    local success, err = exports.qbx_vehicles:SaveVehicle(veh, {
        state = State.GARAGED,
        garage = garageName,
        props = props,
    })

    if not success then
        return false
    end

    -- pe server folosim DeleteEntity pentru a șterge vehiculul
    DeleteEntity(veh)
    return true
end)

-- Comandă /dvgaraj: șterge vehiculul; dacă e al jucătorului, îl pune în garaj (nu la impound).
-- /dv rămâne cel original din qbx_core (doar șterge).
lib.addCommand('dvgaraj', {
    help = 'Șterge vehiculul; dacă e deținut, ajunge în garaj',
    params = {
        { name = 'radius', help = 'Rază (opțional)', type = 'number', optional = true }
    },
    restricted = 'group.admin'
}, function(source, args)
    if exports.qbx_core and exports.qbx_core.IsOptin and not exports.qbx_core:IsOptin(source) then
        exports.qbx_core:Notify(source, 'Trebuie să fii opt-in pentru comenzi admin.', 'error')
        return
    end

    local ped = GetPlayerPed(source)
    local pedCars = { GetVehiclePedIsIn(ped, false) }
    local radius = args.radius

    if pedCars[1] == 0 or radius then
        pedCars = lib.callback.await('qbx_core:client:getVehiclesInRadius', source, radius or 5.0)
    else
        pedCars[1] = NetworkGetNetworkIdFromEntity(pedCars[1])
    end

    local garageName = Config.DvStoredGarage or 'pdmgarage'
    if not Garages[garageName] then
        garageName = 'pdmgarage'
    end

    for i = 1, #pedCars do
        local netId = type(pedCars[i]) == 'number' and pedCars[i] or nil
        if not netId then goto continue end
        local veh = NetworkGetEntityFromNetworkId(netId)
        if not veh or not DoesEntityExist(veh) then goto continue end

        exports.qbx_vehicles:SaveVehicle(veh, {
            state = State.GARAGED,
            garage = garageName,
        })

        DeleteEntity(veh)
        ::continue::
    end
end)
