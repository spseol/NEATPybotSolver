require "core.classextensions"
require "neat.network.neuron"

Gene = {}

GeneMeta = {
    __index = Gene,
    __tostring = function(self)
        local border = "|"
        local margin = " "
        local fill = "#"
        if not self.__enabled then margin = fill end
        
        local geneString = {
            string.format(border .. margin .. "Gene %i - %0.2f" .. margin .. border, self.__innovation, self.__weight),
            string.format(border .. margin .. "%i -> %i" .. margin, self.__input, self.__output)
        }
        
        geneString[2] = geneString[2] .. string.rep(margin, #geneString[1] - #geneString[2] - 1) .. border

        return geneString[1] .. "\n" .. geneString[2] .. "\n"
    end
}

function Gene.new(networkConnection)
    local o = {}

    property(Gene, "__enabled", "enabled", "setEnabled", o, networkConnection:enabled())
    property(Gene, "__input", "input", nil, o, networkConnection:input())
    property(Gene, "__output", "output", nil, o, networkConnection:output())
    property(Gene, "__innovation", "innovation", nil, o, networkConnection:innovation())
    property(Gene, "__weight", "weight", "setWeight", o, networkConnection:weight())
    property(Gene, "__enabledMutation", "enabledMutation", nil, o, networkConnection:enabledMutation())

    setmetatable(o, GeneMeta)
    
    return o
end

function Gene:copy()
    local o = {}
    
    for k, v in pairs(self) do
        o[k] = v
    end
    
    setmetatable(o, GeneMeta)
    
    return o
end

function Gene:toConnection()
    local connection = Connection.new(self.__input, self.__output, self.__weight)
    connection:setInnovation(self.__innovation)
    
    return connection
end
