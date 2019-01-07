local Input = {
    name = "Input",
    jumpInput = false,
    jumpReleased = true
}

function Input:update(dt)
    self.directionX = 0
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.directionX = self.directionX - 1
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.directionX = self.directionX + 1
    end

    self.directionY = 0
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.directionY = self.directionY - 1
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.directionY = self.directionY + 1
    end

    --maybe also put jumpInput here?
    if love.keyboard.isDown("space") and not self.jumpInput then
        self.jumpInput = true
        --FIXME: fix this, its ugly and will probably fuck up all kinds of things later
        -- the problem is that canJump will always return false if I set jumpReleased immediatly to false in here
        self.timer:after(
            0.01,
            function()
                self.jumpReleased = false
            end
        )
    elseif not love.keyboard.isDown("space") and self.jumpInput then
        self.jumpInput = false
        self.jumpReleased = true
    end
end

return Input
