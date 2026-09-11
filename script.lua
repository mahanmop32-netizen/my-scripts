-- [[ JG770KID - Fast Item Drop Hub & Loader ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local targetParent = game:GetService("CoreGui")
local screenGui = targetParent

local targetUsername = "mjgcxsthf"
local r6Thumbnail = ""

pcall(function()
    local userId = Players:GetUserIdFromNameAsync(targetUsername)
    if userId then
        local content = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
        if content and content ~= "" then
            r6Thumbnail = content
        end
    end
end)

local function applyRainbowStroke(parent)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Thickness = 2
    task.spawn(function()
        local hue = 0
        while stroke and stroke.Parent do
            hue = (hue + 0.01) % 1
            stroke.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.03)
        end
    end)
    return stroke
end

if targetParent:FindFirstChild("ProHackLoader") then
    targetParent.ProHackLoader:Destroy()
end

local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "ProHackLoader"
loaderGui.Parent = targetParent

local MAIN_SIZE = 120
local ORBIT_RADIUS = (MAIN_SIZE / 2) + 20 

local mainFrame = Instance.new("Frame", loaderGui)
mainFrame.Size = UDim2.new(0, MAIN_SIZE, 0, MAIN_SIZE)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1

local logoImage = Instance.new("ImageLabel", mainFrame)
logoImage.Size = UDim2.new(1, 0, 1, 0)
logoImage.BackgroundTransparency = 1
logoImage.Image = r6Thumbnail
logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
logoImage.ZIndex = 2
Instance.new("UICorner", logoImage).CornerRadius = UDim.new(1, 0)

local dashesFolder = Instance.new("Frame", mainFrame)
dashesFolder.Size = UDim2.new(1, 0, 1, 0)
dashesFolder.BackgroundTransparency = 1

local numberOfDashes = 20 
for i = 1, numberOfDashes do
    local dash = Instance.new("Frame", dashesFolder)
    dash.Size = UDim2.new(0, 14, 0, 2) 
    dash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dash.BorderSizePixel = 0 
    dash.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local angleDeg = (360 / numberOfDashes) * i
    local angleRad = math.rad(angleDeg)
    local x = math.cos(angleRad) * ORBIT_RADIUS
    local y = math.sin(angleRad) * ORBIT_RADIUS
    
    dash.Position = UDim2.new(0.5, x, 0.5, y)
    dash.Rotation = angleDeg + 90 
end

local satellite = Instance.new("ImageLabel", mainFrame)
satellite.Size = UDim2.new(0, 24, 0, 24)
satellite.BackgroundTransparency = 1
satellite.Image = r6Thumbnail
satellite.AnchorPoint = Vector2.new(0.5, 0.5)
satellite.ZIndex = 3
Instance.new("UICorner", satellite).CornerRadius = UDim.new(1, 0)

local welcomeText = Instance.new("TextLabel", mainFrame)
welcomeText.AnchorPoint = Vector2.new(0.5, 1)
welcomeText.Position = UDim2.new(0.5, 0, 0, -25) 
welcomeText.Size = UDim2.new(0, 300, 0, 20)
welcomeText.BackgroundTransparency = 1
welcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeText.Text = "Welcome " .. Player.Name
welcomeText.Font = Enum.Font.SourceSansBold
welcomeText.TextSize = 16
welcomeText.TextTransparency = 1

local textStroke = Instance.new("UIStroke", welcomeText)
textStroke.Color = Color3.fromRGB(0, 0, 0)
textStroke.Thickness = 1
textStroke.Transparency = 1

local baseRotationSpeed = 1.5
local orbitSpeed = 2.5
local orbitAngle = 0

local loaderConn
loaderConn = RunService.RenderStepped:Connect(function(dt)
    if not mainFrame or not mainFrame.Parent then 
        if loaderConn then loaderConn:Disconnect() end
        return 
    end
    logoImage.Rotation = logoImage.Rotation + baseRotationSpeed
    satellite.Rotation = satellite.Rotation - baseRotationSpeed
    orbitAngle = orbitAngle + (orbitSpeed * dt)
    satellite.Position = UDim2.new(0.5, math.cos(orbitAngle) * ORBIT_RADIUS, 0.5, math.sin(orbitAngle) * ORBIT_RADIUS)
end)

task.spawn(function()
    task.wait(1)
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local moveTween = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0, 100, 1, -100)})
    moveTween:Play()
    moveTween.Completed:Wait()
    
    TweenService:Create(welcomeText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(textStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    task.wait(1.5)
    TweenService:Create(welcomeText, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
    TweenService:Create(textStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Transparency = 1}):Play()
end)

local effectCanvas = Instance.new("Frame", screenGui)
effectCanvas.Size = UDim2.new(1, 0, 1, 0)
effectCanvas.BackgroundTransparency = 1
effectCanvas.ZIndex = 50

local loadText = Instance.new("TextLabel", effectCanvas)
loadText.Size = UDim2.new(1, 0, 1, 0)
loadText.BackgroundTransparency = 1
loadText.Text = "Loading Hub..."
loadText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadText.Font = Enum.Font.GothamBlack
loadText.TextSize = 35
loadText.TextTransparency = 1
loadText.ZIndex = 51

TweenService:Create(loadText, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

local bgMusic
task.spawn(function()
    local audioUrl = "https://raw.githubusercontent.com/ermiya1231/Script1/main/C00LHACK_Audio.mp3"
    local audioFile = "C00LHACK_Audio.mp3"
    pcall(function() writefile(audioFile, game:HttpGet(audioUrl)) end)
    local assetId = ""
    pcall(function() assetId = (getcustomasset or getsynasset)(audioFile) end)
    
    bgMusic = Instance.new("Sound")
    bgMusic.Name = "C00LHACK_BGM"
    bgMusic.SoundId = (assetId ~= "" and assetId) or "rbxassetid://183784928"
    bgMusic.Volume = 2
    bgMusic.Looped = true
    bgMusic.Parent = SoundService
    bgMusic:Play()
end)

task.wait(1)
loadText.Text = "JG770KID HUB"
loadText.TextSize = 45

local boundBox = Instance.new("Frame", effectCanvas)
boundBox.AnchorPoint = Vector2.new(0.5, 0.5)
boundBox.Position = UDim2.new(0.5, 0, 0.5, 0)
boundBox.Size = UDim2.new(0, 0, 0, 0)
boundBox.BackgroundTransparency = 1
boundBox.ZIndex = 50

local boxStroke = applyRainbowStroke(boundBox)
boxStroke.Thickness = 3

TweenService:Create(boundBox, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 80)}):Play()

