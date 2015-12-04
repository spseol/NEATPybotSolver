require "neat.genetic.containers.species"
require "neat.genetic.cells.chromosome"
require "neat.network.network"
require "neat.neatcore"

Pool = {}
PoolMeta = {}
PoolMeta.__index = Pool
function PoolMeta.__tostring(self)
    local content = ""
    print(#self.__species)
    for key, species in pairs(self.__species) do
        content = content .. tostring(key) .. " " .. tostring(species) .. "\n" 
    end
    
    return content
end

function Pool.new()
    local o = {}
    
    property(Pool, "__species", "species", nil, o, {})
    
    setmetatable(o, PoolMeta)
    
    o:_generateInitialChromosomes()
    
    return o
end

function Pool:_generateInitialChromosomes()
    for i = 1, NeatCore.population do
        self:addChromosomeToPool(Chromosome.new(Network.new()))
    end
end

function Pool:newSpecies()
    table.insert(self.__species, Species.new())
end

function Pool:addChromosomeToPool(chromosome)
    local addedToSpecies = false

    for _, species in pairs(self.__species) do
        if ChromosomeAnalyzer.isSameSpecies(chromosome, species:chromosomes()[1]) then
            species:_addChromosome(chromosome)
            addedToSpecies = true
            break
        end
    end
    
    if not addedToSpecies then
        self:newSpecies()
        self.__species[#self.__species]:_addChromosome(chromosome)
    end
end

function Pool:removeWeakSpecies()
    local numberOfNeededChilds
    local survived = {}
    
    for _, species in pairs(self.__species) do
        numberOfChildren = species:averageFitness() / self:totalFitness() * NeatCore.population
        
        -- if it would not reproduce any child, than remove it
        if numberOfChildren >= 1 then
            table.insert(survived, species)
        end
    end
    
    self.__species = survived
end

function Pool:totalFitness()
    local totalFitness = 0
    
    for _, species in pairs(self.__species) do
        totalFitness = totalFitness + species:averageFitness()
    end
    
    return totalFitness
end

function Pool:clearFitness()
    for _, species in pairs(self.__species) do
        for __, chromosome in pairs(species:chromosomes()) do
            chromosome:setFitness(0)
        end
    end
end

function Pool:nextGeneration()
    self:removeWeakSpecies()
    local children = {}

    for _, species in pairs(self.__species) do
        species:removeWorstHalf()
        
        local numberOfChildren = math.floor(species:averageFitness() / self:totalFitness() * NeatCore.population - 1)
        
        for i = 1, numberOfChildren do
            table.insert(children, species:breedChild())
        end
        
        species:removeAllExceptBest()
    end
    
    for _, child in pairs(children) do
        self:addChromosomeToPool(child)
    end
    
    for _, species in pairs(self.__species) do
        species:mutate()
    end
end

function Pool:evaluateAll(inputs, fitnessFunc)
    for _, species in pairs(self.__species) do
        for __, chromosome in pairs(species:chromosomes()) do 
            local network = chromosome:toNetwork()
            local result = network:evaluate(inputs)
            -- print(__, result[1])
            local fitness = fitnessFunc(inputs, result)
            
            chromosome:setFitness(fitness + chromosome:fitness())
            collectgarbage()
        end
    end
end