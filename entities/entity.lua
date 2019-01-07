Entity = Class("Entity")

function Entity:addComponent(...)
    --if not self._components then self._components = {} end
    --if not self._componentsNames then self._componentsNames = {} end
    local comps = self._components or {}
    self._components = {}
    self._componentsNames = {}

    for _, component in ipairs(comps) do
        table.insert(self._components, component)
        table.insert(self._componentsNames, component.name)
    end

    for _, component in ipairs({...}) do
        assert(component.name, "Not a valid component table, has no name property")
        print("Adding ", component.name, " to ", self.class)
        for k, v in pairs(component) do
            if k == "update" or k == "draw" or k == "init" or k == "destroy" then
                --skip those
            elseif k == "name" then
                table.insert(self._components, component)
                table.insert(self._componentsNames, v)
            else
                print("  ", k, v)
                self[k] = v
            end
        end        
    end
end

Entity:addComponent(Components.Timer)

function Entity:init(x, y, properties)

    self.x = x or 0
    self.y = y or 0
    self.dead = false
    self.id = getID()

    print("--------")
    print("Creating new Entity of type ", self.class, self.id)
    print("Components: ", inspect(self._componentsNames))
    print("--------")
    
    --copy over all properties to the object
    properties = properties or {}
    for k, v in pairs(properties) do
        self[k] = v
    end
    
    --init Components
    for _, c in ipairs(self._components) do
        if c.init then
            c.init(self)
        end
    end

end

function Entity:destroy()
    self.dead = true
end

function Entity:destroyComponents()
    for _, c in ipairs(self._components) do
        if c.destroy then
            c.destroy(self)
        end
    end
end

function Entity:update(dt)
    --sets us to the same position, if the "follow" property is set TODO: find a use for this lol
    -- if self.follow then
    --     if self.follow.dead then
    --         self.follow = nil
    --     else
    --         self:setPos(self.follow:getPos())
    --     end
    -- end
    for _, c in ipairs(self._components) do
        if c.update then
            c.update(self, dt)
        end
    end
end

function Entity:draw()
    if DEBUG then
        love.graphics.setColor(1, 0, 0,1)
        love.graphics.circle("fill", self.x, self.y, 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Entity:getPos()
    return self.x, self.y
end

function Entity:setPos(x, y)
--[[     self.x = x or math.floor(self.x + 0.5) --rounding to the nearest integer
    self.y = y or math.floor(self.y + 0.5) ]]
    self.x = x or self.x
    self.y = y or self.y
end
