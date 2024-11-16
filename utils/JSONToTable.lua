-- Função para converter JSON (string) para tabela
local function JSONToTable(jsonStr)
    local func, err = load("return " .. jsonStr, "JSON", "t", {})
    if not func then
        error("Erro ao interpretar JSON: " .. err)
    end
    return func()
end

return JSONToTable;