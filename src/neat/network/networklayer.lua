require "core.classextensions"

NetworkLayer = {
    input = "input",
    output = "output",
    bias = "bias" 
}

function NetworkLayer.new(layerMark)
    local o = {}

    property(NetworkLayer, "__layerMark", nil, nil, o, layerMark)
    property(NetworkLayer, "__neurons", "neurons", "setNeurons", o, {})

    setmetatable(o, { __index = NetworkLayer })

    return o
end

function NetworkLayer:layerMark()
    local basicLayersAliases = {
        bias = 0,
        input = 0,
        output = math.huge
    }
    
    if type(self.__layerMark) == "number" then
        return self.__layerMark
    else
        return basicLayersAliases[self.__layerMark]
    end
end

function NetworkLayer:hasNeuron(wantedNeuron)
    for _, neuron in pairs(self.__neurons) do
        if neuron:ID() == wantedNeuron:ID() then
            return true
        end
    end
    
    return false
end

function NetworkLayer:addNeuron(neuron)
    table.insert(self.__neurons, neuron)
end