local function collisionResponseShoving(world, col, x, y, w, h, goalX, goalY, filter)
    local nX = col.normal.x
    local nY = col.normal.y
    local other = col.other
    local item = col.item
    local otherH = other.h
    local otherW = other.w

    print("Platform collision presolve", nX, nY)
    local newX = other.x
    local newY = other.y
    if nY == 0 then 
        print("from the side")
        newX = item.x - (item.w / 2 + otherW / 2) * nX
    elseif nY == 1 then
        print("from below!", item.velY)
        newY = item.y - item.h
    elseif nY == -1 then
        print("from ahead")
        newY = item.y + otherH
        --other.velY = 200 --some additional whoop downwards, so it doesnt stick to the bottom side. just setting it to zero is not enough with this gravity EXCEPT IT IS DUMBO
    end
    print(newX, newY)

    local bumpCoordX = newX - otherW / 2 --bump uses top left origin rectangles, but the entity position uses bottom center ones
    local bumpCoordY = newY - otherH

    --check if the place we want to move to is already occupied
    local p, len = world:queryRect(bumpCoordX, bumpCoordY, otherW, otherH) --FIXME: this also squishes player when he moves against a platform as it pushes him off from the solid he stands on
    for i = 1, len do
        local blocking = p[i]
        if blocking ~= item and blocking ~= other then
            print(blocking.class)
            print("HOLY FUCK WE ARE GETTING SQUISHED")
            item:squishing(other)
            break
        end
    end

    --move the other object just out of the way, TODO: we probably can skip this if we squish it
    world:update(other, bumpCoordX, bumpCoordY, otherW, otherH)
    other:setPos(newX, newY)

    --our platform itself, just let it move right on
    local cols, len = world:project(col.item, x, y, w, h, goalX, goalY, filter)
    return goalX, goalY, cols, len
end

Platform = Class("Platform", Entity)
Platform:addComponent(Components.Collider)

function Platform:init(x, y, properties)
    self.startX = x
    self.startY = y

    self.oldX = x
    self.oldY = y

    self.velX = 0
    self.velY = 0

    self.riders = {}

    Entity.init(self, x, y, properties)

    -- FIXME: this is a bad place, there is no reason to (re-)create the response on every platform create
    -- havent found a better place yet, though
    world:addResponse("shoving", collisionResponseShoving)

    --Moving our platform constantly between two points
    local tween1, tween2
    tween1 = function()
        self.timer:tween(4, self, {x = self.targetX, y = self.targetY}, "linear", tween2)
    end
    tween2 = function()
        self.timer:tween(4, self, {x = self.startX, y = self.startY}, "linear", tween1)
    end
    tween1()
end

function Platform:squishing(rider)
    rider:destroy()
    EM:create("fxDust", rider.x, rider.y)
end

function Platform:collisionFilter(other)
    if other.collisionClass == "player" then
        return "shoving"
    end
    return nil
end

function Platform:collisionResponse(col)
    local normal = col.normal
    local other = col.other

    if other.collisionClass == "player" then
        print("colliding with player!") --this handing is optional since it is post-solve.
    end
end

function Platform:update(dt)
    Entity.update(self, dt) --this updates all components. might want to do it first UNLESS WE SET THE STATE

    --calculate our velocity
    local deltaX, deltaY = self.x - self.oldX, self.y - self.oldY
    self.velX = deltaX / dt
    self.velY = deltaY / dt

    --update our riders position with our own offset, so we carry him
    for rider ,_ in pairs(self.riders) do
        rider.x = rider.x + deltaX
        rider.y = rider.y + deltaY
    end

    self.oldX = self.x
    self.oldY = self.y
    self.riders = {}
end

function Platform:draw()
    Entity.draw(self)
    if DEBUG then
        lg.line(self.x, self.y, (self.x + self.velX / 4), (self.y + self.velY / 4))
    end
end

function Platform:changeVelocityByCollisionNormal(nx, ny, bounciness)
    bounciness = bounciness or 0
    local vx, vy = self.velX, self.velY

    if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
        vx = -vx * bounciness
    end

    if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
        vy = -vy * bounciness
    end

    self.velX, self.velY = vx, vy
end
