local Movement = {
    name = "Movement",
    maxJumps = 2,
    jumpsLeft = 2,
    speed = 190,
    airSpeed = 100,
    jumpStrength = -300
}

function Movement:update(dt)
    --set us as grounded or not, depending if we can detect a collider just below us
    self.grounded = false
    self.friction = 1
    self.riding = nil
    local items, len = world:queryPoint(self.x,self.y + 2) --used to be + 1 but this for some reason unfucks the behavior on riding platforms moving upwards
    if len > 0 then                                        --so never use an only 2 pixel thick solid
        self.grounded = true
        self.friction = Components.Physics.friction
        self.jumpsLeft = self.maxJumps
        -- register the collider we are touching as our rider
        if items[1].riders then
            items[1].riders[self] = true
        end
        self.riding = items[1]
    end

    --also detect if we are falling
    self.falling = false
    if (self.velY * self.gravityScale > 0) and (not self.grounded)then
        self.falling = true
    end
end

function Movement:airMove()
    local airVel = self.directionX * self.airSpeed
    local currentVel = self.velX
    local diff = airVel - currentVel
    if math.abs(airVel) < math.abs(currentVel) and (airVel * currentVel > 0) then
        --if the current speed is greater than the wanted one AND both numbers are of the same sign (both positive or negative),
        --then dont apply the velocity because it would slow us down
    else
        self:addVelocity(diff, 0)
    end
end

function Movement:move()
    if self.directionX == 0 then return end
    self:turnCheck()
    if self.grounded == false then
        self:airMove()
        return
    end
    local diff = self.directionX * self.speed - self.velX --add to the velocity if we are below our wanted speed. avoids using setVelocity
    self:addVelocity(diff, 0)
end

function Movement:turnCheck()
    --if (player.directionX == player.facing * -1) then
    --    player.facing = player.facing * -1
    --end
    --FIXME: this is bad
    self.facing = (self.directionX == -self.facing) and -self.facing or self.facing
    --self.facing = self.directionX or self.facing
end

function Movement:canJump()
    return self.jumpsLeft > 0 and self.jumpReleased
end

function Movement:jump()
    print("JUMP!")
    self.jumpsLeft = self.jumpsLeft - 1
    print("jumps left", self.jumpsLeft)

    self.velY = 0 --else we go lower on air jump because we have some negative gravity already
    self.grounded = false
    self.falling = false
    self.friction = 1

    -- this seems to be unnecessary after all
    --[[ if self.riding then
        if self.riding.velY then
            print("SSSSSSSSSSSSSSSSSS")
            self.velY = self.riding.velY
        end 
    end ]]

    self:addVelocity(0, self.jumpStrength * self.gravityScale)
end

return Movement
