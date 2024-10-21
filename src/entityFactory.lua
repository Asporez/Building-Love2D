local love = require('love')
-- src/entityFactory.lua
local Entity = {}
Entity.__index = Entity

function Entity:new(x, y, radius, color)
    local instance = {
        x = x or 0,
        y = y or 0,
        radius = radius or 10,
        color = color or {0.2, 0.2, 0.2}
    }
    setmetatable(instance, self)
    return instance
end

function Entity:draw()
    print(self.x, self.y, self.radius)
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

-- Player and NPC classes inherit from Entity
-- Slight modification to constructor pattern
local Player = setmetatable({}, {__index = Entity})
function Player:new(x, y)
    local instance = Entity.new(self, x, y, 20, {0, 1, 0})
    return instance
end

local NPC = setmetatable({}, {__index = Entity})
function NPC:new(x, y)
    local instance = Entity.new(self, x, y, 20, {1, 0, 0})
    return instance
end

-- factory pattern table

local entityFactory = {}
function entityFactory.createEntity(entityType, x, y)
    if entityType == 'player' then
        return Player:new(x, y)
    elseif entityType == 'npc' then
        return NPC:new(x, y)
    end
end

return entityFactory