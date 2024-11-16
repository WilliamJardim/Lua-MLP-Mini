local function createFilledArray(size, generator)
    local array = {}
    for i = 1, size do
        array[i] = generator()
    end
    return array
end

return createFilledArray;