local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Syntix - 99 Nights In The Forest [Beta 1]",
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
      FileName = "SyntixHub"
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
-- Globals
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local ESPFolder = {}
local tracers = {}

--ESP Settings
local espSettings = {
   PlayerESP = false,
   Fairy = false,
   Wolf = false,
   Bunny = false,
   Cultist = false,
   CrossBow = false,
   PeltTrader = false,
   NameColor = Color3.fromRGB(255, 255, 255),
   NameSize = 16,
   HPBarSize = Vector2.new(60, 6)
}

-- Create ESP for a model
local function createESP(model, nameText)
   local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
   if not head then return end

   local name = Drawing.new("Text")
   name.Size = espSettings.NameSize
   name.Center = true
   name.Outline = true
   name.Color = espSettings.NameColor
   name.Visible = false

   -- Health bar background
   local hpBack = Drawing.new("Square")
   hpBack.Color = Color3.fromRGB(0, 0, 0)
   hpBack.Thickness = 1
   hpBack.Filled = true
   hpBack.Transparency = 0.7
   hpBack.Visible = false

   -- Health bar foreground
   local hpBar = Drawing.new("Square")
   hpBar.Color = Color3.fromRGB(0, 255, 0)
   hpBar.Thickness = 1
   hpBar.Filled = true
   hpBar.Transparency = 0.9
   hpBar.Visible = false

   ESPFolder[model] = {
      head = head,
      model = model,
      name = name,
      hpBar = hpBar,
      hpBack = hpBack,
      label = nameText
   }
end

-- Remove all tracers from last frame safely
local function clearTracers()
   for _, line in ipairs(tracers) do
      line:Remove()
   end
   table.clear(tracers)
end

-- Main ESP render loop
RunService.RenderStepped:Connect(function()
   local screenMid = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- bottom center screen
   clearTracers()

   for model, data in pairs(ESPFolder) do
      local head = data.head
      if model and head and model.Parent and head:IsDescendantOf(workspace) then
         local isPlayer = Players:GetPlayerFromCharacter(model)
         local visible = false
         local labelText = ""

         if isPlayer and espSettings.PlayerESP then
            local distVal = math.floor((Camera.CFrame.Position - head.Position).Magnitude)
            labelText = model.Name .. " {" .. distVal .. "m}"
            visible = true
         elseif not isPlayer then
            local n = model.Name:lower()
            local distVal = math.floor((Camera.CFrame.Position - head.Position).Magnitude)
            if espSettings.Fairy and n:find("fairy") then
               labelText = "🧚 Fairy {" .. distVal .. "m}"
               visible = true
            elseif espSettings.Wolf and (n:find("wolf") or n:find("alpha")) then
               labelText = "🐺 Wolf {" .. distVal .. "m}"
               visible = true
            elseif espSettings.Bunny and n:find("bunny") then
               labelText = "🐰 Bunny {" .. distVal .. "m}"
               visible = true
            elseif espSettings.Cultist and n:find("cultist") and not n:find("cross") then
               labelText = "👺 Cultist {" .. distVal .. "m}"
               visible = true
            elseif espSettings.CrossBow and n:find("cross") then
               labelText = "🏹 CrossBow Cultist {" .. distVal .. "m}"
               visible = true
            elseif espSettings.PeltTrader and n:find("pelt") then
               labelText = "🛒 Pelt Trader {" .. distVal .. "m}"
               visible = true
            end
         end

         if visible then
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
               -- Position text 25 pixels ABOVE the head
               local textY = headPos.Y - 25

               data.name.Text = labelText
               data.name.Position = Vector2.new(headPos.X, textY)
               data.name.Color = espSettings.NameColor
               data.name.Size = espSettings.NameSize
               data.name.Visible = true

               -- Health bar below the text
               local humanoid = model:FindFirstChildOfClass("Humanoid")
               if humanoid and humanoid.Health > 0 then
                  local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                  local barWidth = espSettings.HPBarSize.X
                  local barHeight = espSettings.HPBarSize.Y
                  local barX = headPos.X - (barWidth / 2)
                  local barY = textY + 18 -- 18 pixels below the text

                  data.hpBack.Size = Vector2.new(barWidth, barHeight)
                  data.hpBack.Position = Vector2.new(barX, barY)
                  data.hpBack.Visible = true

                  data.hpBar.Size = Vector2.new(barWidth * hpPercent, barHeight)
                  data.hpBar.Position = Vector2.new(barX, barY)
                  data.hpBar.Color = Color3.new(1 - hpPercent, hpPercent, 0) -- green to red gradient
                  data.hpBar.Visible = true
               else
                  data.hpBar.Visible = false
                  data.hpBack.Visible = false
               end

               -- Draw tracer line from bottom center of screen (10 pixels up) to head center
               local line = Drawing.new("Line")
               line.From = screenMid - Vector2.new(0, 10)
               line.To = Vector2.new(headPos.X, headPos.Y)
               line.Color = Color3.fromRGB(255, 0, 0)
               line.Thickness = 1
               line.Visible = true
               table.insert(tracers, line)
            else
               data.name.Visible = false
               data.hpBar.Visible = false
               data.hpBack.Visible = false
            end
         else
            data.name.Visible = false
            data.hpBar.Visible = false
            data.hpBack.Visible = false
         end
      else
         data.name.Visible = false
         data.hpBar.Visible = false
         data.hpBack.Visible = false
      end
   end
end)

