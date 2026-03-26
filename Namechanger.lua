local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Nama & Level Changer PRO",
    LoadingTitle = "Rayfield",
    LoadingSubtitle = "Upgrade by Grok - FULL CUSTOM + AUTO DETECT",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NameLevelChangerPRO",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

local Tab = Window:CreateTab("Main Changer", 0)

-- ==================== SETTINGS ====================
local currentName = game.Players.LocalPlayer.DisplayName
local nameColor = Color3.fromRGB(255, 255, 255)
local nameSize = 1.5
local useStroke = true

local selectedStat = nil
local currentLevelValue = 0

-- ==================== NAMETAG FUNCTION (UPGRADED) ====================
local function applyFakeName(newName, color, sizeMult, stroke)
    if newName == "" then return end
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    
    -- Hapus nametag lama kalau ada
    local oldTag = head:FindFirstChild("FakeNameTagPRO")
    if oldTag then oldTag:Destroy() end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FakeNameTagPRO"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(6, 0, 2, 0)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = newName
    textLabel.TextColor3 = color
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = stroke and 0 or 1
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Parent = billboard
    
    -- Scale ukuran sesuai request
    textLabel.Size = UDim2.new(1, 0, sizeMult, 0)
    
    Rayfield:Notify({
        Title = "✅ Nama Berhasil Diubah",
        Content = "Fake nametag sekarang: " .. newName,
        Duration = 5
    })
end

-- Update existing nametag (live preview)
local function updateExistingNametag(newName, color, sizeMult, stroke)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local tag = head:FindFirstChild("FakeNameTagPRO")
    if tag then
        local textLabel = tag:FindFirstChildOfClass("TextLabel")
        if textLabel then
            textLabel.Text = newName
            textLabel.TextColor3 = color
            textLabel.TextStrokeTransparency = stroke and 0 or 1
            textLabel.Size = UDim2.new(1, 0, sizeMult, 0)
        end
    else
        -- Kalau belum ada, buat baru
        applyFakeName(newName, color, sizeMult, stroke)
    end
end

-- Auto apply saat respawn
local function setupRespawnHandler()
    local player = game.Players.LocalPlayer
    player.CharacterAdded:Connect(function(char)
        wait(1) -- tunggu Head load
        if currentName \~= "" then
            applyFakeName(currentName, nameColor, nameSize, useStroke)
        end
    end)
end

-- ==================== LEVEL FUNCTION (AUTO DETECT) ====================
local function getAllLevelStats()
    local player = game.Players.LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return {} end
    
    local stats = {}
    for _, stat in ipairs(leaderstats:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
            table.insert(stats, stat.Name)
        end
    end
    return stats
end

local function applyLevel(statName, newValue)
    local player = game.Players.LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        Rayfield:Notify({Title = "❌ Error", Content = "Leaderstats tidak ditemukan!", Duration = 6})
        return
    end
    
    local stat = leaderstats:FindFirstChild(statName)
    if stat and (stat:IsA("IntValue") or stat:IsA("NumberValue")) then
        stat.Value = newValue
        Rayfield:Notify({
            Title = "✅ Level Diubah",
            Content = statName .. " sekarang: " .. newValue .. " (client-side)",
            Duration = 5
        })
    else
        Rayfield:Notify({Title = "❌ Error", Content = "Stat " .. statName .. " tidak ditemukan!", Duration = 5})
    end
end

-- ==================== GUI UPGRADED ====================
Tab:CreateSection("🌟 NAMA CHANGER (Full Custom)")

Tab:CreateInput({
    Name = "Nama Baru",
    PlaceholderText = "Ketik nama yang lu mau (bisa emoji dll)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        currentName = Text
    end,
})

Tab:CreateColorPicker({
    Name = "Warna Nama",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        nameColor = Value
        -- Live update kalau nametag udah ada
        updateExistingNametag(currentName, nameColor, nameSize, useStroke)
    end,
})

Tab:CreateSlider({
    Name = "Ukuran Teks",
    Range = {0.5, 5},
    Increment = 0.1,
    CurrentValue = 1.5,
    Callback = function(Value)
        nameSize = Value
        updateExistingNametag(currentName, nameColor, nameSize, useStroke)
    end,
})

Tab:CreateToggle({
    Name = "Text Stroke (Outline Hitam)",
    CurrentValue = true,
    Callback = function(Value)
        useStroke = Value
        updateExistingNametag(currentName, nameColor, nameSize, useStroke)
    end,
})

Tab:CreateButton({
    Name = "🚀 Apply Nama Sekarang",
    Callback = function()
        if currentName \~= "" then
            applyFakeName(currentName, nameColor, nameSize, useStroke)
        end
    end,
})

Tab:CreateSection("📊 LEVEL CHANGER (Auto Detect Semua Stat)")

local statDropdown = Tab:CreateDropdown({
    Name = "Pilih Stat Level",
    Options = {},
    CurrentOption = {},
    Callback = function(Option)
        selectedStat = Option[1]
    end,
})

Tab:CreateButton({
    Name = "🔄 Refresh Daftar Stat Level",
    Callback = function()
        local stats = getAllLevelStats()
        if #stats == 0 then
            Rayfield:Notify({Title = "❌", Content = "Leaderstats belum muncul atau kosong!", Duration = 5})
            return
        end
        statDropdown:Refresh(stats, true) -- true = reset ke pilihan pertama
        Rayfield:Notify({Title = "✅", Content = #stats .. " stat ditemukan!", Duration = 4})
    end,
})

Tab:CreateInput({
    Name = "Nilai Level Baru",
    PlaceholderText = "Contoh: 999999",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        currentLevelValue = tonumber(Text) or 0
    end,
})

Tab:CreateButton({
    Name = "🚀 Apply Level",
    Callback = function()
        if selectedStat and currentLevelValue \~= 0 then
            applyLevel(selectedStat, currentLevelValue)
        else
            Rayfield:Notify({Title = "⚠️", Content = "Pilih stat dulu & isi angkanya!", Duration = 5})
        end
    end,
})

Tab:CreateButton({
    Name = "🗑️ Reset Nametag (Hapus Fake Name)",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local tag = head:FindFirstChild("FakeNameTagPRO")
                if tag then tag:Destroy() end
            end
        end
        Rayfield:Notify({Title = "Reset", Content = "Fake nametag sudah dihapus", Duration = 4})
    end,
})

-- ==================== AUTO START ====================
setupRespawnHandler()

Rayfield:Notify({
    Title = "✅ Script PRO Loaded!",
    Content = "Nama full custom + Level auto-detect ✅\nKlik Refresh Stat Level dulu biar work 100%",
    Duration = 10
})
