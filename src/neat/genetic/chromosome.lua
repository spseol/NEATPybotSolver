function registerLuaFiles(base, subdirs) if registered == nil then registered = {} end if registered[base] then return end local modifiedSubdirs = {} local path = arg[0] local modifiedPath = string.gsub(path, "/", "\\")	local base = string.gsub(base, "/", "\\") for _, sdirPath in pairs(subdirs) do modifiedSubdirs[#modifiedSubdirs + 1] = string.gsub(sdirPath, "/", "\\") end _, last = string.find(modifiedPath, base) base = string.sub(modifiedPath, 1, last + 1)	for _, dirPath in pairs(modifiedSubdirs) do	package.path = package.path .. ";".. base .. dirPath .. "\\?.lua" end registered[base] = true end

registerLuaFiles("NEATPybotSolver", { "src" })
-- registerLuaFiles("neat", { "genetic", "genetic/factors", "network" })

require "core.core"
require "core.neatcore"
require "core.classextensions"
require "neat.network.network"
require "neat.genetic.factors.crossover"
require "neat.genetic.gene"
require "neat.genetic.chromosomeanalyzer"

Chromosome = {}

ChromosomeMeta = {
	__index = Chromosome,
	__tostring = function(self)
		local firstLine = ""
		local secondLine = ""

		for _, gene in pairs(self.__genes) do
			local strGene = tostring(gene)
			firstLine = firstLine .. string.split(strGene, "\n")[1]
			secondLine = secondLine .. string.split(strGene, "\n")[2]
		end

		return string.rep("-", #firstLine) .. "\n" .. firstLine .. "\n" .. secondLine .. "\n" .. string.rep("-", #firstLine)
	end
}

function Chromosome.new(network)
	local o = {}

	-- convert network connections to genes
	local rgenes = {}
	if network then
		for _, v in pairs(network:connections()) do
			rgenes[v:innovation()] = Gene.new(v)
		end
	end

	property(Chromosome, "__genes", "genes", nil, o, rgenes)
	property(Chromosome, "__fitness", "fitness", "setFitness", o, 0)

	setmetatable(o, ChromosomeMeta)

	return o
end

function Chromosome:setGenes(genes)
	for _, gene in pairs(genes) do
		self.__genes[gene:innovation()] = gene
	end
end

function Chromosome:hasGene(gene)
	if self.__genes[gene:innovation()] then
		return true
	else
		return false
	end
end

function Chromosome:toNetwork()
	local network = Network.new(true)
	local connections = {}
	-- TODO add neurons?
	for _, gene in pairs(self.__genes) do
		local connection = Connection.new(gene:input(), gene:output(), gene:weight())
		table.insert(connections, connection)
	end

	network:setConnections(connections)

	return network
end

-- insert innovation number of genes into table
function Chromosome:innovations()
	local innovations = {}

	for k, gene in pairs(self.__genes) do 
		table.insert(innovations, gene:innovation())
	end

	return innovations
end

n = Network.new(true)

local g1 = Connection.new(3, 5, 0.4)
local g2 = Connection.new(3, 4, 0.4)
local g3 = Connection.new(1, 4, 0.4)

local g4 = Connection.new(3, 5, 0.5)
local g5 = Connection.new(3, 4, 0.5)
local g6 = Connection.new(1, 4, 0.5)

local g7 = Connection.new(3, 5, 0.5)
local g8 = Connection.new(3, 4, 0.5)
local g9 = Connection.new(1, 4, 0.5)

n:setConnections({g1, g2, g3, g5, g6, g7, g8, g9})
a = Chromosome.new(n)
a:setFitness(4)

g1:setWeight(0.86)
g2:setWeight(0.86)
g3:setWeight(0.86)

local g10 = Connection.new(3, 5, 0.6)
local g11 = Connection.new(3, 4, 0.6)
local g12 = Connection.new(1, 4, 0.6)

n:setConnections({g1, g2, g3, g4, g6, g7, g8, g9, g10, g11})

b = Chromosome.new(n)
b:setFitness(55)

c = Crossover.crossover(a, b)

print(tostring(a))
print(tostring(b))
print("-----------------------------------------")
print(tostring(c))
--print(b:isSameSpecies(c))
--table.foreach(string.split(tostring(a), "\n"), print)





















