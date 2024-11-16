local DefaultValues = require('utils/DefaultValues');
local Initialization = DefaultValues.Initialization;
local MLP = require('mlp');

-- Usar a classe
local config = {
    layers = {
        { units = 3, activation_functions = {"relu", "sigmoid"} },
        { units = 2, activation_functions = {"sigmoid", "softmax"} }
    },
    initialization = Initialization.Random 
}

local mlp = MLP:new(config)

--Dados de entrada para o problema XOR
local inputs = {
    {0, 0},
    {0, 1},
    {1, 0},
    {1, 1}
};

--Saídas esperadas para o XOR
local targets = {
    {0},
    {1},
    {1},
    {0}
};

mlp.logParameters();

--Treinando a rede
mlp.train(inputs, targets, 0.1, 10000);

--Testando a rede
io.write('Estimativas:\n');
for i = 1, #inputs do
    local input = inputs[i];
    local output = mlp:estimate(input);
    
    io.write(string.format("Entrada: %s, Estimativa: %s\n", table.concat(input, ", "), output));
end