require "core.core"
require "neat.neatcore"
require "core.classextensions"
require "neat.network.network"
require "neat.genetic.factors.crossover"
require "neat.genetic.factors.mutator"
require "neat.genetic.cells.gene"
require "neat.genetic.cells.chromosomeanalyzer"

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

function Chromosome:copyChromosome()
    local o = {}

    -- convert network connections to genes
    -- local rgenes = {}
    -- if network then
    --     for _, v in pairs(network:connections()) do
    --         rgenes[v:innovation()] = Gene.new(v)
    --     end
    -- end

    property(Chromosome, "__genes", "genes", nil, o, {})
    property(Chromosome, "__fitness", "fitness", "setFitness", o, 0)

    setmetatable(o, ChromosomeMeta)
    
    for _, gene in pairs(self:genes()) do
        o:addGene(gene:copy())
    end
    
    return o
end

function Chromosome:addGene(gene)
    self.__genes[gene:innovation()] = gene
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
    local network = Network.new(false)

    for _, gene in pairs(self.__genes) do
        local connection = gene:toConnection()
        
        -- generate neurons if they do not exist
        for _, neuronID in pairs({connection:input(), connection:output()}) do
            -- if network does not have neuron
            if not network:neurons()[neuronID] then
                -- because input, bias and output neurons already exists
                neuron = Neuron.new(Neuron.hidden)
                network:addNeuron(neuron, neuronID)
            end
        end
        
        local startNeuron = network:neurons()[connection:input()]
        local endNeuron = network:neurons()[connection:output()]
        
        startNeuron:addOutput(connection:output())
        endNeuron:addInput(connection:input())
        
        network:addConnection(connection)
    end

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

-- n = Network.new(true)
-- local g1 = Connection.new(3, 5, 0.4)
-- local g2 = Connection.new(5, 7, 0.4)
-- local g3 = Connection.new(6, 5, 0.4)

-- local g4 = Connection.new(2, 6, 0.5)
-- local g5 = Connection.new(7, 6, 0.5)

-- local g6 = Connection.new(7, 4, 0.5)

-- local g7 = Connection.new(3, 5, 0.5)
-- local g8 = Connection.new(3, 4, 0.5)
-- local g9 = Connection.new(6, 7, 0.5)

-- n:setConnections({g1, g2, g3, g5, g7, g8, g9})
-- a = Chromosome.new(n)
-- a:setFitness(4)

-- g1:setWeight(0.86)
-- g1:setEnabled(false)
-- g2:setWeight(0.86)
-- g3:setWeight(0.86)
-- g9:setEnabled(false)
-- local g10 = Connection.new(3, 5, 0.6)
-- local g11 = Connection.new(3, 4, 0.6)
-- local g12 = Connection.new(1, 4, 0.6)

-- n:setConnections({g1, g2, g3, g4, g6})

-- b = Chromosome.new(n)
-- b:setFitness(1)
-- -- print(a)
-- -- Mutator.newLink(b)
-- -- print(b)
-- -- print(Crossover.crossover(a, b))
-- -- n = b:toNetwork()

-- local c1 = Connection.new(1, 6, 1)
-- c1:setEnabled(false)
-- local c2 = Connection.new(3, 6, 1)
-- local c3 = Connection.new(6, 7, 1)
-- local c4 = Connection.new(6, 4, 1)
-- local c5 = Connection.new(7, 5, 1)
-- local c6 = Connection.new(2, 7, 1)
-- -- local c7 = Connection.new(7, 6, 1)
-- -- local c8 = Connection.new(2, 4, 1)
-- -- local c9 = Connection.new(2, 7, 1)

-- local nn = Network.new()
-- nn:addConnection(c1)
-- nn:addConnection(c2)
-- nn:addConnection(c3)
-- nn:addConnection(c4)
-- nn:addConnection(c5)
-- nn:addConnection(c6)
-- -- nn:addConnection(c7)
-- -- nn:addConnection(c8)
-- -- nn:addConnection(c9)
-- local ch = Chromosome.new(nn)
 
-- local res = nn:evaluate({1, 1})
-- print("Result\n---------------------------------")
-- table.foreach(res, print)
 

-- for i=1,100 do
--     print(i)
--     print(n:neurons()[n:randomNeuron(Neuron.input | Neuron.bias)])
-- end
-- b:setFitness(55)

-- nn = Network.new(false)
-- nn:addNeuron(Neuron.new(Neuron.hidden))
-- nn:addNeuron(Neuron.new(Neuron.hidden))
-- n = b:toNetwork()
-- nn:addConnection(Connection.new(5, 6, 0.4))
-- nn:addConnection(g3)

-- print(n:checkRecurrentConnection(g5))
-- table.foreach(n:connections(), print)
-- abc = Set.new({})
-- abc[44] = true
-- abc[6] = true
-- table.foreach(abc, print)
-- print(table.keysCount(abc))
--print(a)

-- ne = Network.new(false)

-- table.foreach(ne:layers()[NetworkLayer.input]:neurons(), print)
-- print(ne:layers()[NetworkLayer.input]:layerMark())

-- print(tostring(a))
-- print(tostring(b))
-- print("-----------------------------------------")
-- print(tostring(c))
--print(b:isSameSpecies(c))
--table.foreach(string.split(tostring(a), "\n"), print)





















