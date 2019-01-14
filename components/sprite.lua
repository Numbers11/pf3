local Sprite = {
    name = "Sprite",
    color = {1, 1, 1, 1},
    rotation = 0,
    scale = 1,
    flip = 1
}

function Sprite:init()
    --self.sprite = nil
    self.facing = 1
end

function Sprite:setSprite(img, quad)
    self.sprite = img
    self.quad = quad
end

function Sprite:unsetSprite()
    self.sprite = nil
    self.quad = nil
end

function Sprite:draw()
    lg.draw(drawable, self.x, self.y, self.rotation, self.scale, self.scale, self.sprite.Width, self.sprite.Height)
end

return Sprite
