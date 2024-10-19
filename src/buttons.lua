local love = require('love')

-- Button factory
function Button(text, func, func_param, spritePath, width, height)
    local buttonImage = love.graphics.newImage(spritePath)
    
    -- Use provided width and height if available, otherwise fall back to image dimensions
    width = width or buttonImage:getWidth()
    height = height or buttonImage:getHeight()

    return {
        width = width,
        height = height,
        func = func or function() print("This button has no functions attached") end,
        func_param = func_param,
        text = text or "No Text",
        button_x = 0,
        button_y = 0,
        text_x = 0,
        text_y = 0,

        -- Check if the button was pressed
        checkPressed = function (self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.button_x) and (mouse_x - cursor_radius <= self.button_x + self.width) then
                if (mouse_y + cursor_radius >= self.button_y) and (mouse_y - cursor_radius <= self.button_y + self.height) then
                    if self.func_param then
                        self.func(self.func_param)
                        print("click")
                    else
                        self.func()
                    end
                end    
            end
        end,

        -- Draw the button and text
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

            -- Draw the button image
            love.graphics.draw(buttonImage, self.button_x, self.button_y)

            -- Draw the button text
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(self.text, self.text_x, self.text_y)

            -- Reset color
            love.graphics.setColor(1, 1, 1)
        end
    }
end

-- Table to hold button creation functions
local buttons = {}

-- Function to create menu buttons
function buttons.createMenuButtons(enableRunning, enableMenu)
    local menuButtons = {}

    menuButtons.startButton = Button("Play", enableRunning, nil, 'sprites/smallGreenButton.png', 96, 36)
    menuButtons.exitButton = Button("Exit", love.event.quit, nil, 'sprites/smallGreenButton.png', 96, 36)

    return menuButtons
end

return buttons