--[[ 
    Converte uma tabela para JSON 
    Suporta números, strings, tabelas (arrays e objetos)
]]
local function tableToJSON(tbl)
    local result = {}
    local isArray = #tbl > 0  -- Verifica se é uma tabela tipo array

    for key, value in pairs(tbl) do
        local serializedKey
        if not isArray then
            serializedKey = '"' .. tostring(key) .. '":'
        else
            serializedKey = ""
        end

        if type(value) == "table" then
            table.insert(result, serializedKey .. tableToJSON(value))
        elseif type(value) == "string" then
            table.insert(result, serializedKey .. '"' .. value .. '"')
        else
            table.insert(result, serializedKey .. tostring(value))
        end
    end

    if isArray then
        return "[" .. table.concat(result, ",") .. "]"
    else
        return "{" .. table.concat(result, ",") .. "}"
    end
end

return tableToJSON;