local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local torso = character:WaitForChild("Torso")

local walkspeed = 32
local speed = 1 + walkspeed * 0.05

local rocket = Instance.new("BodyPosition")
rocket.MaxForce = Vector3.new(12500,12500,12500)

local enabled = false

-- Toggle key = C
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.C then
		enabled = not enabled

		if enabled then
			rocket.Parent = torso
		else
			rocket.Parent = nil
		end
	end
end)

-- Ground / air handling
task.spawn(function()
	while true do
		task.wait(0.5)
		if enabled then
			if humanoid.FloorMaterial == Enum.Material.Air then
				rocket.Parent = character
			else
				rocket.Parent = torso
			end
		end
	end
end)

-- Movement force
task.spawn(function()
	while true do
		task.wait()
		if enabled then
			rocket.Position = Vector3.new(
				torso.Position.X + humanoid.MoveDirection.X * speed * 5.4,
				torso.Position.Y,
				torso.Position.Z + humanoid.MoveDirection.Z * speed * 5.4
			)
		end
	end
end)
