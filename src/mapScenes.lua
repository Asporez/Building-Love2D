local love = require('love')

local mapScenes = {}
mapScenes.__index = mapScenes

-- Constructor function to create new scenes.
function mapScenes:new(name)
    local newMapScene = {}
    setmetatable(newMapScene, mapScenes)
    newMapScene.name = name
    newMapScene.entities = {}
    return newMapScene
end

-- Switch between scenes
function mapScenes:switchScene(newMapSceneName, scenes)
    if scenes[newMapSceneName] then
        return scenes[newMapSceneName]
    else
        print("Scene " .. newMapSceneName .. " not found")
    end
end

function mapScenes:load()
    print(self.name .. " loading")
end

function mapScenes:update(dt)
    print(self.name .. " updating")
end

function mapScenes:draw()
    love.graphics.print("Scene: " .. self.name, 10, 10)
end

return mapScenes