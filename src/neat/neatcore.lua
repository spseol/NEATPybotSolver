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
    },
    
    __allInnovations = {}
}

Innovation = {}
InnovationMeta = {}
InnovationMeta.__index = Innovation

function InnovationMeta.__tostring(self)
    return string.format("Innovation(ID: %i || %i -> %i)", self.__innovation, self.__input, self.__output)
end

function Innovation.new(input, output, innovationNumber)
    local o = {}
    
    property(Innovation, "__innovation", "innovation", nil, o, innovationNumber)
    property(Innovation, "__input", "input", nil, o, input)
    property(Innovation, "__output", "output", nil, o, output)
    
    setmetatable(o, InnovationMeta)
    
    return o
end

function NeatCore:getInnovation(innovation)
    local isNewInnovation = self:checkInnovation(innovation)
    
    if isNewInnovation and type(isNewInnovation) == "boolean" then
        return self:addInnovation(innovation)
    else
        return isNewInnovation  -- contains innovation number
    end
end

function NeatCore:addInnovation(innovation)
    self.__innovation = self.__innovation + 1
    self.__allInnovations[self.__innovation] = Innovation.new(innovation:input(), innovation:output(), self.__innovation)
    
    return self.__innovation
end

-- return true if innovation is new return otherwise return innovation number
function NeatCore:checkInnovation(newInnovation)
    for innovationNumber, innovation in pairs(self.__allInnovations) do
        if newInnovation:input() == innovation:input() and newInnovation:output() == innovation:output() then
            return innovationNumber
        end
    end
    
    return true
end