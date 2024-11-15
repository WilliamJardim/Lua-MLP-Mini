-- Importando módulos
local ActivationFunctions = require('utils/ActivationFunctions');
local randomWeight = require('utils/randomWeight');
local ValidateDataset = require('validators/ValidateDataset');
local ValidateLayerFunctions = require('validators/ValidateLayerFunctions');
local ValidateStructure = require('validators/ValidateStructure');
local DefaultValues = require('utils/DefaultValues');
local Initialization = DefaultValues.Initialization;

-- Define a classe
MLP = {};

-- Método construtor
function MLP:new( config )
    -- Cria um novo objeto
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    -- Propriedades do objeto
    obj.version = '1.0';
    obj.config = config;

    --Aplica uma validação de estrutura 
    ValidateStructure.ValidateStructure( obj.config );

    --layers é um array onde cada elemento é o número de unidades na respectiva camada
    --Essa informação será extraida do config
    obj.layers = {};

    --Esse aqui é um array para armazenar os nomes das funções de ativações das unidades de cada camada, assim: Array de Array<string>
    obj.layers_functions = {};

    for layerIndex = 1, #obj.config.layers do
        local layerDeclaration = obj.config.layers[layerIndex];
        obj.layers[ layerIndex ] = layerDeclaration.units;
    end

    --Identifica quais as funções que cada unidade de cada camada usa,
    --Ignora a camada de entrada que não possui funções
    layerIndex = 2, #obj.config.layers do
        local layerDeclaration = obj.config.layers[layerIndex];

        --Usei - 1 pra ignorar a camada de entrada, e ordenar corretamente
        obj.layers_functions[ layerIndex-1 ] = layerDeclaration.functions;
    end

    --Adicionar validação aqui para validar as funções das camadas
    if #obj.layers_functions then
        --Se tiver this.layers_functions, então ele precisa validar
        ValidateLayerFunctions.ValidateLayerFunctions( obj.config );
    end

    --Inicializando pesos e biases para todas as camadas
    obj.weights = {};
    obj.biases  = {};
        
    -- Método da classe

    --[[
        Calcula o custo de todas as amostras de uma só vez
        @param {Array} train_samples - Todas as amostras de treinamento
        @returns {Number} - o custo
    ]]--
    function obj:compute_train_cost()
        
    end

    --[[
        Retorna os parametros iniciais que foram usados para inicializar a rede
    ]]--
    function obj:getInitialParameters()
        
    end

    --[[
       Log the current network parameters values in a string
       @param parameterShow - The show type
    ]]--
    function obj:logParameters( parameterShow )

    end

    --[[
        Export the current network parameters values into a JSON object
        @returns {DoneParameters}
    ]]--
    function obj:exportParameters()

    end

    --[[
        Import the parameters intro this network
        @param {parameters} - The JSON object that contain the weights and biases 
    ]]--
    function obj:importParameters( parameters )
        
    end

    --[[
        Forward pass (passagem direta)
    ]]--
    function obj:forward(input)

    end

    --[[
        Função de treinamento com retropropagação
    ]]--
    function obj:train(
        inputs,
        targets,
        learningRate,
        epochs,
        printEpochs 
    )

    end

    if config.initialization == Initialization.Random then
        -- Código para quando a inicialização for Random

    elseif config.initialization == Initialization.Zeros then
        -- Código para quando a inicialização for Zeros

    elseif config.initialization == Initialization.Manual then
        obj.importParameters( config.parameters! );

    elseif config.initialization == Initialization.Dev then
        -- Aqui fica por conta do programador definir os parametros antes de tentar usar o modelo
    end

    --Faz a exportação dos parametros iniciais
    obj.initialParameters = obj.exportParameters();

    return obj
end

-- Usar a classe
local config = {
    layers = {
        { units = 3, activation_functions = {"relu", "sigmoid"} },
        { units = 2, activation_functions = {"sigmoid", "softmax"} }
    },
    initialization = Initialization.Random 
}

local mlp = MLP:new(config)