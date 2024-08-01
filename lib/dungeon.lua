Utils = require "lib.utils"

local Dungeon = {}

function Dungeon:create(curr_level)
    local total_rooms = curr_level + 6 -- 6 is the min. no. of rooms
    local room_count = 0
    local origin = {0, 0}
    local maybe_room = {}
    local actual_room = {{0, 0}}

    while room_count <= total_rooms do
        for _, coord in ipairs(Utils:get_adjacent_cells(origin)) do table.insert(maybe_room, coord) end
        math.randomseed(os.time())
        local choice = math.random(1, #maybe_room)

        table.insert(actual_room, maybe_room[choice])
        origin = maybe_room[choice]
        table.remove(maybe_room, choice)

        room_count = room_count + 1
    end

    actual_room = Utils:offset_coords(actual_room, tonumber((total_rooms/2) + 0.5))

    local gen = Utils:bin_matrix(total_rooms, actual_room)
    Utils:print_matrix(gen) -- debugging

    return gen
end

return Dungeon