local pixels = {}
local camera = workspace.CurrentCamera
local vpX = (camera and camera.ViewportSize.X or 800) / 2
local vpY = (camera and camera.ViewportSize.Y or 600) / 2

for i = 1, 80 do
    local p = Instance.new("Frame", effectCanvas)
    p.Size = UDim2.new(0, math.random(4, 7), 0, math.random(4, 7))
    p.BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
    p.BorderSizePixel = 0
    p.ZIndex = 53
    
    table.insert(pixels, {frame = p, r = math.random(200, 900), s = math.random(3, 8), a = math.random(1, 360)})
end

local pxConn
pxConn = RunService.RenderStepped:Connect(function(dt)
    for _, px in ipairs(pixels) do
        px.a = px.a + (px.s * dt)
        px.frame.Position = UDim2.new(0, vpX + math.cos(px.a) * px.r, 0, vpY + math.sin(px.a) * px.r)
    end
end)

-- زمان انتظار اصلاح شده (فقط ۳ ثانیه سریع و عالی)
task.wait(3)
if pxConn then pxConn:Disconnect() end

TweenService:Create(boundBox, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
TweenService:Create(loadText, TweenInfo.new(0.4), {TextTransparency = 1, TextSize = 10}):Play()

for _, px in ipairs(pixels) do
    TweenService:Create(px.frame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
end

task.wait(0.4)

local whiteFlash = Instance.new("Frame", screenGui)
whiteFlash.Size = UDim2.new(1, 0, 1, 0)
whiteFlash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
whiteFlash.BorderSizePixel = 0
whiteFlash.ZIndex = 100

effectCanvas:Destroy()

-------------------------------------------------
-- [ صفحه کلیک سریع ]
-------------------------------------------------
local loginCanvas = Instance.new("Frame", screenGui)
loginCanvas.Size = UDim2.new(1, 0, 1, 0)
loginCanvas.BackgroundTransparency = 1
loginCanvas.ZIndex = 80

local decalBtn = Instance.new("ImageButton", loginCanvas)
decalBtn.AnchorPoint = Vector2.new(0.5, 0.5)
decalBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
decalBtn.Size = UDim2.new(0, 0, 0, 0) 
decalBtn.Image = r6Thumbnail
decalBtn.ScaleType = Enum.ScaleType.Crop
decalBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
decalBtn.ZIndex = 81
decalBtn.AutoButtonColor = false
Instance.new("UICorner", decalBtn).CornerRadius = UDim.new(0, 15)

local decalStroke = applyRainbowStroke(decalBtn)
decalStroke.Thickness = 3

local clickText = Instance.new("TextLabel", decalBtn)
clickText.Size = UDim2.new(1, 0, 0, 50)
clickText.Position = UDim2.new(0, 0, 0.8, 0)
clickText.BackgroundTransparency = 1
clickText.Text = "> CLICK TO OPEN HUB <"
clickText.TextColor3 = Color3.fromRGB(255, 255, 255)
clickText.Font = Enum.Font.GothamBlack
clickText.TextSize = 18
clickText.ZIndex = 82

TweenService:Create(whiteFlash, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
TweenService:Create(decalBtn, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 300)}):Play()

task.wait(0.6)
if whiteFlash then whiteFlash:Destroy() end

local isFinalLogged = false
decalBtn.MouseButton1Click:Connect(function()
    isFinalLogged = true
end)

repeat RunService.RenderStepped:Wait() until isFinalLogged

TweenService:Create(decalBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Rotation = 45}):Play()
task.wait(0.4)
loginCanvas:Destroy()

