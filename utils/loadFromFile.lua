local JSONToTable = require('utils/JSONToTable');

-- Função para carregar JSON de um arquivo
local function loadFromFile(fileName)
    local file = io.open(fileName, "r")
    if not file then
        error("Não foi possível abrir o arquivo para leitura: " .. fileName)
    end

    local jsonData = file:read("*a")
    file:close()
    return JSONToTable(jsonData)
end