local menuOpen = false

-- Paint type labels
local paintTypes = {
    [0] = "Normal", [1] = "Metallic", [2] = "Pearl", [3] = "Matte",
    [4] = "Metal", [5] = "Chrome"
}

-- GTA V color palette (index, name, hex)
local colors = {
    { id=0,  name="Black",          hex="#0f0f0f" },
    { id=1,  name="Carbon Black",   hex="#1a1a1a" },
    { id=2,  name="Graphite",       hex="#2d2d2d" },
    { id=3,  name="Anthracite",     hex="#3d3d3d" },
    { id=4,  name="Black Steel",    hex="#4a4a4a" },
    { id=5,  name="Dark Steel",     hex="#555555" },
    { id=6,  name="Silver",         hex="#c0c0c0" },
    { id=7,  name="Bluish Silver",  hex="#aab4c0" },
    { id=8,  name="Rolled Steel",   hex="#888888" },
    { id=9,  name="Shadow Silver",  hex="#999999" },
    { id=10, name="Stone Silver",   hex="#b0b0b0" },
    { id=11, name="Midnight Silver",hex="#d0d0d0" },
    { id=12, name="Cast Iron",      hex="#e0e0e0" },
    { id=13, name="Red",            hex="#c0392b" },
    { id=14, name="Torino Red",     hex="#e74c3c" },
    { id=15, name="Formula Red",    hex="#ff1a1a" },
    { id=16, name="Lava Red",       hex="#cc0000" },
    { id=17, name="Blaze Red",      hex="#ff3333" },
    { id=18, name="Grace Red",      hex="#ff6666" },
    { id=19, name="Garnet Red",     hex="#8b0000" },
    { id=20, name="Sunset Red",     hex="#ff4500" },
    { id=21, name="Cabernet Red",   hex="#800020" },
    { id=22, name="Wine Red",       hex="#722f37" },
    { id=23, name="Candy Red",      hex="#ff0040" },
    { id=24, name="Hot Pink",       hex="#ff69b4" },
    { id=25, name="Pfsiter Pink",   hex="#ff1493" },
    { id=26, name="Salmon Pink",    hex="#fa8072" },
    { id=27, name="Sunrise Orange", hex="#ff9900" },
    { id=28, name="Orange",         hex="#ff6600" },
    { id=29, name="Bright Orange",  hex="#ff4500" },
    { id=30, name="Gold",           hex="#ffd700" },
    { id=31, name="Bronze",         hex="#cd7f32" },
    { id=32, name="Yellow",         hex="#ffff00" },
    { id=33, name="Race Yellow",    hex="#ffe000" },
    { id=34, name="Dew Yellow",     hex="#f5f500" },
    { id=35, name="Dark Green",     hex="#006400" },
    { id=36, name="Racing Green",   hex="#004225" },
    { id=37, name="Sea Green",      hex="#2e8b57" },
    { id=38, name="Olive Green",    hex="#556b2f" },
    { id=39, name="Bright Green",   hex="#00ff00" },
    { id=40, name="Green",          hex="#008000" },
    { id=41, name="Gasoline Green", hex="#00ff7f" },
    { id=42, name="Lime Green",     hex="#32cd32" },
    { id=43, name="Midnight Blue",  hex="#001f3f" },
    { id=44, name="Galaxy Blue",    hex="#003366" },
    { id=45, name="Dark Blue",      hex="#00008b" },
    { id=46, name="Saxon Blue",     hex="#1e90ff" },
    { id=47, name="Blue",           hex="#0000ff" },
    { id=48, name="Mariner Blue",   hex="#4169e1" },
    { id=49, name="Harbor Blue",    hex="#5f9ea0" },
    { id=50, name="Diamond Blue",   hex="#87ceeb" },
    { id=51, name="Surf Blue",      hex="#00bfff" },
    { id=52, name="Nautical Blue",  hex="#006994" },
    { id=53, name="Purple",         hex="#800080" },
    { id=54, name="Cobalt Blue",    hex="#0047ab" },
    { id=55, name="Medium Blue",    hex="#0066cc" },
    { id=56, name="Azure Blue",     hex="#007fff" },
    { id=57, name="Spin Blue",      hex="#4488cc" },
    { id=58, name="Horizon Blue",   hex="#88aacc" },
    { id=59, name="Powder Blue",    hex="#b0c4de" },
    { id=60, name="Sky Blue",       hex="#87cefa" },
    { id=61, name="Midnight Purple",hex="#2e003e" },
    { id=62, name="Dark Purple",    hex="#4a0080" },
    { id=63, name="Grape",          hex="#6f2da8" },
    { id=64, name="Hot Purple",     hex="#9b30ff" },
    { id=65, name="Bright Purple",  hex="#bf00ff" },
    { id=66, name="Medium Purple",  hex="#9370db" },
    { id=67, name="Berry",          hex="#7b1fa2" },
    { id=68, name="Violet",         hex="#8a2be2" },
    { id=69, name="Iris",           hex="#5d3fd3" },
    { id=70, name="Royal Purple",   hex="#7851a9" },
    { id=71, name="Plum",           hex="#8e4585" },
    { id=72, name="Creame",         hex="#fffdd0" },
    { id=73, name="Ice White",      hex="#f5f5f5" },
    { id=74, name="Frost White",    hex="#ffffff" },
    { id=75, name="Brown",          hex="#964b00" },
    { id=76, name="Straw Brown",    hex="#d2b48c" },
    { id=77, name="Sandy Brown",    hex="#f4a460" },
    { id=78, name="Bleached Brown", hex="#deb887" },
    { id=79, name="Schafter Brown", hex="#8b7355" },
    { id=80, name="Neon Blue",      hex="#4deeea" },
    { id=81, name="Neon Green",     hex="#74ee15" },
    { id=82, name="Lemon",          hex="#fff44f" },
    { id=83, name="Lime",           hex="#aefd6c" },
    { id=84, name="Chum",           hex="#f70d1a" },
    { id=85, name="Neon Orange",    hex="#ff9933" },
    { id=86, name="Neon Red",       hex="#ff3333" },
    { id=87, name="Neon Cyan",      hex="#00ffff" },
    { id=88, name="Neon Pink",      hex="#ff6ec7" },
    { id=89, name="Neon Magenta",   hex="#ff00ff" },
}

