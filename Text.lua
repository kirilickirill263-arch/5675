--[ORBIT] СКРИПТ "DELTA CLICK" ДЛЯ ROBLOX (LocalScript)
-- Активация: клавиша "V" или кнопка GUI
-- Частота: 25 кликов в секунду (настраиваемая задержка)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- НАСТРОЙКИ
local CONFIG = {
    ToggleKey = Enum.KeyCode.V,          -- клавиша включения/выключения
    ClickDelay = 0.04,                   -- задержка между кликами (сек)
    UseMouseButton = Enum.UserInputType.MouseButton1, -- левая кнопка мыши
    AutoAim = false,                     -- автонаведение на ближайшего игрока
    ShowGUI = true
}

-- СОСТОЯНИЕ
local isActive = false
local clickConnection = nil
local guiFrame = nil

-- ФУНКЦИЯ КЛИКА (симуляция нажатия ЛКМ)
local function doClick()
    -- Эмуляция нажатия через виртуальный ввод (только если разрешено Roblox)
    -- Альтернатива: mouse.Button1Down() / mouse.Button1Up()
    mouse.Button1Down()
    task.wait(0.01)
    mouse.Button1Up()
end

-- ЦИКЛ КЛИКОВ (с фиксированной задержкой)
local function startClickLoop()
    if clickConnection then return end
    clickConnection = RunService.Heartbeat:Connect(function()
        if isActive then
            doClick()
            task.wait(CONFIG.ClickDelay)
        end
    end)
end

local function stopClickLoop()
    if clickConnection then
        clickConnection:Disconnect()
        clickConnection = nil
    end
end

-- ПЕРЕКЛЮЧЕНИЕ СОСТОЯНИЯ
local function toggleClick(state)
    isActive = (state ~= nil) and state or not isActive
    if isActive then
        startClickLoop()
        print("[ORBIT] Delta Click АКТИВИРОВАН")
    else
        stopClickLoop()
        print("[ORBIT] Delta Click ОТКЛЮЧЕН")
    end
    -- Обновление цвета GUI
    if guiFrame then
        guiFrame.BackgroundColor3 = isActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end

-- СОЗДАНИЕ GUI (интерфейс)
local function createGUI()
    if not CONFIG.ShowGUI then return end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaClickGUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    guiFrame = Instance.new("Frame")
    guiFrame.Size = UDim2.new(0, 120, 0, 40)
    guiFrame.Position = UDim2.new(0, 10, 0, 10)
    guiFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    guiFrame.BorderSizePixel = 2
    guiFrame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "DELTA CLICK [V]"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = guiFrame

    -- клик по GUI для переключения
    guiFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleClick()
        end
    end)
end

-- ХОТКЕЙ (клавиша V)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CONFIG.ToggleKey then
        toggleClick()
    end
end)

-- АВТОПРИЦЕЛ (опционально)
if CONFIG.AutoAim then
    RunService.Heartbeat:Connect(function()
        if not isActive then return end
        local closest, dist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                local screenPos, onScreen = camera:WorldToScreenPoint(root.Position)
                if onScreen then
                    local d = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = root
                    end
                end
            end
        end
        if closest then
            mouse.MoveTo(closest.Position)  -- наведение на цель
        end
    end)
end

-- ЗАПУСК
createGUI()
print("[ORBIT] Delta Click скрипт загружен. Нажми V для переключения.")

-- БЕЗОПАСНОСТЬ: отключение при выходе
player:OnTeleport(function()
    stopClickLoop()
end)
