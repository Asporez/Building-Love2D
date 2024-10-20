local love = require('love')
local Button = require('src.Buttons')
local MapScenes = require('src.MapScenes')  -- Load the MapScenes module

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
            MapScenes = {},
            currentMapScene = nil,  -- Store the currently active map scene
            utility = {}
        }
    }
}

-- Table to store Buttons depending on program state
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
        MapScenes = {},
        currentMapScene = nil,
        utility = {}
    }

    -- Initialize map scenes when switching to the running state
    program.state.running.MapScenes.mapScene1 = MapScenes:new("Scene1")
    program.state.running.MapScenes.mapScene2 = MapScenes:new("Scene2")

    -- Set the current scene to Scene1 by default
    program.state.running.currentMapScene = program.state.running.MapScenes.mapScene1
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
    local currentMapScene = MapScenes:switchScene(newMapScene, program.state.running.MapScenes)
    if currentMapScene then
        program.state.running.currentMapScene = currentMapScene
        program.state.running.currentMapScene:load()
    end
end

function love.load()
    -- Load Buttons for the menu state
    stateButtons.menu_state = Button.createMenuButtons(enableRunning, enableMenu)
end

-- Love2D core input function with Button passed as parameter
function love.mousepressed(x, y, mouse_Button, istouch, presses)
    if mouse_Button == 1 then
        if isMenu() then  -- Check if the program is in the menu state
            -- Loop through each Button and check if it was pressed
            for _, btn in pairs(stateButtons.menu_state) do
                -- Check if the Button was clicked based on cursor position
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