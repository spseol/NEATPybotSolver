require "core.classextensions"
require "neat.network.connection"
require "neat.network.neuron"
require "neat.network.networklayer"
require "neat.neatcore"

Network = {}

function Network.new(empty)
    local o = {}
    setmetatable(o, { __index = Network })

    property(Network, "__layers", "layers", nil, o, {})
    -- property(Network, "__neurons", "neurons", "setNeurons", o, {})
    property(Network, "__connections", "connections", "setConnections", o, {})

    if not empty then
        -- local connections = {}

        for i = 1, NeatCore.IO.InputsCount do
            o:addNeuron(Neuron.new(true), NetworkLayer.input)
            -- table.insert(o.__neurons.input, Neuron.new(true))
            -- create simples connections, i = input neuron index, Neat.IO.InputsCount + 2 = output neuron index  
            -- table.insert(connections, Connection.new(i, Neat.IO.InputsCount + 2))
        end
        
        -- add one extra for bias
        o:addNeuron(Neuron.new(true), NetworkLayer.bias)

        for i = 1, NeatCore.IO.OutputsCount do
            o:addNeuron(Neuron.new(), NetworkLayer.output)
        end
    end

    return o
end

function Network:layerOfNeuron(neuron)
    for _, layer in pairs(self.__layers) do
        if layer:hasNeuron(neuron) then
            return layer:layerMark()
        end
    end
end

function Network:addNeuron(neuron, layer)
    if self.__layers[layer] == nil then
        self.__layers[layer] = NetworkLayer.new(layer)
    end
    
    self.__layers[layer]:addNeuron(neuron)
    -- table.insert(self.__layers[layer], neuron)
end



