-- Wheel category names
local wheelCategories = {
    [0] = "Sport",
    [1] = "Muscle",
    [2] = "Lowrider",
    [3] = "SUV",
    [4] = "Offroad",
    [5] = "Tuner",
    [6] = "Bike",
    [7] = "High End",
}

-- Window tint labels
local windowTints = {
    { id=0, name="None" },
    { id=1, name="Pure Black" },
    { id=2, name="Dark Smoke" },
    { id=3, name="Light Smoke" },
    { id=4, name="Stock" },
    { id=5, name="Limo" },
    { id=6, name="Green" },
}

-- Plate style labels
local plateStyles = {
    { id=0, name="Blue on White 1" },
    { id=1, name="Blue on White 2" },
    { id=2, name="Blue on White 3" },
    { id=3, name="Yellow on Black" },
    { id=4, name="Yellow on Blue" },
    { id=5, name="North Yankton" },
}

-- Neon positions
local neonPositions = { "Left", "Right", "Front", "Back" }

-- Suspension labels
local suspensionLabels = {
    [-1] = "Stock",
    [0]  = "Lowered",
    [1]  = "Street",
    [2]  = "Sport",
    [3]  = "Competition",
}

-- Armor labels
local armorLabels = {
    [-1] = "No Armor",
    [0]  = "20% Armor",
    [1]  = "40% Armor",
    [2]  = "60% Armor",
    [3]  = "80% Armor",
    [4]  = "100% Armor",
}

-- Performance mod stage labels
local stageLabels = {
    [-1] = "Stock",
    [0]  = "Level I",
    [1]  = "Level II",
    [2]  = "Level III",
    [3]  = "Level IV (EMS)",
}

local function getVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then veh = GetVehiclePedIsIn(ped, true) end
    return veh
end

