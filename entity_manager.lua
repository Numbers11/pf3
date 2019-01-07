local EntityManager = Class("EntityManager")

function EntityManager:init()
    self.entities = {}
    self.count = 0
    self.toBeCreated = {}
    self.pause = false
end

function EntityManager:create(...)
    return self:add(New(...))
end

function EntityManager:add(entity)
    --adding a reference to the EntityManager to the object. Migth be useful in the future.
    entity._em = self
    self.count = self.count + 1
    table.insert(self.entities, entity) --This time, I want the entities to be an array so they always update and draw in the same order
    return entity
end

function EntityManager:remove(entID)
    for i = self.count, 1, -1 do
        local e = self.entities[i]
        if e.id == entID then
            e:destroy()
            e:destroyComponents()
            table.remove(self.entities, i)
            self.count = self.count - 1
            break
        end
    end
end

function EntityManager:removeAll()
    for i = self.count, 1, -1 do
        local e = self.entities[i]
        e:destroy()
        e:destroyComponents()
        self.entities[i] = nil
    end    
    self.count = 0
end

function EntityManager:update(dt)
    if self.pause then
        return
    end
    for i = self.count, 1, -1 do
        local e = self.entities[i]
        if e.dead then
            e:destroyComponents()
            table.remove(self.entities, i)
            self.count = self.count - 1
        else
            e:update(dt)
        end
    end
end

function EntityManager:draw()
    for i = self.count, 1, -1 do
        local e = self.entities[i]
        e:draw()
    end
end   

return EntityManager()