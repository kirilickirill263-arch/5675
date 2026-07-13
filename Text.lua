-- [[ ESP С НУЛЯ ДЛЯ PROJECT DELTA ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки
local ESP = {
    Enabled = true,
    BoxColor = Color3.fromRGB(0, 255, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    FontSize = 14,
    MaxDistance = 500
}

-- Создаём папку для объектов ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = game.CoreGui

-- Функция создания ESP для игрока
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Голова для прицела
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    -- Создаём текстовую метку (имя + дистанция)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = ESPFolder
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name .. " [" .. math.floor((head.Position - Camera.CFrame.Position).Magnitude) .. "m]"
    textLabel.TextColor3 = ESP.TextColor
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.3
    textLabel.Parent = billboard
    
    -- Бокс-эсп (рамка вокруг игрока)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Box_" .. player.Name
    box.Size = Vector3.new(3.5, 5.5, 2)
    box.Adornee = character:FindFirstChild("HumanoidRootPart")
    box.Color3 = ESP.BoxColor
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Parent = ESPFolder
end

-- Удаление ESP при выходе игрока
local function RemoveESP(player)
    local billboard = ESPFolder:FindFirstChild("ESP_" .. player.Name)
    if billboard then billboard:Destroy() end
    local box = ESPFolder:FindFirstChild("Box_" .. player.Name)
    if box then box:Destroy() end
end

-- Обновление дистанции (каждый кадр)
game:GetService("RunService").RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local billboard = ESPFolder:FindFirstChild("ESP_" .. player.Name)
                if billboard then
                    local text = billboard:FindFirstChildOfClass("TextLabel")
                    if text then
                        local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                        text.Text = player.Name .. " [" .. dist .. "m]"
                        -- Скрываем если далеко
                        billboard.Enabled = dist <= ESP.MaxDistance
                    end
                end
                local box = ESPFolder:FindFirstChild("Box_" .. player.Name)
                if box then
                    local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                    box.Visible = dist <= ESP.MaxDistance
                end
            end
        end
    end
end)

-- Добавление новых игроков
Players.PlayerAdded:Connect(CreateESP)

-- Удаление при уходе
Players.PlayerRemoving:Connect(RemoveESP)

-- Создаём ESP для уже существующих игроков
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

print("✅ ESP загружен! Отключается клавишей F1")
