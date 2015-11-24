if not CoreDefined then

table.keysCount = function(t)
	local count = 0

	for _, __ in pairs(t) do count = count + 1 end

	return count
end

Set = {}

function Set.new(list)
	local o = {}

	for _, v in pairs(list) do
		o[v] = true
	end

	setmetatable(o, { __index = Set })	

	return o
end

function Set:intersect(other)
	local intersect = {}

	for k, _ in pairs(self) do
		if other[k] then
			table.insert(intersect, k)
		end
	end

	return Set.new(intersect)
end

function Set:difference(other)
	local diff = {}

	for firstSet, secondSet in pairs {[other] = self, [self] = other} do
		for k, _ in pairs(firstSet) do
			if not secondSet[k] then
				table.insert(diff, k)
			end
		end
	end

	return Set.new(diff)
end

function Set:toList()
	local list = {}

	for k, _ in pairs(self) do
		table.insert(list, k)
	end

	return list
end

CoreDefined = true
end

--[[local a = Set.new {1, 2, 5, 6}
print(table.keysCount(a))
table.foreach(a, print)
print("---------------------------------")
a[5] = nil
print(table.keysCount(a))
table.foreach(a, print)]]
--[[
A = {}

function A.new()
	local o = {}

	setmetatable(o, { __index = A })

	return o
end

function A:f()
	error("Not implemented")
end

B = {}
setmetatable(B,  { __index = A })
function B.new()
	local o = {}

	setmetatable(o, { __index = B })

	return o
end

function B:f()
	print("ff")
end

a = B.new()
a:f()]]





















