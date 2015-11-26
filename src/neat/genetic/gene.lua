dofile("../../core/classextensions.lua")
dofile("../network/connection.lua")

if not GeneDefined then

Gene = {}

GeneMeta = {
	__index = Gene,
	__tostring = function(self)

		local geneString = {
			string.format("| Gene %i - %0.2f |", self.__innovation, self.__weight),
			string.format("| %i -> %i ", self.__input, self.__output)
		}
		geneString[2] = geneString[2] .. string.rep(" ", #geneString[1] - #geneString[2] - 1) .. "|"

		return geneString[1] .. "\n" .. geneString[2] .. "\n"
	end
}

function Gene.new(networkConnection)
	local o = {}

	property(Gene, "__input", "input", nil, o, networkConnection:input())
	property(Gene, "__output", "output", nil, o, networkConnection:output())
	property(Gene, "__innovation", "innovation", nil, o, networkConnection:innovation())
	property(Gene, "__weight", "weight", nil, o, networkConnection:weight())

	setmetatable(o, GeneMeta)

	return o
end

GeneDefined = true
end
