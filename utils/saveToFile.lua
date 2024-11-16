local tableToJSON = require('utils/tableToJSON');

-- Função para salvar um arquivo JSON
local function saveToFile(fileName, tbl)
    local jsonData = tableToJSON(tbl)
    local file = io.open(fileName, "w")
    if file then
        file:write(jsonData)
        file:close()
    else
        error("Não foi possível abrir o arquivo para escrita: " .. fileName)
    end
end

return saveToFile;