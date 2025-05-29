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
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GrowAGardenGUI"
    ScreenGui.Parent = playerGui
    ScreenGui.ResetOnSpawn = false

    -- Create Main Frame with blur effect
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Add blur effect
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = game:GetService("Lighting")

    -- Create Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Create Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Title.BorderSizePixel = 0
    Title.Text = "Grow-a-Garden Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title

    -- Create Container for buttons
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    Container.Parent = MainFrame

    -- Auto Layout for Container
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = Container

    -- Variables for farming
    local autoFarm = false
    local autoWater = false
    local autoSell = false
    local selectedSeed = "Tomato"
    local farmingSpeed = 1

    -- Function to create section
    local function createSection(name)
        local section = Instance.new("Frame")
        section.Name = name .. "Section"
        section.Size = UDim2.new(1, 0, 0, 30)
        section.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        section.BorderSizePixel = 0
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 6)
        sectionCorner.Parent = section
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Size = UDim2.new(1, 0, 1, 0)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = name
        sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectionTitle.TextSize = 14
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Parent = section
        
        section.Parent = Container
        return section
    end

    -- Function to create toggle button
    local function createToggle(name, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        button.BorderSizePixel = 0
        button.Text = name .. ": OFF"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Parent = Container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        local isEnabled = false
        
        button.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            button.Text = name .. ": " .. (isEnabled and "ON" or "OFF")
            button.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 55)
            callback(isEnabled)
        end)
        
        return button
    end

    -- Create dropdown for seeds
    local function createDropdown(options)
        local dropdown = Instance.new("Frame")
        dropdown.Size = UDim2.new(1, 0, 0, 35)
        dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        dropdown.BorderSizePixel = 0
        dropdown.Parent = Container
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 6)
        dropdownCorner.Parent = dropdown
        
        local selected = Instance.new("TextButton")
        selected.Size = UDim2.new(1, 0, 1, 0)
        selected.BackgroundTransparency = 1
        selected.Text = "Selected Seed: " .. selectedSeed
        selected.TextColor3 = Color3.fromRGB(255, 255, 255)
        selected.TextSize = 14
        selected.Font = Enum.Font.Gotham
        selected.Parent = dropdown
        
        local optionsList = Instance.new("Frame")
        optionsList.Size = UDim2.new(1, 0, 0, #options * 35)
        optionsList.Position = UDim2.new(0, 0, 1, 5)
        optionsList.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        optionsList.BorderSizePixel = 0
        optionsList.Visible = false
        optionsList.ZIndex = 2
        optionsList.Parent = dropdown
        
        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, 6)
        optionsCorner.Parent = optionsList
        
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 35)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
            optionButton.BackgroundTransparency = 1
            optionButton.Text = option
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionButton.TextSize = 14
            optionButton.Font = Enum.Font.Gotham
            optionButton.ZIndex = 2
            optionButton.Parent = optionsList
            
            optionButton.MouseButton1Click:Connect(function()
                selectedSeed = option
                selected.Text = "Selected Seed: " .. option
                optionsList.Visible = false
            end)
        end
        
        selected.MouseButton1Click:Connect(function()
            optionsList.Visible = not optionsList.Visible
        end)
        
        return dropdown
    end

    -- Farming Functions
    local function getClosestPlot()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        
        local closest = nil
        local minDist = math.huge
        
        for _, plot in pairs(plots:GetChildren()) do
            if plot:IsA("Model") and plot:FindFirstChild("PrimaryPart") then
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
            ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end
    end

    local function waterPlot()
        local plot = getClosestPlot()
        if plot then
            local args = {
                [1] = "Water",
                [2] = plot
            }
            ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end
    end

    local function harvestCrop()
        local plot = getClosestPlot()
        if plot then
            local args = {
                [1] = "Harvest",
                [2] = plot
            }
            ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end
    end

    local function sellCrops()
        local args = {
            [1] = "Sell"
        }
        ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end

    -- Create Sections
    createSection("Main")

    -- Create Seed Dropdown
    createDropdown({"Tomato", "Carrot", "Corn", "Watermelon", "Strawberry", "Pumpkin"})

    -- Create Toggles
    createToggle("Auto Farm", function(enabled)
        autoFarm = enabled
        if enabled then
            notify("Auto Farm", "Started auto farming", 3)
            spawn(function()
                while autoFarm do
                    plantSeed()
                    wait(0.5)
                    waterPlot()
                    wait(5)
                    harvestCrop()
                    wait(0.5)
                end
            end)
        else
            notify("Auto Farm", "Stopped auto farming", 3)
        end
    end)

    createToggle("Auto Water", function(enabled)
        autoWater = enabled
        if enabled then
            notify("Auto Water", "Started auto watering", 3)
            spawn(function()
                while autoWater do
                    waterPlot()
                    wait(1)
                end
            end)
        else
            notify("Auto Water", "Stopped auto watering", 3)
        end
    end)

    createToggle("Auto Sell", function(enabled)
        autoSell = enabled
        if enabled then
            notify("Auto Sell", "Started auto selling", 3)
            spawn(function()
                while autoSell do
                    sellCrops()
                    wait(1)
                end
            end)
        else
            notify("Auto Sell", "Stopped auto selling", 3)
        end
    end)

    -- Make GUI draggable
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Title.InputChanged:Connect(function(input)
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
    notify("Script Loaded", "Grow-a-Garden Hub is ready!", 5)
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
