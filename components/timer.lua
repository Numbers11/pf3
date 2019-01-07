local Timer = {
    name = "Timer"
}

function Timer:init()
    self.timer = GlobalTimer.new()
    if self.ttl then
        self.timer:after(self.ttl, function()
            self:destroy()
        end)
    end
end

function Timer:destroy()
    self.timer:clear()
end

function Timer:update(dt)
    self.timer:update(dt)
end

return Timer