Utils = require "lib.utils"
lvl = require "lib.levels"

local Dungeon = {}

function Dungeon:create(curr_level)
    local total_rooms = curr_level -- 6 is the min. no. of rooms
    local offset = math.ceil((total_rooms/2))
    local origin = {offset, offset}
    local gen = Utils:new_matrix(total_rooms, total_rooms)
    gen[origin[1]][origin[2]] = 1
    local room_count = 1
    local maybe_room = {}

    while room_count < total_rooms do
        if Utils:get_adjacent_cells(origin, total_rooms) == nil then goto continue end
        for _, coord in ipairs(Utils:get_adjacent_cells(origin, total_rooms)) do
            if coord[1] > 0 and coord[1] < total_rooms and coord[2] > 0 and coord[2] < total_rooms and gen[coord[1]][coord[2]] == 0 then
                table.insert(maybe_room, coord)
            end
        end

        math.randomseed(os.time())

        choice = math.random(1, #maybe_room)
        set_coord = maybe_room[choice]

        if gen[set_coord[1]][set_coord[2]] == 1 then
            goto continue
        end

        gen[set_coord[1]][set_coord[2]] = 1
        origin = set_coord
        table.remove(maybe_room, choice)

        room_count = room_count + 1
        ::continue::
    end

    Utils:print_matrix(gen) -- debugging
    print("\n")

    return gen
end

function Dungeon:draw_level(ox, oy, lvl)
    for p = 1, #lvl do
        for q = 1, #lvl[p] do
            love.graphics.draw(floor, (p * CELL_SIZE) + ox, (q * CELL_SIZE) + oy)
        end
    end
end

function Dungeon:draw(gen)
    for i = 1, #gen do
        for j = 1, #gen[i] do
            if gen[i][j] == 1 then
                Dungeon:draw_level((i * CELL_SIZE * 6) - (CELL_SIZE * 20), (j *CELL_SIZE * 6) - (CELL_SIZE * 20), lvl[6])
            end
        end
    end
end

function Dungeon:fill_dungeon()
    
end

return Dungeon