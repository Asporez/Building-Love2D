local love = require('love')

local MapScenes = {}
MapScenes.__index = MapScenes

-- Constructor function to create new scenes.
function MapScenes:new(name)
    local newMapScene = setmetatable({}, MapScenes)
    newMapScene.name = name
-- Store scene specific entities
    newMapScene.entities = {}
    return newMapScene
end

-- Add entities to scene
function MapScenes:addEntity(entity)
    table.insert(self.entities, entity)
end

-- Switch between scenes
function MapScenes:switchScene(newMapSceneName, scenes)
    if scenes[newMapSceneName] then
        return scenes[newMapSceneName]
    else
        print("Scene " .. newMapSceneName .. " not found")
        return false
    end
end


function MapScenes:load()
    print(self.name .. " loading")
end

function MapScenes:update(dt)
    print(self.name .. " updating")
    for _, entity in ipairs(self.entities) do
        if entity.update then
            entity:update(dt)
        end
    end
end

function MapScenes:draw()
    love.graphics.print("Scene: " .. self.name, 10, 10)
    for _, entity in ipairs(self.entities) do
        entity:draw()
    end
end

return MapScenes