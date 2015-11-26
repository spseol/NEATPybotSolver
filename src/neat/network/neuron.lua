dofile("../../core/classextensions.lua")

if not NeuronDefined then

Neuron = {
	index = 0
}

function Neuron.new(isInput)
	local o = {}

	if not isInput then
		property(Neuron, "__inputs", "inputs", "setInputs", o, {})
	end

	property(Neuron, "__isInput", "isInput", nil, o, isInput)
	property(Neuron, "__index", "index", nil, o, Neuron.index + 1)
	property(Neuron, "__outputs", "outputs", "setOutputs")
	Neuron.index = Neuron.index + 1

	setmetatable(o, { __index = Neuron })

	return o
end

NeuronDefined = true
end