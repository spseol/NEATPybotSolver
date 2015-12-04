require "core.classextensions"
require "core.extendedmath"

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

function Neuron:setValue(value)
    if (self.__type & (Neuron.hidden | Neuron.output | Neuron.bias)) ~= 0 then
        error("Value can be set only to input neuron.")
    end
    
    self.__value = value
end

function Neuron:activate(value)
    return math.sigmoid(value)
end

-- TODO add sigmoid
function Neuron:value()
    if self.__type == Neuron.bias then
        return 1
    elseif self.__type == Neuron.input then
        return self.__value
    elseif #self.__inputNeurons == 0 then
        return nil
    else
        local sum = 0
        local iNeuronValue
        
        for key, inputNeuron in pairs(self.__inputNeurons) do
            iNeuronValue = inputNeuron:value()
            
            if iNeuronValue ~= nil then
                sum = sum + iNeuronValue * self.__inputWeights[key] 
            end
        end
        
        return self:activate(sum)
    end
end

function Neuron:addInput(inputNeuronID)
    table.insert(self.__inputs, inputNeuronID)
end

function Neuron:addOutput(outputNeuronID)
    table.insert(self.__outputs, outputNeuronID)
end

function Neuron:removeInput(inputNeuronID)
    if table.find(self.__inputs, inputNeuronID) then
        table.remove(self.__inputs, inputNeuronID)
    end
end

function Neuron:removeOutput(outputNeuronID)
    if table.find(self.__outputs, outputNeuronID) then
        table.remove(self.__outputs, outputNeuronID)
    end
end