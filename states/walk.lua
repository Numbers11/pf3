local Walk = Class("Walk", State)

function Walk:init(entity)
    State.init(self, entity)
end

function Walk:onEnter(from)
    local player = self.ent
    State.onEnter(self, from)
    player:setAnimation("walk")

    -- if from == "idle" then
    --     EM:create("fxDust", player.x, player.y)
    -- end
end

function Walk:onUpdate(dt)
    local player = self.ent

    player:move()

    if player:canJump() and player.jumpInput then
        self.sm:setState("jump")
        return
    end

    --no longer moving, going back to idle
    if player.directionX == 0 then
        self.sm:setState("idle")
        return
    end
end

return Walk
