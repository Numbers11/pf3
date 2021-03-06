Player = Class("Player", Entity)
Player:addComponent(Components.Input, Components.Physics, Components.Collider, Components.Movement, Components.Animation, Components.StateMachine, Components.EdgeGrab)

function Player:init(x, y, properties)
    self.collisionClass = "player"

    Entity.init(self, x, y, properties)

    self:addAnimation("walk", Assets.animations.adventurer, 0.12, "2-7", 2)
    self:addAnimation("idle", Assets.animations.adventurer, 0.2, "1-4", 1)
    self:addAnimation("jmpStart", Assets.animations.adventurer, 0.1, "1-4", 3) --, 'pauseAtEnd'
    self:addAnimation("falling", Assets.animations.adventurer, 0.2, "2-3", 4) --, 'pauseAtEnd'
    self:addAnimation("dash", Assets.animations.adventurer, 0.2, "1-2", 12)
    self:addAnimation("edgeGrab", Assets.animations.adventurer, 0.2, "2-5", 5)
    self:addAnimation("edgeClimb", Assets.animations.adventurer, 0.1, "6-7", 5, "1-3", 6)
    self:setAnimation("idle")

    self:addState("idle", States.Idle(self))
    self:addState("walk", States.Walk(self))
    self:addState("jump", States.Jump(self))
    self:addState("falling", States.Falling(self))
    self:addState("edgeGrab", States.EdgeGrab(self))
    self:addState("edgeClimb", States.EdgeClimb(self))
    self:setState("idle")
end

function Player:collisionFilter(other)
    --if other.collisionClass == "platform" then --right now we have no extra collision class for platforms
    --    return nil
    --end
    if other.collisionClass == "unit" then
        return "cross"
    end
    return "slide"
end

function Player:collisionResponse(col)
    local normal = col.normal
    local other = col.other
    if other.collisionClass == "solid" then
        if normal.y == -1 then
            --we are landing on an object from above
            self.velY = 0
            print("we landed on something")
        elseif normal.y == 1 then
            --we hit our head
            self.velY = 0
            print("Ouch my head")
        elseif normal.y == 0 then
            --we hit something to the side
            --self.velX = 0

            --check if we can grab this edge & if yes set us to the edge grab state
            if self:detectEdge(other) then
                self:positionOnEdge(other.y, normal.x)
                self:setState("edgeGrab")
            end
        end
    else
        print("other collision")
    end
end

function Player:update(dt)
    if self.falling and not (self:getStateName() == "falling") then self:setState("falling") end

    Entity.update(self, dt) --this updates all components
end

function Player:draw()
    Components.Animation.draw(self)
    if DEBUG then
        Components.Physics.draw(self)
        Entity.draw(self)
        if self.riding then
            lg.line(self.x, self.y, self.riding.x, self.riding.y)
        end
    end
end
