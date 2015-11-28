require "core.classextensions"

Neuron = {
    index = 0
}

NeuronMeta = {}

NeuronMeta.__index = Neuron
function NeuronMeta.__tostring(self)
    return string.format("Neuron(ID: %i)", self.__ID)
end

function Neuron.new(isInputOrBias)
    local o = {}

    if not isInput then
        property(Neuron, "__inputs", "inputs", "setInputs", o, {})
    end

    property(Neuron, "__isInput", "isInput", nil, o, isInput)
    property(Neuron, "__index", "index", nil, o, Neuron.index + 1)
    property(Neuron, "__outputs", "outputs", "setOutputs")
    Neuron.index = Neuron.index + 1

    setmetatable(o, NeuronMeta)

    return o
end