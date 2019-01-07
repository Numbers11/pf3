local Falling = Class("Falling", State)

function Falling:init(entity)
    State.init(self, entity)
end

function Falling:onEnter(from)
    local player = self.ent
    State.onEnter(self, from)
    player:setAnimation("falling")
end

function Falling:onUpdate(dt)
    local player = self.ent

    --air movement
    if player.directionX ~= 0 then
        --player:turnCheck()
        player:move()
    end

    --check key presses and transform accordingly
    if love.keyboard.isDown("f") then --attack yes
        self.sm:setState("attack")
        return
    elseif player:canJump() and player.jumpInput then -- jump yes
        --self.sm:setState("jump")
        self.sm:setState("jump")
        print("jump from falling")
        return
    end
    
    --back on the ground
    if player.grounded then
        dustPointX = player.x
        dustPointY = player.y
        self.sm:setState("idle") --maybe make a choice between idle or walk, depending if direction is still pressed
    end
end

return Falling