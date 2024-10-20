local entityFactory = {}
local Entity = {}
Entity.__index = Entity

-- function to instantiate an entity
function Entity:new(x, y, radius, color)
    local newEntity = {
        x = x or 0,
        y = y or 0,
        radius = radius or 10,
        color = color or {1, 1, 1}
    }
    setmetatable(newEntity, self)
    return newEntity
end

function Entity.draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.radius)
    love.graphics.setColor(1, 1, 1)
end
-- set metatable and assing it to inherit the parameters of Entity table.
local Player = setmetatable({}, {__index = Entity})
function Player:new(x, y)
    return Entity.new(self, x, y, 20, {0, 1, 0})
end

local NPC = setmetatable({}, {__index = Entity})
function NPC:new(x, y)
    return Entity.new(self, x, y, 20, {1, 0, 0})
end
-- Constructor function that creates the entities to be instantiated.
function entityFactory.createEntity(entityType, x, y)
    if entityType == 'player' then
        return Player:new(x, y)
    elseif entityType == 'npc' then
        return NPC:new(x, y)
    end
end

return entityFactory