local radius = 15
local weaponName = "WoodenSword"
local killaura = false

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Syntix - Bridge Duel",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Syntix Hub",
   LoadingSubtitle = "by Syntix",
   ShowText = "Syntix Hub", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Syntix Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Combat", "box")

local Section = MainTab:CreateSection("Combat Settings")

local Toggle = MainTab:CreateToggle({
   Name = "Kill Aura [OP]",
   CurrentValue = false,
   Flag = "AuraToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        killaura = Value
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Kill Aura Range",
   Range = {5, 30},
   Increment = 1,
   Suffix = "Range",
   CurrentValue = 15,
   Flag = "KillRangeSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        radius = Value
   end,
})

--Kill Aura Function
local toolService = ReplicatedStorage:WaitForChild("Modules", 9e9)
    :WaitForChild("Knit", 9e9)
    :WaitForChild("Services", 9e9)
    :WaitForChild("ToolService", 9e9)

local attackFunction = toolService:WaitForChild("RF", 9e9):WaitForChild("AttackPlayerWithSword", 9e9)

--Main KillAura Loop
RunService.RenderStepped:Connect(function()
    if not killaura then return end

    local character = localPlayer.Character
    if not character then return end

    local myHRP = character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetChar = player.Character
            local targetHRP = targetChar.HumanoidRootPart

            if (myHRP.Position - targetHRP.Position).Magnitude <= radius then
                local args = {
                    [1] = workspace:FindFirstChild(targetChar.Name),
                    [2] = false,
                    [3] = weaponName,
                    [4] = "â€‹"
                }
                attackFunction:InvokeServer(unpack(args))
            end
        end
    end
end)
