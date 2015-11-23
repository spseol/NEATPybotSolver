dofile("../core/classextensions.lua")

if not NetworkDefined then

Network = {}

function Network.new(empty)
	local o = {}

	property(Network, "__neurons", "neurons", "setNeurons", o, {})
	property(Network, "__links", "links", "setLinks", o, {})

	if not empty then
		local neurons = {}
		local links = {}

		-- add one extra for bias
		for i = 1, Neat.IO.InputsCount + 1 do
			table.insert(neurons, Neuron.new(true))
			-- create simples links, i = input neuron index, Neat.IO.InputsCount + 2 = output neuron index  
			-- table.insert(links, Connection.new(i, Neat.IO.InputsCount + 2))
		end

		for i = 1, Neat.IO.OutputsCount do
			table.insert(neurons, Neuron.new())
		end
	end

	setmetatable(o, { __index = Network })

	return o
end

function Network:toGenome()

end

NetworkDefined = true
end