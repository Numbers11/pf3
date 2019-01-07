local Idle = Class("Idle", State)

function Idle:init(entity)
    State.init(self, entity)
end

function Idle:onEnter(from)
    local player = self.ent
    State.onEnter(self, from)
    player:setAnimation("idle")
end

function Idle:onUpdate(dt)
    local player = self.ent

    --check key presses and transform accordingly
    if love.keyboard.isDown("f") then --attack TODO: implement
        self.sm:setState("attack")
    elseif player:canJump() and player.jumpInput then
        self.sm:setState("jump")
    elseif player.directionX ~= 0 then --move
        self.sm:setState("walk")
    end
end

return Idle