-- Scanner to add ESP to models dynamically
task.spawn(function()
   while true do
      task.wait(1)
      for _, model in pairs(workspace:GetDescendants()) do
         if model:IsA("Model") and not ESPFolder[model] and model:FindFirstChild("Head") then
            if Players:GetPlayerFromCharacter(model) or model:IsDescendantOf(workspace.Characters) then
               createESP(model, "Unknown")
            end
         end
      end
   end
end)

-- ESP Toggles in ESP Tab
local Camera = workspace.CurrentCamera

local playerCounter = Drawing.new("Text")
playerCounter.Center = true
playerCounter.Outline = true
playerCounter.Size = 40
playerCounter.Color = Color3.fromRGB(255, 0, 0)
playerCounter.Font = 4
playerCounter.Visible = false

local linesEnabled = false
local trackerEnabled = false

local maxLines = 50
local playerLines = {}
for i = 1, maxLines do
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 2
    playerLines[i] = line
end


-- Update Drawing
game:GetService("RunService").RenderStepped:Connect(function()
    if not trackerEnabled then
        playerCounter.Visible = false
        for _, line in pairs(playerLines) do
            line.Visible = false
        end
        return
    end

    local visibleCount = 0
    local viewportSize = Camera.ViewportSize
    local startLinePos = Vector2.new(viewportSize.X / 2, 50)

    local visiblePlayers = {}

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen and screenPos.Z > 0 then
                    visibleCount += 1
                    table.insert(visiblePlayers, {player = player, pos = Vector2.new(screenPos.X, screenPos.Y)})
                end
            end
        end
    end

    playerCounter.Text = tostring(visibleCount)
    playerCounter.Position = Vector2.new(viewportSize.X / 2, 8)
    playerCounter.Visible = trackerEnabled

    for i = 1, maxLines do
        playerLines[i].Visible = false
    end

    if linesEnabled and visibleCount > 0 then
        for i, info in pairs(visiblePlayers) do
            if i > maxLines then break end
            local line = playerLines[i]
            line.From = startLinePos
            line.To = info.pos
            line.Visible = true
        end
    end
end)

--Bring items
local function bringItemsByName(name)
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
            if part then
                part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end

--Tabs
local InfoTab = Window:CreateTab("Info", "info")
local EspTab = Window:CreateTab("ESP", "box")
local BringTab = Window:CreateTab("Bring Itmes", "bring-to-front")

--Info Tab
InfoTab:CreateParagraph({
   Title = "Hello",
   Content = "This is Syntix Hub , most skidest script ever"
})

--ESP Tab
local Section = EspTab:CreateSection("ESP Settings")

local Toggle = EspTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "ESPToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        espSettings.PlayerESP = Value
        trackerEnabled = Value
        linesEnabled = Value

        playerCounter.Visible = Value

        if not Value then
            for _, line in pairs(playerLines) do
                line.Visible = false
            end
        end
   end,
})

local Toggle = EspTab:CreateToggle({
   Name = "Fairy ESP",
   CurrentValue = false,
   Flag = "FairyToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        espSettings.Fairy = Value
   end,
})

local Toggle = EspTab:CreateToggle({
   Name = "Wolf ESP",
   CurrentValue = false,
   Flag = "WolfToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        espSettings.Wolf = Value
   end,
})

local Toggle = EspTab:CreateToggle({
   Name = "Bunny ESP",
   CurrentValue = false,
   Flag = "WolfToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        espSettings.Bunny = Value
   end,
})

local Toggle = EspTab:CreateToggle({
   Name = "Cultist ESP",
   CurrentValue = false,
   Flag = "WolfToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      espSettings.Cultist = Value
      espSettings.CrossBow = Value
   end,
})

local Toggle = EspTab:CreateToggle({
   Name = "Pelt Trader ESP",
   CurrentValue = false,
   Flag = "WolfToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      espSettings.PeltTrader = Value
   end,
})

local Section = EspTab:CreateSection("Items")

local itemESPEnabled = false
local itemColor = Color3.fromRGB(255, 0, 0) --Red

-- Valid items only (confirmed working/real)
local showToggles = {
    ["Berry"] = false,
    ["Log"] = false,
    ["Chest"] = false,
    ["Toolbox"] = false,
    ["Coal"] = false,
    ["Carrot"] = false,
    ["Flashlight"] = false,
    ["Radio"] = false,
    ["Sheet Metal"] = false,
    ["Bolt"] = false,
    ["Chair"] = false,
    ["Fan"] = false,
    ["Good Sack"] = false,
    ["Good Axe"] = false,
    ["Raw Meat"] = false,
    ["Cooked Meat"] = false,
    ["Stone"] = false,
    ["Nails"] = false,
    ["Scrap"] = false,
    ["Wooden Plank"] = false,
}

