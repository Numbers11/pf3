function loadAssets()
    local assets = {}
    assets.animations = {}
    local asset = {}
    asset.image = lg.newImage("asset/adventurer.png")
    asset.g = anim8.newGrid(50, 37, asset.image:getWidth(), asset.image:getHeight())
    assets.animations["adventurer"] = asset

    assets.animations["dust"] = {
        image = lg.newImage("asset/Smoke_Fire.png"),
        g = anim8.newGrid(16, 16, 64, 64)
    }

    assets.animations["explosion"] = {
        image = lg.newImage("asset/Explosion.png"),
        g = anim8.newGrid(96, 96, 1152, 96)
    }
    return assets
end

return loadAssets()
