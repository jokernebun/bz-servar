-- ============================================================
-- BZ Framework - Utilitati partajate
-- ============================================================

--- Afiseaza un mesaj de debug daca DevMode este activ
---@param msg string
function BZ.Debug(msg)
    if BZ.Config and BZ.Config.DevMode then
        print('^3[BZ Debug]^7 ' .. tostring(msg))
    end
end

--- Rotunjeste un numar la N zecimale
---@param num number
---@param decimals number
function BZ.Round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

--- Formateaza bani: 10000 -> "10,000"
---@param amount number
function BZ.FormatMoney(amount)
    amount = math.floor(amount or 0)
    local formatted = tostring(amount)
    local k = #formatted % 3
    if k == 0 then k = 3 end
    local result = formatted:sub(1, k)
    for i = k + 1, #formatted, 3 do
        result = result .. ',' .. formatted:sub(i, i + 2)
    end
    return result .. ' lei'
end

--- Returneaza true daca string-ul este gol sau nil
---@param s string
function BZ.IsEmpty(s)
    return s == nil or s == ''
end

--- Cauta un job dupa nume
---@param jobName string
function BZ.GetJobData(jobName)
    return BZ.Jobs[jobName] or BZ.Jobs['unemployed']
end

--- Cauta o gasta dupa nume
---@param gangName string
function BZ.GetGangData(gangName)
    return BZ.Gangs[gangName] or BZ.Gangs['none']
end

--- Verifica daca jucatorul are un anumit job
---@param jobName string|table
function BZ.IsJob(jobName)
    if not BZ.PlayerData then return false end
    if type(jobName) == 'table' then
        for _, v in ipairs(jobName) do
            if BZ.PlayerData.job == v then return true end
        end
        return false
    end
    return BZ.PlayerData.job == jobName
end

--- Returneaza distanta intre doua coords
---@param c1 vector3
---@param c2 vector3
function BZ.GetDistance(c1, c2)
    return #(c1 - c2)
end

--- Genereaza un string aleator de N caractere
---@param length number
function BZ.RandomString(length)
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result  = {}
    for i = 1, length do
        local idx = math.random(1, #charset)
        result[i] = charset:sub(idx, idx)
    end
    return table.concat(result)
end

--- Genereaza un numar de inmatriculare random
function BZ.GeneratePlate()
    -- Format: XX-00-XXX
    local letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local function L() return letters:sub(math.random(1,#letters),math.random(1,#letters)) end
    local function N() return math.random(10,99) end
    return string.format('%s%s-%d-%s%s%s', L(),L(), N(), L(),L(),L())
end
