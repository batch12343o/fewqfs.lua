-- Hypershot Aimbot & ESP Script v1.0
-- Date: August 15, 2025
-- Features: Aimbot with circle FOV, ESP wallhack for enemies only (not teammates), Nice GUI with Activate/Resume/Close buttons, Minimizes to circle button
-- Compatibility: Delta Executor (inject and execute)
-- How it works: Aimbot locks to closest enemy head in FOV circle; ESP draws boxes/lines through walls for enemies; Team check via Player.Team
-- Anti-Detection: Smooth aim, no spam; Use at own risk (Roblox TOS violation may lead to bans)
-- Game Info: Hypershot is FPS with teams in TDM/CTF; Enemies are opposite team; Weapons/abilities in loadouts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Global toggles
local aimbotEnabled = false
local espEnabled = false
local paused = false
local fovRadius = 150  -- Adjustable FOV circle radius (pixels)

-- ESP drawings table
local espDrawings = {}

-- FOV circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = fovRadius
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Function to check if player is enemy
local function isEnemy(player)
    if player == LocalPlayer then return false end
    if player.Team == LocalPlayer.Team then return false end  -- Ignore teammates
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
        return true
    end
    return false
end

-- Function to get closest enemy in FOV
local function getClosestEnemy()
    local closest = nil
    local minDist = fovRadius
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

-- Aimbot loop
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and not paused then
        local target = getClosestEnemy()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            mousemoverel((targetPos.X - UserInputService:GetMouseLocation().X) / 4, (targetPos.Y - UserInputService:GetMouseLocation().Y) / 4)  -- Smooth aim
        end
    end
end)

-- ESP update loop
RunService.RenderStepped:Connect(function()
    if espEnabled and not paused then
        for _, player in pairs(Players:GetPlayers()) do
            if isEnemy(player) then
                local char = player.Character
                if char then
                    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                        if onScreen then
                            -- Create ESP if not exists
                            if not espDrawings[player] then
                                espDrawings[player] = {
                                    box = Drawing.new("Square"),
                                    line = Drawing.new("Line")
                                }
                                espDrawings[player].box.Thickness = 2
                                espDrawings[player].box.Color = Color3.fromRGB(255, 0, 0)  -- Red for enemies
                                espDrawings[player].line.Thickness = 1
                                espDrawings[player].line.Color = Color3.fromRGB(255, 0, 0)
                            end
                            -- Update box
                            local box = espDrawings[player].box
                            box.Size = Vector2.new(200 / screenPos.Z, 400 / screenPos.Z)  -- Size based on distance
                            box.Position = Vector2.new(screenPos.X - box.Size.X / 2, screenPos.Y - box.Size.Y / 2)
                            box.Visible = true
                            -- Update line to head
                            local line = espDrawings[player].line
                            line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            line.To = Vector2.new(screenPos.X, screenPos.Y)
                            line.Visible = true
                        else
                            if espDrawings[player] then
                                espDrawings[player].box.Visible = false
                                espDrawings[player].line.Visible = false
                            end
                        end
                    end
                end
            end
        end
    else
        -- Hide all ESP if disabled
        for _, drawing in pairs(espDrawings) do
            if drawing.box then drawing.box.Visible = false end
            if drawing.line then drawing.line.Visible = false end
        end
    end
end)

-- Clean up ESP on player leave
Players.PlayerRemoving:Connect(function(player)
    if espDrawings[player] then
        espDrawings[player].box:Remove()
        espDrawings[player].line:Remove()
        espDrawings[player] = nil
    end
end)

-- GUI Setup
local sg = Instance.new("ScreenGui")
sg.Parent = CoreGui
sg.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Dark modern
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)  -- Rounded corners for nice look
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "Hypershot Aimbot & ESP"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = mainFrame

local activateButton = Instance.new("TextButton")
activateButton.Text = "Activate"
activateButton.Size = UDim2.new(0.8, 0, 0, 40)
activateButton.Position = UDim2.new(0.1, 0, 0.3, 0)
activateButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)  -- Blue
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.Parent = mainFrame
activateButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    espEnabled = not espEnabled
    fovCircle.Visible = aimbotEnabled
    activateButton.Text = aimbotEnabled and "Deactivate" or "Activate"
end)

local resumeButton = Instance.new("TextButton")
resumeButton.Text = "Resume"
resumeButton.Size = UDim2.new(0.8, 0, 0, 40)
resumeButton.Position = UDim2.new(0.1, 0, 0.55, 0)
resumeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green
resumeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resumeButton.Parent = mainFrame
resumeButton.MouseButton1Click:Connect(function()
    paused = not paused
    resumeButton.Text = paused and "Resume" or "Pause"
end)

local closeButton = Instance.new("TextButton")
closeButton.Text = "Close"
closeButton.Size = UDim2.new(0.8, 0, 0, 40)
closeButton.Position = UDim2.new(0.1, 0, 0.8, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    local openCircle = sg:FindFirstChild("OpenCircle")
    if not openCircle then
        openCircle = Instance.new("ImageButton")
        openCircle.Name = "OpenCircle"
        openCircle.Size = UDim2.new(0, 50, 0, 50)
        openCircle.Position = UDim2.new(0, 10, 0.9, -60)
        openCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        openCircle.Image = ""
        local uicorner = Instance.new("UICorner")
        uicorner.CornerRadius = UDim.new(0.5, 0)
        uicorner.Parent = openCircle
        openCircle.Parent = sg
        openCircle.MouseButton1Click:Connect(function()
            mainFrame.Visible = true
            openCircle.Visible = false
        end)
    end
    openCircle.Visible = true
end)

-- Update FOV circle position
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        fovCircle.Position = UserInputService:GetMouseLocation()
    end
end)

-- Initial setup
print("Hypershot Script Loaded - GUI Ready")
