# **Building Löve**

## Step by step journal of a software developer.

Hi, I am AsporeZ and I often forget things, so I will try to step by step my own projects for further reference
or maybe it will be useful to somebody else some day.

# ES23

## Preparing the project.
#### Index
[Template Fork](#template-fork)

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

- Whenever we create a module in it's own file, we import it into the main flow of the program through require:
In main.lua 
```lua
local button = require('src/buttons')
```

above love.load but below the rest of the stored tables:
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

- Refactor buttons.lua to load sprites. REFACTORING means you have to change the code, usually id have to show what parts to remove and what not to but im lazy and this is my journal.
```lua
-- Button factory
function Button(text, func, func_param, spritePath, width, height)
    local buttonImage = love.graphics.newImage(spritePath)
    
    -- Use provided width and height if available, otherwise fall back to image dimensions
    width = width or buttonImage:getWidth()
    height = height or buttonImage:getHeight()

    return {
        width = width,

        (...)

-- Table to hold button creation functions
local buttons = {}

-- Function to create menu buttons
function buttons.createMenuButtons(enableRunning, enableMenu)
    local menuButtons = {}

-- Create a "Play" button
    menuButtons.startButton = Button("Play", enableRunning, nil, 'sprites/smallGreenButton.png', 96, 36)

    return menuButtons
end

return buttons
```
in main.lua
```lua
-- Table to store buttons depending on program state
local stateButtons = {
    menu_state = {}
}
(...)

function love.load()
    -- Load buttons for the menu state
    stateButtons.menu_state = button.createMenuButtons(enableRunning, enableMenu)
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

(...)

function love.draw()
    if isMenu() then
        stateButtons.menu_state.startButton:draw(love.graphics.getWidth() / 2 - 65, love.graphics.getHeight() / 2 - 25, 35, 10)
    elseif isRunning() then
        print("Running")
    end
end
```
Boom, just like that, we add spritePath to the list of parameters then we store the Love2D built-in sprite renderer function in buttonImage which becomes the object, we define that object by assigning the path that love.graphics.newImage() needs and it loads the sprite.
TODO: EXPLAIN MORE

- Add exit button
```lua
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
```
Now because it's a good habit to form early in a project, before drawing I stored the math to place the buttons in their own values this way the program doesnt need to check the size of the screen each time a button is drawn.
main.lua
```lua
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
```

TODO: EXPLAIN HERE

- Create src/mapScene.lua metatable and store it in the "running" nested table. This... METATABLE RWAAARRR!! ...again is a neat Lua feature with a bunch of moving parts.
```lua
local love = require('love')

local mapScenes = {}
mapScenes.__index = mapScenes

function mapScenes:new(name)
    local newMapScene = {}
    setmetatable(newMapScene, mapScenes)
    newMapScene.name = name
    newMapScene.entities = {}
    return newMapScene
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
```
TODO: EXPLAIN METATABLES

- Change the program state nested table in main.lua

```lua
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
```
The game state is pretty important since it is kind of the gateway through which the modules interact...

# **Template Fork**
[back to index](#index)

Well this was a few lines of simple code right!? At this point the program is a solid template to start building the user interface for any type of programs so I will will create a fork that can be used to start any other project. Although writing the initial stages of a code is fun I think leaving detailed notes on methods and the reason behind them is going to pay off in the future!!

I am going to try to fork at point that I consider to be modular like now, the next steps might be the right one, might be a horrible series of mistakes... so I want to have the ability to perhaps built each modules in a different order... in any case I think it would be neat to have modular components on my repository that can be sort of patched up together.

# Codemark
WARNING, EVERYTHING BELOW DOESNT REALLY WORK YET AND MIGHT BE REFACTORED ENTIRELY, THIS IS WHERE I AM CURRENTLY WORKING.
[back to index](#index)

## Creating Entitites

Now we are going to create a factory pattern that stores a metatable in a table... yeah I know it's a lot of tables but this is Lua, land of tables and unicorns.
THe purpose of this is that just like the button function, we don't have to program the entire function each time we want to create an entity, we can simply create inherited

```lua
local entityFactory = {}

local Entity = {}
Entity.__index = Entity

-- function to instantiate an entity
function Entity:new( x, y, radius, color )
    local newEntity = {
        x = x or 0,
        y = y or 0,
        radius = radius or 10,
        color = color {1, 1, 1}
    }
    setmetatable(newEntity, self)
    return newEntity
end
```

This function is Lua's way to simulate Object Oriented Programming, it create an object that behaves the same as a class with other programming languages, but really it's just a table. So we declared that entities are now a thing in this project, now let's define how they should be drawn!

```lua
function Entity.draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.radius)
    love.graphics.setColor(1, 1, 1)
end
```

Now this is just a placeholder circle so that I can bask in the result later and also have a way to see if the code works or not. We still have to define individual entities, let's create a player entity and NPC entity with the only distinction being that the player is green and the NPC is red.
Note how both functions return a table and a metatable... the metatable is what we defined earlier, without the first function in the factory pattern but we add "self" (self, x, y, 20, {}). Cogito ego sum, well programs don't think so they can only be themselves as defined by the programmer. Without the initial function in the factory patterns, parameters wouldn't mean anything... without the metatable to add to an Entity, it would simply be the default entity which we set as a white circle.

#### You can put as many tables into tables as you want, you can put as many tables in those tables, and you can put as many tables in those tables as you want... although eventually you are going to have to face the law of thermodynamics and memory is also an issue.

```lua
-- set metatable and assing it to inherit the parameters of Entity table.
local Player = setmetatable({}, {__index = Entity})
function Player:new(x, y)
    return Entity.new(self, x, y, 20, {0, 1, 0})
end

local NPC = setmetatable({}, {__index = Entity})
function NPC:new(x, y)
    return Entity.new(self, x, y, 20, {1, 0, 0})
end
```

Finally, create the constructor function. How we set the position into the table by calling it entityType then checking through the types available.

```lua
-- Constructor function that creates the entities to be instantiated.
function entityFactory.createEntity(entityType, x, y)
    if entityType == 'player' then
        return Player:new(x, y)
    elseif entityType == 'npc' then
        return NPC:new(x, y)
    end
end
```

- Load the module in main.lua:
```lua
local entityFactory = require('src.entityFactory')

(...)

-- Initialize entityFactory
local player
local npc

function love.load()
-- Load buttons for the menu state
    stateButtons.menu_state = button.createMenuButtons(enableRunning, enableMenu)

-- Load individual entities
    player = entityFactory.createEntity('player', 800, 600)
    npc = entityFactory.createEntity('npc', 800, 100)
end
```

TODO: Define drawing logic in mapScenes