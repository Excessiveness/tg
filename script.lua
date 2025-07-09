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
frame.Active = true
frame.Draggable = false -- custom drag logic will be used

-- Custom drag logic for the whole frame except the scrolling list
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Prevent drag if clicking on the scrolling list
        local target = game:GetService("UserInputService"):GetFocusedTextBox()
        if input.Target == sprinklerList or (input.Target and input.Target:IsDescendantOf(sprinklerList)) then
            return
        end
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Text = "Sprinkler Remover Script v1.6"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.Parent = frame
title.Active = false -- not draggable, just a label

-- Remove custom drag logic for title bar
-- Remove resize handle and resizing logic

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

-- Status label
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

-- Farm located label (new)
local farmLocatedLabel = Instance.new("TextLabel")
farmLocatedLabel.Size = UDim2.new(0.45, 0, 0.1, 0)
farmLocatedLabel.Position = UDim2.new(0.5, 0, 0.72, 0)
farmLocatedLabel.Text = ""
farmLocatedLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
farmLocatedLabel.Font = Enum.Font.SourceSans
farmLocatedLabel.TextSize = 14
farmLocatedLabel.TextWrapped = true
farmLocatedLabel.TextXAlignment = Enum.TextXAlignment.Left
farmLocatedLabel.BackgroundTransparency = 1
farmLocatedLabel.Parent = frame

-- Add credits label to the GUI
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, 0, 0.07, 0)
creditsLabel.Position = UDim2.new(0, -5, 0.93, 0)
creditsLabel.Text = "Credits: Phynomie"
creditsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
creditsLabel.Font = Enum.Font.SourceSansItalic
creditsLabel.TextSize = 14
creditsLabel.BackgroundTransparency = 1
creditsLabel.TextXAlignment = Enum.TextXAlignment.Right
creditsLabel.Parent = frame

-- Variables
local foundSprinklers = {}
local connection = nil
local playerFarm = nil
local objectsPhysicalConnectionAdded = nil
local objectsPhysicalConnectionRemoved = nil

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

local function findPlayerFarm()
    local farmParent = workspace:FindFirstChild("Farm")
    if not farmParent then return nil end
    
    for _, farm in ipairs(farmParent:GetChildren()) do
        local important = farm:FindFirstChild("Important")
        if important then
            local data = important:FindFirstChild("Data")
            if data then
                local owner = data:FindFirstChild("Owner")
                if owner and owner.Value == player.Name then
                    statusLabel.Text = "Found your farm! (" .. player.Name .. ")"
                    farmLocatedLabel.Text = "Located your farm! (" .. player.Name .. ")"
                    return farm
                end
            end
        end
    end
    farmLocatedLabel.Text = "your farm is not found"
    return nil
end

local function scanForSprinklers()
    -- Find player's farm if we don't have it yet
    if not playerFarm or not playerFarm.Parent then
        playerFarm = findPlayerFarm()
        if not playerFarm then
            statusLabel.Text = "Status: Your farm not found"
            return
        end
    end

    local important = playerFarm:FindFirstChild("Important")
    if not important then
        statusLabel.Text = "Status: Important folder not found in your farm"
        return
    end

    local objectsPhysical = important:FindFirstChild("Objects_Physical") or important:FindFirstChild("Objects_Phyiscal")
    if not objectsPhysical then
        statusLabel.Text = "Status: Objects_Physical not found in your farm"
        return
    end

    -- Clear previous list
    foundSprinklers = {}

    -- Only add objects named/containing 'Sprinkler' and owned by the local player
    for _, obj in ipairs(objectsPhysical:GetChildren()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and string.find(obj.Name, "Sprinkler") then
            local ownerAttr = obj:GetAttribute("OWNER")
            if ownerAttr == player.Name then
                table.insert(foundSprinklers, obj)
            end
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

local function disconnectSprinklerListeners()
    if objectsPhysicalConnectionAdded then
        objectsPhysicalConnectionAdded:Disconnect()
        objectsPhysicalConnectionAdded = nil
    end
    if objectsPhysicalConnectionRemoved then
        objectsPhysicalConnectionRemoved:Disconnect()
        objectsPhysicalConnectionRemoved = nil
    end
end

local function startMonitoring()
    disconnectSprinklerListeners()
    if not playerFarm or not playerFarm.Parent then
        playerFarm = findPlayerFarm()
        if not playerFarm then
            return
        end
    end
    local important = playerFarm:FindFirstChild("Important")
    if not important then return end
    local objectsPhysical = important:FindFirstChild("Objects_Physical") or important:FindFirstChild("Objects_Phyiscal")
    if not objectsPhysical then return end
    -- Listen for sprinklers being added/removed anywhere under Objects_Physical
    objectsPhysicalConnectionAdded = objectsPhysical.DescendantAdded:Connect(function(child)
        if string.find(child.Name, "Sprinkler") then
            scanForSprinklers()
        end
    end)
    objectsPhysicalConnectionRemoved = objectsPhysical.DescendantRemoving:Connect(function(child)
        if string.find(child.Name, "Sprinkler") then
            scanForSprinklers()
        end
    end)
    -- Initial scan
    scanForSprinklers()
end

-- Button connections
closeButton.MouseButton1Click:Connect(function()
    if connection then connection:Disconnect() end
    gui:Destroy()
end)

renameButton.MouseButton1Click:Connect(renameSprinklers)

-- Initialize
startMonitoring()
