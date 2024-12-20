local Utils = {}

function Utils:new_matrix(rows, cols)
    local matrix = {}
    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = 0
        end
    end
    return matrix
end

function Utils:add_coords(p1, p2)
    return {
        p1[1] + p2[1],
        p1[2] + p2[2]
    }
end

function Utils:get_adjacent_cells(cell, size)
    result = {}

    if Utils:add_coords(cell, {0, -1})[1] < size and Utils:add_coords(cell, {0, -1})[2] < size then table.insert(result, Utils:add_coords(cell, {0, -1})) end
    if Utils:add_coords(cell, {-1, 0})[1] < size and Utils:add_coords(cell, {-1, 0})[2] < size then table.insert(result, Utils:add_coords(cell, {-1, 0})) end
    if Utils:add_coords(cell, {1, 0})[1] < size and Utils:add_coords(cell, {1, 0})[2] < size then table.insert(result, Utils:add_coords(cell, {1, 0})) end
    if Utils:add_coords(cell, {0, 1})[1] < size and Utils:add_coords(cell, {0, 1})[2] < size then table.insert(result, Utils:add_coords(cell, {0, 1})) end

    return result
end

function Utils:print_matrix(matrix)
    for i = 1, #matrix do
        for j = 1, #matrix[i] do
            io.write(matrix[i][j] .. " ")
        end
        io.write("\n")
    end
end

return Utils
