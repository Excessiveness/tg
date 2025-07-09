-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FarmScannerGUI"
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.5, 0)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "Farm Instance Scanner"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.Parent = frame

-- Output Console
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(0.95, 0, 0.8, 0)
console.Position = UDim2.new(0.025, 0, 0.15, 0)
console.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
console.BorderSizePixel = 0
console.ScrollBarThickness = 6
console.AutomaticCanvasSize = Enum.AutomaticSize.Y
console.Parent = frame

local consoleContent = Instance.new("TextLabel")
consoleContent.Size = UDim2.new(1, 0, 0, 0)
consoleContent.AutomaticSize = Enum.AutomaticSize.Y
consoleContent.Text = ""
consoleContent.TextColor3 = Color3.new(0.8, 0.8, 0.8)
consoleContent.Font = Enum.Font.Code
consoleContent.TextSize = 14
consoleContent.TextXAlignment = Enum.TextXAlignment.Left
consoleContent.TextYAlignment = Enum.TextYAlignment.Top
consoleContent.BackgroundTransparency = 1
consoleContent.TextWrapped = true
consoleContent.Parent = console

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0.08, 0)
closeButton.Position = UDim2.new(0.35, 0, 0.9, 0)
closeButton.Text = "End Script"
closeButton.Font = Enum.Font.SourceSans
closeButton.TextSize = 16
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeButton.Parent = frame

-- Safe print function
local function consolePrint(...)
    local args = {...}
    local text = table.concat(args, " ")
    
    -- Safely update the console
    pcall(function()
        consoleContent.Text = consoleContent.Text .. text .. "\n"
    end)
end

-- Safe search function
local function searchAndPrint(parent, searchTerm)
    if not parent or not parent:IsA("Instance") then
        consolePrint("[ERROR] Invalid parent instance")
        return
    end

    local success, descendants = pcall(function()
        return parent:GetDescendants()
    end)

    if not success then
        consolePrint("[ERROR] Failed to get descendants")
        return
    end

    for _, child in ipairs(descendants) do
        local success, childName = pcall(function()
            return tostring(child)
        end)

        if success and childName:find(searchTerm) then
            local success, fullName = pcall(function()
                return child:GetFullName()
            end)
            consolePrint("Found '" .. searchTerm .. "' at:", success and fullName or "[PATH UNAVAILABLE]")
        end
    end
end

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    pcall(function()
        gui:Destroy()
    end)
    consolePrint("\n[SCRIPT TERMINATED BY USER]")
end)

-- Main execution
consolePrint("=== Starting Farm Scan ===")
consolePrint("Searching in workspace.Farm:GetChildren()[6].Sign.Core_Part...\n")

-- Safe execution of the scan
local success, err = pcall(function()
    local farm = workspace:FindFirstChild("Farm")
    if not farm then
        error("Farm not found in workspace")
    end

    local farmChildren = farm:GetChildren()
    if #farmChildren < 6 then
        error("Farm has less than 6 children")
    end

    local targetSign = farmChildren[6]:FindFirstChild("Sign")
    if not targetSign then
        error("Sign not found in Farm child #6")
    end

    local corePart = targetSign:FindFirstChild("Core_Part")
    if not corePart then
        error("Core_Part not found in Sign")
    end

    consolePrint("Scanning for 'robloy22sf'...")
    searchAndPrint(corePart, "robloy22sf")
    
    consolePrint("\nScanning for 'Phynomie'...")
    searchAndPrint(corePart, "Phynomie")
    
    consolePrint("\n=== Scan Complete ===")
end)

if not success then
    consolePrint("[ERROR] " .. tostring(err))
end

consolePrint("\nClick 'End Script' to close this window")
