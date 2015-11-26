require "core.classextensions"
require "neat.network.connection"
require "neat.network.neuron"

Network = {}

function Network.new(empty)
	local o = {}

	property(Network, "__neurons", "neurons", "setNeurons", o, {})
	property(Network, "__connections", "connections", "setConnections", o, {})

	if not empty then
		local neurons = {}
		local connections = {}

		-- add one extra for bias
		for i = 1, Neat.IO.InputsCount + 1 do
			table.insert(neurons, Neuron.new(true))
			-- create simples connections, i = input neuron index, Neat.IO.InputsCount + 2 = output neuron index  
			-- table.insert(connections, Connection.new(i, Neat.IO.InputsCount + 2))
		end

		for i = 1, Neat.IO.OutputsCount do
			table.insert(neurons, Neuron.new())
		end
	end

	setmetatable(o, { __index = Network })

	return o
end