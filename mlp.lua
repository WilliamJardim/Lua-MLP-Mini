-- Importando módulos
local ActivationFunctions = require('utils/ActivationFunctions');
local randomWeight = require('utils/randomWeight');
local ValidateDataset = require('validators/ValidateDataset');
local ValidateLayerFunctions = require('validators/ValidateLayerFunctions');
local ValidateStruture = require('validators/ValidateStruture');

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

    return obj
end

-- Usar a classe
local modelo = MLP:new()
modelo:compute_train_cost() 