local function getModName(veh, modType, modIndex)
    local name = GetModTextLabel(veh, modType, modIndex)
    if name and name ~= '' then
        local localized = GetLabelText(name)
        if localized and localized ~= 'NULL' then return localized end
    end
    return 'Option ' .. (modIndex + 1)
end

local function buildModList(veh, modType)
    local count = GetNumVehicleMods(veh, modType)
    local current = GetVehicleMod(veh, modType)
    local list = {}
    table.insert(list, { id = -1, name = "Stock", equipped = (current == -1) })
    for i = 0, count - 1 do
        local name = getModName(veh, modType, i)
        table.insert(list, { id = i, name = name, equipped = (current == i) })
    end
    return list
end

local function getVehicleData()
    local veh = getVehicle()
    if not DoesEntityExist(veh) then return nil end

    SetVehicleModKit(veh, 0)

    local model = GetEntityModel(veh)
    local name = GetLabelText(GetDisplayNameFromVehicleModel(model))
    if name == 'NULL' or name == '' then name = GetDisplayNameFromVehicleModel(model) end

    local p1, p2 = GetVehicleColours(veh)
    local pearl, wheel = GetVehicleExtraColours(veh)
    local r1, g1, b1 = GetVehicleCustomPrimaryColour(veh)
    local r2, g2, b2 = GetVehicleCustomSecondaryColour(veh)
    local useCustom1 = GetIsVehiclePrimaryColourCustom(veh)
    local useCustom2 = GetIsVehicleSecondaryColourCustom(veh)

    local neonR, neonG, neonB = GetVehicleNeonLightsColour(veh)

    local wheelType = GetVehicleWheelType(veh)
    local frontWheelMod = GetVehicleMod(veh, 23)
    local backWheelMod  = GetVehicleMod(veh, 24)
    local numFrontWheels = GetNumVehicleMods(veh, 23)
    local numBackWheels  = GetNumVehicleMods(veh, 24)

    local data = {
        name        = name,
        plate       = GetVehicleNumberPlateText(veh),
        plateStyle  = GetVehicleNumberPlateTextIndex(veh),
        windowTint  = GetVehicleWindowTint(veh),

        primaryColor   = p1,
        secondaryColor = p2,
        pearlColor     = pearl,
        wheelColor     = wheel,
        useCustomPrimary   = useCustom1,
        useCustomSecondary = useCustom2,
        customPrimary   = useCustom1 and { r = r1, g = g1, b = b1 } or nil,
        customSecondary = useCustom2 and { r = r2, g = g2, b = b2 } or nil,

        neonEnabled = {
            GetVehicleNeonLightEnabled(veh, 0),
            GetVehicleNeonLightEnabled(veh, 1),
            GetVehicleNeonLightEnabled(veh, 2),
            GetVehicleNeonLightEnabled(veh, 3),
        },
        neonColor = { r = neonR, g = neonG, b = neonB },

        xenon   = IsToggleModOn(veh, 22),
        turbo   = IsToggleModOn(veh, 18),
        wheelType = wheelType,

        -- Performance
        engine       = GetVehicleMod(veh, 11),
        brakes       = GetVehicleMod(veh, 12),
        transmission = GetVehicleMod(veh, 13),
        suspension   = GetVehicleMod(veh, 15),
        armor        = GetVehicleMod(veh, 16),

        numEngineMods       = GetNumVehicleMods(veh, 11),
        numBrakeMods        = GetNumVehicleMods(veh, 12),
        numTransmissionMods = GetNumVehicleMods(veh, 13),
        numSuspensionMods   = GetNumVehicleMods(veh, 15),
        numArmorMods        = GetNumVehicleMods(veh, 16),

        -- Exterior
        spoilerMods   = buildModList(veh, 0),
        frontBumpers  = buildModList(veh, 1),
        rearBumpers   = buildModList(veh, 2),
        sideSkirts    = buildModList(veh, 3),
        exhaustMods   = buildModList(veh, 4),
        hoodMods      = buildModList(veh, 7),
        grilleMods    = buildModList(veh, 6),
        roofMods      = buildModList(veh, 10),

        -- Interior
        seatMods      = buildModList(veh, 29),
        steeringMods  = buildModList(veh, 30),
        dashboardMods = buildModList(veh, 26),
        dialMods      = buildModList(veh, 27),

        -- Wheels
        wheelTypeName   = wheelCategories[wheelType] or 'Custom',
        frontWheelMod   = frontWheelMod,
        backWheelMod    = backWheelMod,
        numFrontWheels  = numFrontWheels,
        numBackWheels   = numBackWheels,

        colors      = colors,
        windowTints = windowTints,
        plateStyles = plateStyles,
        wheelCategories = wheelCategories,
        stageLabels = stageLabels,
        suspensionLabels = suspensionLabels,
        armorLabels = armorLabels,
    }

    return data
