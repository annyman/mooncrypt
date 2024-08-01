local Vec = {} -- // TODO rewrite the whole vec library

function Vec:new(x, y)
    local self = {}
        self.x = x
        self.y = y

    return self
end

function Vec:add(v, w)
    return Vec:new(v.x + w.x, v.y + w.y)
end

function Vec:scale(v, s)
    return Vec:new(v.x * s, v.y * s)
end

function Vec:mag(v)
    return math.sqrt((v.x * v.x) + (v.y * v.y))
end

function Vec:dot(v, w)
    return (v.x * w.x) + (v.y * w.y)
end

return Vec
