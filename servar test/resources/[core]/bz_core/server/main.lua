-- ============================================================
-- BZ Core - Server Main
-- ============================================================

local Players = {}  -- Players[source] = PlayerObject

-- ============================================================
-- PLAYER CONNECTED
-- ============================================================
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifiers(src)[1]

    Wait(0)
    deferrals.update('Se verifica datele...')

    if not license then
        deferrals.done('Nu ai o licenta Steam/FiveM valida!')
        return
    end

    -- Inregistreaza/actualizeaza jucatorul
    MySQL.query('SELECT * FROM players WHERE license = ?', { license }, function(result)
        if result and #result > 0 then
            -- Actualizeaza ultima conectare
            MySQL.update('UPDATE players SET name = ?, last_seen = NOW() WHERE license = ?',
                { name, license })
            if result[1].banned == 1 then
                deferrals.done('Esti banat! Motiv: ' .. (result[1].ban_reason or 'Fara motiv'))
                return
            end
        else
            -- Jucator nou
            MySQL.insert('INSERT INTO players (license, name) VALUES (?, ?)',
                { license, name })
        end
        deferrals.done()
    end)
end)

-- ============================================================
-- PLAYER DROPPED
-- ============================================================
AddEventHandler('playerDropped', function(reason)
    local src = source
    if Players[src] then
        local p = Players[src]
        SavePlayer(src, function()
            Players[src] = nil
            print('^3[BZ Core]^7 ' .. p.name .. ' a parasit serverul.')
        end)
    end
end)

-- ============================================================
-- FUNCTII PLAYER
-- ============================================================

--- Creeaza obiectul player si il incarca din DB
---@param src number
---@param charId number
function LoadCharacter(src, charId)
    local license = GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifiers(src)[1]

    MySQL.query('SELECT * FROM characters WHERE id = ? AND license = ?', { charId, license }, function(result)
        if not result or #result == 0 then
            TriggerClientEvent('bz:core:notify', src, 'Personajul nu a fost gasit!', 'error')
            return
        end

        local char = result[1]
        Players[src] = {
            source  = src,
            license = license,
            charId  = charId,
            name    = char.firstname .. ' ' .. char.lastname,
            firstname = char.firstname,
            lastname  = char.lastname,
            job       = char.job,
            jobGrade  = char.job_grade,
            gang      = char.gang,
            gangGrade = char.gang_grade,
            cash      = char.cash,
            bank      = char.bank,
            blackMoney= char.black_money,
            metadata  = char.metadata and json.decode(char.metadata) or {},
            coords    = char.coords and json.decode(char.coords) or nil,
            heading   = char.heading or 0,
            health    = char.health or 200,
            armor     = char.armor or 0,
            isDead    = char.is_dead == 1,
            jailTime  = char.jail_time or 0,
        }

        TriggerClientEvent('bz:core:playerLoaded', src, Players[src])
        TriggerEvent('bz:core:playerLoaded', src, Players[src])
        print('^2[BZ Core]^7 ' .. Players[src].name .. ' s-a conectat. (Job: ' .. char.job .. ')')
    end)
end

--- Salveaza datele playerului in DB
---@param src number
---@param cb function|nil
function SavePlayer(src, cb)
    local p = Players[src]
    if not p then if cb then cb() end return end

    local ped    = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local heading= GetEntityHeading(ped)
    local health = GetEntityHealth(ped)
    local armor  = GetPedArmour(ped)

    MySQL.update(
        'UPDATE characters SET job=?, job_grade=?, gang=?, gang_grade=?, cash=?, bank=?, black_money=?, coords=?, heading=?, health=?, armor=?, metadata=?, last_played=NOW() WHERE id=?',
        {
            p.job, p.jobGrade, p.gang, p.gangGrade,
            p.cash, p.bank, p.blackMoney,
            json.encode({ x=coords.x, y=coords.y, z=coords.z }),
            heading, health, armor,
            json.encode(p.metadata),
            p.charId,
        },
        function() if cb then cb() end end
    )
end

-- Auto-save la fiecare 5 minute
CreateThread(function()
    while true do
        Wait(300000)
        for src, _ in pairs(Players) do
            SavePlayer(src)
        end
    end
end)

