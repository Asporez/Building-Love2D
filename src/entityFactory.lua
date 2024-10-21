-- local love = require('love')
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