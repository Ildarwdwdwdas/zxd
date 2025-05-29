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

-- Copy Utility
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        pcall(function()
            game.StarterGui:SetCore('SendNotification', {
                Title = 'Copied!',
                Text = 'Link copied to clipboard.',
                Duration = 3,
            })
        end)
    end
end

-- Loading Animations with Smart Status Updates
local function playLoadingAnimations()
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

    -- Credits text fade in
    wait(0.5)
    local creditsFadeTween = TweenService:Create(
        creditsText,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 0,
        }
    )
    creditsFadeTween:Play()

    -- Made by text fade in
    wait(0.3)
    local madeByFadeTween = TweenService:Create(
        madeByText,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 0,
        }
    )
    madeByFadeTween:Play()

    -- Game name fade in
    wait(0.3)
    local gameNameFadeTween = TweenService:Create(
        gameNameText,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 0,
        }
    )
    gameNameFadeTween:Play()

    -- Status text fade in
    wait(0.3)
    local statusFadeTween = TweenService:Create(
        statusText,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 0,
        }
    )
    statusFadeTween:Play()

    -- Loading percentage fade in
    wait(0.2)
    local percentFadeTween = TweenService:Create(
        loadingPercent,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 0,
        }
    )
    percentFadeTween:Play()

    -- Smart loading sequence with realistic steps
    wait(0.5)

    local loadingSteps = {
        {
            text = 'Initializing script environment...',
            percent = 5,
            duration = 0.8,
        },
        { text = 'Loading core modules...', percent = 15, duration = 0.6 },
        {
            text = 'Connecting to authentication server...',
            percent = 25,
            duration = 1.0,
        },
        {
            text = 'Verifying game compatibility...',
            percent = 40,
            duration = 0.7,
        },
        {
            text = 'Loading game-specific features...',
            percent = 55,
            duration = 0.9,
        },
        {
            text = 'Injecting security protocols...',
            percent = 70,
            duration = 0.8,
        },
        {
            text = 'Establishing secure connection...',
            percent = 85,
            duration = 0.7,
        },
        { text = 'Finalizing initialization...', percent = 95, duration = 0.6 },
        { text = 'Ready to authenticate!', percent = 100, duration = 0.5 },
    }

    for _, step in ipairs(loadingSteps) do
        statusText.Text = step.text
        loadingPercent.Text = step.percent .. '%'

        local barTween = TweenService:Create(
            loadingBar,
            TweenInfo.new(
                step.duration * 0.8,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Size = UDim2.new(step.percent / 100, 0, 1, 0),
            }
        )
        barTween:Play()

        wait(step.duration)
    end

    -- Final completion effect
    wait(0.8)
    statusText.Text = 'Loading complete! Starting authentication...'

    wait(1)

    -- Fade out loading screen
    local fadeOutTween = TweenService:Create(
        loadingFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 1,
        }
    )

    local logoFadeOutTween = TweenService:Create(
        logo,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            ImageTransparency = 1,
        }
    )

    local creditsFadeOutTween = TweenService:Create(
        creditsText,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 1,
        }
    )

    local madeByFadeOutTween = TweenService:Create(
        madeByText,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 1,
        }
    )

    local gameNameFadeOutTween = TweenService:Create(
        gameNameText,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 1,
        }
    )

    local statusFadeOutTween = TweenService:Create(
        statusText,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 1,
        }
    )

    local percentFadeOutTween = TweenService:Create(
        loadingPercent,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 1,
        }
    )

    fadeOutTween:Play()
    logoFadeOutTween:Play()
    creditsFadeOutTween:Play()
    madeByFadeOutTween:Play()
    gameNameFadeOutTween:Play()
    statusFadeOutTween:Play()
    percentFadeOutTween:Play()

    fadeOutTween.Completed:Connect(function()
        loadingFrame:Destroy()
        -- createKeySystem() -- Удалено, чтобы убрать ключ систему
    end)
end

-- Start loading sequence
playLoadingAnimations()