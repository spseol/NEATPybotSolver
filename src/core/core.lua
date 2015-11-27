table.keysCount = function(t)
    local count = 0

    for _, __ in pairs(t) do count = count + 1 end

    return count
end

table.last = function(t)
    local last

    for _, v in pairs(t) do
        last = v
    end

    return last
end

table.join = function(t)
    local result = ""

    for _, v in pairs(t) do
        result = result .. v
    end

    return result
end

table.copy = function(t)
    local copiedTable = {}

    for k, v in pairs(t) do
        copiedTable[k] = v
    end

    return copiedTable
end

table.merge = function(t1, t2)
    local result = table.copy(t1)

    for k, v in pairs(t2) do
        result[k] = v
    end

    return result
end

table.join = function(t1, t2)
    local result = table.copy(t1)

    for _, v in pairs(t2) do
        table.insert(result, v)
    end

    return result
end

string.split = function(str, separator)
    local list = {}
    local startCharIndex = 1
    
    for i = 1, #str do
        local char = string.sub(str, i, i)
        if char == separator then
            table.insert(list, string.sub(str, startCharIndex, i - 1))
            startCharIndex = i + 1    -- skip separator
        end
    end

    return list
end

math.round = function(v)
    local rest = v - math.floor(v)

    if rest < 0.5 then
        return math.floor(v)
    else
        return math.ceil(v)
    end
end

math.randomseed(os.time())
math.random()
function math.seededRandom(start, end_)
    -- math.randomseed(math.random())
    if start ~= nil and end_ ~= nil then
        return math.random(start, end_)
    else
      return math.random()
    end
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

--local b = {print, {}, "u", print}
--print(table.keysCount(b))
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





















