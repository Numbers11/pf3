fxDust = Class("fxDust", Entity)

fxDust:addComponent(Components.Animation)

function fxDust:init(x, y, properties)
    self.ttl = 0.8
    self.scale = 1
    Entity.init(self, x, y, properties)

    self:addAnimation("dust", Assets.animations.dust, 0.1, "1-4", 1, "1-4", 2)
    self:setAnimation("dust")
    self.animation.onLoop = "pauseAtEnd"
    self.timer:tween(0.8, self, {scale = 3}, "out-quad")
end

function fxDust:update(dt)
    Entity.update(self, dt)
end

function fxDust:draw()
    Components.Animation.draw(self)
    Entity.draw(self)
end
