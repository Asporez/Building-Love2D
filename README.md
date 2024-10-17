# ES23

 Yet another prototype!

# **Building Löve**

## Step by step journal of a software developer.

Hi, I am AsporeZ and I often forget things, so I will try to step by step my own projects for further reference
or maybe it will be useful to somebody else some day.

# ES23

## Preparing the project.

- Create Löve2D core loop in main.lua
```lua
local love = require('love')

function love.load()
	-- body
end

function love.update(dt)
	-- body
end

function love.draw()
	-- body
end
```

- Create program states table:
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

- Create src/Buttons.lua
```lua
local love = require('love')
--[[
Standalone factory pattern table that produces buttons as well as determine
functionality of those buttons from the main file.
--]]
-- text string, function, optional parameters, position X, position Y, text position X, text position Y
function Button(text, func, func_param, spritePath, width, height)
    local buttonImage = love.graphics.newImage(spritePath)
    width = buttonImage:getWidth()
    height = buttonImage:getHeight()
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

            love.graphics.draw(buttonImage, self.button_x, self.button_y)

            love.graphics.setColor(0, 0, 0)
            love.graphics.print(self.text, self.text_x, self.text_y)

            love.graphics.setColor(1, 1, 1)
        end
    }
end

return Button
```
	+ TODO: Explanation in details of this factory pattern table template.