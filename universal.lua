local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create Movement Frame (black box for buttons)
local movementFrame = Instance.new("Frame")
movementFrame.Name = "Movement"
movementFrame.Size = UDim2.new(0, 200, 0, 200)
movementFrame.Position = UDim2.new(1, -210, 0.5, -100)
movementFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
movementFrame.Parent = screenGui

-- Create Combat/Visual Frame (black box for buttons)
local combatFrame = Instance.new("Frame")
combatFrame.Name = "Combat/Visual"
combatFrame.Size = UDim2.new(0, 200, 0, 200)
combatFrame.Position = UDim2.new(1, -420, 0.5, -100)  -- Adjusted for slight gap
combatFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
combatFrame.Parent = screenGui

-- Create Titles for Frames
local movementTitle = Instance.new("TextLabel")
movementTitle.Size = UDim2.new(0, 200, 0, 30)
movementTitle.Position = UDim2.new(0, 0, 0, -30)  -- Position above the movementFrame
movementTitle.Text = "Movement"
movementTitle.TextSize = 18  -- Slightly bigger title
movementTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
movementTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
movementTitle.Parent = movementFrame

local combatTitle = Instance.new("TextLabel")
combatTitle.Size = UDim2.new(0, 200, 0, 30)
combatTitle.Position = UDim2.new(0, 0, 0, -30)  -- Position above the combatFrame
combatTitle.Text = "Combat/Visual"
combatTitle.TextSize = 18  -- Slightly bigger title
combatTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
combatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
combatTitle.Parent = combatFrame

-- Create Buttons for Movement
local flightButton = Instance.new("TextButton")
flightButton.Size = UDim2.new(0, 180, 0, 40)
flightButton.Position = UDim2.new(0, 10, 0, 40)  -- Adjusted position
flightButton.Text = "Flight"
flightButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
flightButton.Parent = movementFrame

local clickToTPButton = Instance.new("TextButton")
clickToTPButton.Size = UDim2.new(0, 180, 0, 40)
clickToTPButton.Position = UDim2.new(0, 10, 0, 90)  -- Adjusted position
clickToTPButton.Text = "Click to TP"
clickToTPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
clickToTPButton.Parent = movementFrame

-- Create Buttons for Combat/Visual
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 180, 0, 40)
espButton.Position = UDim2.new(0, 10, 0, 40)  -- Adjusted position
espButton.Text = "ESP"
espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
espButton.Parent = combatFrame

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0, 180, 0, 40)
aimbotButton.Position = UDim2.new(0, 10, 0, 90)  -- Adjusted position
aimbotButton.Text = "Aimbot"
aimbotButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
aimbotButton.Parent = combatFrame

-- States to track if the buttons are toggled
local flightButtonToggled = false
local clickToTPToggled = false
local espButtonToggled = false
local aimbotButtonToggled = false
local flying = false
local teleporting = false
local aiming = false

-- Toggle Flight button state and color change
flightButton.MouseButton1Click:Connect(function()
    flightButtonToggled = not flightButtonToggled
    if flightButtonToggled then
        flightButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green when toggled
    else
        flightButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red when untoggled
    end
end)

-- Toggle Click to TP button state and color change
clickToTPButton.MouseButton1Click:Connect(function()
    clickToTPToggled = not clickToTPToggled
    if clickToTPToggled then
        clickToTPButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        clickToTPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Toggle ESP button state and color change
espButton.MouseButton1Click:Connect(function()
    espButtonToggled = not espButtonToggled
    if espButtonToggled then
        espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        -- Enable ESP when toggled
        for _, v in pairs(players:GetPlayers()) do
            if v ~= player then
                addPlayerEsp(v)  -- Add ESP to other players
            end
        end
    else
        espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        -- Disable ESP when toggled
        for _, v in pairs(players:GetPlayers()) do
            if v ~= player then
                removePlayerEsp(v)  -- Remove ESP from other players
            end
        end
    end
end)

-- Toggle Aimbot button state and color change
aimbotButton.MouseButton1Click:Connect(function()
    aimbotButtonToggled = not aimbotButtonToggled
    if aimbotButtonToggled then
        aimbotButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        aiming = true  -- Enable aimbot functionality
    else
        aimbotButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        aiming = false  -- Disable aimbot functionality
    end
end)

-- Flight logic with G key
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Check if G is held and Flight button is toggled
    if input.KeyCode == Enum.KeyCode.G and flightButtonToggled then
        local humanoidRootPart = nil
        repeat
            wait(0.1)
            if player.Character then
                humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            end
        until humanoidRootPart

        -- Start flying when G is pressed
        flying = true
        while flying do
            if humanoidRootPart then
                local camera = workspace.CurrentCamera
                local velocity = camera.CFrame.LookVector * 50  -- Move in camera's direction
                humanoidRootPart.Velocity = velocity  -- Apply velocity to simulate flight
            end
            wait(0.1)
        end
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        flying = false  -- Stop flying when G is released
    end
end)

