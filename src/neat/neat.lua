function registerLuaFiles(base, subdirs) 
    if registered == nil then 
        registered = {} 
    end 
    
    if registered[base] then 
        return 
    end 
    
    local modifiedSubdirs = {} 
    local path = arg[0] 
    local modifiedPath = string.gsub(path, "/", "\\")    
    local base = string.gsub(base, "/", "\\") 
    
    for _, sdirPath in pairs(subdirs) do 
        modifiedSubdirs[#modifiedSubdirs + 1] = string.gsub(sdirPath, "/", "\\") 
    end 
    
    _, last = string.find(modifiedPath, base) base = string.sub(modifiedPath, 1, last + 1)
        
    for _, dirPath in pairs(modifiedSubdirs) do    
        package.path = package.path .. ";".. base .. dirPath .. "\\?.lua" 
    end
     
    registered[base] = true 
end

registerLuaFiles("NEATPybotSolver", { "src" })

require "neat.neatcore"
require "neat.genetic.containers.pool"

local pool = Pool.new()
local generation = 0

function calcFitness(inputs, result)
    if result[1] == nil then
        return 0
    end
    
    local flooredResult = math.floor(result[1])
    
    if inputs[1] ~ inputs[2] == flooredResult then
        return 1
    else
        return 0
    end
end

local n = Network.new()
-- while true do
for i = 1, 20 do 
    pool:clearFitness()
    
    -- eval all to get fitness
    pool:evaluateAll({0, 0}, calcFitness)
    pool:evaluateAll({0, 1}, calcFitness)
    pool:evaluateAll({1, 0}, calcFitness)
    pool:evaluateAll({1, 1}, calcFitness)
    
    
    -- print generation
    generation = generation + 1
    print("Next generation", generation, "-----------------------")
    print(collectgarbage("count"))

    print(pool)
    
    pool:nextGeneration()
end