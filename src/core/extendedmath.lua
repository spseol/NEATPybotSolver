function math.sigmoid(x)
    -- round to network could be able to get 1 or -1
    -- if x >= 2 then
    --     return 1
    -- elseif x <= -2 then
    --     return -1
    -- else 
        return 2 / (1 + math.exp(-4.9 * x)) - 1
    -- end
end