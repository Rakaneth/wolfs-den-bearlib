local utils = {}

function utils.copy(tbl)
    local copy
    if type(tbl) == "table" then
        copy = {}
        for k, v in next, tbl, nil do
            copy[k] = v
        end
        setmetatable(copy, getmetatable(tbl))
    else
        copy = tbl
    end
    return copy
end

function utils.merge(base, mod)
    local result = utils.copy(base)
    local m = utils.copy(mod)
    for k, v in next, m, nil do
        if (type(result[k]) or false) == "table" then
            result[k] = utils.merge(result[k] or {}, v or {})
        else
            if not result[k] then
                result[k] = v
            end
        end
    end
    return result
end

function utils.any(tbl, calbak)
    for _, v in pairs(tbl) do
        if calbak(v) then
            return true
        end
    end
    return false
end

function utils.all(tbl, calbak)
    for _, v in pairs(tbl) do
        if not calbak(v) then
            return false
        end
    end
    return true
end

function utils.contains(tbl, val)
    return utils.any(
        tbl,
        function(v)
            return val == v
        end
    )
end

function utils.first(tbl, calbak)
    for _, v in ipairs(tbl) do
        if calbak(v) then
            return v
        end
    end
    return nil
end

function utils.filter(tbl, calbak)
    local result = {}
    for _, v in ipairs(tbl) do
        if calbak(v) then
            table.insert(result, v)
        end
    end
    return result
end

function utils.clamp(val, low, high)
    if val < low then
        return low
    elseif val > high then
        return high
    else
        return val
    end
end

function utils.between(val, low, high)
    return utils.clamp(val, low, high) == val
end

function utils.printf(...)
    print(string.format(...))
end

function utils.getProbTable(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        if v.freq then
            results[k] = v.rarity
        end
    end
    return result
end

return utils
