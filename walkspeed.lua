--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.Parent = screenGui

-- Enable Dragging for Frame
frame.Active = true
frame.Draggable = true

-- Create Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "Speed:"
speedLabel.Size = UDim2.new(0, 100, 0, 50)
speedLabel.Position = UDim2.new(0, 50, 0, 25)
speedLabel.Parent = frame

-- Create Speed Input
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 100, 0, 50)
speedInput.Position = UDim2.new(0, 50, 0, 75)
speedInput.PlaceholderText = "Enter speed"
speedInput.Parent = frame

-- Create Activate/Deactivate Button
local toggleButton = Instance.new("TextButton")
toggleButton.Text = "Activate"
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(0, 50, 0, 125)
toggleButton.Parent = frame

-- Create Open/Close Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "Close"
closeButton.Size = UDim2.new(0, 100, 0, 50)
closeButton.Position = UDim2.new(0, 50, 0, 175)
closeButton.Parent = frame

-- Create Open Button
local openButton = Instance.new("TextButton")
openButton.Text = "Open"
openButton.Size = UDim2.new(0, 100, 0, 50)
openButton.Position = UDim2.new(0.5, -50, 0.5, -25)
openButton.Visible = false
openButton.Active = false -- Open button won't be draggable
openButton.Parent = screenGui

-- Script variables
local active = false
local speed = 0

-- Activate/Deactivate function
toggleButton.MouseButton1Click:Connect(function()
    active = not active
    if active then
        toggleButton.Text = "Deactivate"
        speed = tonumber(speedInput.Text) or 0
    else
        toggleButton.Text = "Activate"
        speed = 0
    end
end)

-- Close/Open function
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    frame.Active = false -- Disable dragging when hidden
    frame.Draggable = false -- Disable dragging for the main frame
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    frame.Visible = true
    frame.Active = true -- Enable dragging when visible
    frame.Draggable = true -- Enable dragging for the main frame
    openButton.Visible = false
end)

-- Speed and Jump function
game:GetService("RunService").RenderStepped:Connect(function()
    if active and speed ~= 0 then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.MoveDirection.Magnitude > 0 then
                    local hrp = character.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame + humanoid.MoveDirection * speed * game:GetService("RunService").RenderStepped:Wait()
                end
            end
        end
    end
end)

-- Ensure camera follows character
game:GetService("RunService").RenderStepped:Connect(function()
    if game.Players.LocalPlayer.Character then
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
end)
