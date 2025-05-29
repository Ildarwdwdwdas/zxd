-- Services
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local MarketplaceService = game:GetService('MarketplaceService')
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild('PlayerGui')
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local currentGameName = 'Loading...'

-- Get current game name
pcall(function()
    currentGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- Main Script Function
local function loadScript()
    -- Create notification function
    local function notify(title, text, duration)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration;
        })
    end

    -- Create Main GUI
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "GrowAGardenGUI"
    mainGui.Parent = playerGui

    -- Create Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 300)
    mainFrame.Position = UDim2.new(0.85, 0, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = mainGui

    -- Add Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.BorderSizePixel = 0
    title.Text = "Grow A Garden Farm"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title

    -- Variables for farming
    local autoFarm = false
    local autoSell = false
    local autoWater = false
    local autoBuySeeds = false
    local selectedSeed = "Tomato"

    -- Function to create buttons
    local function createButton(name, posY, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.Position = UDim2.new(0.05, 0, 0, posY)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.BorderSizePixel = 0
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Parent = mainFrame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        button.MouseButton1Click:Connect(callback)
        return button
    end

    -- Create Dropdown for Seeds
    local seedDropdown = Instance.new("TextButton")
    seedDropdown.Size = UDim2.new(0.9, 0, 0, 30)
    seedDropdown.Position = UDim2.new(0.05, 0, 0, 40)
    seedDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    seedDropdown.BorderSizePixel = 0
    seedDropdown.Text = "Seed: " .. selectedSeed
    seedDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    seedDropdown.Font = Enum.Font.Gotham
    seedDropdown.TextSize = 14
    seedDropdown.Parent = mainFrame

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = seedDropdown

    -- Farming Functions
    local function getClosestPlot()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        
        local closest = nil
        local minDist = math.huge
        
        for _, plot in pairs(plots:GetChildren()) do
            if plot:IsA("Model") then
                local distance = (plot.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                if distance < minDist then
                    minDist = distance
                    closest = plot
                end
            end
        end
        
        return closest
    end

    local function plantSeed()
        local plot = getClosestPlot()
        if plot then
            local args = {
                [1] = "Plant",
                [2] = selectedSeed,
                [3] = plot
            }
            ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
        end
    end

    local function harvestCrop()
        local plot = getClosestPlot()
        if plot then
            local args = {
                [1] = "Harvest",
                [2] = plot
            }
            ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
        end
    end

    local function waterPlot()
        local plot = getClosestPlot()
        if plot then
            local args = {
                [1] = "Water",
                [2] = plot
            }
            ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
        end
    end

    local function sellCrops()
        local args = {
            [1] = "Sell"
        }
        ReplicatedStorage.RemoteEvent:FireServer(unpack(args))
    end

    -- Create Buttons
    local autoFarmButton = createButton("Auto Farm: OFF", 80, function()
        autoFarm = not autoFarm
        autoFarmButton.Text = "Auto Farm: " .. (autoFarm and "ON" or "OFF")
        autoFarmButton.BackgroundColor3 = autoFarm and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        
        while autoFarm do
            plantSeed()
            wait(1)
            waterPlot()
            wait(5) -- Wait for crop to grow
            harvestCrop()
            wait(0.5)
        end
    end)

    local autoSellButton = createButton("Auto Sell: OFF", 120, function()
        autoSell = not autoSell
        autoSellButton.Text = "Auto Sell: " .. (autoSell and "ON" or "OFF")
        autoSellButton.BackgroundColor3 = autoSell and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        
        while autoSell do
            sellCrops()
            wait(1)
        end
    end)

    local autoWaterButton = createButton("Auto Water: OFF", 160, function()
        autoWater = not autoWater
        autoWaterButton.Text = "Auto Water: " .. (autoWater and "ON" or "OFF")
        autoWaterButton.BackgroundColor3 = autoWater and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
        
        while autoWater do
            waterPlot()
            wait(1)
        end
    end)

    -- Make GUI draggable
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Initial notification
    notify("Script Loaded", "Farm GUI has been loaded!", 5)
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
