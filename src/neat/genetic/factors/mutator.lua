require "neat.neatcore"
require "neat.genetic.factors.crossover"

Mutator = {}

function Mutator.mutateChromosome(chromosome)
    if math.seededRandom() > NeatCore.MutationChances.chromosome then return end
end

function Mutator.mutateGeneWeights(gene)
    if math.seededRandom() > NeatCore.MutationChances.perturb then
        local step = NeatCore.MutationChances.stepSize
        gene:setWeight(gene:weight() + math.seededRandom() * 2 * step - step)
    else
        -- because sigmoid(2) = max(sigmoid) and sigmoid(-2) = min(sigmoid) 
        gene:setWeight(math.seededRandom() * 4 - 2)
    end
end

function Mutator.mutateDisabledInheritedGenes(parent1, parent2, chromosome)
    -- is Set
    local disabledGenesInnovations = {}
    local genes = chromosome:genes()
    
    -- select all disabled genes from parents
    for _, parentChromosome in pairs({parent1, parent2}) do
        for __, gene in pairs(parentChromosome:genes()) do
            if not gene:enabled() then 
                disabledGenesInnovations[gene:innovation()] = true
            end
        end
    end
    
    -- apply inherit disable mutation, where it has chance to have 
    -- disabled gene if parent has that gene disabled as well
    for innovation, _ in pairs(disabledGenesInnovations) do
        for _, gene in pairs(genes) do
            if innovation == gene:innovation() then
                if math.seededRandom() > NeatCore.MutationsChances.disableIfParentDisable then
                    gene:setEnabled(true)
                end
            end
        end
    end
end

function Mutator.mutateChromosoneGenesEnable(chromosome)
    for _, gene in pairs(chromosome:genes()) do
        if math.seededRandom() <= NeatCore.MutationsChances.disableGene then
            gene:setEnabled(false)
        else
            gene:setEnabled(true)
        end
    end
end

function Mutator.newNode(chromosome)
    local genes = chromosome:genes()
    local neuronsIndexes = {}
    local geneIndex = chromosome:innovations()[math.seededRandom(1, #chromosome:innovations())]
    
    for _, gene in pairs(genes) do
        neuronsIndexes[gene:input()] = true
        neuronsIndexes[gene:output()] = true
    end 
    
    -- Set to list and then sort list
    neuronsIndexes = Set.copySet(neuronsIndexes)
    neuronsIndexes = neuronsIndexes:toList()
    table.sort(neuronsIndexes)
    
    for index, gene in pairs(genes) do
        if index == geneIndex then
            local firstNewGene = Gene.new(Connection.new(gene:input(), neuronsIndexes[#neuronsIndexes] + 1, 1))
            local secondNewGene = Gene.new(Connection.new(neuronsIndexes[#neuronsIndexes] + 1, gene:output(), gene:weight()))
             
            genes[firstNewGene:innovation()] = firstNewGene
            genes[secondNewGene:innovation()] = secondNewGene
            gene:setEnabled(false)
        end
    end
end

function Mutator.newLink()
end

function Mutator.crossover()
end
