-- ============================================================
-- BZ Menu - Client
-- Sistem de meniuri context (lista cu optiuni)
-- ============================================================

local menuOpen    = false
local menuActions = {}

--- Deschide un meniu context
---@param options table  Lista de optiuni: { label, description, icon, event, args, close, disabled }
---@param title string   Titlul meniului
---@param subtitle string
function BZ.OpenMenu(options, title, subtitle)
    menuActions = {}
    local uiOptions = {}

    for i, opt in ipairs(options) do
        menuActions[i] = {
            event  = opt.event,
            args   = opt.args or {},
            netEvent = opt.netEvent,
            cb     = opt.cb,
        }
        table.insert(uiOptions, {
            id          = i,
            label       = opt.label or 'Optiune',
            description = opt.description or '',
            icon        = opt.icon or '',
            disabled    = opt.disabled or false,
            price       = opt.price,
        })
    end

    menuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action   = 'open',
        title    = title    or 'Meniu',
        subtitle = subtitle or '',
        options  = uiOptions,
    })
end
exports('OpenMenu', BZ.OpenMenu)

--- Inchide meniul
function BZ.CloseMenu()
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end
exports('CloseMenu', BZ.CloseMenu)

--- Callback de la UI cand se selecteaza o optiune
RegisterNUICallback('selectOption', function(data, cb)
    cb('ok')
    local id = tonumber(data.id)
    BZ.CloseMenu()

    if menuActions[id] then
        local action = menuActions[id]
        if action.cb then
            action.cb(action.args)
        elseif action.netEvent then
            TriggerServerEvent(action.netEvent, table.unpack(action.args))
        elseif action.event then
            TriggerEvent(action.event, table.unpack(action.args))
        end
    end
end)

--- Inchide cu ESC
RegisterNUICallback('closeMenu', function(_, cb)
    cb('ok')
    BZ.CloseMenu()
end)

--- Input dialog simplu
---@param fields table  { label, type('text'|'number'), placeholder, required }
---@param title string
---@param cb function   Primeste table cu valorile completate, sau nil daca s-a inchis
function BZ.OpenInput(fields, title, cb)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openInput',
        title  = title or 'Completati',
        fields = fields,
    })

    -- Stocam callback-ul temporar
    BZ._inputCallback = cb
end
exports('OpenInput', BZ.OpenInput)

RegisterNUICallback('submitInput', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeInput' })
    if BZ._inputCallback then
        BZ._inputCallback(data.values)
        BZ._inputCallback = nil
    end
end)

RegisterNUICallback('cancelInput', function(_, cb)
    cb('ok')
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeInput' })
    if BZ._inputCallback then
        BZ._inputCallback(nil)
        BZ._inputCallback = nil
    end
end)

--- Progress bar
---@param label string
---@param duration number (ms)
---@param cb function  apelat la sfarsit (sau nil daca anulat)
function BZ.ProgressBar(label, duration, cb, canCancel)
    canCancel = canCancel ~= false
    SendNUIMessage({
        action    = 'progressBar',
        label     = label,
        duration  = duration,
        canCancel = canCancel,
    })
    SetNuiFocus(false, false)
    BZ._progressCb = cb

    CreateThread(function()
        local start = GetGameTimer()
        while GetGameTimer() - start < duration do
            Wait(100)
            if canCancel and IsControlJustPressed(0, 194) then -- X key
                SendNUIMessage({ action = 'cancelProgress' })
                if BZ._progressCb then
                    BZ._progressCb(false)
                    BZ._progressCb = nil
                end
                return
            end
        end
        if BZ._progressCb then
            BZ._progressCb(true)
            BZ._progressCb = nil
        end
    end)
end
exports('ProgressBar', BZ.ProgressBar)

--- Confirmare (Da / Nu)
---@param title string
---@param message string
---@param cb function  cb(true/false)
function BZ.Confirm(title, message, cb)
    BZ.OpenMenu({
        {
            label = '✅  Da, confirma',
            icon  = 'check',
            cb    = function() cb(true) end,
        },
        {
            label = '❌  Nu, anuleaza',
            icon  = 'times',
            cb    = function() cb(false) end,
        },
    }, title, message)
end
exports('Confirm', BZ.Confirm)
