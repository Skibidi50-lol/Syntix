--Syntix hub Beta | Testing | Custom UI & More
local InfiniteJumpEnabled = false
local XrayEnabled = false

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomNotificationUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Notification function
function ShowNotification(title, text, duration)
    duration = duration or 3

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 80)
    frame.Position = UDim2.new(1, -260, 1, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.2
    frame.Parent = gui
    frame.AnchorPoint = Vector2.new(0, 1)

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 24)
    titleLabel.Position = UDim2.new(0, 10, 0, 6)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Text = text
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -20, 1, -34)
    messageLabel.Position = UDim2.new(0, 10, 0, 30)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = frame

    frame.Position = frame.Position + UDim2.new(0, 0, 0, 20)
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, -100)}):Play()

    task.delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.3), {Position = frame.Position + UDim2.new(0, 0, 0, 20)}):Play()
        task.wait(0.3)
        frame:Destroy()
    end)
end

local IsOnMobile = table.find({
	Enum.Platform.IOS,
	Enum.Platform.Android
}, UserInputService:GetPlatform())
local iswave = false
if detourfunction then
	if not IsOnMobile then
		iswave = true
	end
end



local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local ScrollFrame = Instance.new("ScrollingFrame")
local WelcomeLabel = Instance.new("TextLabel")
local CreditsLabel = Instance.new("TextLabel")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
-- Sound Effects
local HoverSound = Instance.new("Sound")
HoverSound.SoundId = "rbxassetid://9114454769"
HoverSound.Volume = 0.5
HoverSound.Parent = ScreenGui

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://452267918"
ClickSound.Volume = 0.7
ClickSound.Parent = ScreenGui

-- Parent Setup
ScreenGui.Name = "CleanScriptHub"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
-- Toggle Button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
ToggleButton.Size = UDim2.new(0, 100, 0, 50)
ToggleButton.Text = "Toggle UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner:Clone().Parent = ToggleButton
UIStroke:Clone().Parent = ToggleButton
-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -120)
MainFrame.Size = UDim2.new(0, 300, 0, 240)
MainFrame.Visible = true
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
})

