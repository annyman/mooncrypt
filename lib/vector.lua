local Vec = {}

function Vec:new(x, y)
    local self = {}
        self.x = x
        self.y = y

    return self
end

return Vec
