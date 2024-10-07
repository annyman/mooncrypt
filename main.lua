-- imports
local Utils = require "lib.utils"
local Vec = require "lib.vector"
local Player = require "entities.player"
local Dungeon = require "lib.dungeon"
local Camera = require "lib.camera"

-- consts
SCREEN_HEIGHT = 600
SCREEN_WIDTH = 600
CELL_SIZE = 16

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setDefaultFilter('nearest', 'nearest') -- Avoids blurring when pixel art is zoomed

    floor = love.graphics.newImage('assets/img/floor.png')

    moon = Player:new(
        love.graphics.newImage('assets/img/moon.png'),
        Vec:new(0, 0)
    )

    CM = Camera.newManager() -- camera yap
    CM.setScale(1.75)
    CM.setDeadzone(-16,-16,16,16)
    CM.setLerp(0.2)
    CM.setOffset(0)
    CM.setCoords(0, 0)

    lvl1 = Dungeon:create(7)
end

function love.update(dt)
    Player:update(moon, dt)

    CM.setTarget(moon.pos.x+8, moon.pos.y+8)
    CM.update(dt)
end

function love.draw()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10) -- print fps

    CM.attach()
        Dungeon:draw(lvl1)
        Player:draw(moon)
    CM.detach()

    --CM.debug()
end
