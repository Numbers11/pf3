local EdgeGrab = {
    name = "EdgeGrab",
}

function EdgeGrab:detectEdge(other)
    if self.velY * self.gravityScale > 0 then --we are falling
        if math.abs(other.y - (self.y - self.h)) <= 3 then --TODO: this doesnt work with inverted gravity
            print("AND SLIGHTY ABOVE")
            return true
        end
    end    
    return false
end

function EdgeGrab:positionOnEdge(oY, nX)
    self:setPos(nil, oY + self.h + 2)
    self.edgeSide = nX
    self.edgeHeight = oY    
end

return EdgeGrab