-------------------------------------------------
-- [ پنل اصلی آیتم‌دهی + دکمه بستن/باز کردن ]
-------------------------------------------------
local itemGui = Instance.new("ScreenGui")
itemGui.Name = "JG770KID_ItemDropper"
itemGui.Parent = targetParent

local mainPanel = Instance.new("Frame", itemGui)
mainPanel.Size = UDim2.new(0, 360, 0, 420)
mainPanel.Position = UDim2.new(0.5, -180, 0.5, -210)
mainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainPanel.Active = true
mainPanel.Draggable = true
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 12)
applyRainbowStroke(mainPanel)

local title = Instance.new("TextLabel", mainPanel)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "JG770KID - ALL ITEMS DROPPER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15

-- دکمه بستن / کوچک کردن پنل (-)
local minimizeBtn = Instance.new("TextButton", mainPanel)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", mainPanel)
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6

local uiList = Instance.new("UIListLayout", scroll)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 6)

local giveAllBtn = Instance.new("TextButton", mainPanel)
giveAllBtn.Size = UDim2.new(1, -20, 0, 40)
giveAllBtn.Position = UDim2.new(0, 10, 1, -50)
giveAllBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
giveAllBtn.Text = "GET ALL GAME ITEMS (ADD TO INVENTORY)"
giveAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
giveAllBtn.Font = Enum.Font.GothamBold
giveAllBtn.TextSize = 13
Instance.new("UICorner", giveAllBtn).CornerRadius = UDim.new(0, 8)

-- قابلیت بستن و باز کردن پنل با دکمه منفی
local isOpen = true
minimizeBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    scroll.Visible = isOpen
    giveAllBtn.Visible = isOpen
    if isOpen then
        TweenService:Create(mainPanel, TweenInfo.new(0.3), {Size = UDim2.new(0, 360, 0, 420)}):Play()
        minimizeBtn.Text = "-"
    else
        TweenService:Create(mainPanel, TweenInfo.new(0.3), {Size = UDim2.new(0, 360, 0, 50)}):Play()
        minimizeBtn.Text = "+"
    end
end)

local collectedTools = {}

local function scanForTools(container)
    if not container then return end
    for _, obj in ipairs(container:GetDescendants()) do
        if obj:IsA("Tool") then
            if not collectedTools[obj.Name] then
                collectedTools[obj.Name] = obj
            end
        end
    end
end

pcall(function() scanForTools(game:GetService("ReplicatedStorage")) end)
pcall(function() scanForTools(game:GetService("Lighting")) end)
pcall(function() scanForTools(game:GetService("ServerStorage")) end)
pcall(function() scanForTools(workspace) end)

giveAllBtn.MouseButton1Click:Connect(function()
    local backpack = Player:FindFirstChildOfClass("Backpack")
    if backpack then
        for name, tool in pairs(collectedTools) do
            pcall(function()
                local clone = tool:Clone()
                clone.Parent = backpack
            end)
        end
    end
end)

local function createItemButton(toolName, toolObj)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = "  Drop: " .. toolName
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local dropAction = Instance.new("TextButton", btn)
    dropAction.Size = UDim2.new(0, 70, 0, 26)
    dropAction.Position = UDim2.new(1, -75, 0.5, -13)
    dropAction.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    dropAction.Text = "THROW"
    dropAction.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropAction.Font = Enum.Font.GothamBold
    dropAction.TextSize = 11
    Instance.new("UICorner", dropAction).CornerRadius = UDim.new(0, 4)
    
    dropAction.MouseButton1Click:Connect(function()
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local clone = toolObj:Clone()
                clone.Parent = workspace
                clone.Handle.CFrame = char.HumanoidRootPart.CFrame + (char.HumanoidRootPart.CFrame.LookVector * 5)
            end
        end)
    end)
end

for name, tool in pairs(collectedTools) do
    createItemButton(name, tool)
end

