require "core.classextensions"

Neuron = {
    output = 1,
    input = 2,
    bias = 4,
    hidden = 8,
}

NeuronMeta = {}
NeuronMeta.__index = Neuron
function NeuronMeta.__tostring(self)
    local neuronType = {
        [1] = "Output",
        [2] = "Input",
        [4] = "Bias",
        [8] = "Hidden"
    }
    return string.format("%s neuron(ID: %i)", neuronType[self.__type], self.__ID)
end

function Neuron.new(neuronType, id)
    local o = {}

    if neuronType ~= Neuron.input then
        property(Neuron, "__inputs", "inputs", "setInputs", o, {})
    end
    
    if neuronType ~= Neuron.output then
        property(Neuron, "__outputs", "outputs", "setOutputs", o, {})
    end

    property(Neuron, "__inputWeights", "inputWeights", "setInputWeights", o, {})
    property(Neuron, "__inputNeurons", "inputNeurons", "setInputNeurons", o, {})
    property(Neuron, "__type", "type", "setType", o, neuronType)
    property(Neuron, "__ID", "ID", "setID", o, id)

    setmetatable(o, NeuronMeta)

    return o
end