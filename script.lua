local function searchAndPrint(parent, searchTerm)
    for _, child in ipairs(parent:GetDescendants()) do
        if tostring(child):find(searchTerm) then
            print("Found '" .. searchTerm .. "' at:", child:GetFullName())
        end
    end
end

-- Get the target parent (workspace.Farm:GetChildren()[6].Sign.Core_Part)
local farmChildren = workspace.Farm:GetChildren()
if #farmChildren >= 6 then
    local targetSign = farmChildren[6]:FindFirstChild("Sign")
    if targetSign then
        local corePart = targetSign:FindFirstChild("Core_Part")
        if corePart then
            -- Search for both terms
            searchAndPrint(corePart, "robloy22sf")
            searchAndPrint(corePart, "Phynomie")
        else
            warn("Core_Part not found in Sign")
        end
    else
        warn("Sign not found in Farm child #6")
    end
else
    warn("Farm has less than 6 children")
end
