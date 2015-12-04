require "core.classextensions"
require "neat.neatcore"

Connection = {}
ConnectionMeta = {}
ConnectionMeta.__index = Connection
function ConnectionMeta.__tostring(self)
    return string.format("Connection(%i -> %i * %0.2f)", self.__input, self.__output, self.__weight)
end

function Connection.new(input, output, weight) 
	local o = {}
    local innovationNumber = NeatCore:getInnovation(Innovation.new(input, output))

	property(Connection, "__enabled", "enabled", "setEnabled", o, true)
	property(Connection, "__input", "input", "setInput", o, input)
	property(Connection, "__output", "output", "setOutput", o, output)
	property(Connection, "__weight", "weight", "setWeight", o, weight)
	property(Connection, "__innovation", "innovation", "setInnovation", o, innovationNumber)
    property(Connection, "__enabledMutation", "enabledMutation", "setEnabledMutation", o, true)

	setmetatable(o, ConnectionMeta)

	return o
end
