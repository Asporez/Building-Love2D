local love = require('love')

local MapScene = {}
MapScene.__index = MapScene

-- Constructor function to create new scenes.
function MapScene:new(name)
    local newMapScene = setmetatable({}, MapScene)
    newMapScene.name = name
    newMapScene.entities = {}  -- Initialize an empty table to store entities
    return newMapScene
end

-- Switch between scenes
function MapScene:switchScene(newMapSceneName, scenes)
    if scenes[newMapSceneName] then
        return scenes[newMapSceneName]
    else
        print("Scene " .. newMapSceneName .. " not found")
    end
end

-- Add entity to the current scene
function MapScene:addEntity(entity)
    table.insert(self.entities, entity)
end

-- Scene load logic
function MapScene:load()
    print(self.name .. " loading")
end

-- Update all entities within the scene
function MapScene:update(dt)
    for _, entity in ipairs(self.entities) do
        if entity.update then
            entity:update(dt)  -- Call the entity's update method
        end
    end
end

-- Draw all entities within the scene
function MapScene:draw()
    -- Display the scene's name on the screen
    love.graphics.print("Scene: " .. self.name, 10, 10)

    for _, entity in ipairs(self.entities) do
        if entity.draw then
            entity:draw()  -- Call the entity's draw method
        end
    end
end

return MapScene