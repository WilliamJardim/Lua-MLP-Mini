local DefaultValues = require('utils/DefaultValues');
local Initialization = DefaultValues.Initialization;
local LayerType      = DefaultValues.LayerType;
local ioWriteArray   = require('utils/ioWriteArray');
local MLP = require('mlp');

-- Usar a classe
local config = {
    layers = {
        { type = LayerType.Input,  inputs = 2, units = 2 },
        { type = LayerType.Hidden, inputs = 2, units = 2, activation_functions = {"sigmoid", "sigmoid"} },
        { type = LayerType.Final,  inputs = 2, units = 1, activation_functions = {"sigmoid"} }
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

mlp:logParameters();

--Treinando a rede
mlp:train(inputs, targets, 0.1, 10000, 1);

--Testando a rede
io.write('Estimativas:\n');

-- Calculando as estimativas para os dados de entrada
local estimatedValues = {}

for i = 1, #inputs do
    local input = inputs[i];

    local output = mlp:estimate(input);
    
    io.write(string.format("Entrada: %s, Estimativa: %s\n", table.concat(input, ", "), ioWriteArray(output) ));

    table.insert(estimatedValues, output);
end

io.write( 'Erro inicial(ANTES DO TREINAMENTO): ', mlp:compute_train_cost( inputs, targets, estimatedValues ) );

