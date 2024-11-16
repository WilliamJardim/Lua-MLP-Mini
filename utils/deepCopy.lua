-- Função auxiliar para copiar tabelas profundamente
local function deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for key, value in pairs(orig) do
            copy[deepCopy(key)] = deepCopy(value)
        end
    else -- Para tipos primitivos, apenas copie o valor
        copy = orig
    end
    return copy
end

return deepCopy;