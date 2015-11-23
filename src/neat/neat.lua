-----------------------------------------------------------------------------
Neat = {
	__innovation = 0,
	population = 1000,

	IO = {
		InputsCount = 2,
		OutputsCount = 1
	},

	-- settings to determinate genomes compability to divide them into species
	SpeciesCoefficients = {
		excess = 1.0,
		disjoint = 1.0,
		weight = 0.4,
		deltaThreshold = 3.0
	},

	-- mutations chances
	MutationsChances = {
		genome = 0.8,
		weight = 0.9,
		randomWeight = 0.1
	},

	-- chance, that property will inherit parent property, crossover chances etc...
	TansformationChances = {
		disableIfParentDisable = 0.75,
		offspringCrossover = 0.75,
		interspeciesMatingRate = 0.001,
		newNode = 0.03,
		newLink = 0.05
	}
}

function Neat:_newInnovation()
	self.__innovation = self.__innovation + 1
	return self.__innovation
end

function Neat:_checkInnovationInGeneration()
end

function Neat:evaluateNetwork(network, inputs)
	--TODO dodělat
	outputs = nil
	return outputs
end


Inputs = {}
InputsSize = 2

Outputs = {
	"Result"
}

a = Network.new()
b = a:neurons()
for k,v in pairs(a:neurons()) do
	print(k,v)
end

table.insert(b, "ff")

print("----------------------------")

for k,v in pairs(a:neurons()) do
	print(k,v)
end
