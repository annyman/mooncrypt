local Player = {}

function Player:new(name, pos, vel)

    local self = {}
        self.name = name
        self.pos = pos
        self.vel = vel

    return self
end

function Player:speak(player)
    print(player.name)
end

return Player
