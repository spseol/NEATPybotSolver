require "core.classextensions"

Neuron = {
    _ID = 0
}

NeuronMeta = {}

NeuronMeta.__index = Neuron
function NeuronMeta.__tostring(self)
    return string.format("Neuron(ID: %i)", self.__ID)
end

function Neuron.new(isInputOrBias)
    local o = {}

    if not isInputOrBias then
        property(Neuron, "__inputs", "inputs", "setInputs", o, {})
    end

    property(Neuron, "__isInputOrBias", "isInputOrBias", nil, o, isInputOrBias)
    property(Neuron, "__ID", "ID", nil, o, Neuron._ID + 1)
    property(Neuron, "__outputs", "outputs", "setOutputs")
    Neuron._ID = Neuron._ID + 1

    setmetatable(o, NeuronMeta)

    return o
end