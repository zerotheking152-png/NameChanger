-- =============================================
-- FISH IT! NAME + LEVEL CHANGER GUI (ON/OFF)
-- Copy paste FULL ke executor lu (Fluxus/Solara/Wave/etc)
-- =============================================

local player = game.Players.LocalPlayer
local customName = "BUAT"          -- default nama
local customLevel = "999"          -- default level
local enabled = false

-- ================== BUAT GUI ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishItNameChanger"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🐟 FISH IT NAME CHANGER"
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Nama
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 100, 0, 30)
nameLabel.Position = UDim2.new(0, 20, 0, 55)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Nama:"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Font = Enum.Font.Gotham
nameLabel.TextScaled = true
nameLabel.Parent = mainFrame

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0, 180, 0, 30)
nameBox.Position = UDim2.new(0, 120, 0, 55)
nameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
nameBox.Text = customName
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.PlaceholderText = "Masukin nama lu"
nameBox.ClearTextOnFocus = false
nameBox.Font = Enum.Font.Gotham
nameBox.TextScaled = true
nameBox.Parent = mainFrame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 8)
nameCorner.Parent = nameBox

-- Level
local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(0, 100, 0, 30)
levelLabel.Position = UDim2.new(0, 20, 0, 95)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Level:"
levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Font = Enum.Font.Gotham
levelLabel.TextScaled = true
levelLabel.Parent = mainFrame

local levelBox = Instance.new("TextBox")
levelBox.Size = UDim2.new(0, 180, 0, 30)
levelBox.Position = UDim2.new(0, 120, 0, 95)
levelBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
levelBox.Text = customLevel
levelBox.TextColor3 = Color3.fromRGB(255, 255, 255)
levelBox.PlaceholderText = "Masukin level"
levelBox.ClearTextOnFocus = false
levelBox.Font = Enum.Font.Gotham
levelBox.TextScaled = true
levelBox.Parent = mainFrame

local levelCorner = Instance.new("UICorner")
levelCorner.CornerRadius = UDim.new(0, 8)
levelCorner.Parent = levelBox

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 280, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 140)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.Text = "OFF - Klik buat nyalain"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleBtn

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: DISABLED"
statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

-- ================== LOGIC ==================
local function updateNameTag(char)
    if not enabled or not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    for _, gui in pairs(head:GetChildren()) do
        if gui:IsA("BillboardGui") or gui.Name:lower():find("name") or gui.Name:lower():find("tag") or gui.Name:lower():find("level") then
            for _, label in pairs(gui:GetDescendants()) do
                if label:IsA("TextLabel") then
                    if label.Text:find(player.Name) or label.Text:find("Level") or label.Text:find("%d+") then
                        label.Text = customName .. "\nLevel " .. customLevel
                    end
                end
            end
        end
    end
end

local function applyChanges()
    if player.Character then
        updateNameTag(player.Character)
    end
end

-- Update real-time tiap heartbeat
game:GetService("RunService").Heartbeat:Connect(function()
    if enabled and player.Character and player.Character:FindFirstChild("Head") then
        updateNameTag(player.Character)
    end
end)

-- Character spawn
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if enabled then
        updateNameTag(char)
    end
end)

-- Toggle logic
local function toggleFunction()
    enabled = not enabled
    if enabled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        toggleBtn.Text = "ON - Klik buat matiin"
        statusLabel.Text = "Status: ENABLED ✅"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        applyChanges()
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        toggleBtn.Text = "OFF - Klik buat nyalain"
        statusLabel.Text = "Status: DISABLED ❌"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

toggleBtn.MouseButton1Click:Connect(toggleFunction)

-- Update custom value langsung dari textbox
nameBox.FocusLost:Connect(function(enterPressed)
    customName = nameBox.Text \~= "" and nameBox.Text or "BUAT"
    if enabled then applyChanges() end
end)

levelBox.FocusLost:Connect(function(enterPressed)
    customLevel = levelBox.Text \~= "" and levelBox.Text or "999"
    if enabled then applyChanges() end
end)

-- Close GUI
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("GUI ditutup. Inject lagi kalau mau dipake.")
end)

-- Kalau character udah ada pas inject
if player.Character then
    task.wait(1)
    if enabled then
        updateNameTag(player.Character)
    end
end

print("✅ FISH IT GUI LOADED! Buka GUI di layar lu, custom nama & level, klik ON/OFF sesuka hati bro!")
