-- ============================================================
-- BZ Core - Client Callbacks
-- ============================================================

local pendingCallbacks = {}
local requestCounter   = 0

--- Trimite un callback la server si asteapta raspunsul
---@param name string
---@param cb function
---@param ... any
function BZ.TriggerCallback(name, cb, ...)
    requestCounter = requestCounter + 1
    local id = requestCounter
    pendingCallbacks[id] = cb
    TriggerServerEvent('bz:core:callback', name, id, ...)
end
exports('TriggerCallback', BZ.TriggerCallback)

--- Raspuns de la server
RegisterNetEvent('bz:core:callbackResponse', function(requestId, ...)
    if pendingCallbacks[requestId] then
        pendingCallbacks[requestId](...)
        pendingCallbacks[requestId] = nil
    end
end)

-- ============================================================
-- HELPER KEYS (detectie taste)
-- ============================================================

local registeredKeys = {}

--- Inregistreaza o tasta custom
---@param label string
---@param key number  (control id GTA)
---@param cb function
function BZ.RegisterKey(label, key, cb)
    table.insert(registeredKeys, { label=label, key=key, cb=cb })
end

CreateThread(function()
    while true do
        Wait(0)
        for _, k in ipairs(registeredKeys) do
            if IsControlJustPressed(0, k.key) then
                k.cb()
            end
        end
    end
end)

-- ============================================================
-- KEYS DEFAULT
-- ============================================================

-- F6 = meniu job
BZ.RegisterKey('Meniu Job', 166, function()
    if BZ.Loaded then
        TriggerEvent('bz:job:openMenu')
    end
end)

-- E = interactie
BZ.RegisterKey('Interactie', 38, function()
    if BZ.Loaded then
        TriggerEvent('bz:interact:check')
    end
end)

-- F2 = inventar
BZ.RegisterKey('Inventar', 289, function()
    if BZ.Loaded then
        TriggerEvent('bz:inventory:toggle')
    end
end)

-- F3 = emote menu (simplu)
BZ.RegisterKey('Emote Menu', 290, function()
    if BZ.Loaded then
        TriggerEvent('bz:emotes:open')
    end
end)
