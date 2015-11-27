NeatCore = {
    __innovation = 0,
    population = 1000,

    IO = {
        InputsCount = 2,
        OutputsCount = 1,
        Inputs = {},
        Outputs = {}
    },

    -- settings to determinate chromosomes compability to divide them into species
    SpeciesCoefficients = {
        excess = 1.0,
        disjoint = 1.0,
        weight = 0.4,
        deltaThreshold = 1.5--3.0
    },
    
    -- mutations chances and
    -- chance, that property will inherit parent property, crossover chances etc...
    MutationsChances = {
        chromosome = 0.8,
        perturb = 0.9,
        randomWeight = 0.1,
        disableIfParentDisable = 0.75,
        offspringCrossover = 0.75,
        newNode = 0.3, -- 0.03
        newLink = 0.6, -- 0.05
        disableGene = 0.4,
        enableGene = 0.2
    },
    
    Mutation = {
        interspeciesMatingRate = 0.001,
        stepSize = 0.1
    }
}

function NeatCore:newInnovation()
    self.__innovation = self.__innovation + 1
    return self.__innovation
end

-- returns true if innovation already exists in generation
function NeatCore:checkInnovationinGeneration(innovationGene)
end