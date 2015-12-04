require "core.classextensions"
require "neat.network.connection"
require "neat.network.neuron"
require "neat.neatcore"

Network = {}

function Network.new(empty)
    local o = {}
    setmetatable(o, { __index = Network })

    property(Network, "__neuronsCount", "neuronsCount", nil, o, 0)
    property(Network, "__neurons", "neurons", nil, o, {})
    property(Network, "__connections", "connections", "setConnections", o, {})

    if not empty then
        -- local connections = {}

        for i = 1, NeatCore.IO.InputsCount do
            o:addNeuron(Neuron.new(Neuron.input))
            -- table.insert(o.__neurons.input, Neuron.new(true))
            -- create simples connections, i = input neuron index, Neat.IO.InputsCount + 2 = output neuron index  
            -- table.insert(connections, Connection.new(i, Neat.IO.InputsCount + 2))
        end
        
        -- add one extra for bias
        o:addNeuron(Neuron.new(Neuron.bias))

        for i = 1, NeatCore.IO.OutputsCount do
            o:addNeuron(Neuron.new(Neuron.output))
        end
        end
    end

    return o
end

        end
    end
end

    end
    
    self.__layers[layer]:addNeuron(neuron)
    -- table.insert(self.__layers[layer], neuron)
end



















