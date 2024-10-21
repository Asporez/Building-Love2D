local love = require('love')

local MapScenes = {}
MapScenes.__index = MapScenes

-- Constructor function to create new scenes.
function MapScenes:new(name)
    local newMapScene = {}
    setmetatable(newMapScene, MapScenes)
    newMapScene.name = name
    return newMapScene
end

-- Switch between scenes
function MapScenes:switchScene(newMapSceneName, scenes)
    if scenes[newMapSceneName] then
        return scenes[newMapSceneName]
    else
        print("Scene " .. newMapSceneName .. " not found")
    end
end

function MapScenes:load()
    print(self.name .. " loading")
end

function MapScenes:update(dt)
    print(self.name .. " updating")
end

function MapScenes:draw()
    love.graphics.print("Scene: " .. self.name, 10, 10)
end

return MapScenes