end

-- Open the menu
RegisterNetEvent('apex_tuning:open')
AddEventHandler('apex_tuning:open', function()
    local veh = getVehicle()
    if not DoesEntityExist(veh) then
        TriggerEvent('chat:addMessage', { args = { "You must be in or near a vehicle!" } })
        return
    end
    openMenu()
end)

function openMenu()
    local data = getVehicleData()
    if not data then return end

    menuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'open', data = data })
end

-- NUI Callbacks
RegisterNUICallback('close', function(_, cb)
    menuOpen = false
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNUICallback('applyMod', function(data, cb)
    local veh = getVehicle()
    if not DoesEntityExist(veh) then cb({}); return end
    SetVehicleModKit(veh, 0)

    local t = data.type
    local val = tonumber(data.value)

    if t == 'primaryColor' then
        SetVehicleColours(veh, val, GetVehicleColours(veh))
        ClearVehicleCustomPrimaryColour(veh)
    elseif t == 'secondaryColor' then
        local p1 = GetVehicleColours(veh)
        SetVehicleColours(veh, p1, val)
        ClearVehicleCustomSecondaryColour(veh)
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
        SetVehicleMod(veh, 23, 0, false)
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
        SetVehicleNeonLightEnabled(veh, pos, val == 1)
    elseif t == 'neonColor' then
        SetVehicleNeonLightsColour(veh, tonumber(data.r), tonumber(data.g), tonumber(data.b))
    elseif t == 'engine' then
        SetVehicleMod(veh, 11, val, false)
    elseif t == 'brakes' then
        SetVehicleMod(veh, 12, val, false)
    elseif t == 'transmission' then
        SetVehicleMod(veh, 13, val, false)
    elseif t == 'suspension' then
        SetVehicleMod(veh, 15, val, false)
    elseif t == 'armor' then
        SetVehicleMod(veh, 16, val, false)
    elseif t == 'spoiler' then
        SetVehicleMod(veh, 0, val, false)
    elseif t == 'frontBumper' then
        SetVehicleMod(veh, 1, val, false)
    elseif t == 'rearBumper' then
        SetVehicleMod(veh, 2, val, false)
    elseif t == 'sideSkirt' then
        SetVehicleMod(veh, 3, val, false)
    elseif t == 'exhaust' then
        SetVehicleMod(veh, 4, val, false)
    elseif t == 'hood' then
        SetVehicleMod(veh, 7, val, false)
    elseif t == 'grille' then
        SetVehicleMod(veh, 6, val, false)
    elseif t == 'roof' then
        SetVehicleMod(veh, 10, val, false)
    elseif t == 'seats' then
        SetVehicleMod(veh, 29, val, false)
    elseif t == 'steeringWheel' then
        SetVehicleMod(veh, 30, val, false)
    elseif t == 'dashboard' then
        SetVehicleMod(veh, 26, val, false)
    elseif t == 'dial' then
        SetVehicleMod(veh, 27, val, false)
    end

    cb({})
end)

-- Open command
RegisterCommand('tuning', function()
    local veh = getVehicle()
    if not DoesEntityExist(veh) then
        TriggerEvent('chat:addMessage', { args = { "[Apex Tuning] Nu esti in niciun vehicul!" } })
        return
    end
    openMenu()
end, false)

-- Close on ESC (handled by NUI, but also handle key)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen and IsControlJustPressed(0, 200) then -- ESC
            menuOpen = false
            SetNuiFocus(false, false)
            SendNUIMessage({ type = 'close' })
        end
    end
end)