-- ============================================================
-- FUNCTII PUBLICE (pentru alte resurse)
-- ============================================================

--- Returneaza obiectul player
---@param src number
function GetPlayer(src)
    return Players[src]
end
exports('GetPlayer', GetPlayer)

--- Returneaza toti playerii conectati cu personaj incarcat
function GetPlayers()
    return Players
end
exports('GetPlayers', GetPlayers)

--- Adauga bani la jucator
---@param src number
---@param type string 'cash'|'bank'|'black_money'
---@param amount number
function AddMoney(src, type, amount)
    local p = Players[src]
    if not p then return false end
    amount = math.floor(amount)
    if type == 'cash'        then p.cash       = p.cash       + amount
    elseif type == 'bank'    then p.bank       = p.bank       + amount
    elseif type == 'black'   then p.blackMoney = p.blackMoney + amount
    end
    TriggerClientEvent('bz:core:updateMoney', src, { cash=p.cash, bank=p.bank })
    return true
end
exports('AddMoney', AddMoney)

--- Scoate bani de la jucator
---@param src number
---@param type string
---@param amount number
function RemoveMoney(src, type, amount)
    local p = Players[src]
    if not p then return false end
    amount = math.floor(amount)
    if type == 'cash' then
        if p.cash < amount then return false end
        p.cash = p.cash - amount
    elseif type == 'bank' then
        if p.bank < amount then return false end
        p.bank = p.bank - amount
    elseif type == 'black' then
        if p.blackMoney < amount then return false end
        p.blackMoney = p.blackMoney - amount
    end
    TriggerClientEvent('bz:core:updateMoney', src, { cash=p.cash, bank=p.bank })
    return true
end
exports('RemoveMoney', RemoveMoney)

--- Seteaza jobul unui jucator
---@param src number
---@param job string
---@param grade number
function SetJob(src, job, grade)
    local p = Players[src]
    if not p then return false end
    if not BZ.Jobs[job] then return false end
    grade = grade or 0
    p.job      = job
    p.jobGrade = grade
    MySQL.update('UPDATE characters SET job=?, job_grade=? WHERE id=?', { job, grade, p.charId })
    TriggerClientEvent('bz:core:updateJob', src, { job=job, grade=grade, label=BZ.Jobs[job].label, gradeLabel=BZ.Jobs[job].grades[grade] and BZ.Jobs[job].grades[grade].label or 'Necunoscut' })
    TriggerEvent('bz:core:jobChanged', src, job, grade)
    return true
end
exports('SetJob', SetJob)

--- Verifica daca un player are jobul specificat
---@param src number
---@param job string|table
---@param minGrade number|nil
function HasJob(src, job, minGrade)
    local p = Players[src]
    if not p then return false end
    minGrade = minGrade or 0
    if type(job) == 'table' then
        for _, v in ipairs(job) do
            if p.job == v and p.jobGrade >= minGrade then return true end
        end
        return false
    end
    return p.job == job and p.jobGrade >= minGrade
end
exports('HasJob', HasJob)

-- ============================================================
-- EVENTS
-- ============================================================

RegisterNetEvent('bz:core:requestLoad', function(charId)
    LoadCharacter(source, charId)
end)

RegisterNetEvent('bz:core:saveAndExit', function()
    local src = source
    SavePlayer(src, function()
        TriggerClientEvent('bz:multichar:show', src)
        Players[src] = nil
    end)
end)

-- ============================================================
-- SALARIU - platit la fiecare 30 min
-- ============================================================
CreateThread(function()
    while true do
        Wait(1800000) -- 30 minute
        for src, p in pairs(Players) do
            local jobData = BZ.Jobs[p.job]
            if jobData and jobData.grades[p.jobGrade] then
                local salary = jobData.grades[p.jobGrade].salary or 0
                if salary > 0 then
                    AddMoney(src, 'bank', salary)
                    TriggerClientEvent('bz:core:notify', src,
                        'Salariu primit: ' .. salary .. ' lei', 'success')
                end
            end
        end
    end
end)
