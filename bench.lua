-- first
function ClampConditional(value, min, max)
    local result = (value < min) and min or value
    
    if result > max then
        result = max
    end
    
    return result
end

-- second
function ClampMath(value, min, max)
    return math.max(min, math.min(value, max))
end

-- params
local iterations = 10000000
local runs = 100
local testValue = 15.5
local testMin = 0.0
local testMax = 10.0


print("-" .. string.rep("-", 60))

-- first
local total_time1 = 0
for run = 1, runs do
    local start = os.clock()
    for i = 1, iterations do
        local result = ClampConditional(testValue, testMin, testMax)
    end
    total_time1 = total_time1 + (os.clock() - start)
end
local avg_time1 = total_time1 / runs

-- second
local total_time2 = 0
for run = 1, runs do
    local start = os.clock()
    for i = 1, iterations do
        local result = ClampMath(testValue, testMin, testMax)
    end
    total_time2 = total_time2 + (os.clock() - start)
end
local avg_time2 = total_time2 / runs

print(string.format("ClampConditional: %.6f sec ", avg_time1))
print(string.format("ClampMath:        %.6f sec ", avg_time2))

if avg_time2 < avg_time1 then
    local diff = ((avg_time1 - avg_time2) / avg_time1) * 100
    print(string.format("ClampMath faster %.2f%%", diff))
else
    local diff = ((avg_time2 - avg_time1) / avg_time2) * 100
    print(string.format("ClampConditional faster %.2f%%", diff))
end
