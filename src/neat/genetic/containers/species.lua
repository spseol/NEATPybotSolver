require "neat.genetic.cells.chromosome"
require "neat.genetic.factors.mutator"
require "core.core"

Species = {}
SpeciesMeta = {}
SpeciesMeta.__index = Species
function SpeciesMeta.__tostring(self)
    return string.format("Species %f", self:averageFitness())
end

function Species.new()
    local o = {}
    
    property(Species, "__chromosomes", "chromosomes", nil, o, {})
    
    setmetatable(o, SpeciesMeta)
    
    return o
end

function Species:sortChromosomes()
    table.sort(self.__chromosomes, function(a, b) 
        return a:fitness() > b:fitness()
    end)
end

function Species:averageFitness()
    local totalFitnessInSpecies = 0
    
    for _, chromosome in pairs(self.__chromosomes) do
        totalFitnessInSpecies = totalFitnessInSpecies + chromosome:fitness()
    end
    
    return totalFitnessInSpecies / table.keysCount(self.__chromosomes)
end

function Species:_addChromosome(chromosome)
    table.insert(self.__chromosomes, chromosome)
end

function Species:breedChild()
    local parent1 = self.__chromosomes[math.seededRandom(1, #self.__chromosomes)]
    local parent2 = self.__chromosomes[math.seededRandom(1, #self.__chromosomes)]
    
    return Mutator.breedChild(parent1, parent2)
end

function Species:mutate()
    for _, chromosome in pairs(self.__chromosomes) do
        Mutator.mutateChromosome(chromosome)
    end
end

function Species:removeWorstHalf()
    self:sortChromosomes()
    
    for i = 1, math.floor(#self.__chromosomes / 2) do 
        table.remove(self.__chromosomes)
    end
end

function Species:removeAllExceptBest()
    self:sortChromosomes()
    
    while #self.__chromosomes > 1 do
        table.remove(self.__chromosomes)
    end
end

function Species:replaceWorstByChildren(children)
    self:sortChromosomes()
    
    for i = 1, #children do 
        table.remove(self.__chromosomes)
    end
    
    for i = 1, #children do 
        self:_addChromosome(children[i])
    end
end