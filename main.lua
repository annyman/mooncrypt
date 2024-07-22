function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.update(dt)
    --
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    width, height, flags = love.window.getMode()
    love.graphics.print("Welcome to Mooncrypt!", (width/2)-30, (height/2)-30)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

-- exit program press 'Q'
function love.keypressed(k)
    if k == 'q' then
       love.event.quit()
    end
 end
