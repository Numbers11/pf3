local StateMachine = {
    name = "StateMachine",

}

function StateMachine:init()
    self.states = {}
    self.currentState = nil
    self.currentStateName = ""
end

function StateMachine:getState()
    return self.currentState, self.currentStateName
end

function StateMachine:getStateName()
    return self.currentStateName
end

function StateMachine:addState(name, state)
    --table.insert(self.states, newState)
    self.states[name] = state
    state.sm = self
    return state
end

function StateMachine:removeState(name)
    local state = self.states[name]
    self.states[name] = nil
    return state
end

function StateMachine:setState(name)
    assert(self.states[name], "Error: Trying to set a non-existant state " .. name)
    --if self.states[name] == self.currentState then return end

    local oldState = self.currentStateName

    if self.currentState ~= nil then
        self.currentState:onLeave(name) --to
    end
    self.currentState = self.states[name]
    self.currentStateName = name

    self.currentState:onEnter(oldState) --from
end

function StateMachine:update(dt)
    if self.currentState then
        self.currentState:onUpdate(dt)
    end
end

return StateMachine