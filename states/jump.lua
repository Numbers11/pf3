local Jump = Class("Jump", State)

function Jump:init(entity)
    State.init(self, entity)
end

function Jump:onEnter(from)
    local player = self.ent

    State.onEnter(self, from)
    player:setAnimation("jmpStart")
    player:jump()
end

function Jump:onUpdate(dt)
    local player = self.ent

    if player.directionX ~= 0 then
        --player:turnCheck()
        player:move()
    end

    --either the super meat boy, so velocity.y = 0 or gravity scale like super mario. right now the super meat boys
    if not love.keyboard.isDown("space") then
        player.velY = 0
        print("RELEASED!", player.jumpsLeft)
        self.sm:setState("falling")
    end
end

return Jump
