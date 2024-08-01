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

function Utils:get_adjacent_cells(cell)
    return {
        Utils:add_coords(cell, {0, -1}),
        Utils:add_coords(cell, {1, 0}),
        Utils:add_coords(cell, {0, 1}),
        Utils:add_coords(cell, {-1, 0})
    }
end

function Utils:bin_matrix(size, coords)
    local mat = Utils:new_matrix(size, size)

    for _, coord in ipairs(coords) do
        mat[coord[1]][coord[2]] = 1
    end

    return mat
end

function Utils:offset_coords(coords, offset)
    local offset_coords = {}
    for _, v in ipairs(coords) do
        table.insert(offset_coords, (Utils:add_coords(v, {offset, offset})))
    end

    return offset_coords
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
