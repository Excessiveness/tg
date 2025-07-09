local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "SprinklerRemoverGUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Window
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.35, 0, 0.4, 0)
frame.Position = UDim2.new(0.5, 0, 0.3, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Text = "Sprinkler Remover Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.15, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeButton.Parent = frame

-- Sprinkler List
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
listLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
listLabel.Text = "Listed Sprinklers:"
listLabel.TextColor3 = Color3.new(1, 1, 1)
listLabel.Font = Enum.Font.SourceSans
listLabel.TextSize = 16
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.BackgroundTransparency = 1
listLabel.Parent = frame

local sprinklerList = Instance.new("ScrollingFrame")
sprinklerList.Size = UDim2.new(0.4, 0, 0.6, 0)
sprinklerList.Position = UDim2.new(0.05, 0, 0.3, 0)
sprinklerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sprinklerList.BorderSizePixel = 0
sprinklerList.ScrollBarThickness = 6
sprinklerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
sprinklerList.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = sprinklerList

local placeholder = Instance.new("TextLabel")
placeholder.Size = UDim2.new(1, 0, 0, 30)
placeholder.Text = "Nothing detected yet..."
placeholder.TextColor3 = Color3.fromRGB(180, 180, 180)
placeholder.Font = Enum.Font.SourceSans
placeholder.TextSize = 14
placeholder.BackgroundTransparency = 1
placeholder.Parent = sprinklerList

-- Action Buttons
local renameButton = Instance.new("TextButton")
renameButton.Size = UDim2.new(0.45, 0, 0.15, 0)
renameButton.Position = UDim2.new(0.5, 0, 0.3, 0)
renameButton.Text = "Change Name"
renameButton.Font = Enum.Font.SourceSans
renameButton.TextSize = 16
renameButton.TextColor3 = Color3.new(1, 1, 1)
renameButton.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
renameButton.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.45, 0, 0.4, 0)
statusLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextWrapped = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = frame

-- Variables
local foundSprinklers = {}
local connection = nil

-- Functions
local function updateList()
    for _, child in ipairs(sprinklerList:GetChildren()) do
        if child:IsA("TextLabel") and child ~= placeholder then
            child:Destroy()
        end
    end

    if #foundSprinklers == 0 then
        placeholder.Visible = true
    else
        placeholder.Visible = false
        for _, sprinkler in ipairs(foundSprinklers) do
            if sprinkler and sprinkler.Parent then
                local item = Instance.new("TextLabel")
                item.Size = UDim2.new(1, 0, 0, 25)
                item.Text = "• " .. sprinkler.Name .. " (" .. sprinkler:GetFullName() .. ")"
                item.TextColor3 = Color3.new(1, 1, 1)
                item.Font = Enum.Font.SourceSans
                item.TextSize = 14
                item.TextXAlignment = Enum.TextXAlignment.Left
                item.BackgroundTransparency = 1
                item.Parent = sprinklerList
            end
        end
    end
end

local function scanForSprinklers()
    local farm = workspace:FindFirstChild("Farm")
    if not farm then
        statusLabel.Text = "Status: Farm not found in workspace"
        return
    end

    -- Find farm with player as owner
    local targetFarm = nil
    for _, child in ipairs(farm:GetChildren()) do
        if child:FindFirstChild("Owner") and child.Owner.Value == player.Name then
            targetFarm = child
            break
        end
    end

    if not targetFarm then
        statusLabel.Text = "Status: No farm owned by you found"
        return
    end

    local objectsPhysical = targetFarm:FindFirstChild("Objects_Physical")
    if not objectsPhysical then
        statusLabel.Text = "Status: Objects_Physical not found in your farm"
        return
    end

    -- Clear previous list
    foundSprinklers = {}

    -- Find all sprinklers
    for _, obj in ipairs(objectsPhysical:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(obj.ClassName, "Sprinkler") then
            table.insert(foundSprinklers, obj)
        end
    end

    updateList()
    statusLabel.Text = "Status: Found " .. #foundSprinklers .. " sprinkler(s)"
end

local function renameSprinklers()
    if #foundSprinklers == 0 then
        statusLabel.Text = "Status: No sprinklers to rename"
        return
    end

    local alreadyRenamed = true
    for _, sprinkler in ipairs(foundSprinklers) do
        if sprinkler and sprinkler.Parent and sprinkler.Name ~= "B" then
            alreadyRenamed = false
            break
        end
    end

    if alreadyRenamed then
        statusLabel.Text = "Status: Sprinklers name has already been changed!"
        return
    end

    for _, sprinkler in ipairs(foundSprinklers) do
        if sprinkler and sprinkler.Parent then
            sprinkler.Name = "B"
        end
    end

    statusLabel.Text = "Status: Renamed " .. #foundSprinklers .. " sprinkler(s) to 'B'"
    task.wait(1)
    scanForSprinklers() -- Refresh the list
end

-- Set up monitoring
local function startMonitoring()
    if connection then connection:Disconnect() end
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        scanForSprinklers()
    end)
end

-- Button connections
closeButton.MouseButton1Click:Connect(function()
    if connection then connection:Disconnect() end
    gui:Destroy()
end)

renameButton.MouseButton1Click:Connect(renameSprinklers)

-- Initialize
startMonitoring()
scanForSprinklers()
