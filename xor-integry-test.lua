local DefaultValues = require('utils/DefaultValues');
local Initialization = DefaultValues.Initialization;
local LayerType      = DefaultValues.LayerType;
local ioWriteArray   = require('utils/ioWriteArray');
local MLP = require('mlp');

-- Estrutura da rede: 2 neurônios na entrada, 2 na camada oculta, 1 na saída
local mlp = MLP:new({
    layers = {
        { type = LayerType.Input,  inputs = 2, units = 2 },
        { type = LayerType.Hidden, inputs = 2, units = 2 },
        { type = LayerType.Final,  inputs = 2, units = 1 }
    },
    initialization = Initialization.Dev
});

local pesosIniciais = {
    {
        {
            0.8228850033675079,
            -0.314907800152612
        },
        {
            0.001901923545564177,
            0.6076617485704823
        }
    },
    {
        {
            0.21803494362838416,
            0.13302177857890918
        }
    }
};

mlp.weights = pesosIniciais;

local biasesIniciais = {
    {
        -0.6336502693201962,
        0.9156237345346292
    },
    {
        -0.02445825279113123
    }
}

mlp.biases = biasesIniciais;

-- Dados de entrada para o problema XOR
local inputs = {
    {0, 0},
    {0, 1},
    {1, 0},
    {1, 1}
};

-- Saídas esperadas para o XOR
local targets = {
    {0},
    {1},
    {1},
    {0}
};

-- Treinando a rede
mlp:train(inputs, targets, 0.1, 10000, 1000);

-- Testando a rede
io.write('Estimativas:');
for i = 1, #inputs do
    local input = inputs[i];

    local output = mlp:estimate(input);
    io.write('Entrada: ' .. input .. 'Estimativa: ' .. output);
end

--[[
    CONFERI O RESULTADO DA EXECUÇÂO EM LUA DEU O SEGUINTE

    ├ëpoca 0 teve erro 1.0042949265382
    ├ëpoca 1000 teve erro 0.75730424537195
    ├ëpoca 2000 teve erro 0.0067622468014417
    ├ëpoca 3000 teve erro 0.00096456042400615
    ├ëpoca 4000 teve erro 0.0003579708746998
    ├ëpoca 5000 teve erro 0.0001837263766913
    ├ëpoca 6000 teve erro 0.0001111472265208
    ├ëpoca 7000 teve erro 7.4273212730211e-05
    ├ëpoca 8000 teve erro 5.3054752693712e-05
    ├ëpoca 9000 teve erro 3.9753414805063e-05
    ├ëpoca 10000 teve erro 3.0876729421038e-05

    EM TODA EXECUCAÇÂO SEMPRE DÀ ESSE MESMO RESULTADOS
]]--

--[[**
 * O RESULTADO PRECISA BATER COM ISSO 
 
    Erro inicial(ANTES DO TREINAMENTO): 1.006463576017077
    mlp.js:127 Epoch 0, Erro total: 1.0042949265382282
    mlp.js:127 Epoch 1000, Erro total: 0.7573042453719532
    mlp.js:127 Epoch 2000, Erro total: 0.006762246801441626
    mlp.js:127 Epoch 3000, Erro total: 0.0009645604240061526
    mlp.js:127 Epoch 4000, Erro total: 0.0003579708746998038
    mlp.js:127 Epoch 5000, Erro total: 0.0001837263766912989
    mlp.js:127 Epoch 6000, Erro total: 0.00011114722652080309
    mlp.js:127 Epoch 7000, Erro total: 0.00007427321273021063
    mlp.js:127 Epoch 8000, Erro total: 0.00005305475269371219
    mlp.js:127 Epoch 9000, Erro total: 0.000039753414805063484
    script.js:53 Estimativas:
    script.js:56 Entrada: 0,0, Estimativa: 0
    script.js:56 Entrada: 0,1, Estimativa: 1
    script.js:56 Entrada: 1,0, Estimativa: 1
    script.js:56 Entrada: 1,1, Estimativa: 0

 */

/**
 * Erro inicial(ANTES DO TREINAMENTO): 1.006463576017077
mlp.js:127 Epoch 0, Erro total: 1.0042949265382282
mlp.js:127 Epoch 1000, Erro total: 0.7573042453719532
mlp.js:127 Epoch 2000, Erro total: 0.006762246801441626
mlp.js:127 Epoch 3000, Erro total: 0.0009645604240061526
mlp.js:127 Epoch 4000, Erro total: 0.0003579708746998038
mlp.js:127 Epoch 5000, Erro total: 0.0001837263766912989
mlp.js:127 Epoch 6000, Erro total: 0.00011114722652080309
mlp.js:127 Epoch 7000, Erro total: 0.00007427321273021063
mlp.js:127 Epoch 8000, Erro total: 0.00005305475269371219
mlp.js:127 Epoch 9000, Erro total: 0.000039753414805063484
script.js:53 Estimativas:
script.js:56 Entrada: 0,0, Estimativa: 0
script.js:56 Entrada: 0,1, Estimativa: 1
script.js:56 Entrada: 1,0, Estimativa: 1
script.js:56 Entrada: 1,1, Estimativa: 0
 */


/**
 * os pesos finais precisam ser
 * 
 * [
    [
        [
            7.356551391331864,
            -7.512464010167511
        ],
        [
            -7.017645475366182,
            6.69359492863455
        ]
    ],
    [
        [
            12.728437039164444,
            12.855089565130744
        ]
    ]
]
 * 
 */


/**
 * os biases finais precisam ser
 * 
 *[
    [
        -4.016713934290134,
        -3.6312859187312987
    ],
    [
        -6.289294653592655
    ]
]
 */--]]