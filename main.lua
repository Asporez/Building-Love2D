local love = require('love')

local button = require('src.buttons')

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
    program.state['menu'] = true
    program.state['running'] = false
end

local function enableRunning()
    program.state['menu'] = false
    program.state['running'] = true
end

-- Helper functions to check for game state
local function isMenu()
    return program.state['menu']
end

local function isRunning()
    return program.state['running']
end

function love.load()
-- Load buttons for the menu state
    stateButtons.menu_state = button.createMenuButtons(enableRunning, enableMenu)
-- Load 

end

-- Love2D core input function with button passed as parameter
function love.mousepressed(x, y, mouse_button, istouch, presses)
    if not isRunning() then
        if mouse_button == 1 then
            if isMenu() then
                for _, btn in pairs(stateButtons.menu_state) do
                    btn:checkPressed(x, y, cursor.radius)
                end
            end
        end
    end
end

function love.keypressed(key)
    if isRunning() then
        if key == 'escape' then
            enableMenu()
        end
    end
end

function love.update(dt)
    
end

function love.draw()
    if isMenu() then
        local menuPositionX = love.graphics.getWidth() / 2 - 65
        local menuPositionY = love.graphics.getHeight() / 2 - 25
        stateButtons.menu_state.startButton:draw(menuPositionX, menuPositionY, 35, 10)
        stateButtons.menu_state.exitButton:draw(menuPositionX, menuPositionY + 40, 35, 10)
    elseif isRunning() then
        print("Running")
    end
end