-- Click to TP logic (on T key)
local mouse = player:GetMouse()
local teleporting = false

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Check if T is pressed and Click to TP button is toggled
    if input.KeyCode == Enum.KeyCode.T and clickToTPToggled then
        teleporting = true
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        teleporting = false
    end
end)

-- Listen for mouse click to teleport
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- If T is held and Click to TP button is toggled, listen for left mouse click
    if teleporting and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local targetPosition = mouse.Hit.p

        -- Set the teleport position
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        end
    end
end)

-- ESP logic
local playerEsp = {}

-- Function to add ESP for a specific player
function addPlayerEsp(v)
    local list = {}

    -- Red outline for box with transparency
    list.boxOutline = Drawing.new("Square")
    list.boxOutline.Color = Color3.new(1, 0, 0)  -- Red outline for box
    list.boxOutline.Thickness = 2
    list.boxOutline.Transparency = 0.6  -- Add transparency to the box

    -- Player name label above the head with transparency
    list.nameLabel = Drawing.new("Text")
    list.nameLabel.Color = Color3.new(1, 0, 0)  -- Red text for player name
    list.nameLabel.Size = 16
    list.nameLabel.Center = true
    list.nameLabel.Outline = true
    list.nameLabel.OutlineColor = Color3.new(0, 0, 0)  -- Black outline for text
    list.nameLabel.Transparency = 0.6  -- Add transparency to the name text

    -- Update ESP every frame
    list.connection = game:GetService("RunService").RenderStepped:Connect(function()
        -- Check if ESP is toggled before proceeding
        if not espButtonToggled then
            list.boxOutline.Visible = false
            list.nameLabel.Visible = false
            return
        end

        local cam = game:GetService("Workspace").CurrentCamera
        local char = v.Character
        if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.PrimaryPart then
            local headPos, headVis = cam:WorldToViewportPoint(char.Head.Position)
            local feetPos, feetVis = cam:WorldToViewportPoint(char.PrimaryPart.Position - Vector3.new(0, char.PrimaryPart.Size.Y / 2, 0))

            if headVis then
                -- Update name label above head
                list.nameLabel.Position = Vector2.new(headPos.X, headPos.Y - 20)  -- Slightly above the head
                list.nameLabel.Text = v.Name
                list.nameLabel.Visible = true
            else
                list.nameLabel.Visible = false
            end

            if headVis and feetVis then
                -- Update red outline around box
                local height = feetPos.Y - headPos.Y
                local width = height * 0.5
                list.boxOutline.Position = Vector2.new(headPos.X - width / 2, headPos.Y)
                list.boxOutline.Size = Vector2.new(width, height)
                list.boxOutline.Visible = true
            else
                list.boxOutline.Visible = false
            end
        else
            list.nameLabel.Visible = false
            list.boxOutline.Visible = false
        end
    end)
end

-- Function to remove ESP for a specific player
function removePlayerEsp(v)
    -- Logic for removing ESP for a specific player
end

-- Add ESP for all players in the game
players.PlayerAdded:Connect(function(v)
    if espButtonToggled then
        addPlayerEsp(v)
    end
end)

-- Aimbot logic, only enabled when Aimbot button is toggled and B is held
local aiming = false
local aimbotRadius = 100  -- Radius for the aimbot target area
local aimbotCircle  -- Circle frame for the aimbot radius

-- Aimbot logic, only enabled when Aimbot button is toggled and B is held
local aiming = false
local aimbotRadius = 100  -- Set the radius for the circle around the crosshair

-- Toggle aiming with B key, only if aimbot button is toggled
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.B and aimbotButtonToggled then
        aiming = true
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.B then
        aiming = false
    end
end)

-- Update aimbot targeting logic
runService.RenderStepped:Connect(function()
    if aiming and aimbotButtonToggled then
        -- Aimbot logic to lock onto enemies' heads while B is held
        local closestPlayer = nil
        local shortestDistance = math.huge
        local targetPart = "Head"  -- Target the "Head" part
        local camera = workspace.CurrentCamera
        local mousePosition = userInputService:GetMouseLocation()

        for _, target in pairs(players:GetPlayers()) do
            if target ~= player and target.Character and target.Character:FindFirstChild(targetPart) then
                local targetPosition = target.Character[targetPart].Position
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPosition)

                if onScreen then
                    -- Calculate the distance between the crosshair and the target's screen position
                    local distanceFromCrosshair = (Vector2.new(screenPos.X, screenPos.Y) - mousePosition).Magnitude

                    -- Check if the target is within the specified radius from the crosshair
                    if distanceFromCrosshair <= aimbotRadius then
                        local targetDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePosition).Magnitude
                        if targetDistance < shortestDistance then
                            shortestDistance = targetDistance
                            closestPlayer = target
                        end
                    end
                end
            end
        end

        -- Aim at the closest player's head if within the circle
        if closestPlayer then
            local targetPosition = closestPlayer.Character[targetPart].Position
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPosition)
        end
    end
end)