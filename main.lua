-- imports
require "lib.utils"
require "lib.vector"
require "entities.player"

-- consts
SCREEN_HEIGHT = 800
SCREEN_WIDTH = 800
CELL_SIZE = 16

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    moon = Player:new(
        love.graphics.newImage('assets/img/moon.png'),
        Vec:new(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    )
end

function love.update(dt)
    Player:update(moon, dt)
end

function love.draw()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10) -- print fps
    Player:draw(moon)
end
