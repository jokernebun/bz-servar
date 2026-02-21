-- ============================================================
-- BZ Multichar - Client
-- ============================================================

local multicharOpen = false

-- Camera pentru selectie personaj
local cam = nil

local function SetupCamera()
    if cam then DestroyCam(cam, false) end
    cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA',
        -1393.0, -617.0, 33.0,   -- pozitie
        0.0, 0.0, 0.0,           -- rotatie
        50.0, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, true)
end

local function DestroyCamera()
    if cam then
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
end

-- ============================================================
-- ARATA MULTICHAR
-- ============================================================
RegisterNetEvent('bz:multichar:show', function()
    multicharOpen = true
    DoScreenFadeOut(500)

    -- Teleporteaza in locatie neutra
    Wait(600)
    local ped = PlayerPedId()
    SetEntityVisible(ped, false, false)
    SetEntityCoords(ped, -1393.0, -617.0, 30.0, false, false, false, false)
    FreezeEntityPosition(ped, true)

    SetupCamera()
    DoScreenFadeIn(800)

    -- Cere personajele de la server
    TriggerServerEvent('bz:core:getCharacters')
end)

-- Primeste personajele si le afiseaza in UI
RegisterNetEvent('bz:multichar:receiveChars', function(chars)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action    = 'show',
        characters = chars,
        maxChars  = BZ.Config.MaxChars,
    })
end)

-- ============================================================
-- NUI CALLBACKS
-- ============================================================

-- Selecteaza un personaj
RegisterNUICallback('selectCharacter', function(data, cb)
    cb('ok')
    local charId = tonumber(data.charId)
    CloseMultichar()
    TriggerServerEvent('bz:core:requestLoad', charId)
end)

-- Creeaza personaj nou
RegisterNUICallback('createCharacter', function(data, cb)
    cb('ok')
    TriggerServerEvent('bz:core:createCharacter', {
        firstname = data.firstname,
        lastname  = data.lastname,
        dob       = data.dob,
        sex       = data.sex,
    })
end)

-- Sterge personaj
RegisterNUICallback('deleteCharacter', function(data, cb)
    cb('ok')
    TriggerServerEvent('bz:core:deleteCharacter', tonumber(data.charId))
end)

-- Inchide (disconnect)
RegisterNUICallback('disconnect', function(_, cb)
    cb('ok')
    SetNuiFocus(false, false)
    ForceSocialClubUpdate()
end)

-- ============================================================
-- EVENTS DE LA SERVER
-- ============================================================

RegisterNetEvent('bz:core:charCreated', function(charId)
    -- Reincarca lista
    TriggerServerEvent('bz:core:getCharacters')
end)

RegisterNetEvent('bz:core:charDeleted', function()
    TriggerServerEvent('bz:core:getCharacters')
end)

-- Cand personajul este incarcat, inchide UI-ul
RegisterNetEvent('bz:core:playerLoaded', function()
    CloseMultichar()
end)

-- ============================================================
-- HELPER
-- ============================================================

function CloseMultichar()
    if not multicharOpen then return end
    multicharOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hide' })
    DoScreenFadeOut(500)
    Wait(600)
    local ped = PlayerPedId()
    SetEntityVisible(ped, true, true)
    FreezeEntityPosition(ped, false)
    DestroyCamera()
    DoScreenFadeIn(800)
end
