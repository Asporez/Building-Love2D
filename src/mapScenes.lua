-- src/mapScenes.lua
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

program.state.running.mapScenes.mapScene1 = mapScenes:new("Scene1")
program.state.running.mapScenes.mapScene2 = mapScenes:new("Scene2")

program.state.running.currentMapScene = program.state.running.mapScenes.Scene1

local function switchScene(newMapScene)
    if program.state.running.mapScenes[newMapScene] then
        program.state.running.currentMapScene = program.state.running.mapScenes[newMapScene]
        program.state.running.currentMapScene:load()
    else
        print("Scene "..newMapScene.." not found")
    end
end

function mapScenes:load()
    print(self.name.."loading")
end

function mapScenes:update(dt)
    print(self.name.."updating")
end

function mapScenes:draw()
    love.graphics.print("Scene:"..self.name, 10, 10)
end