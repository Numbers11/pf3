Grenade = Class("Grenade", Entity)
Grenade:addComponent(Components.Physics, Components.Collider)

function Grenade:init(x, y, properties)
    self.collisionClass = "unit"
    self.friction = 1
    self.w = 5
    self.h = 5
    self.ttl = 5

    Entity.init(self, x, y, properties)
    self.velX = 100
    --self.velY = 300
end

function Grenade:collisionFilter(other)
    if other.collisionClass == "player" then
        return "cross"
    end
    return "bounce"
end

function Grenade:collisionResponse(col)
    local normal = col.normal
    local other = col.other

    if other.collisionClass == "player" then
        print("BOOM!")
        self:destroy()
    elseif other.collisionClass == "solid" then
        -- bounce
        print(self.velY)
        --cutoff value for small y
        --so we just slide on the ground
        if math.abs(self.velY) < 15 then 
            print("YOO")
            self.grounded = true
            self.velY = 0
            self.friction = 0.98
        else
            self:changeVelocityByCollisionNormal(normal.x, normal.y, 0.7)
        end
    end
end

function Grenade:destroy()
    EM:create("fxExplosion", self.x, self.y + 22)
    Entity.destroy(self)
end

-- (c) kikito
function Grenade:changeVelocityByCollisionNormal(nx, ny, bounciness)
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