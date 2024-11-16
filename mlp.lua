-- Importando módulos
local ActivationFunctions = require('utils/ActivationFunctions');
local randomWeight = require('utils/randomWeight');
local ValidateDataset = require('validators/ValidateDataset');
local ValidateLayerFunctions = require('validators/ValidateLayerFunctions');
local ValidateStructure = require('validators/ValidateStructure');
local DefaultValues = require('utils/DefaultValues');
local Initialization = DefaultValues.Initialization;
local LayerType      = DefaultValues.LayerType;
local createFilledArray = require('utils/createFilledArray');
local deepCopy = require('utils/deepCopy');
local saveToFile = require('utils/saveToFile');
local loadFromFile = require('utils/loadFromFile');

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
    function obj:compute_train_cost( inputs, mytargets, estimatedValues )
        local cost = 0;
        
        for i = 1, #inputs
        do
            local targets      = mytargets[i];
            local estimations  = estimatedValues[i];

            for S = 1, #estimations
            do
                local diferenca = estimations[S] - targets[S]
                cost = cost + (diferenca * diferenca) -- Substituí math.pow(diferenca, 2) por diferenca * diferenca
            end
        end

        return cost;
    end

    --[[
        Retorna os parametros iniciais que foram usados para inicializar a rede
    ]]--
    function obj:getInitialParameters()
        return obj.initialParameters;
    end

    --[[
       Log the current network parameters values in a string
       @param parameterShow - The show type
    ]]--
    function obj:logParameters( parameterShow )
        -- Definir valor padrão para parameterShow se não for fornecido
        parameterShow = parameterShow or 'short';

        local netStr = '-=-=- WEIGHTS OF THE NETWORK: -=-=- \n\n'
        local identSimbol = '--->'

        -- Iterar sobre as camadas (layers)
        for l = 1, #obj.weights do
            netStr = netStr .. 'LAYER ' .. l - 1 .. ':\n '

            -- Iterar sobre as unidades (units) de cada camada
            for j = 1, #obj.weights[l] do
                if parameterShow == 'verbose' then
                    netStr = netStr .. '     ' .. identSimbol .. ' UNIT OF NUMBER ' .. j - 1 .. ':\n '
                elseif parameterShow == 'short' then
                    netStr = netStr .. '     ' .. identSimbol .. ' UNIT ' .. j - 1 .. ':\n '
                end

                -- Iterar sobre os pesos (weights) de cada unidade
                for k = 1, #obj.weights[l][j] do
                    if parameterShow == 'verbose' then
                        netStr = netStr .. '          ' .. identSimbol .. ' WEIGHT OF INPUT X' .. k - 1 .. ': ' .. obj.weights[l][j][k] .. '\n '
                    elseif parameterShow == 'short' then
                        netStr = netStr .. '          ' .. identSimbol .. ' W' .. j - 1 .. k - 1 .. ': ' .. obj.weights[l][j][k] .. '\n '
                    end
                end

                -- Adicionar o viés (bias) para a unidade
                netStr = netStr .. '          ' .. identSimbol .. ' BIAS: ' .. obj.biases[l][j] .. '\n '
                netStr = netStr .. '\n'
            end

            netStr = netStr .. '\n'
        end

        -- Imprimir a string resultante
        io.write(netStr)
    end

    --[[
        Export the current network parameters values into a JSON object
        @returns {DoneParameters}
    ]]--
    function obj:exportParameters()
        -- Criar o objeto com os parâmetros
        local parameters = {
            weights = deepCopy(obj.weights),
            biases = deepCopy(obj.biases),
            layers = deepCopy(obj.layers),
            generatedAt = os.time() -- Timestamp atual
        }

        return parameters
    end

    --Salva os parametros para dentro de um arquivo
    function obj:saveParametersToFile()
        local parametros = obj.exportParameters();
        saveToFile('parameteres/params.json', parametros);
    end

    --[[
        Import the parameters intro this network
        @param {parameters} - The JSON object that contain the weights and biases 
    ]]--
    function obj:importParameters(parameters)
        -- Verifica se o parâmetro fornecido é uma tabela válida
        if type(parameters) ~= "table" then
            error("Os parâmetros fornecidos devem ser uma tabela.")
        end
    
        -- Verifica se os campos necessários estão presentes
        if not parameters.weights or not parameters.biases then
            error("Os parâmetros devem conter os campos 'weights' e 'biases'.")
        end
    
        -- Atualiza os pesos
        self.weights = {}
        for i, layerWeights in ipairs(parameters.weights) do
            self.weights[i] = {}
            for j, weight in ipairs(layerWeights) do
                self.weights[i][j] = weight
            end
        end
    
        -- Atualiza os biases
        self.biases = {}
        for i, bias in ipairs(parameters.biases) do
            self.biases[i] = bias
        end
    
        -- Mensagem opcional para indicar sucesso na importação
        print("Parâmetros importados com sucesso.")
    end

    --Importar os parametros de dentro de um arquivo
    function obj:importParametersFromFile( fileName )
        local dadosArquivo = loadFromFile( fileName );
        obj.importParameters( dadosArquivo );
    end

    --[[
        Forward pass (passagem direta)
    ]]--
    function obj:forward(input)
        if input == nil or #input == 0 then
            error("input inválido para a passagem direta")
        end

        local activations = input;

        --Passar pelos neurônios de cada camada
        obj.layerActivations = {activations}; -- Para armazenar as ativações de cada camada

        for l = 1, #obj.weights
        do
            local nextActivations = {};

            for j = 1, #obj.weights[l]
            do

                local weightedSum = 0;

                for k = 1, #activations
                do
                    weightedSum = weightedSum + activations[k] * obj.weights[l][j][k];
                end

                weightedSum = weightedSum + obj.biases[l][j];

                -- Verifica se a unidade tem uma função especificada, ou se vai usar uma função padrão
                local unidadeTemFuncao = (#obj.layers_functions > 0 and obj.layers_functions[l] and obj.layers_functions[l][j]) and true or false;
                local nomeDaFuncao = (unidadeTemFuncao == true) and obj.layers_functions[l][j] or 'Sigmoid';

                table.insert(nextActivations, ActivationFunctions[ nomeDaFuncao ]( weightedSum ) )
            end

            activations = nextActivations;
            table.insert(obj.layerActivations, activations);
        end

        return activations;
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
        --Garante que os parametros iniciais sejam arquivados ANTES DO TREINAMENTO COMEÇAR
        obj.initialParameters = obj:exportParameters();

        --Valida os dados de treinamento
        ValidateDataset( obj.config, 
                         inputs, 
                         targets );
        
        for epoch = 0, epochs
        do
            for i = 1, #inputs
            do
                local inputAtual = inputs[i]; 
                local target     = targets[i];

                -- Passagem direta
                local output = obj:forward(inputAtual);

                -- Cálculo do erro da saída
                local outputError = {};
                for j = 1, #output
                do
                    local error = target[j] - output[j];
                    table.insert(outputError, error);
                end

                -- Backpropagation (retropropagação)
                local layerErrors = {outputError};

                -- Cálculo dos erros das camadas ocultas, começando da última camada
                for l = #self.weights, 2, -1 do
                    local layerError = {}

                    for j = 1, #self.weights[l - 1] do
                        local error = 0
                        for k = 1, #self.weights[l] do
                            error = error + layerErrors[1][k] * self.weights[l][k][j]
                        end

                        -- Verifica se a unidade tem uma função especificada ou usa uma função padrão
                        local unidadeTemFuncao = (self.layers_functions and self.layers_functions[l] and self.layers_functions[l][j]) ~= nil
                        local nomeDaFuncao = unidadeTemFuncao and self.layers_functions[l][j] or "Sigmoid"

                        -- Aplica a derivada da função de ativação
                        table.insert(
                            layerError,
                            error * ActivationFunctions[nomeDaFuncao .. "Derivative"](self.layerActivations[l][j])
                        )
                    end

                    -- Adiciona os erros da camada oculta atual como o primeiro elemento da tabela
                    table.insert(layerErrors, 1, layerError)
                end

                -- Atualização dos pesos e biases
                for l = #self.weights, 1, -1 do
                    for j = 1, #self.weights[l] do
                        for k = 1, #self.weights[l][j] do
                            -- Atualiza os pesos usando a retropropagação
                            self.weights[l][j][k] = self.weights[l][j][k] + learningRate * layerErrors[l][j] * self.layerActivations[l][k]
                        end
            
                        -- Atualiza os biases
                        self.biases[l][j] = self.biases[l][j] + learningRate * layerErrors[l][j]
                    end
                end
            end

            -- Calculando as estimativas para os dados de entrada APÒS ESSA EPOCA
            local estimatedValuesAfterEpoch = {}

            for i = 1, #inputs do
                local input = inputs[i];

                local output = obj:estimate(input);

                table.insert(estimatedValuesAfterEpoch, output);
            end

            local totalError = obj:compute_train_cost( inputs, targets, estimatedValuesAfterEpoch );

            -- Log do erro para monitoramento
            if epoch % printEpochs == 0 then
                print("Época " .. epoch .. " teve erro " .. totalError)
            end

        end

    end

    function obj:estimate(inputs)
        if inputs == nil or #inputs == 0 then
            error("inputs inválido para a passagem direta")
        end

        return obj:forward(inputs);
    end

    if config.initialization == Initialization.Random then
        -- Código para quando a inicialização for Random
        -- Eu deixo o "i" valendo 2 por que eu tambem ignoro a camada de entrada que não precisa de parametros
        for i = 2, #obj.layers 
        do
            --Pesos entre a camada i-1 e a camada i
            local layerWeights = {};

            for j = 1, obj.layers[i] 
            do
                local neuronWeights = {};

                for k = 1, obj.layers[i - 1]
                do
                    table.insert(neuronWeights, randomWeight() )
                end
                
                table.insert(layerWeights, neuronWeights);
            end

            table.insert(obj.weights, layerWeights)

            --Biases para a camada i
            local qtdeParametros      = obj.layers[i];
            local layerBiases         = createFilledArray(qtdeParametros, function() return randomWeight() end);
            table.insert(obj.biases, layerBiases)
        end 

    elseif config.initialization == Initialization.Zeros then
        -- Código para quando a inicialização for Zeros
        -- Eu deixo o "i" valendo 2 por que eu tambem ignoro a camada de entrada que não precisa de parametros
        for i = 2, #obj.layers 
        do
            --Pesos entre a camada i-1 e a camada i
            local layerWeights = {};

            for j = 1, #obj.layers[i] 
            do
                local neuronWeights = {};

                for k = 1, #obj.layers[i - 1]
                do
                    table.insert(neuronWeights, 0 )
                end
                
                table.insert(layerWeights, neuronWeights);
            end

            table.insert(obj.weights, layerWeights)

            --Biases para a camada i
            local qtdeParametros      = #obj.layers[i];
            local layerBiases         = createFilledArray(qtdeParametros, function() return 0 end);
            table.insert(obj.biases, layerBiases)
        end 

    elseif config.initialization == Initialization.Manual then
        obj.importParameters( config.parameters );

    elseif config.initialization == Initialization.Dev then
        -- Aqui fica por conta do programador definir os parametros antes de tentar usar o modelo
    end

    --Faz a exportação dos parametros iniciais
    obj.initialParameters = obj.exportParameters();

    return obj
end

return MLP;