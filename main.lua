-- imports
local Utils = require "lib.utils"
local Vec = require "lib.vector"
local Player = require "entities.player"
local Dungeon = require "lib.dungeon"

-- consts
SCREEN_HEIGHT = 600
SCREEN_WIDTH = 600
CELL_SIZE = 16

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    moon = Player:new(
        love.graphics.newImage('assets/img/moon.png'),
        Vec:new(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    )

    lvl1 = Dungeon:create(1)

end

function love.update(dt)
    Player:update(moon, dt)
end

function love.draw()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10) -- print fps
    Player:draw(moon)
end
