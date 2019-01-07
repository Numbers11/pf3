local Animation = {
    name = "Animation",
    color = {1, 1, 1, 1},
    rotation = 0,
    scale = 1,
    flip = 1
}

function Animation:init()
    self.animations = {}
    self.animation = nil
    self.facing = 1
end

function Animation:addAnimation(name, animation, speed, ...)
    local anim = {}
    anim = anim8.newAnimation(animation.g(...), speed)
    anim.sprite = animation.image
    anim.grid = animation.g

    self.animations[name] = anim
end

function Animation:removeAnimation(name)
    self.animations[name] = nil
end

function Animation:setAnimation(name)
    assert(self.animations[name], "Error: Trying to set a non-existant animation " .. name)
    self.animation = self.animations[name]
    self.animation:gotoFrame(1)
end

function Animation:getAnimation(name)
    return self.animations[name]
end

function Animation:unsetAnimation()
    self.animation = nil
end

function Animation:update(dt)
    if self.animation then
        self.animation:update(dt)
    end
end

function Animation:draw()
    local anim = self.animation
    if anim then
        --        love.graphics.setShader(shader)
        lg.setColor(unpack(self.color))
        anim.flippedH = self.facing ~= 1
        --anim.flippedV = self.gravityScale < 0
        anim:draw(anim.sprite, self.x, self.y, self.rotation, self.scale, self.scale, anim.grid.frameWidth / 2, anim.grid.frameHeight)
        lg.setColor(1, 1, 1, 1)
    --        love.graphics.setShader()
    end
end

return Animation
