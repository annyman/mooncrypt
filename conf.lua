function love.conf(t)
    t.title = "MoonCrypt"        -- The title of the window
    t.version = "11.5"           -- The LOVE version this game was made for (string)
    t.window.width = 800         -- The window width (number)
    t.window.height = 800        -- The window height (number)
    t.window.borderless = true   -- Remove all border visuals (boolean)
    t.window.fullscreen = false  -- Enable fullscreen (boolean)
    t.window.vsync = true        -- Enable vertical sync (boolean)
    t.window.msaa = 9            -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.resizable = false   -- Disable window resizing
end