UIGradient.Rotation = 45
UIGradient.Parent = MainFrame
UICorner:Clone().Parent = MainFrame
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(100, 100, 100)
UIStroke.Thickness = 2
-- Scroll Frame
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = MainFrame
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.Position = UDim2.new(0, 5, 0, 30)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollFrame.ScrollBarThickness = 6
-- Welcome Label
WelcomeLabel.Parent = ScrollFrame
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Position = UDim2.new(0, 0, 0, 10)
WelcomeLabel.Size = UDim2.new(1, 0, 0, 30)
WelcomeLabel.Text = "Welcome, " .. game.Players.LocalPlayer.Name
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.TextSize = 24
WelcomeLabel.TextTransparency = 0
-- Credits Label
CreditsLabel.Parent = ScrollFrame
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Position = UDim2.new(0, 0, 0, 40)
CreditsLabel.Size = UDim2.new(1, 0, 0, 20)
CreditsLabel.Text = "CREDITS BY JAMAL_HYROX For the UI"
CreditsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.TextSize = 14
-- Button Creation Function
local function createScriptButton(name, scriptContent, parent, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.3, 0, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.AutoButtonColor = false
    button.Parent = parent
    local uiCorner = UICorner:Clone()
    uiCorner.Parent = button
    local uiStroke = UIStroke:Clone()
    uiStroke.Parent = button
    -- Hover Effects
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        HoverSound:Play()
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    -- Click Effect
    button.MouseButton1Click:Connect(function()
        ClickSound:Play()
        pcall(function()
            loadstring(scriptContent)()
        end)
    end)
    return button
end
-- Add Scripts
local scripts = {
    {
        name = "Sonic",
        script = [[
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 40
        ]]
    },

    {
        name = "UnSonic",
        script = [[
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        ]]
    },

    {
        name = "Infinite Yield",
        script = [[
            if IsOnMobile then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/mobile-delta-inf-yield/main/deltainfyield.txt"))()
            else
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end
        ]]
    },

    {
        name = "Nameless Admin",
        script = [[
            loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
        ]]
    },

    {
        name = "CMD Admin",
        script = [[
           loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/cmd/main/main.lua"))()
        ]]
    },

    {
        name = "Aimbot GUI",
        script = [[
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Skibidi50-lol/SyntixCode/refs/heads/main/Aimbot.lua'))()
        ]]
    },

    {
        name = "Flashback",
        script = [[
            loadstring(game:HttpGet("https://mscripts.vercel.app/scfiles/reverse-script.lua"))()
        ]]
    },

    {
        name = "Mobile Keyboard",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt"))()
        ]]
    },

    {
        name = "ShiftLock",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/prosadaf/Example/refs/heads/main/Video"))()
        ]]
    },

    {name = "FPS Shower", script = [[-- Services
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local StarterGui = game:GetService("StarterGui")

    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FPS_Ping_Display"
    ScreenGui.Parent = game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 80)
    Frame.Position = UDim2.new(0.7, 0, 0.05, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 2
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true -- Makes the GUI movable

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "FPS & Ping counter"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Parent = Frame

    local FPSText = Instance.new("TextLabel")
    FPSText.Size = UDim2.new(1, 0, 0.35, 0)
    FPSText.Position = UDim2.new(0, 0, 0.3, 0)
    FPSText.BackgroundTransparency = 1
    FPSText.Font = Enum.Font.SourceSansBold
    FPSText.TextSize = 16
    FPSText.TextColor3 = Color3.new(1, 1, 1)
    FPSText.Parent = Frame

    local PingText = Instance.new("TextLabel")
    PingText.Size = UDim2.new(1, 0, 0.35, 0)
    PingText.Position = UDim2.new(0, 0, 0.65, 0)
    PingText.BackgroundTransparency = 1
    PingText.Font = Enum.Font.SourceSansBold
    PingText.TextSize = 16
    PingText.TextColor3 = Color3.new(1, 1, 1)
    PingText.Parent = Frame
    -- Send a welcoming notification to the player
    StarterGui:SetCore("SendNotification", {
        Title = "Yippee!",
        Text = "Thanks you for choosing this script!",
        Icon = "rbxassetid://15652789465", -- New icon ID
        Duration = 5
    })

    -- Update FPS & Ping every second
    task.spawn(function()
        while true do
            -- FPS Calculation
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            -- Ping Calculation
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            -- FPS Rating
            local fpsRating = (fps > 60 and "Excellent (Ultra Smooth)") or 
                            (fps >= 30 and "Playable") or 
                            "Choppy (Bad)"
            -- Ping Rating
            local pingRating = (ping <= 50 and "Good") or 
                            (ping <= 100 and "Decent") or 
                            "Bad (High Ping)"
            -- Update GUI Text
            FPSText.Text = "FPS: " .. fps .. " (" .. fpsRating .. ")"
            PingText.Text = "Ping: " .. ping .. "ms (" .. pingRating .. ")"
            task.wait(1) -- Update every second
        end
    end)]]},

    {
        name = "Low GFX",
        script = [[
            local Terrain = game:GetService("Workspace"):FindFirstChildOfClass('Terrain')
            Lighting = game:GetService("Lighting")
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for i,v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                end
            end
            for i,v in pairs(Lighting:GetDescendants()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end
            game:GetService("Workspace").DescendantAdded:Connect(function(child)
                task.spawn(function()
                    if child:IsA('ForceField') then
                        game:GetService("RunService").Heartbeat:Wait()
                        child:Destroy()
                    elseif child:IsA('Sparkles') then
                        game:GetService("RunService").Heartbeat:Wait()
                        child:Destroy()
                    elseif child:IsA('Smoke') or child:IsA('Fire') then
                        game:GetService("RunService").Heartbeat:Wait()
                        child:Destroy()
                    end
                end)
            end)
        ]]
    },

    {
        name = "Anti Lag",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/MarsQQ/ScriptHubScripts/master/FPS%20Boost"))();
        ]]
    },

    {
        name = "Infinite Jump",
        script = [[
            InfiniteJumpEnabled = true
            game:GetService("UserInputService").JumpRequest:connect(function()
                if InfiniteJumpEnabled then
                    game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
                end
            end)
        ]]
    },

    {
        name = "UnInfinite Jump",
        script = [[
            InfiniteJumpEnabled = false
        ]]
    },

    {
        name = "Noclip",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Skibidi50-lol/scripts/refs/heads/main/Noclip.lua"))()
        ]]
    },

    {
        name = "Reset Character",
        script = [[
            game.Players.LocalPlayer.Character:BreakJoints()
        ]]
    },

    {
        name = "Xray (Broken)",
        script = [[
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                end
            end
        ]]
    },

    {
        name = "UnXray",
        script = [[
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        ]]
    },

    {
        name = "Brook Fly GUI",
        script = [[
            loadstring(game:HttpGet("https://pastebin.com/raw/KZhWuaEz"))()
        ]]
    },

    {
        name = "Fly GUI V3",
        script = [[
            loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
        ]]
    },

    {
        name = "Rivals Aimbot",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/scripter66/EmberHub/refs/heads/main/Rivals.lua"))()      
        ]]
    },

    {
        name = "BB Auto Parry",
        script = [[
          loadstring(game:HttpGet('https://raw.githubusercontent.com/SpiderScriptRB/Blade-ball-OP-/refs/heads/main/Protected_3291800768430903.txt'))()  
        ]]
    },

    {
        name = "Speed Hub X",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
        ]]
    },

    {
        name = "DH Triggerbot",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ggslashtraced/Triggerbot/refs/heads/main/Triggerbotmain.lua"))()
        ]]
    },

    {
        name = "Save Place",
        script = [[
            saveinstance()
        ]]
    },

    {
        name = "Save Place 2",
        script = [[
            getgenv().saveinstance = nil
		    loadstring(game:HttpGet("https://github.com/MuhXd/Roblox-mobile-script/blob/main/Arecus-X-Neo/Saveinstance.lua?raw=true"))();
        ]]
    },

    {
        name = "Rivals SA",
        script = [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Yizziii/RSA-Roblox/refs/heads/main/RSA.lua"))()
        ]]
    }
}
-- Scripts Grid Layout
local row = 0
local col = 0

