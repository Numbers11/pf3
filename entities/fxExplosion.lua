fxExplosion = Class("fxExplosion", Entity)

fxExplosion:addComponent(Components.Animation)

function fxExplosion:init(x, y, properties)
    self.ttl = 1.5
    self.scale = 0.7
    Entity.init(self, x, y, properties)

    self:addAnimation("explosion", Assets.animations.explosion, 0.12, "1-12", 1)
    self:setAnimation("explosion")
    self.animation.onLoop = "pauseAtEnd"
    --self.timer:tween(1.2, self, {scale = 3}, "out-quad")
end

function fxExplosion:update(dt)
    Entity.update(self, dt)
end

function fxExplosion:draw()
    Components.Animation.draw(self)
    Entity.draw(self)
end
