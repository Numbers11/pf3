DEBUG = true
PAUSE = false

la = love.audio
lf = love.filesystem
lg = love.graphics
lm = love.mouse

bump = require "lib.bump.bump"
vec = require "lib.hump.vector"
sti = require "lib.Simple-Tiled-Implementation.sti"
Camera = require "lib.STALKER-X.Camera"
GlobalTimer = require "lib.hump.timer"
Signal = require "lib.hump.signal"
anim8 = require "lib.anim8.anim8"
inspect = require "lib.inspect.inspect"
lovebird = require "lib.lovebird.lovebird"

Assets = require "assets"

require "util"
require "class"
require "state"

Components = requireAllAs("components", "name")
States = requireAllAs("states", "class")

requireAll("entities") --import these to a table too?

EM = require("entity_manager")

print("...")
prinspect(Entity)
prinspect(fxDust)

function addColliders()
    for _, rect in ipairs(map.layers["collision"].objects) do
        rect.collisionClass = "solid"
        rect.class = "Solid"
        world:add(rect, rect.x, rect.y, rect.width, rect.height)
    end
end

function spawn()
    EM:removeAll()
    local objectLayer = map.layers["object"]
    local spawnPoint = objectLayer.objects[1]

    aplayer = EM:create("Player", spawnPoint.x, spawnPoint.y, {w = 12, h = 28, name = "Adolf"})
    EM:create("Platform", spawnPoint.x - 100, spawnPoint.y, {w = 40, h = 20, targetX = spawnPoint.x + 200, targetY = spawnPoint.y})
    EM:create("Platform", spawnPoint.x + 220, spawnPoint.y + 20, {w = 40, h = 20, targetX = spawnPoint.x + 220, targetY = spawnPoint.y - 200})

    GlobalTimer.after(1, function() EM:create("Grenade", spawnPoint.x, spawnPoint.y) end)
end

function love.load(arg)
    map = sti("asset/map.lua")
    world = bump.newWorld(32)
    addColliders()

    camera = Camera(0, 0)
    camera:setFollowStyle("PLATFORMER")
    
    spawn()
    print(inspect(aplayer))
    --[[     GlobalTimer.every(0.3, function()
        for i = 1, 10 do
            local ttl =  5
            local p = EM:create("Entity", spawnPoint.x, spawnPoint.y, {ttl = ttl})
            local angle = math.random() * math.pi * 2
            local radius = 200
            local goalX = math.cos(angle)*radius;
            local goalY = math.sin(angle)*radius;
            p.timer:tween(ttl, p, {x = p.x + goalX, y = p.y + goalY})
        end
    end) ]]
end

function love.keypressed(key, unicode)
    if key == "f1" then
        DEBUG = not DEBUG
    elseif key == "+" then
        scrale.toggleFullscreen()
    elseif key == "escape" then
        love.event.quit()
    elseif key == "z" then
        aplayer.gravityScale = aplayer.gravityScale * -1
    elseif key == "f5" then
        spawn()
    elseif key == "f8" then
        PAUSE = not PAUSE
    elseif key == "f11" then
        collectgarbage()
    end
end

function love.update(dt)
    lovebird.update()
    GlobalTimer.update(dt)
    camera:update(dt)
    camera:follow(aplayer.x, aplayer.y)
    if PAUSE then return end -- below this line doesnt get updated if we pause
    EM:update(dt)
    map:update(dt)
end

function love.draw()
    camera:attach()
    --draw our stuff here
    drawCollisions()
    EM:draw()
    camera:detach()
    camera:draw()
    if DEBUG then
        lg.print("EMC: " .. EM.count .. "\nFPS: " .. love.timer.getFPS() .. "\nGC : " .. collectgarbage("count"), 1, 1)
    end
end
