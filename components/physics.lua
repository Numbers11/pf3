local Physics = {
    name = "Physics",
    gravity = 600,
    friction = 0.85,
    gravityScale = 1,
    maxY = 500,
    maxX = 500,
    noPhysics = false
}

function Physics:init()
    self.velX = self.velX or 0
    self.velY = self.velY or 0
end

function Physics:setVelocity(x, y)
    self.velX = x or self.velX
    self.velY = y or self.velY
end

function Physics:addVelocity(x, y)
    self.velX = self.velX + x
    self.velY = self.velY + y
end

function Physics:update(dt)
    if self.noPhysics then return end
    
    local vX = self.velX
    local vY = self.velY
    local x = self.x
    local y = self.y
    
    --apply friction
    vX = vX * self.friction --this sucks because it doesnt respect dt

    --cutoff value
    if 15 > math.abs(vX) then
        vX = 0
    end
    --todo:max gravity value?

    --apply gravity
    if not self.grounded then
        vY = vY + self.gravity * self.gravityScale * dt
    end

    --set new values
    self.x = x + vX * dt
    self.y = y + vY * dt
    self.velX = vX
    self.velY = vY
end

function Physics:draw()
    lg.print("v: " .. trunc(self.velX, 2) .. "/" .. trunc(self.velY, 2) .."\n" .. self.currentStateName , self.x, self.y)
end

return Physics