local foodItems = {
    "Berry",
    "Carrot",
    "Raw Meat",
    "Cooked Meat"
}

EspTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Callback = function(Value) 
        itemESPEnabled = Value
    end,
})

EspTab:CreateToggle({
    Name = "Food ESP",
    CurrentValue = false,
    Callback = function(v)
        for _, itemName in ipairs(foodItems) do
            showToggles[itemName] = v
        end
    end
})

EspTab:CreateToggle({
    Name = "Revolver + Ammo ESP",
    CurrentValue = false,
    Callback = function(v)
        showToggles["Revolver"] = v
        showToggles["Revolver Ammo"] = v
    end
})

for itemName, _ in pairs(showToggles) do
    local isFood = table.find(foodItems, itemName)
    if not isFood then
        EspTab:CreateToggle({
            Name = itemName,
            CurrentValue = false,
            Callback = function(v) showToggles[itemName] = v end,
        })
    end
end

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local ItemsFolder = Workspace:WaitForChild("Items")
local itemEspTable = {}

local function createItemText()
    local text = Drawing.new("Text")
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Font = 2
    text.Color = itemColor
    text.Visible = false
    return text
end

local function updateItems()
    for _, item in ipairs(ItemsFolder:GetChildren()) do
        if not itemEspTable[item] then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                itemEspTable[item] = {
                    part = part,
                    text = createItemText()
                }
            end
        end
    end

    for obj, esp in pairs(itemEspTable) do
        if not obj:IsDescendantOf(Workspace) then
            esp.text:Remove()
            itemEspTable[obj] = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not itemESPEnabled then
        for _, esp in pairs(itemEspTable) do
            esp.text.Visible = false
        end
        return
    end

    updateItems()

    for item, esp in pairs(itemEspTable) do
        local part = esp.part
        local text = esp.text
        local name = item.Name

        if part and showToggles[name] then
            local pos, visible = Camera:WorldToViewportPoint(part.Position)
            if visible then
                local distance = (Camera.CFrame.Position - part.Position).Magnitude
                text.Text = string.format("%s [%.0fm]", name, distance)
                text.Position = Vector2.new(pos.X, pos.Y)
                text.Color = itemColor
                text.Visible = true
            else
                text.Visible = false
            end
        else
            text.Visible = false
        end
    end
end)

--Bring Tab
local Section = BringTab:CreateSection("Bring Settings")

BringTab:CreateButton({
    Name = "Bring Everything",
    Callback = function()
        for _, item in ipairs(workspace.Items:GetChildren()) do
            local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
            if part then
                part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

BringTab:CreateButton({
    Name = "Bring Flashlight",
    Callback = function()
        bringItemsByName("Flashlight")
    end
})

BringTab:CreateButton({
    Name = "Bring Nails",
    Callback = function()
        bringItemsByName("Nails")
    end
})

BringTab:CreateButton({
    Name = "Bring Fan",
    Callback = function()
        bringItemsByName("Fan")
    end
})

BringTab:CreateButton({
    Name = "Bring Ammo",
    Callback = function()
        local keywords = {"ammo"}
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, item in ipairs(workspace.Items:GetChildren()) do
            for _, word in ipairs(keywords) do
                if item.Name:lower():find(word) then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
                    if part then
                        part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                end
            end
        end
    end
})

BringTab:CreateButton({
    Name = "Bring Sheet Metal",
    Callback = function()
        local keyword = "sheet metal"
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, item in ipairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find(keyword) then
                local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
                if part then
                    part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
    end
})

BringTab:CreateButton({
    Name = "Bring Fuel Canister",
    Callback = function()
        local keyword = "fuel canister"
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, item in ipairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find(keyword) then
                local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
                if part then
                    part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
    end
})

BringTab:CreateButton({
    Name = "Bring Tyre",
    Callback = function()
        local keyword = "tyre"
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, item in ipairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find(keyword) then
                local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
                if part then
                    part.CFrame = root.CFrame + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
    end
})

BringTab:CreateButton({
    Name = "Bring Bandage",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, item in ipairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") and item.Name:lower():find("bandage") then
                local part = item:FindFirstChildWhichIsA("BasePart")
                if part then
                    part.CFrame = root.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end
    end
})

BringTab:CreateButton({
    Name = "Bring Lost Child",
    Callback = function()
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:lower():find("lost") and model:FindFirstChild("HumanoidRootPart") then
                model:PivotTo(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
            end
        end
    end
})

BringTab:CreateButton({
    Name = "Bring Revolver",
    Callback = function()
        for _, item in ipairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") and item.Name:lower():find("revolver") then
                local part = item:FindFirstChildWhichIsA("BasePart")
                if part then
                    part.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end
    end
})

local Section = BringTab:CreateSection("Extra")

BringTab:CreateButton({
    Name = "Bring Carrot",
    Callback = function()
        bringItemsByName("Carrot")
    end
})
