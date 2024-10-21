local love = require('love')
local button = require('src.buttons')
local mapScenes = require('src.mapScenes')  -- Load the mapScenes module
local entityFactory = require('src.entityFactory')

-- Table to store mouse cursor shape
local cursor = {
    radius = 5,
    x = 10,
    y = 10
}

-- Table to store program states
local program = {
    state = {
        menu = true,
        running = {
            mapScenes = {},
            currentMapScene = nil,  -- Store the currently active map scene
            utility = {}
        }
    }
}

-- Table to store buttons depending on program state
local stateButtons = {
    menu_state = {}
}

-- Helper functions to switch program states
local function enableMenu()
    program.state.menu = true
    program.state.running = false
end

local function enableRunning()
    program.state.menu = false

    -- Initialize the running state as a table instead of a boolean
    program.state.running = {
        mapScenes = {},
        currentMapScene = nil,
        utility = {}
    }

    -- Initialize map scenes when switching to the running state
    local mapScene1 = mapScenes:new("Scene1")
    program.state.running.mapScenes.mapScene1 = mapScene1


    local mapScene2 = mapScenes:new("Scene2")
    program.state.running.mapScenes.mapScene2 = mapScene2

    local player = entityFactory.createEntity('player', 100, 100)
    local npc = entityFactory.createEntity('npc', 800, 100)
    mapScene1:addEntity(player)
    mapScene1:addEntity(npc)

    -- Set the current scene to Scene1 by default
    program.state.running.currentMapScene = mapScene1
    program.state.running.currentMapScene:load()
end


-- Helper functions to check for game state
local function isMenu()
    return program.state.menu
end

local function isRunning()
    return program.state.running
end

-- Function to switch between map scenes
local function switchScene(newMapScene)
    local currentMapScene = mapScenes:switchScene(newMapScene, program.state.running.mapScenes)
    if currentMapScene then
        program.state.running.currentMapScene = currentMapScene
        program.state.running.currentMapScene:load()
    else
        print("scene switch failed")
    end
end

function love.load()
    -- Load buttons for the menu state
    stateButtons.menu_state = button.createMenuButtons(enableRunning, enableMenu)

    if program.state.running and program.state.running.currentMapScene then
        local player = entityFactory.createEntity('player', 100, 100)
        local npc = entityFactory.createEntity('npc', 800, 100)
        program.state.running.currentMapScene:addEntity(player)
        program.state.running.currentMapScene:addEntity(npc)
    end
end

-- Love2D core input function with button passed as parameter
function love.mousepressed(x, y, mouse_button, istouch, presses)
    if mouse_button == 1 then
        if isMenu() then  -- Check if the program is in the menu state
            -- Loop through each button and check if it was pressed
            for _, btn in pairs(stateButtons.menu_state) do
                -- Check if the button was clicked based on cursor position
                btn:checkPressed(x, y, cursor.radius)
            end
        end
    end
end


function love.keypressed(key)
    if isRunning() then
        if key == 'escape' then
            enableMenu()
        elseif key == '1' then  -- Switch to Scene1
            switchScene("mapScene1")
        elseif key == '2' then  -- Switch to Scene2
            switchScene("mapScene2")
        end
    end
end

function love.update(dt)
    if isRunning() and program.state.running.currentMapScene then
        program.state.running.currentMapScene:update(dt)
    end
end

function love.draw()
    if isMenu() then
        local menuPositionX = love.graphics.getWidth() / 2 - 65
        local menuPositionY = love.graphics.getHeight() / 2 - 25
        stateButtons.menu_state.startButton:draw(menuPositionX, menuPositionY, 35, 10)
        stateButtons.menu_state.exitButton:draw(menuPositionX, menuPositionY + 40, 35, 10)
    elseif isRunning() and program.state.running.currentMapScene then
        program.state.running.currentMapScene:draw()
    end
end