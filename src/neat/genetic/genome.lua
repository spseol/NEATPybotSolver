dofile("../core/classextensions.lua")
dofile("gene.lua")
dofile("../core/core.lua")
dofile("../core/neatcore.lua")

if not GenomeDefined then

Genome = {}

function Genome.new(network)
	local o = {}

	-- convert network connections to genes
	local rgenes = {}
	for _, v in pairs(network:connections()) do
		table.insert(rgenes, Gene.new(v))
	end

	table.sort(rgens, function(a, b) return a:innovation() < b:innovation() end)

	property(Genome, "__genes", "genes", nil, o, rgenes)

	setmetatable(o, { __index = Genome })

	return o
end

function Genome:compareLengthsOfGenomes(genome1, genome2)
	local longerGenome = #genome1:genes() < #genome2:genes() and genome2 or genome1
	local shorterGenome = #genome1:genes() < #genome2:genes() and genome1 or genome2

	return shorterGenome, longerGenome
end

function Genome:merge(otherGenome)
	error("Not implemented")
end

function Genome:innovations()
	local innovations = {}

	for k, gene in pairs(self:genes()) do 
		table.insert(innovations, gene.innovation())
	end

	-- table.sort(innovations)

	return innovations
end

function Genome:disjointAndExcess(otherGenome)
	local shorterGenome, longerGenome = Genome:compareLengthsOfGenomes(self, otherGenome)
	local shorterGenomeInnovations = shorterGenome:innovations()
	local longerGenomeInovations = longerGenome:innovations()


	local disjointGenes = Set.new(shorterGenomeInnovations):difference(
		Set.new(longerGenomeInovations)
	)

	local excess = {}

	for innovation, _ in pairs(disjointGenes) do
		if innovation > shorterGenome[#shorterGenome] then
			disjoint[innovation] = nil
			table.insert(excess, innovation)
		end
	end

	return disjoint:toList(), excess
end

function Genome:isSameSpecies(otherGenome)
	error("Not implemented")
end

GenomeDefined = true
end