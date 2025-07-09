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

-- Custom print function
local function consolePrint(...)
    local text = ""
    for i, v in ipairs({...}) do
        text ..= tostring(v) .. (i < #({...}) and " " or "")
    end
    
    consoleContent.Text ..= text .. "\n"
    task.wait() -- Allow UI to update
end

-- Search function
local function searchAndPrint(parent, searchTerm)
    for _, child in ipairs(parent:GetDescendants()) do
        if tostring(child):find(searchTerm) then
            consolePrint("Found '" .. searchTerm .. "' at:", child:GetFullName())
        end
    end
end

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
    consolePrint("\n[SCRIPT TERMINATED BY USER]")
end)

-- Main execution
consolePrint("=== Starting Farm Scan ===")
consolePrint("Searching in workspace.Farm:GetChildren()[6].Sign.Core_Part...\n")

local farmChildren = workspace.Farm:GetChildren()
if #farmChildren >= 6 then
    local targetSign = farmChildren[6]:FindFirstChild("Sign")
    if targetSign then
        local corePart = targetSign:FindFirstChild("Core_Part")
        if corePart then
            consolePrint("Scanning for 'robloy22sf'...")
            searchAndPrint(corePart, "robloy22sf")
            
            consolePrint("\nScanning for 'Phynomie'...")
            searchAndPrint(corePart, "Phynomie")
            
            consolePrint("\n=== Scan Complete ===")
        else
            consolePrint("[ERROR] Core_Part not found in Sign")
        end
    else
        consolePrint("[ERROR] Sign not found in Farm child #6")
    end
else
    consolePrint("[ERROR] Farm has less than 6 children")
end

consolePrint("\nClick 'End Script' to close this window")
