-- Services
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local MarketplaceService = game:GetService('MarketplaceService')

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild('PlayerGui')
local currentGameName = 'Loading...'

-- Get current game name
pcall(function()
    currentGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- Function to load your actual script
local function loadScript()
    -- Create notification function
    local function notify(title, text, duration)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration;
        })
    end

    -- Notify that script is starting
    notify("Script Status", "Starting script...", 3)
    
    -- Add a small delay to ensure notification is visible
    wait(1)
    
    -- Your main script code goes here
    notify("Script Status", "Script loaded successfully!", 5)
    
    -- Create a simple GUI to show the script is running
    local successGui = Instance.new("ScreenGui")
    successGui.Name = "ScriptSuccessGui"
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = successGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Script Running ✅"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.Parent = frame
    
    successGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Animate the frame
    frame.Position = UDim2.new(0.5, -100, -0.1, 0)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back)
    local tween = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -100, 0, 20)})
    tween:Play()
    
    -- Add your actual script functionality here
    print("Script is now running!")
end

-- Main GUI Setup
local gui = Instance.new('ScreenGui')
gui.Name = 'XetraHub'
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Loading Screen
local loadingFrame = Instance.new('Frame')
loadingFrame.Name = 'LoadingScreen'
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = gui

-- Loading Background Gradient
local gradient = Instance.new('UIGradient')
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20)),
})
gradient.Rotation = 45
gradient.Parent = loadingFrame

-- Logo Container
local logoContainer = Instance.new('Frame')
logoContainer.Name = 'LogoContainer'
logoContainer.Size = UDim2.new(0, 200, 0, 200)
logoContainer.Position = UDim2.new(0.5, -100, 0.5, -150)
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = loadingFrame

-- Logo Image
local logo = Instance.new('ImageLabel')
logo.Name = 'Logo'
logo.Size = UDim2.new(1, 0, 1, 0)
logo.Position = UDim2.new(0, 0, 0, 0)
logo.BackgroundTransparency = 1
logo.Image = 'rbxassetid://111108278176277'
logo.ImageTransparency = 0.2
logo.Parent = logoContainer

-- Logo Corner
local logoCorner = Instance.new('UICorner')
logoCorner.CornerRadius = UDim.new(0, 20)
logoCorner.Parent = logo

-- Credits Text
local creditsText = Instance.new('TextLabel')
creditsText.Name = 'Credits'
creditsText.Size = UDim2.new(0, 400, 0, 60)
creditsText.Position = UDim2.new(0.5, -200, 0.5, 80)
creditsText.BackgroundTransparency = 1
creditsText.Text = 'Xetra Hub'
creditsText.TextColor3 = Color3.fromRGB(255, 255, 255)
creditsText.TextSize = 32
creditsText.Font = Enum.Font.GothamBold
creditsText.TextTransparency = 1
creditsText.Parent = loadingFrame

-- Made By Text
local madeByText = Instance.new('TextLabel')
madeByText.Name = 'MadeBy'
madeByText.Size = UDim2.new(0, 400, 0, 40)
madeByText.Position = UDim2.new(0.5, -200, 0.5, 130)
madeByText.BackgroundTransparency = 1
madeByText.Text = 'Made By Bebo Mods'
madeByText.TextColor3 = Color3.fromRGB(180, 180, 190)
madeByText.TextSize = 18
madeByText.Font = Enum.Font.Gotham
madeByText.TextTransparency = 1
madeByText.Parent = loadingFrame

-- Game Name Display
local gameNameText = Instance.new('TextLabel')
gameNameText.Name = 'GameName'
gameNameText.Size = UDim2.new(0, 600, 0, 30)
gameNameText.Position = UDim2.new(0.5, -300, 0.5, 170)
gameNameText.BackgroundTransparency = 1
gameNameText.Text = '🎮 ' .. currentGameName
gameNameText.TextColor3 = Color3.fromRGB(100, 200, 255)
gameNameText.TextSize = 16
gameNameText.Font = Enum.Font.GothamBold
gameNameText.TextTransparency = 1
gameNameText.Parent = loadingFrame

-- Loading Status Text
local statusText = Instance.new('TextLabel')
statusText.Name = 'StatusText'
statusText.Size = UDim2.new(0, 400, 0, 25)
statusText.Position = UDim2.new(0.5, -200, 0.75, 0)
statusText.BackgroundTransparency = 1
statusText.Text = 'Initializing...'
statusText.TextColor3 = Color3.fromRGB(150, 150, 160)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextTransparency = 1
statusText.Parent = loadingFrame

