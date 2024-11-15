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