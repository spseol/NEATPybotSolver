Crossover = {}

function Crossover.crossover(chromosome, otherChromosome)
    local childChromosome = Chromosome.new()
    local childGenes = {}

    local parent1Genes = chromosome:genes()
    local parent2Genes = otherChromosome:genes()

    local disjointGenes, excessGenes = ChromosomeAnalyzer.disjointAndExcessGenes(chromosome, otherChromosome)
    -- contains { moreFitGenes, lessFitGenes }
    local commonGenes = { ChromosomeAnalyzer.common(chromosome, otherChromosome) }

    -- randomly inherit parent common genes
    for key, _ in pairs(commonGenes[1]) do
        local usedGene = commonGenes[math.seededRandom(1, 2)][key]
        table.insert(childGenes, usedGene:copy())
    end

    -- inherit excess and disjoint genes from more fit parent
    local moreFitParent, l = ChromosomeAnalyzer.moreFitChromosome(chromosome, otherChromosome)
    local disjointAndExcessGenes = table.join(ChromosomeAnalyzer.disjointAndExcessGenes(chromosome, otherChromosome))

    -- inherit excess and disjoint genes only from more fitter parent
    for _, gene in pairs(disjointAndExcessGenes) do
        if moreFitParent:hasGene(gene) then
            table.insert(childGenes, moreFitParent:genes()[gene:innovation()])
        end
    end

    childChromosome:setGenes(childGenes)
    Mutator.mutateDisabledInheritedGenes(chromosome, otherChromosome, childChromosome)

    return childChromosome
end