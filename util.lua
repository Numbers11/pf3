function drawDebugRect(x, y, w, h)
    local alpha = 0.4
    lg.setColor(0.2 * alpha, 1 * alpha, 0.2 * alpha, alpha)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.rectangle("line", x, y, w, h)
    love.graphics.circle("fill", x, y, 2)
    lg.setColor(1, 1, 1, 1)
end

function drawCollisions()
    local items, len = world:getItems()
    for i = 1, len do
        drawDebugRect(world:getRect(items[i]))
    end
end

_ID = 1

function getID()
    local id = _ID
    _ID = _ID + 1
    return id
end

function New(class, x, y, properties)
    assert(_G[class], "Trying to create a non-existant entity " .. class)
    return _G[class](x, y, properties)
end

function requireAll(folder)
    local files = lf.getDirectoryItems(folder)
    for i = 1, #files do
        require(folder .. "." .. files[i]:gsub("%.lua$", ""))
    end
end

function requireAllAs(folder, key)
    local files = lf.getDirectoryItems(folder)
    local t = {}
    for i = 1, #files do
        local s = require(folder .. "." .. files[i]:gsub("%.lua$", ""))
        assert(s ~= true, "Attempting to require a script that doesnt return anything")
        t[s[key]] = s
    end
    return t
end

function prinspect(...)
    return print(inspect(...))
end

function trunc(num, digits)
    local mult = 10 ^ (digits)
    return math.modf(num * mult) / mult
end
