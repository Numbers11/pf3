local EdgeClimb = Class("EdgeClimb", State)

function EdgeClimb:init(entity)
    State.init(self, entity)
end

function EdgeClimb:onEnter(from)
    local player = self.ent
    State.onEnter(self, from)
    player:setAnimation("edgeClimb")

    player.velX = 0
    player.velY = 0
    player.noPhyiscs = true
    player.noClip = true

    --there is some very hardcoded fuckery going on here
    player.timer:tween(0.5, player, {y = player.edgeHeight - 4}, "out-in-cubic")
    player.timer:tween(0.4, player, {x = player.x - player.edgeSide * 5})
    player.timer:after(0.5, function()
        player.noClip = false
        player.noPhysics = false
        player.y = player.edgeHeight
        player.x = player.x - player.edgeSide * 5
        self.sm:setState("idle")
    end)
end

return EdgeClimb