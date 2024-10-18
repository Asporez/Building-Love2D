# **Building Löve**

## Step by step journal of a software developer.

Hi, I am AsporeZ and I often forget things, so I will try to step by step my own projects for further reference
or maybe it will be useful to somebody else some day.

# ES23

## Preparing the project.

- Create Löve2D core loop in main.lua
```lua
local love = require('love')
--everything in and above the body of love.load() is loaded once when the program is launched
function love.load()
	-- body
end
-- after love.load() the program flow starts with the first love.update call
function love.update(dt)
	-- function input/output that needs update goes here. (dt) means delta-time or the amount of time since the last update (max60fps)
end
-- everything here is also part of update as well as above love.update, put functions that are not within their own file here for callbacks.
-- in fact everything in the program flow could go here but I prefer not to.
function love.draw()
	-- this is where the artsy things happen
end
-- everything below love.draw() gets updated like the rest of the loop and then start the loop again from the end of love.load()
```
#### Above love.load()
- Create program states table, menu is a boolean set to true to indicate it will be the initial state when the program launches:
```lua
 -- Table to store program states
local program = {
    state = {
        menu = true,
        running = false
    }
}
```

- Create cursor table:
```lua
-- Table to store mouse cursor shape
local cursor = {
    radius = 5,
    x = 10,
    y = 10
}
```

- Create buttons table as well as a table for each states, this is so the program can tell when to instantiate buttons.
```lua
local buttons = {
    menu_state = {}
}
```

#### Create /src/ folder to put the code you wrote.
- Create src/buttons.lua
```lua
local love = require('love')
--[[
Standalone factory pattern table that produces buttons as well as determine
functionality of those buttons from the main file.
--]]
-- text string, function, optional parameters, position X, position Y, text position X, text position Y
function Button(text, func, func_param, width, height)
    
    return {
        width = width or 100,
        height = height or 100,
        func = func or function() print("This button has no functions attached") end,
        func_param = func_param,
        text = text or "No Text",
        button_x = 0,
        button_y = 0,
        text_x = 0,
        text_y = 0,
-- Execute the button that is clicked on
        checkPressed = function (self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.button_x) and (mouse_x - cursor_radius <= self.button_x + self.width) then
                if (mouse_y + cursor_radius >= self.button_y) and (mouse_y - cursor_radius <= self.button_y + self.height) then
                    if self.func_param then
                        self.func(self.func_param)
                    else
                        self.func()
                    end
                end    
            end
        end,
-- Determines the appearance of the buttons to be instantiated.
        draw = function (self, button_x, button_y, text_x, text_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y

            if text_x then
                self.text_x = text_x + self.button_x
            else
                self.text_x = self.button_x
            end

            if text_y then
                self.text_y = text_y + self.button_y
            else
                self.text_y = self.button_y
            end

            -- Draw the button as a rectangle
            love.graphics.setColor(0.6, 0.6, 0.6)  -- Gray color for the button
            love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)

            love.graphics.setColor(0, 0, 0)
            love.graphics.print(self.text, self.text_x, self.text_y)

            love.graphics.setColor(1, 1, 1)
        end
    }
end

return Button
```
###

This is a factory pattern constructor function, it returns a table and assigns the "meaning" of the values. It is a rather neat methods with a lot of moving parts but just copy and paste it as is for now it will be refactored many times anyway and I will explain further when that happens. Having this from the start makes everything easier later.

Inside of the constructor there is a checkPressed function that uses the cursor_radius type we wrote in main.lua, what it does in a nutshell is every time you click the mouse button, if it is on top of a button iot executes the function and it's parameters.
The other function draws the button on the screen.

Let's load this button into our main flow, first we need to create a helper function that will define the switch between states by simply switching the bool

- In main.lua above love.load but below the rest of the stored tables:
```lua
-- Helper functions to switch between states
local function enableMenu()
    game.state['menu'] = true
    game.state['running'] = false
end

local function enableRunning()
    game.state['menu'] = false
    game.state['running'] = true
end
```

- Load the button and set the helper function for the start button, and lets make an exit button for good measure.
```lua
function love.load()
    buttons.menu_state.startButton = button( "Start", enableRunning, nil, 120, 40 )
    buttons.menu_state.exitButton = button( "Exit", love.event.quit, nil, 120, 40 )
end
```

- Below love.load, create this function to record mouse clicks:
```lua
function love.mousepressed( x, y, button, istouch, presses )
    if not isRunning() then
        if button == 1 then
            if isMenu() then
                for index in pairs( buttons.menu_state ) do
                    buttons.menu_state[index]:checkPressed( x, y, cursor.radius )
                end
            end
        end 
    end
end
```
TODO: EXPLAIN HERE
- Create this function to exit to menu:
```lua
function love.keypressed(key)
    if isRunning() then
        if key == 'escape' then
            enableMenu()
        end
    end
end
```
TODO: EXPLAIN HERE

- Go back above love.load() and add this helper function to handle the checks in the codes above. It is not necessary but it would impact performance later if we didn't.
```lua
-- game state checks helper functions
local function isMenu()
    return game.state[ 'menu' ]
end

local function isRunning()
    return game.state[ 'running' ]
end
```

- Now finally let's draw those buttons on the screen:
```lua
function love.draw()
    
    love.graphics.setColor( 1, 1, 1 )
    if isMenu() then
        buttons.menu_state.startButton:draw( 700, 20, 5, 10 )
        buttons.menu_state.exitButton:draw( 700, 70, 5, 10 )
    elseif isRunning() then
        love.graphics.print("Running", 10, 10)
    end

end
```
TODO: EXPLAIN HERE