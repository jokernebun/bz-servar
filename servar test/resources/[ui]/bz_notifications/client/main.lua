-- ============================================================
-- BZ Notifications - Client
-- ============================================================

AddEventHandler('bz:notifications:show', function(message, type, duration)
    type     = type     or 'info'
    duration = duration or 4000
    SendNUIMessage({
        action   = 'show',
        message  = tostring(message),
        type     = type,
        duration = duration,
    })
end)

-- Alias pentru alte resurse
AddEventHandler('bz:notify', function(message, type, duration)
    TriggerEvent('bz:notifications:show', message, type, duration)
end)
