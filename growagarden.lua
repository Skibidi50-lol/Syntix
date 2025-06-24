local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Leaderstats = LocalPlayer:WaitForChild("leaderstats")
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ShecklesCount = Leaderstats:WaitForChild("Sheckles")

local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local Farms = workspace:WaitForChild("Farm")

local SeedStock = {}
local ToggleBuy, ToggleHarvest, ToggleSell, SelectedSeedStock, OnlyShowStock

ReGui:Init({ Prefabs = InsertService:LoadLocalAsset(PrefabsId) })
ReGui:DefineTheme("GardenTheme", {
    WindowBg = Color3.fromRGB(26, 20, 8),
    TitleBarBg = Color3.fromRGB(45, 95, 25),
    TitleBarBgActive = Color3.fromRGB(69, 142, 40),
    ResizeGrab = Color3.fromRGB(45, 95, 25),
    FrameBg = Color3.fromRGB(45, 95, 25),
    FrameBgActive = Color3.fromRGB(69, 142, 40),
    CollapsingHeaderBg = Color3.fromRGB(69, 142, 40),
    ButtonsBg = Color3.fromRGB(69, 142, 40),
    CheckMark = Color3.fromRGB(69, 142, 40),
    SliderGrab = Color3.fromRGB(69, 142, 40),
})

local function GetSeedStock(ignoreZero)
    local SeedShop = PlayerGui:FindFirstChild("Seed_Shop")
    if not SeedShop then return {} end
    local Frame = SeedShop:FindFirstChild("Frame", true)
    if not Frame then return {} end
    local ScrollFrame = Frame:FindFirstChild("ScrollingFrame")
    if not ScrollFrame then return {} end

    local result = {}
    for _, item in ipairs(ScrollFrame:GetChildren()) do
        if not item:IsA("Frame") or not item:FindFirstChild("Main_Frame") then continue end
        local stockText = item.Main_Frame:FindFirstChild("Stock_Text")
        if stockText then
            local stock = tonumber(stockText.Text:match("%d+")) or 0
            if not ignoreZero or stock > 0 then
                result[item.Name] = stock
            end
            SeedStock[item.Name] = stock
        end
    end
    return result
end

local function GetFarm()
    for _, farm in ipairs(Farms:GetChildren()) do
        local owner = farm:FindFirstChild("Important") and farm.Important.Data.Owner.Value
        if owner == LocalPlayer.Name then return farm end
    end
end

local function BuyAllSelectedSeeds()
    local seed = SelectedSeedStock.Selected
    local stock = SeedStock[seed]
    if not stock or stock <= 0 then return end
    for i = 1, stock do
        GameEvents.BuySeedStock:FireServer(seed)
        task.wait(0.05)
    end
end

local function CanHarvest(plant)
    local prompt = plant:FindFirstChild("ProximityPrompt", true)
    return prompt and prompt.Enabled
end

local function GetHarvestablePlants()
    local plants = {}
    local farm = GetFarm()
    if not farm then return plants end
    local function collect(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            if CanHarvest(obj) then table.insert(plants, obj) end
            local fruits = obj:FindFirstChild("Fruits")
            if fruits then collect(fruits) end
        end
    end
    local physical = farm.Important:FindFirstChild("Plants_Physical")
    if physical then collect(physical) end
    return plants
end

local function HarvestAll()
    local char = LocalPlayer.Character
    if not char then return end
    local plants = GetHarvestablePlants()
    for _, plant in ipairs(plants) do
        local prompt = plant:FindFirstChild("ProximityPrompt", true)
        if prompt then
            local targetPart = plant:IsA("Model") and plant.PrimaryPart or plant:FindFirstChildWhichIsA("BasePart")
            if not targetPart and plant:IsA("Model") then
                plant.PrimaryPart = plant:FindFirstChildWhichIsA("BasePart")
                targetPart = plant.PrimaryPart
            end
            if targetPart then
                local pos = targetPart.Position + Vector3.new(0, 3, 0)
                char:PivotTo(CFrame.new(pos))
                task.wait(0.15)
                fireproximityprompt(prompt)
                task.wait(0.2)
            end
        end
    end
end

local function SellInventory()
    local char = LocalPlayer.Character
    if not char then return end
    char:PivotTo(CFrame.new(62, 4, -26))
    GameEvents.Sell_Inventory:FireServer()
end

local function SeedShop()
    PlayerGui.Seed_Shop.Enabled = true
end

local function hide()
    PlayerGui.Seed_Shop.Enabled = false
    PlayerGui.Gear_Shop.Enabled = false
    PlayerGui.HoneyEventShop_UI.Enabled = false
    PlayerGui.CosmeticShop_UI.Enabled = false
end

local function MakeLoop(toggle, func)
    task.spawn(function()
        while true do
            task.wait(0.5)
            if toggle and toggle.Value then
                pcall(func)
            end
        end
    end)
end

local Window = ReGui:Window({
    Title = "Syntix | Grow A Garden",
    Theme = "GardenTheme",
    Size = UDim2.fromOffset(300, 250)
})

local BuyNode = Window:TreeNode({ Title = "Auto-Buy 🌱" })
OnlyShowStock = BuyNode:Checkbox({ Label = "Only show stocked seeds", Value = false })
SelectedSeedStock = BuyNode:Combo({
    Label = "Seed",
    Selected = "",
    GetItems = function()
        return GetSeedStock(OnlyShowStock.Value)
    end
})
ToggleBuy = BuyNode:Checkbox({ Label = "🔁 Auto Buy Enabled", Value = false })
BuyNode:Button({ Text = "🛒 Buy All Now", Callback = BuyAllSelectedSeeds })

local HarvestNode = Window:TreeNode({ Title = "Auto-Harvest 🌾" })
ToggleHarvest = HarvestNode:Checkbox({ Label = "🌾 Auto Harvest", Value = false })
HarvestNode:Button({ Text = "🌾 Harvest Now", Callback = HarvestAll })

local SellingNode = Window:TreeNode({ Title = "Auto-Sell 💰" })
ToggleSell = SellingNode:Checkbox({ Label = "💰 Auto Sell", Value = false })
SellingNode:Button({ Text = "💸 Sell Inventory", Callback = SellInventory })

local ShopNode = Window:TreeNode({ Title = "Shop 🛒" })
ShopNode:Button({ Text = "🛒 Seed Shop", Callback = SeedShop })
ShopNode:Button({ Text = "🛑 Hide All Shops", Callback = hide })

MakeLoop(ToggleBuy, BuyAllSelectedSeeds)
MakeLoop(ToggleHarvest, HarvestAll)
MakeLoop(ToggleSell, SellInventory)

task.spawn(function()
    while true do
        task.wait(1)
        GetSeedStock()
    end
end)