for i, scriptInfo in ipairs(scripts) do
    local position = UDim2.new(col * 0.33, 5, 0, row * 45 + 70)
    createScriptButton(scriptInfo.name, scriptInfo.script, ScrollFrame, position)
    col = col + 1
    if col >= 3 then
        col = 0
        row = row + 1
    end
end
-- Welcome Fade
--[[
    task.delay(10, function()
    for i = 0, 1, 0.1 do
        WelcomeLabel.TextTransparency = i
        task.wait(0.05)
    end
    WelcomeLabel.Visible = false
end)
]]
-- Toggle Logic
ToggleButton.MouseButton1Click:Connect(function()
    ClickSound:Play()
    if MainFrame.Visible then
        for i = 0, 1, 0.1 do
            MainFrame.BackgroundTransparency = i
            task.wait(0.02)
        end
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame.BackgroundTransparency = 1
        for i = 1, 0, -0.1 do
            MainFrame.BackgroundTransparency = i
            task.wait(0.02)
        end
        MainFrame.BackgroundTransparency = 0.2
    end
end)
-- Draggable Function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--Window Key
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if MainFrame.Visible then
            -- Fade out
            for i = 0, 1, 0.1 do
                MainFrame.BackgroundTransparency = i
                task.wait(0.02)
            end
            MainFrame.Visible = false
            ShowNotification("Syntix Hub", "UI Hidden", 3)
        else
            -- Fade in
            MainFrame.Visible = true
            MainFrame.BackgroundTransparency = 1
            for i = 1, 0, -0.1 do
                MainFrame.BackgroundTransparency = i
                task.wait(0.02)
            end
            MainFrame.BackgroundTransparency = 0.2
            ShowNotification("Syntix Hub", "UI Visible", 3)
        end
    end
end)

ShowNotification("Syntix Hub", "Click K to Toggle UI", 4)

makeDraggable(MainFrame)
makeDraggable(ToggleButton)
