local EdgeGrab = Class("EdgeGrab", State)

function EdgeGrab:init(entity)
    State.init(self, entity)
end

function EdgeGrab:onEnter(from)
    local player = self.ent
    State.onEnter(self, from)
    player:setAnimation("edgeGrab")

    --make us unaffected by gravity and still in place
    player.velX = 0
    player.velY = 0
    player.noPhysics = true
end

function EdgeGrab:onUpdate(dt)
    local player = self.ent
    if player.directionY == 1 or player.directionX == player.edgeSide then -- let go
        print("press A to let go")
        player.noPhysics = false
        player.facing = player.edgeSide
        player:addVelocity(player.edgeSide * 20, 20)
        self.sm:setState("falling")
    elseif player.directionY == -1 then -- climb up
        print("climb up")
        self.sm:setState("edgeClimb")
    end
end

return EdgeGrab