require "core.classextensions"
require "core.core"
require "neat.network.connection"
require "neat.network.neuron"
require "neat.neatcore"

Network = {}

function Network.new(empty)
    local o = {}
    setmetatable(o, { __index = Network })

    property(Network, "__neuronsCount", "neuronsCount", nil, o, 0)
    property(Network, "__neurons", "neurons", nil, o, {})
    property(Network, "__connections", "connections", "setConnections", o, {})

    if not empty then
        -- local connections = {}

        for i = 1, NeatCore.IO.InputsCount do
            o:addNeuron(Neuron.new(Neuron.input))
            -- table.insert(o.__neurons.input, Neuron.new(true))
            -- create simples connections, i = input neuron index, Neat.IO.InputsCount + 2 = output neuron index  
            -- table.insert(connections, Connection.new(i, Neat.IO.InputsCount + 2))
        end
        
        -- add one extra for bias
        o:addNeuron(Neuron.new(Neuron.bias))

        for i = 1, NeatCore.IO.OutputsCount do
            o:addNeuron(Neuron.new(Neuron.output))
        end
        
        --  generate connections
        for inID = 1, NeatCore.IO.InputsCount + 1 do
            for outID = NeatCore.IO.InputsCount + 2, NeatCore.IO.InputsCount + NeatCore.IO.OutputsCount + 1 do
                local connection = Connection.new(inID, outID, math.seededRandom() * 2 - 1)
                o:addConnection(connection)
            end 
        end
    end

    return o
end

function Network:evaluate(inputs)
    local results = {}
    
    if #inputs ~= NeatCore.IO.InputsCount then
        error("Inputs size do not same as NeatCore.IO.InputsCount")
    end
    
    -- clear neurons weights and neurons
    for _, neuron in pairs(self.__neurons) do
        neuron:setInputWeights({})
        neuron:setInputNeurons({})
    end
    
    -- fill with updated weights and neurons
    for _, connection in pairs(self.__connections) do
        if connection:enabled() then
            self.__neurons[connection:output()]:inputNeurons()[connection:input()] = self.__neurons[connection:input()]
            self.__neurons[connection:output()]:inputWeights()[connection:input()] = connection:weight()
        end 
    end
    
    -- set input to inputs neurons
    for key, value in pairs(inputs) do
        self.__neurons[key]:setValue(value)
    end
    
    -- output neurons indexes starts at InputsCount + 2 and end at InputsCount + OutputsCount + 1 
    for i = 1, NeatCore.IO.OutputsCount do
        results[i] = self.__neurons[NeatCore.IO.InputsCount + i + 1]:value()
    end
    
    return results
end

function Network:findConnection(inputNeuronID, outputNeuronID)
    for _, connection in pairs(self.__connections) do
        if connection:input() == inputNeuronID and connection:output() == outputNeuronID then
            return connection
        end
    end
    
    error("Connection not found")
end

function Network:addConnection(connection)
    if not self.__neurons[connection:input()] then
        self:addNeuron(Neuron.new(Neuron.hidden), connection:input())
    end
    
    if not self.__neurons[connection:output()] then
        self:addNeuron(Neuron.new(Neuron.hidden), connection:output())
    end
    
    self.__neurons[connection:input()]:addOutput(connection:output())
    self.__neurons[connection:output()]:addInput(connection:input())
    table.insert(self.__connections, connection)
end

function Network:removeConnection(connection)
    local inID = connection:input()
    local outID = connection:output()

    if table.find(self.__connections, connection) then
        if table.keysCount(self.__neurons[inID]:outputs()) == 1 and self.__neurons[inID]:outputs() == outID then
            self:removeNeuron(inID)
        end
        
        if table.keysCount(self.__neurons[outID]:inputs()) == 1 and self.__neurons[outID]:inputs() == inID then
            self:removeNeuron(outID)
        end
        
        table.removeTable(self.__connections, connection)
    end
end

function Network:removeNeuron(neuronID)
    self.__neurons[neuronID] = nil
    self.__neuronsCount = self:__lastNeuronID()
end

function Network:addNeuron(neuron, id)
    local neuronID

    if not id then
        self.__neuronsCount = self.__neuronsCount + 1
        neuronID = self.__neuronsCount
    else
        neuronID = id
        self.__neuronsCount = self:__lastNeuronID()
    end

    neuron:setID(neuronID)
    self.__neurons[neuron:ID()] = neuron
end

function Network:checkRecurrentConnection(connection)
    self:addConnection(connection)

    local startNeuron = self.__neurons[connection:input()]
    local currentLayer = Set.new({startNeuron:ID()})
    
    -- because link with bias or input neuron, can not cause recurrent connection
    if startNeuron:type() & (Neuron.input | Neuron.bias) then
        return false
    end 
    
    
    for _, neuronID in pairs(startNeuron:inputs()) do
        currentLayer[neuronID] = true
    end
    
    local expandedLayer
    local clearedLayer
    
    while true do
        expandedLayer = self:__expandLayerPaths(currentLayer) 
        currentLayer = self:__removeOutputNeuronsFromLayer(expandedLayer)
        
        -- means all paths finished in output layer, which means it is not recurrent
        if table.keysCount(currentLayer) == 0 then
            break
        -- if startNeuronID is found in expanded layer
        elseif currentLayer[startNeuron:ID()] then
            self:removeConnection(connection)
            return true
        end
    end
    
    self:removeConnection(connection)
    return false
end

function Network:__expandLayerPaths(currentLayer)
    local expandedLayer = Set.new({})
    
    for neuronID, _ in pairs(currentLayer) do
        local neuronType = self.__neurons[neuronID]:type()
        if neuronType ~= Neuron.input and neuronType ~= Neuron.bias then 
            for _, nextNeuronID in pairs(self.__neurons[neuronID]:inputs()) do
                expandedLayer[nextNeuronID] = true
            end
        end
    end
    
    return expandedLayer
end

-- not removing outputs neurons from network 
function Network:__removeOutputNeuronsFromLayer(currentLayer)
    local needToRemove = Set.new({})

    for neuronID, _ in pairs(currentLayer) do
        if self.__neurons[neuronID]:type() == Neuron.output then
            needToRemove[neuronID] = true
        end
    end
    
    return needToRemove:difference(currentLayer)
end

function Network:__lastNeuronID()
    local lastID
    
    for ID, _ in pairs(self.__neurons) do
        lastID = ID
    end
    
    return lastID
end


function Network:randomNeuron(exclude)
    local IDList = {}
    local randomID
    
    -- sort IDs into list
    for ID, _ in pairs(self.__neurons) do
        table.insert(IDList, ID)
    end
    
    repeat
        randomID = IDList[math.seededRandom(1, #IDList)]
    until exclude & self.__neurons[randomID]:type() == 0
    
    return randomID
end


















