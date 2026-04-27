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

getgenv().AutoCashier = false

local vim = game:GetService("VirtualInputManager")

local function click(btn)
    local pos = btn.AbsolutePosition
    local size = btn.AbsoluteSize
    local x = pos.X + size.X/2
    local y = pos.Y + size.Y/2
    vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
    vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function getNumber(str)
    return tonumber(string.match(str or "", "%d+"))
end

local busy = false

Section:NewToggle("Auto Cashier", "", function(state)
    getgenv().AutoCashier = state

    if state then
        task.spawn(function()
            while getgenv().AutoCashier do
                task.wait(0.2)
                if busy then continue end

                local gui = game.Players.LocalPlayer.PlayerGui
                if not gui then continue end

                local cashierUI
                for _, v in ipairs(gui:GetChildren()) do
                    if v:IsA("ScreenGui") and v.Enabled then
                        if v:FindFirstChild("+", true) then
                            cashierUI = v
                            break
                        end
                    end
                end

                if not cashierUI then continue end

                local nums = {}
                local plusBtn, minusBtn, giveBtn

                for _, v in ipairs(cashierUI:GetDescendants()) do
                    if v:IsA("TextLabel") or v:IsA("TextButton") then
                        local num = getNumber(v.Text)
                        if num and num <= 200 then
                            table.insert(nums, num)
                        end
                    end

                    if v:IsA("TextButton") then
                        if v.Text == "+" then plusBtn = v end
                        if v.Text == "-" then minusBtn = v end
                        if v.Text:lower():find("đưa") then giveBtn = v end
                    end
                end

                if #nums < 2 or not plusBtn or not minusBtn then continue end

                table.sort(nums)
                local receive = nums[1]
                local give = nums[#nums]
                local change = give - receive

                if change < 0 or change > 200 then continue end

                busy = true

                for i = 1, 20 do
                    click(minusBtn)
                    task.wait(0.005)
                end

                task.wait(0.05)

                for i = 1, change do
                    click(plusBtn)
                    task.wait(0.004)
                end

                task.wait(0.05)

                if giveBtn then
                    click(giveBtn)
                end

                task.wait(0.2)
                busy = false
            end
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

task.spawn(function()
    while true do
        task.wait(1)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = getgenv().WS
        end
    end
end)
