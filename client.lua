-- Apex Tuning - client
local menuOpen = false
local savedVehicleState = nil
local pendingMenuOpen = nil
local menuCam = nil
local camRunning = false
local camAngle, camPitch, camDist = 180.0, 20.0, 6.0

-- Verifică dacă un punct este în interiorul unui poligon (pe plan X,Y; Z ignorat pentru simplitate)
local function pointInPolygon(p, points)
    local n = #points
    local inside = false
    local j = n
    for i = 1, n do
        if ((points[i].y > p.y) ~= (points[j].y > p.y)) and (p.x < (points[j].x - points[i].x) * (p.y - points[i].y) / (points[j].y - points[i].y) + points[i].x) then
            inside = not inside
        end
        j = i
    end
    return inside
end

local function getZoneCenter(points)
    if not points or #points < 1 then return nil end
    local x, y, z = 0.0, 0.0, 0.0
    for i = 1, #points do
        x = x + points[i].x
        y = y + points[i].y
        z = z + points[i].z
    end
    local n = #points
    return vector3(x / n, y / n, z / n)
end

local function isInTuningZone()
    local ped = PlayerPedId()
    if not ped or ped == 0 then return false end
    local coords = GetEntityCoords(ped)
    local p = vector3(coords.x, coords.y, coords.z)
    local zones = Config.Zones or {}
    for i = 1, #zones do
        local z = zones[i]
        if z.points and #z.points >= 3 then
            if pointInPolygon(p, z.points) then return true end
            -- Fallback pe rază (ex. Benny's: parcare/interior) – dacă ești aproape de centrul zonei
            if z.radius and z.radius > 0 then
                local center = getZoneCenter(z.points)
                if center then
                    local dist = #(p - center)
                    if dist <= z.radius then return true end
                end
            end
        end
    end
    return false
end

local function createMenuCamera(veh)
    if not DoesEntityExist(veh) then return end
    camAngle = GetEntityHeading(veh) + 90.0
    camPitch = 20.0
    camDist = 6.0
    camRunning = true
    menuCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(menuCam, true)
    RenderScriptCams(true, true, 800, 1, 0)
    Citizen.CreateThread(function()
        while camRunning and menuCam do
            local vc = GetEntityCoords(veh)
            local a, p = math.rad(camAngle), math.rad(camPitch)
            local cx = vc.x + camDist * math.cos(a) * math.cos(p)
            local cy = vc.y + camDist * math.sin(a) * math.cos(p)
            local cz = vc.z + camDist * math.sin(p)
            SetCamCoord(menuCam, cx, cy, cz)
            PointCamAtCoord(menuCam, vc.x, vc.y, vc.z + 0.6)
            Citizen.Wait(0)
        end
    end)
end

local function destroyMenuCamera()
    camRunning = false
    if menuCam then
        RenderScriptCams(false, true, 500, 1, 0)
        DestroyCam(menuCam, false)
        menuCam = nil
    end
end

local function getVehicle()
    if type(cache) == 'table' and cache.vehicle and cache.vehicle ~= 0 and DoesEntityExist(cache.vehicle) then
        return cache.vehicle
    end
    local ped = PlayerPedId()
    if not ped or ped == 0 then return 0 end
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 or not DoesEntityExist(veh) then
        veh = GetVehiclePedIsIn(ped, true)
    end
    if veh and veh ~= 0 and DoesEntityExist(veh) then return veh end
    local coords = GetEntityCoords(ped)
    local closest = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    if closest and closest ~= 0 and DoesEntityExist(closest) and IsPedInVehicle(ped, closest, false) then
        return closest
    end
    return 0
end

local function buildModList(veh, modType)
    if not DoesEntityExist(veh) then return {} end
    SetVehicleModKit(veh, 0)
    local count = GetNumVehicleMods(veh, modType)
    if type(count) ~= 'number' or count < 0 then count = 0 end
    local current = GetVehicleMod(veh, modType)
    if type(current) ~= 'number' then current = -1 end
    local list = { { id = -1, name = "Stock", equipped = (current == -1) } }
    for i = 0, count - 1 do
        local name = GetModTextLabel(veh, modType, i)
        if name and name ~= '' then
            local loc = GetLabelText(name)
            if loc and loc ~= 'NULL' then name = loc end
        else
            name = 'Option ' .. (i + 1)
        end
        list[#list + 1] = { id = i, name = name, equipped = (current == i) }
    end
    return list
end

local wheelCategories = { [0] = "Sport", [1] = "Muscle", [2] = "Lowrider", [3] = "SUV", [4] = "Offroad", [5] = "Tuner", [6] = "Bike", [7] = "High End" }
local windowTints = { { id = 0, name = "None" }, { id = 1, name = "Pure Black" }, { id = 2, name = "Dark Smoke" }, { id = 3, name = "Light Smoke" }, { id = 4, name = "Stock" }, { id = 5, name = "Limo" }, { id = 6, name = "Green" } }
local plateStyles = { { id = 0, name = "Blue on White 1" }, { id = 1, name = "Blue on White 2" }, { id = 2, name = "Blue on White 3" } }

local function getVehicleData()
    local veh = getVehicle()
    if not veh or veh == 0 or not DoesEntityExist(veh) then return nil end
    SetVehicleModKit(veh, 0)
    Citizen.Wait(0)
    local model = GetEntityModel(veh)
    local name = GetLabelText(GetDisplayNameFromVehicleModel(model))
    if name == 'NULL' or name == '' then name = GetDisplayNameFromVehicleModel(model) end
    local p1, p2 = GetVehicleColours(veh)
    local pearl, wheel = GetVehicleExtraColours(veh)
    local wheelType = GetVehicleWheelType(veh)
    local wheelCountByType = {}
    local wheelNamesByType = {}
    for catId, _ in pairs(wheelCategories) do
        SetVehicleWheelType(veh, catId)
        local nFront = GetNumVehicleMods(veh, 23)
        local nBack = GetNumVehicleMods(veh, 24)
        wheelCountByType[catId] = { front = nFront, back = nBack }
        wheelNamesByType[catId] = {}
        local n = math.max(nFront, nBack)
        for i = 0, n - 1 do
            local lbl = GetModTextLabel(veh, 23, i)
            if lbl and lbl ~= '' then
                local loc = GetLabelText(lbl)
                wheelNamesByType[catId][i] = (loc and loc ~= 'NULL') and loc or ('Option ' .. (i + 1))
            end
        end
    end
    SetVehicleWheelType(veh, wheelType)
    local frontWheelMod = GetVehicleMod(veh, 23)
    local backWheelMod = GetVehicleMod(veh, 24)
    local numFrontWheels = GetNumVehicleMods(veh, 23)
    local numBackWheels = GetNumVehicleMods(veh, 24)
    local neonR, neonG, neonB = GetVehicleNeonLightsColour(veh)
    local neonEnabled = {
        IsVehicleNeonLightEnabled(veh, 0),
        IsVehicleNeonLightEnabled(veh, 1),
        IsVehicleNeonLightEnabled(veh, 2),
        IsVehicleNeonLightEnabled(veh, 3),
    }
    local engineLvl = GetVehicleMod(veh, 11)
    local brakesLvl = GetVehicleMod(veh, 12)
    local transLvl = GetVehicleMod(veh, 13)
    local suspLvl = GetVehicleMod(veh, 15)
    local turboOn = IsToggleModOn(veh, 18)
    local numEngine = GetNumVehicleMods(veh, 11)
    local numBrake = GetNumVehicleMods(veh, 12)
    local numTrans = GetNumVehicleMods(veh, 13)
    local numSusp = GetNumVehicleMods(veh, 15)
    -- Power level 0-100 from performance mods (engine, brakes, transmission, suspension, turbo)
    local powerScore = 0
    if numEngine > 0 then powerScore = powerScore + math.floor((engineLvl + 1) / math.max(numEngine, 1) * 25) end
    if numBrake > 0 then powerScore = powerScore + math.floor((brakesLvl + 1) / math.max(numBrake, 1) * 20) end
    if numTrans > 0 then powerScore = powerScore + math.floor((transLvl + 1) / math.max(numTrans, 1) * 25) end
    if numSusp > 0 then powerScore = powerScore + math.floor((suspLvl + 1) / math.max(numSusp, 1) * 15) end
    if turboOn then powerScore = powerScore + 15 end
    powerScore = math.min(100, powerScore)
    -- Tax class 1-5 (placeholder; will come from vehicle.lua later)
    local taxClass = math.max(1, math.min(5, math.floor(powerScore / 20) + 1))

    local data = {
        name = name,
        model = GetEntityModel(veh),
        plate = GetVehicleNumberPlateText(veh),
        plateStyle = GetVehicleNumberPlateTextIndex(veh),
        windowTint = GetVehicleWindowTint(veh),
        primaryColor = p1,
        secondaryColor = p2,
        pearlColor = pearl,
        wheelColor = wheel,
        neonEnabled = neonEnabled,
        neonColor = { r = neonR, g = neonG, b = neonB },
        xenon = IsToggleModOn(veh, 22),
        turbo = IsToggleModOn(veh, 18),
        wheelType = wheelType,
        frontWheelMod = frontWheelMod,
        backWheelMod = backWheelMod,
        numFrontWheels = numFrontWheels,
        numBackWheels = numBackWheels,
        wheelCountByType = wheelCountByType,
        wheelNamesByType = wheelNamesByType,
        engine = engineLvl,
        brakes = brakesLvl,
        transmission = transLvl,
        suspension = suspLvl,
        armor = GetVehicleMod(veh, 16),
        numEngineMods = numEngine,
        numBrakeMods = numBrake,
        numTransmissionMods = numTrans,
        numSuspensionMods = numSusp,
        numArmorMods = GetNumVehicleMods(veh, 16),
        powerLevel = powerScore,
        taxClass = taxClass,
        spoilerMods = buildModList(veh, 0),
        frontBumpers = buildModList(veh, 1),
        rearBumpers = buildModList(veh, 2),
        sideSkirts = buildModList(veh, 3),
        exhaustMods = buildModList(veh, 4),
        hoodMods = buildModList(veh, 7),
        grilleMods = buildModList(veh, 6),
        roofMods = buildModList(veh, 10),
        frameMods = buildModList(veh, 5),
        leftFenderMods = buildModList(veh, 8),
        rightFenderMods = buildModList(veh, 9),
        engineBlockMods = buildModList(veh, 39),
        airFilterMods = buildModList(veh, 40),
        trimMods = buildModList(veh, 27),
        liveryMods = buildModList(veh, 48),
        seatMods = buildModList(veh, 32),
        steeringMods = buildModList(veh, 33),
        hornMods = buildModList(veh, 14),
        colors = {},
        windowTints = windowTints,
        plateStyles = plateStyles,
        wheelCategories = wheelCategories,
        stageLabels = { [-1] = "Stock", [0] = "Level I", [1] = "Level II", [2] = "Level III", [3] = "Level IV" },
        suspensionLabels = {},
        armorLabels = {},
    }
    -- Minimal color list so UI doesn't break
    for i = 0, 50 do
        data.colors[i + 1] = { id = i, name = "Color " .. i, hex = "#333333" }
    end
    return data
end

local function applyOneMod(veh, data)
    if not DoesEntityExist(veh) then return end
    SetVehicleModKit(veh, 0)
    local t = data.type
    local val = tonumber(data.value)
    if t == 'primaryColor' then
        local _, p2cur = GetVehicleColours(veh)
        SetVehicleColours(veh, val, p2cur)
    elseif t == 'secondaryColor' then
        local p1 = GetVehicleColours(veh)
        SetVehicleColours(veh, p1, val)
    elseif t == 'pearlColor' then
        local _, wc = GetVehicleExtraColours(veh)
        SetVehicleExtraColours(veh, val, wc)
    elseif t == 'wheelColor' then
        local pc = GetVehicleExtraColours(veh)
        SetVehicleExtraColours(veh, pc, val)
    elseif t == 'windowTint' then
        SetVehicleWindowTint(veh, val)
    elseif t == 'plateStyle' then
        SetVehicleNumberPlateTextIndex(veh, val)
    elseif t == 'wheelType' then
        SetVehicleWheelType(veh, val)
    elseif t == 'frontWheel' then
        SetVehicleMod(veh, 23, val, false)
    elseif t == 'backWheel' then
        SetVehicleMod(veh, 24, val, false)
    elseif t == 'turbo' then
        ToggleVehicleMod(veh, 18, val == 1)
    elseif t == 'xenon' then
        ToggleVehicleMod(veh, 22, val == 1)
    elseif t == 'neonToggle' then
        local pos = tonumber(data.pos)
        if pos ~= nil then SetVehicleNeonLightEnabled(veh, pos, val == 1) end
    elseif t == 'neonColor' then
        SetVehicleNeonLightsColour(veh, tonumber(data.r) or 0, tonumber(data.g) or 0, tonumber(data.b) or 0)
    elseif t == 'engine' then SetVehicleMod(veh, 11, val, false)
    elseif t == 'brakes' then SetVehicleMod(veh, 12, val, false)
    elseif t == 'transmission' then SetVehicleMod(veh, 13, val, false)
    elseif t == 'suspension' then SetVehicleMod(veh, 15, val, false)
    elseif t == 'armor' then SetVehicleMod(veh, 16, val, false)
    elseif t == 'spoiler' then SetVehicleMod(veh, 0, val, false)
    elseif t == 'frontBumper' then SetVehicleMod(veh, 1, val, false)
    elseif t == 'rearBumper' then SetVehicleMod(veh, 2, val, false)
    elseif t == 'sideSkirt' then SetVehicleMod(veh, 3, val, false)
    elseif t == 'exhaust' then SetVehicleMod(veh, 4, val, false)
    elseif t == 'hood' then SetVehicleMod(veh, 7, val, false)
    elseif t == 'grille' then SetVehicleMod(veh, 6, val, false)
    elseif t == 'roof' then SetVehicleMod(veh, 10, val, false)
    elseif t == 'frame' then SetVehicleMod(veh, 5, val, false)
    elseif t == 'leftFender' then SetVehicleMod(veh, 8, val, false)
    elseif t == 'rightFender' then SetVehicleMod(veh, 9, val, false)
    elseif t == 'engineBlock' then SetVehicleMod(veh, 39, val, false)
    elseif t == 'airFilter' then SetVehicleMod(veh, 40, val, false)
    elseif t == 'trim' then SetVehicleMod(veh, 27, val, false)
    elseif t == 'livery' then SetVehicleMod(veh, 48, val, false)
    elseif t == 'seats' then SetVehicleMod(veh, 32, val, false)
    elseif t == 'steeringWheel' then SetVehicleMod(veh, 33, val, false)
    elseif t == 'horn' then SetVehicleMod(veh, 14, val, false)
    end
end

RegisterNetEvent('apex_tuning:paySuccess')
AddEventHandler('apex_tuning:paySuccess', function()
    savedVehicleState = nil
    menuOpen = false
    SetNuiFocus(false, false)
    destroyMenuCamera()
    SendNUIMessage({ type = 'close' })
end)

-- Server cere props după plată; trimitem și închidem meniul
RegisterNetEvent('apex_tuning:sendPropsThenClose')
AddEventHandler('apex_tuning:sendPropsThenClose', function()
    local veh = getVehicle()
    local props = veh and DoesEntityExist(veh) and getVehicleProperties(veh) or nil
    if props then
        TriggerServerEvent('apex_tuning:saveVehicleProps', props)
    end
    TriggerEvent('apex_tuning:paySuccess')
end)

RegisterNetEvent('apex_tuning:receiveVehicleInfo')
AddEventHandler('apex_tuning:receiveVehicleInfo', function(info)
    if not pendingMenuOpen or not pendingMenuOpen.data then return end
    local data = pendingMenuOpen.data
    data.baseHp = (info and tonumber(info.hp)) or 100
    data.baseSpeed = (info and tonumber(info.speed)) or 200
    data.baseClass = (info and tostring(info.class)) or 'D'
    pendingMenuOpen = nil
    local veh = getVehicle()
    if not veh or veh == 0 or not DoesEntityExist(veh) then return end
    savedVehicleState = data
    menuOpen = true
    SetNuiFocus(true, true)
    createMenuCamera(veh)
    SendNUIMessage({ type = 'open', data = data, cash = 0, card = 0 })
    TriggerServerEvent('apex_tuning:getMoney')
end)

RegisterNetEvent('apex_tuning:receiveMoney')
AddEventHandler('apex_tuning:receiveMoney', function(money)
    if not menuOpen then return end
    SendNUIMessage({
        type = 'updateMoney',
        cash = money and money.cash or 0,
        card = money and money.card or 0,
    })
end)

-- Deschidere din server (comanda /tuning pentru staff) - bypassZone = true ignoră zona
RegisterNetEvent('apex_tuning:open')
AddEventHandler('apex_tuning:open', function(bypassZone)
    local veh = getVehicle()
    if not DoesEntityExist(veh) then
        TriggerEvent('chat:addMessage', { args = { Config and Config.Messages and Config.Messages.NotInVehicle or 'Intră în mașină!' } })
        return
    end
    openMenu(bypassZone == true)
end)

function openMenu(bypassZone)
    if not bypassZone and not isInTuningZone() then
        local msg = Config and Config.Messages and Config.Messages.NotInZone or '[Apex Tuning] Poți folosi tuning-ul doar în garajele de tuning.'
        TriggerEvent('chat:addMessage', { args = { msg } })
        return
    end
    local veh = getVehicle()
    if not veh or veh == 0 or not DoesEntityExist(veh) then
        TriggerEvent('chat:addMessage', { args = { Config and Config.Messages and Config.Messages.NotInVehicle or '[Apex Tuning] Intră în mașină.' } })
        return
    end
    local ok, data = pcall(function() return getVehicleData() end)
    if not ok then
        TriggerEvent('chat:addMessage', { args = { '[Apex Tuning] Eroare: ' .. tostring(data) } })
        return
    end
    if not data then
        TriggerEvent('chat:addMessage', { args = { '[Apex Tuning] Nu s-au putut încărca datele.' } })
        return
    end
    pendingMenuOpen = { data = data }
    TriggerServerEvent('apex_tuning:getVehicleInfo', data.model)
end

RegisterNUICallback('mouseMove', function(data, cb)
    if not menuOpen or not menuCam then cb({}); return end
    local dx = tonumber(data.dx) or 0
    local dy = tonumber(data.dy) or 0
    camAngle = camAngle + dx * 0.35
    camPitch = math.max(-25.0, math.min(65.0, camPitch - dy * 0.25))
    cb({})
end)

RegisterNUICallback('close', function(_, cb)
    menuOpen = false
    SetNuiFocus(false, false)
    destroyMenuCamera()
    SendNUIMessage({ type = 'close' })
    cb({})
end)

RegisterNUICallback('buy', function(data, cb)
    local total = tonumber(data.total) or 0
    if total < 0 then total = 0 end
    TriggerServerEvent('apex_tuning:pay', total)
    cb({ ok = true })
end)

RegisterNUICallback('applyMod', function(data, cb)
    local veh = getVehicle()
    if DoesEntityExist(veh) then applyOneMod(veh, data) end
    cb({})
end)

RegisterNUICallback('applyAllMods', function(data, cb)
    local veh = getVehicle()
    if not DoesEntityExist(veh) then cb({}); return end
    SetVehicleModKit(veh, 0)
    local mods = data.mods or {}
    for i = 1, #mods do applyOneMod(veh, mods[i]) end
    cb({})
end)

-- Proprietăți vehicul pentru salvare în baza de date (player_vehicles.mods).
-- Salvăm TOATE modificările (mod 0-49 + wheelType + toggle-uri), chiar dacă mașina curentă nu le are.
-- Altă mașină poate folosi acest profil și aplică doar modurile pe care le suportă.
local function getVehicleProperties(veh)
    if not DoesEntityExist(veh) then return nil end
    SetVehicleModKit(veh, 0)
    local p1, p2 = GetVehicleColours(veh)
    local pearl, wheelCol = GetVehicleExtraColours(veh)
    local neonR, neonG, neonB = GetVehicleNeonLightsColour(veh)
    local props = {
        model = GetEntityModel(veh),
        plate = GetVehicleNumberPlateText(veh),
        plateIndex = GetVehicleNumberPlateTextIndex(veh),
        bodyHealth = GetVehicleBodyHealth(veh),
        engineHealth = GetVehicleEngineHealth(veh),
        tankHealth = GetVehiclePetrolTankHealth(veh),
        fuelLevel = GetVehicleFuelLevel(veh),
        dirtLevel = GetVehicleDirtLevel(veh),
        color1 = p1,
        color2 = p2,
        pearlescentColor = pearl,
        wheelColor = wheelCol,
        dashboardColor = GetVehicleDashboardColour(veh),
        interiorColor = GetVehicleInteriorColour(veh),
        windowTint = GetVehicleWindowTint(veh),
        neonEnabled = {
            IsVehicleNeonLightEnabled(veh, 0),
            IsVehicleNeonLightEnabled(veh, 1),
            IsVehicleNeonLightEnabled(veh, 2),
            IsVehicleNeonLightEnabled(veh, 3),
        },
        neonColor = { neonR, neonG, neonB },
        xenonColor = GetVehicleXenonLightsColour(veh),
        modWheelType = GetVehicleWheelType(veh),
        -- Toggle-uri (nitro, turbo, tire smoke, xenon)
        toggle17 = IsToggleModOn(veh, 17),
        toggle18 = IsToggleModOn(veh, 18),
        toggle20 = IsToggleModOn(veh, 20),
        toggle22 = IsToggleModOn(veh, 22),
    }
    -- Toate modurile 0-49 (inclusiv -1 dacă mașina nu are opțiune) – pentru orice mașină care le suportă
    for i = 0, 49 do
        props["mod" .. i] = GetVehicleMod(veh, i)
    end
    -- Alias-uri pentru compatibilitate qbx_customs / ox_lib
    props.modEngine = props.mod11
    props.modBrakes = props.mod12
    props.modTransmission = props.mod13
    props.modSuspension = props.mod15
    props.modArmor = props.mod16
    props.modTurbo = props.toggle18
    props.modSmokeEnabled = props.toggle20
    props.modXenon = props.toggle22
    props.modFrontWheels = props.mod23
    props.modBackWheels = props.mod24
    props.modFrontBumper = props.mod1
    props.modRearBumper = props.mod2
    props.modSideSkirt = props.mod3
    props.modExhaust = props.mod4
    props.modFrame = props.mod5
    props.modGrille = props.mod6
    props.modHood = props.mod7
    props.modFender = props.mod8
    props.modRightFender = props.mod9
    props.modRoof = props.mod10
    props.modSpoilers = props.mod0
    props.modTrimA = props.mod27
    props.modLivery = props.mod48
    props.modSeats = props.mod32
    props.modSteeringWheel = props.mod33
    props.modHorns = props.mod14
    props.modEngineBlock = props.mod39
    props.modAirFilter = props.mod40
    return props
end

exports('OpenMenu', function()
    if menuOpen then return false end
    local veh = getVehicle()
    if not veh or veh == 0 or not DoesEntityExist(veh) then return false end
    openMenu()
    return true
end)

-- Deschidere din zonă (tasta E sau /apexopen) - doar în garajele de tuning
RegisterCommand('apexopen', function()
    if menuOpen then return end
    openMenu(false)
end, false)

RegisterKeyMapping('apex_tuning_open', 'Deschide Apex Tuning', 'keyboard', (Config and Config.OpenKey) or 'e')

-- În garajele de tuning: intri cu mașina și apeși E – se deschide meniul (fără comandă)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen then
            if IsControlJustPressed(0, 200) then -- ESC
                menuOpen = false
                SetNuiFocus(false, false)
                destroyMenuCamera()
                SendNUIMessage({ type = 'close' })
            end
        else
            -- Nu e deschis meniul: dacă ești în mașină și în zonă de tuning, E deschide
            local veh = getVehicle()
            if veh and veh ~= 0 and DoesEntityExist(veh) and isInTuningZone() then
                if IsControlJustPressed(0, 38) then -- E (INPUT_PICKUP)
                    openMenu(false)
                end
            end
        end
    end
end)