-- Loading Bar Container
local loadingBarContainer = Instance.new('Frame')
loadingBarContainer.Name = 'LoadingBarContainer'
loadingBarContainer.Size = UDim2.new(0, 400, 0, 8)
loadingBarContainer.Position = UDim2.new(0.5, -200, 0.8, 0)
loadingBarContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
loadingBarContainer.BorderSizePixel = 0
loadingBarContainer.Parent = loadingFrame

local loadingBarCorner = Instance.new('UICorner')
loadingBarCorner.CornerRadius = UDim.new(0, 4)
loadingBarCorner.Parent = loadingBarContainer

-- Loading Bar Fill
local loadingBar = Instance.new('Frame')
loadingBar.Name = 'LoadingBar'
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.Position = UDim2.new(0, 0, 0, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingBarContainer

local loadingBarFillCorner = Instance.new('UICorner')
loadingBarFillCorner.CornerRadius = UDim.new(0, 4)
loadingBarFillCorner.Parent = loadingBar

-- Loading Percentage
local loadingPercent = Instance.new('TextLabel')
loadingPercent.Size = UDim2.new(0, 100, 0, 25)
loadingPercent.Position = UDim2.new(0.5, -50, 0.85, 0)
loadingPercent.BackgroundTransparency = 1
loadingPercent.Text = '0%'
loadingPercent.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingPercent.TextSize = 14
loadingPercent.Font = Enum.Font.GothamBold
loadingPercent.TextTransparency = 1
loadingPercent.Parent = loadingFrame

-- Loading Animations with Smart Status Updates
local function playLoadingAnimations()
    local function fadeIn(obj, duration)
        local tween = TweenService:Create(
            obj,
            TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 0}
        )
        tween:Play()
        return tween
    end

    -- Logo fade in with scale
    logo.ImageTransparency = 1
    logoContainer.Size = UDim2.new(0, 150, 0, 150)
    logoContainer.Position = UDim2.new(0.5, -75, 0.5, -150)

    local logoScaleTween = TweenService:Create(
        logoContainer,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 200, 0, 200),
            Position = UDim2.new(0.5, -100, 0.5, -150),
        }
    )

    local logoFadeTween = TweenService:Create(
        logo,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            ImageTransparency = 0.2,
        }
    )

    logoScaleTween:Play()
    wait(0.3)
    logoFadeTween:Play()

    -- Fade in text elements
    wait(0.5)
    fadeIn(creditsText, 0.6)
    wait(0.3)
    fadeIn(madeByText, 0.6)
    wait(0.3)
    fadeIn(gameNameText, 0.5)
    wait(0.3)
    fadeIn(statusText, 0.4)
    wait(0.2)
    fadeIn(loadingPercent, 0.4)

    -- Loading steps
    local loadingSteps = {
        {text = 'Initializing...', percent = 10, duration = 0.5},
        {text = 'Loading core modules...', percent = 30, duration = 0.5},
        {text = 'Preparing features...', percent = 50, duration = 0.5},
        {text = 'Setting up interface...', percent = 70, duration = 0.5},
        {text = 'Finalizing...', percent = 90, duration = 0.5},
        {text = 'Complete!', percent = 100, duration = 0.5}
    }

    for _, step in ipairs(loadingSteps) do
        statusText.Text = step.text
        loadingPercent.Text = step.percent .. '%'

        local barTween = TweenService:Create(
            loadingBar,
            TweenInfo.new(step.duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(step.percent / 100, 0, 1, 0)}
        )
        barTween:Play()
        wait(step.duration)
    end

    -- Fade out everything
    wait(0.5)
    
    local fadeOutTweens = {}
    local function fadeOut(obj)
        local tween = TweenService:Create(
            obj,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextTransparency = 1}
        )
        table.insert(fadeOutTweens, tween)
        tween:Play()
    end

    -- Fade out all elements
    fadeOut(creditsText)
    fadeOut(madeByText)
    fadeOut(gameNameText)
    fadeOut(statusText)
    fadeOut(loadingPercent)

    -- Fade out logo and background
    local logoFadeOut = TweenService:Create(
        logo,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {ImageTransparency = 1}
    )
    logoFadeOut:Play()

    local backgroundFadeOut = TweenService:Create(
        loadingFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )
    backgroundFadeOut:Play()

    -- Wait for all fade out tweens to complete
    wait(0.6)

    -- Clean up and proceed
    loadingFrame:Destroy()
    
    -- Load the main script
    loadScript()
end

-- Start the loading sequence
spawn(function()
    playLoadingAnimations()
end)
