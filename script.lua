if getgenv().ExecConnections then
    for _, v in pairs(getgenv().ExecConnections) do
        pcall(function() v:Disconnect() end)
    end
end
getgenv().ExecConnections = {}

for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "MobileToggle" or v.Name == "Kavo" or v.Name == "Simple Hub VIP" then
        v:Destroy()
    end
end

-- FIX LINK
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Simple Hub VIP", "Midnight")

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local Corner = Instance.new("UICorner")

ScreenGui.Name = "MobileToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
ToggleButton.Position = UDim2.new(0.05,0,0.2,0)
ToggleButton.Size = UDim2.new(0,50,0,50)
ToggleButton.Text = "UI"
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
Corner.CornerRadius = UDim.new(0,12)
Corner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

local Main = Window:NewTab("Auto")
local Section = Main:NewSection("Functions")

getgenv().SmartFarm = false
getgenv().SmartFarmRunning = false

Section:NewToggle("Smart Farm", "", function(state)
    getgenv().SmartFarm = state

    if state and not getgenv().SmartFarmRunning then
        getgenv().SmartFarmRunning = true

        task.spawn(function()
            while true do
                if not getgenv().SmartFarm then break end
                task.wait(0.25) -- giảm lag

                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char then continue end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end

                local target, dist = nil, math.huge

                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        local name = v.Name:lower()
                        if name:find("collect") or name:find("cash") then
                            local d = (hrp.Position - v.Position).Magnitude
                            if d < dist and d < 120 then -- giảm range
                                dist = d
                                target = v
                            end
                        end
                    end
                end

                if target then
                    hrp.CFrame = target.CFrame
                    if firetouchinterest then
                        firetouchinterest(hrp, target, 0)
                        task.wait()
                        firetouchinterest(hrp, target, 1)
                    end
                end
            end

            getgenv().SmartFarmRunning = false
        end)
    end
end)

local Player = Window:NewTab("Player")
local PSection = Player:NewSection("Stats")

getgenv().WS = 16
PSection:NewSlider("WalkSpeed", "", 250, 16, function(s)
    getgenv().WS = s
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end
end)

local wsConn = game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.5)
    hum.WalkSpeed = getgenv().WS
end)
table.insert(getgenv().ExecConnections, wsConn)

-- GIỮ SPEED LUÔN
task.spawn(function()
    while true do
        task.wait(1)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = getgenv().WS
        end
    end
end)
