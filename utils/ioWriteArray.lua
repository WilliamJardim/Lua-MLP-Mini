-- Função para escrever um array em uma string
function ioWriteArray(array)
    local result = "{"  -- Inicializa uma string vazia
    
    -- Itera sobre os elementos do array e adiciona na string
    for _, value in ipairs(array) do
        result = result .. tostring(value) .. ", "
    end
    
    -- Adiciona uma nova linha no final
    result = result .. "}" .. "\n"
    
    -- Retorna a string com o conteúdo do array
    return result;
end

return ioWriteArray;