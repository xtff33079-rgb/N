getgenv().SecureMode = true
Rayfield = loadstring(game:HttpGet('https://githubusercontent.com'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Internet Cafe Tycoon",
   LoadingTitle = "Fixing Menu...",
   LoadingSubtitle = "by Hub",
   ConfigurationSaving = {Enabled = true, FolderName = "NetHubConfig"}
})

local Main = Window:CreateTab("Main", 4483362458)
_G.AutoFarm = false
_G.AutoBuy = false

local function GetMyTycoon()
    local tycoons = workspace:FindFirstChild("Tycoons")
    if not tycoons then return nil end
    for _, tycoon in ipairs(tycoons:GetChildren()) do
        local owner = tycoon:FindFirstChild("Owner")
        if owner and (owner.Value == lp.Name or owner.Value == lp) then
            return tycoon
        end
    end
    return nil
end

Main:CreateToggle({
   Name = "Auto Cashier & Collect",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      task.spawn(function()
         local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
         while _G.AutoFarm do
            pcall(function()
               for _, r in ipairs(remotes:GetDescendants()) do
                  if r:IsA("RemoteEvent") and (r.Name:find("Change") or r.Name:find("Serve") or r.Name:find("Cashier") or r.Name:find("Checkout")) then
                     r:FireServer()
                  end
               end
               for _, v in ipairs(workspace:GetChildren()) do
                  if (v.Name == "Cash" or v.Name == "Money") and v:IsA("BasePart") then
                     v.CFrame = lp.Character.HumanoidRootPart.CFrame
                  end
               end
               local myTycoon = GetMyTycoon()
               if myTycoon then
                   for _, v in ipairs(myTycoon:GetDescendants()) do
                       if v:IsA("ClickDetector") and (v.Parent.Name:find("Register") or v.Parent.Name:find("Cashier")) then
                           fireclickdetector(v)
                       end
                   end
               end
            end)
            task.wait(0.3)
         end
      end)
   end,
})

Main:CreateToggle({
   Name = "Auto Buy Buttons",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoBuy = Value
      task.spawn(function()
         while _G.AutoBuy do
            local myTycoon = GetMyTycoon()
            if myTycoon then
                local folder = myTycoon:FindFirstChild("Buttons") or myTycoon:FindFirstChild("Purchases")
                if folder then
                    for _, btn in ipairs(folder:GetChildren()) do
                        local part = btn:FindFirstChild("Head") or btn:FindFirstChild("Part") or btn
                        if part and part:IsA("BasePart") and part.Transparency == 0 then
                            firetouchinterest(lp.Character.HumanoidRootPart, part, 0)
                            firetouchinterest(lp.Character.HumanoidRootPart, part, 1)
                        end
                    end
                end
            end
            task.wait(1)
         end
      end)
   end,
})

local Settings = Window:CreateTab("Settings", 4483362458)
Settings:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if lp.Character and lp.Character:FindFirstChild("Humanoid") then
          lp.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

lp.Idled:Connect(function()
   game:GetService("VirtualUser"):CaptureController()
   game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
