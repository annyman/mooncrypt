local Player = {}


function Player:new(sprite, pos)
    local self = {}
        self.sprite = sprite
        self.pos = pos

    return self
end

function Player:update(plr, dt)
    function love.keypressed(k)
        if k == 'd' then
            plr.pos.x = plr.pos.x + CELL_SIZE
        elseif k == 'a' then
            plr.pos.x = plr.pos.x - CELL_SIZE
        elseif k == 's' then
            plr.pos.y = plr.pos.y + CELL_SIZE
        elseif k == 'w' then
            plr.pos.y = plr.pos.y - CELL_SIZE
        end

        if k == 'q' then -- exit program press 'Q'
            love.event.quit()
         end
    end
end

function Player:draw(plr)
    love.graphics.draw(plr.sprite, plr.pos.x, plr.pos.y)
end

return Player
