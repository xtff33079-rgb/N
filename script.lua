getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Internet Cafe Tycoon",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Hub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NetHubConfig",
      FileName = "MainConfig"
   }
})

local Main = Window:CreateTab("Main", 4483362458)
local Section = Main:CreateSection("Auto Features")

_G.AutoCollect = false
_G.AutoBuy = false

Main:CreateToggle({
   Name = "Auto Collect Cash",
   CurrentValue = false,
   Flag = "ToggleCollect",
   Callback = function(Value)
      _G.AutoCollect = Value
      if Value then
         task.spawn(function()
            while _G.AutoCollect do
               pcall(function()
                  for _, v in pairs(workspace:GetDescendants()) do
                     if (v.Name == "Money" or v.Name == "Cash") and v:IsA("BasePart") then
                        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                     end
                  end
               end)
               task.wait(0.3)
            end
         end)
      end
   end,
})

Main:CreateToggle({
   Name = "Auto Buy Buttons",
   CurrentValue = false,
   Flag = "ToggleBuy",
   Callback = function(Value)
      _G.AutoBuy = Value
      if Value then
         task.spawn(function()
            while _G.AutoBuy do
               pcall(function()
                  local playerTycoon = nil
                  for _, tycoon in pairs(workspace.Tycoons:GetChildren()) do
                     if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value == game.Players.LocalPlayer.Name then
                        playerTycoon = tycoon
                        break
                     end
                  end
                  if playerTycoon then
                     for _, btn in pairs(playerTycoon.Buttons:GetChildren()) do
                        if btn:FindFirstChild("Head") and btn.Head.Transparency == 0 then
                           firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, btn.Head, 0)
                           firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, btn.Head, 1)
                        end
                     end
                  end
               end)
               task.wait(1)
            end
         end)
      end
   end,
})

local Settings = Window:CreateTab("Settings", 4483362458)

Settings:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

Settings:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:connect(function()
         vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         task.wait(1)
         vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
   end,
})
