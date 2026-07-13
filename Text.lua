-- [[ ESP С МЕНЮ ДЛЯ PROJECT DELTA ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===== НАСТРОЙКИ =====
local Settings = {
    ESPEnabled = true,
    BoxEnabled = true,
    TracerEnabled = true,
    NameEnabled = true,
    DistanceEnabled = true,
    HealthEnabled = true,
    BoxColor = Color3.fromRGB(0, 255, 0),
    TracerColor = Color3.fromRGB(255, 0, 0),
    MaxDistance = 500
}

-- ===== СОЗДАНИЕ ГУИ =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Основной фон меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "⚡ ESP CONTROL ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Функция создания переключателя
local function CreateToggle(parent, yPos, labelText, settingName, defaultState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggleBtn.Text = defaultState and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    
    toggleBtn.MouseButton1Click:Connect(function()
        Settings[settingName] = not Settings[settingName]
        toggleBtn.BackgroundColor3 = Settings[settingName] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleBtn.Text = Settings[settingName] and "ON" or "OFF"
    end)
    
    return toggleBtn
end

-- Создаём переключатели
CreateToggle(MainFrame, 40, "🔹 ESP ВКЛ/ВЫКЛ", "ESPEnabled", true)
CreateToggle(MainFrame, 80, "📦 БОКС-ESP", "BoxEnabled", true)
CreateToggle(MainFrame, 120, "〰️ ЛИНИИ (Tracer)", "TracerEnabled", true)
CreateToggle(MainFrame, 160, "🏷️ ИМЯ", "NameEnabled", true)
CreateToggle(MainFrame, 200, "📏 ДИСТАНЦИЯ", "DistanceEnabled", true)
CreateToggle(MainFrame, 240, "❤️ ЗДОРОВЬЕ", "HealthEnabled", true)

-- Ползунок дистанции
local DistFrame = Instance.new("Frame")
DistFrame.Size = UDim2.new(1, -20, 0, 40)
DistFrame.Position = UDim2.new(0, 10, 0, 285)
DistFrame.BackgroundTransparency = 1
DistFrame.Parent = MainFrame

local DistLabel = Instance.new("TextLabel")
DistLabel.Size = UDim2.new(0.5, 0, 1, 0)
DistLabel.BackgroundTransparency = 1
DistLabel.Text = "📡 Дальность: 500м"
DistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DistLabel.TextXAlignment = Enum.TextXAlignment.Left
DistLabel.TextScaled = true
DistLabel.Font = Enum.Font.Gotham
DistLabel.Parent = DistFrame

local DistSlider = Instance.new("TextButton")
DistSlider.Size = UDim2.new(0.4, 0, 0.6, 0)
DistSlider.Position = UDim2.new(0.55, 0, 0.2, 0)
DistSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DistSlider.Text = " "
DistSlider.BorderSizePixel = 0
DistSlider.Parent = DistFrame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = DistSlider

DistSlider.MouseButton1Down:Connect(function()
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local framePos = DistSlider.AbsolutePosition.X
            local frameSize = DistSlider.AbsoluteSize.X
            local percent = math.clamp((mouseX - framePos) / frameSize, 0, 1)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            Settings.MaxDistance = math.floor(percent * 950 + 50)
            DistLabel.Text = "📡 Дальность: " .. Settings.MaxDistance .. "м"
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Горячая клавиша для открытия/закрытия меню (Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ===== ЛОГИКА ESP =====
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = game.CoreGui

-- Создание ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local head = character:FindFirstChild("Head")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not head or not root then return end
    
    -- Billboard для имени и здоровья
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = ESPFolder
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = ""
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.3
    textLabel.Parent = billboard
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = ""
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextStrokeTransparency = 0.3
    healthLabel.Parent = billboard
    
    -- Бокс
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Box_" .. player.Name
    box.Size = Vector3.new(3.5, 5.5, 2)
    box.Adornee = root
    box.Color3 = Settings.BoxColor
    box.Transparency = 0.4
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Parent = ESPFolder
    
    -- Трейсер
    local tracer = Instance.new("LineHandleAdornment")
    tracer.Name = "Tracer_" .. player.Name
    tracer.Color3 = Settings.TracerColor
    tracer.Thickness = 2
    tracer.Adornee = root
    tracer.PointTo = Camera.CFrame.Position
    tracer.AlwaysOnTop = true
    tracer.Parent = ESPFolder
    
    -- Сохраняем ссылки
    player.ESPData = {
        Billboard = billboard,
        TextLabel = textLabel,
        HealthLabel = healthLabel,
        Box = box,
        Tracer = tracer
    }
end

-- Удаление ESP
local function RemoveESP(player)
    if player.ESPData then
        for _, obj in pairs(player.ESPData) do
            if obj then obj:Destroy() end
        end
        player.ESPData = nil
    end
end

-- Обновление
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        
        if not head or not root or not humanoid then
            if player.ESPData then
                for _, obj in pairs(player.ESPData) do
                    if obj then obj:Destroy() end
                end
                player.ESPData = nil
            end
            continue
        end
        
        local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
        local isVisible = Settings.ESPEnabled and dist <= Settings.MaxDistance
        
        -- Создаём если нет
        if not player.ESPData then
            CreateESP(player)
        end
        
        if player.ESPData then
            -- Обновляем видимость
            player.ESPData.Billboard.Enabled = isVisible and Settings.NameEnabled
            player.ESPData.Box.Visible = isVisible and Settings.BoxEnabled
            player.ESPData.Tracer.Visible = isVisible and Settings.TracerEnabled
            
            -- Обновляем текст
            if isVisible and Settings.NameEnabled then
                local text = ""
                if Settings.NameEnabled then
                    text = player.Name
                end
                if Settings.DistanceEnabled then
                    text = text .. " [" .. dist .. "м]"
                end
                player.ESPData.TextLabel.Text = text
                
                -- Здоровье
                if Settings.HealthEnabled then
                    local hp = math.floor(humanoid.Health)
                    local maxHp = humanoid.MaxHealth
                    local percent = hp / maxHp
                    local color = Color3.fromRGB(255 * (1 - percent), 255 * percent, 0)
                    player.ESPData.HealthLabel.Text = "❤️ " .. hp .. "/" .. maxHp
                    player.ESPData.HealthLabel.TextColor3 = color
                    player.ESPData.HealthLabel.Visible = true
                else
                    player.ESPData.HealthLabel.Visible = false
                end
            else
                player.ESPData.Billboard.Enabled = false
            end
        end
    end
end)

-- Обработка игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if player.ESPData then
            for _, obj in pairs(player.ESPData) do
                if obj then obj:Destroy() end
            end
            player.ESPData = nil
        end
        CreateESP(player)
    end)
end)

Players.PlayerRemoving:Connect(RemoveESP)

-- Существующие игроки
for _, player in pairs(Players:GetPlayers()) do
    task.wait(0.1)
    CreateESP(player)
end

print("✅ ESP Menu загружен! Нажми INSERT для открытия меню")
