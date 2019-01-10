local Collider = {
    name = "Collider",
    collisionClass = "solid"
}

function Collider:init()
    assert(self.w and self.h, "Error: A rectangle collider needs a width and a height!")
    world:add(self, self.x - self.w / 2, self.y - self.h, self.w, self.h)
end

function Collider:destroy()
    print("collider destroyed")
    world:remove(self)
end

function Collider:update(dt)
    local actualX, actualY, cols, len = world:move(self, self.x - self.w / 2, self.y - self.h, function(...)
        if self.noClip then return false end
        return self.collisionFilter(...)
    end)
    self:setPos(actualX + self.w / 2, actualY + self.h)
    for i = 1, len do
        self:collisionResponse(cols[i]) --TODO: at the moment, the collisionResponse is called after we set our new position. is that good? Probably yes.
    end
end

return Collider
