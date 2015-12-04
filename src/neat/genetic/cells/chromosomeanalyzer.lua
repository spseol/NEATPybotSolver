ChromosomeAnalyzer = {}
-- return common genes of two chromosomes
function ChromosomeAnalyzer.common(chromosome, otherChromosome)
    local shorterChromosome, longerChromosome = ChromosomeAnalyzer.compareLengthsOfChromosomes(chromosome, otherChromosome)
    local shorterChromosomeInnovations = shorterChromosome:innovations()
    local longerChromosomeInovations = longerChromosome:innovations()
    local moreFitChromosome, lessFitChromosome = ChromosomeAnalyzer.moreFitChromosome(chromosome, otherChromosome)

    local commonGenesInnovations = Set.new(shorterChromosomeInnovations):intersect(
        Set.new(longerChromosomeInovations)
    ):toList()

    local commonGenes = {}
    local lessFitCommonGenes = {}

    -- return genes from both chromosomes, because genes does not have to match in weight
    for _, innovation in pairs(commonGenesInnovations) do
        table.insert(commonGenes, moreFitChromosome:genes()[innovation]:copy())
        table.insert(lessFitCommonGenes, lessFitChromosome:genes()[innovation]:copy())
    end

    return commonGenes, lessFitCommonGenes
end

function ChromosomeAnalyzer.isSameSpecies(chromosome, otherChromosome)
    local disjoint, excess = ChromosomeAnalyzer.disjointAndExcessGenes(chromosome, otherChromosome)
    local common = ChromosomeAnalyzer.common(chromosome, otherChromosome)
    local weights = 0

    for k, gene in pairs(common) do
        weights = weights + gene:weight()
    end
    
    local dExcess = NeatCore.SpeciesCoefficients.excess * table.keysCount(excess)
    local dDisjoint = NeatCore.SpeciesCoefficients.disjoint * table.keysCount(disjoint)
    local dWeights = NeatCore.SpeciesCoefficients.weight * (weights / table.keysCount(common))

    return dExcess + dDisjoint + dWeights < NeatCore.SpeciesCoefficients.deltaThreshold
end

function ChromosomeAnalyzer.compareLengthsOfChromosomes(chromosome1, chromosome2)
    local longerChromosome = table.keysCount(chromosome1:genes()) < table.keysCount(chromosome2:genes()) and chromosome2 or chromosome1
    local shorterChromosome = table.keysCount(chromosome1:genes()) < table.keysCount(chromosome2:genes()) and chromosome1 or chromosome2

    return shorterChromosome, longerChromosome
end

function ChromosomeAnalyzer.disjointAndExcessGenes(chromosome, otherChromosome)
    local shorterChromosome, longerChromosome = ChromosomeAnalyzer.compareLengthsOfChromosomes(chromosome, otherChromosome)
    local shorterChromosomeInnovations = shorterChromosome:innovations()
    local longerChromosomeInovations = longerChromosome:innovations()

    -- is Set
    local disjointGenesInnovations = Set.new(shorterChromosomeInnovations):difference(
        Set.new(longerChromosomeInovations)
    )
    local excessGenesInnovations = {}

    -- split excess genes
    local lowerChromosome, lowerInnovation = ChromosomeAnalyzer.chromosomeWithLowerInnovation(chromosome, otherChromosome)
    for innovation, _ in pairs(disjointGenesInnovations) do
        if innovation > lowerInnovation then
            -- excess genes
            disjointGenesInnovations[innovation] = nil
            table.insert(excessGenesInnovations, innovation)
        end
    end

    -- is List
    disjointGenesInnovations = disjointGenesInnovations:toList()

    -- Fill disjointGenes and excessGenes
    local disjointGenes = {}
    local excessGenes = {}

    for _, innovation in pairs(disjointGenesInnovations) do
        if chromosome:genes()[innovation] then
            table.insert(disjointGenes, chromosome:genes()[innovation]:copy())
        else
            table.insert(disjointGenes, otherChromosome:genes()[innovation]:copy())
        end
    end

    for _, innovation in pairs(excessGenesInnovations) do
        if chromosome:genes()[innovation] then
            table.insert(excessGenes, chromosome:genes()[innovation]:copy())
        else
            table.insert(excessGenes, otherChromosome:genes()[innovation]:copy())
        end
    end -- end of filling

    return disjointGenes, excessGenes
end

function ChromosomeAnalyzer.moreFitChromosome(chromosome, otherChromosome)
    local moreFitChromosome = chromosome:fitness() < otherChromosome:fitness() and otherChromosome or chromosome
    local lessFitChromosome = chromosome:fitness() < otherChromosome:fitness() and chromosome or otherChromosome

    return moreFitChromosome, lessFitChromosome
end

function ChromosomeAnalyzer.chromosomeWithHigherInnovation(chromosome, otherChromosome)
    local highestInnovation = {[chromosome] = 0, [otherChromosome] = 0}

    for _, chromosome in pairs({chromosome, otherChromosome}) do
        for __, gene in pairs(chromosome:genes()) do
            highestInnovation[chromosome] = gene:innovation()
        end
    end

    if highestInnovation[chromosome] > highestInnovation[otherChromosome] then
        return chromosome, highestInnovation[chromosome]
    else
        return otherChromosome, highestInnovation[otherChromosome]
    end
end

function ChromosomeAnalyzer.chromosomeWithLowerInnovation(chromosome, otherChromosome)
    local highestInnovation = {[chromosome] = 0, [otherChromosome] = 0}

    for _, chromosome in pairs({chromosome, otherChromosome}) do
        for __, gene in pairs(chromosome:genes()) do
            highestInnovation[chromosome] = gene:innovation()
        end
    end

    if highestInnovation[chromosome] < highestInnovation[otherChromosome] then
        return chromosome, highestInnovation[chromosome]
    else
        return otherChromosome, highestInnovation[otherChromosome]
    end
end
