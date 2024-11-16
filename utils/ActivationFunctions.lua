-- Definindo a classe de funções de ativação
ActivationFunctions = {}
ActivationFunctions.__index = ActivationFunctions

-- Função para garantir que a classe seja um Singleton
function ActivationFunctions.new()
    error("Não é permitido instanciar esta classe diretamente.")
end

-- Função de ativação sigmoide
function ActivationFunctions.Sigmoid(x)
    return 1 / (1 + math.exp(-x))
end

-- Derivada da sigmoide
function ActivationFunctions.SigmoidDerivative(x)
    return x * (1 - x)
end

-- Função de ativação ReLU
function ActivationFunctions.ReLU(x)
    return math.max(0, x)
end

-- Derivada da ReLU
function ActivationFunctions.ReLUDerivative(x)
    return x > 0 and 1 or 0
end

-- Exportando a tabela para poder usá-la em outro lugar
return ActivationFunctions
