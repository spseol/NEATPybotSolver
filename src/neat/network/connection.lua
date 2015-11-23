dofile("../core/classextensions.lua")

if not ConnectionDefined then

Connection = {}

function Connection.new(input, output, weight) 
	local o = {}

	property(Connection, "__enabled", "enabled", "setEnabled", o, true)
	property(Connection, "__input", "input", "setInput", o, input)
	property(Connection, "__output", "output", "setOutput", o, output)
	property(Connection, "__weight", "weight", "setWeight", o, weight)
	property(Connection, "__innovation", "innovation", "setInnovation", Neat:_newInnovation())

	setmetatable(o, { __index = Connection })

	return o
end

ConnectionDefined = true
end