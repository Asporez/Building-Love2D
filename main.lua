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
        running = false
    }
}

-- Table to store buttons depending on program state
local buttons = {
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
    buttons.menu_state.startButton = button("Play", enableRunning, nil, 110, 40)
end

-- Love2D core input function with button passed as parameter.
function love.mousepressed(x, y, button, istouch, presses)
    if not isRunning() then
        if button == 1 then
            if isMenu() then
                for _, btn in pairs(buttons.menu_state) do
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
        buttons.menu_state.startButton:draw(love.graphics.getWidth() / 2 - 65, love.graphics.getHeight() / 2 - 25)
    elseif isRunning() then
        print("Running", 0, 0)
    end
end