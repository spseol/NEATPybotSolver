

-----------------------------------------------------------------------------
Neat = {}

function Neat:_checkInnovationInGeneration()
end

function Neat:evaluateNetwork(network, inputs)
    --TODO dodělat
    outputs = nil
    return outputs
end


Inputs = {}
InputsSize = 2

Outputs = {
    "Result"
}

a = Network.new()
b = a:neurons()
for k,v in pairs(a:neurons()) do
    print(k,v)
end

table.insert(b, "ff")

print("----------------------------")

for k,v in pairs(a:neurons()) do
    print(k,v)
end
