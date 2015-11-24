dofile("../core/classextensions.lua")

if not GeneDefined then

Gene = {}

GeneMeta = {
	__index = Gene,
	__tostring = (function(self)
		return "Gene innovation " .. self.__innovation .. ": " .. self.__input .. " -> " .. self.__output
	end)
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