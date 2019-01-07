State = Class("State")

function State:init(entity)
    self.ent = entity
end

function State:onLeave()
    local player = self.ent
    --sprint("| " .. player.name .. ": state " .. self.class .. " left")
end

function State:onEnter(from)
    local player = self.ent
    print("| " .. player.name .. ": state " .. self.class .. " entered from " .. from)
end

function State:onUpdate(dt)
end
