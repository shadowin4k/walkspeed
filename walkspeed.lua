local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local walkspeed = 32
local speed = 1 + walkspeed * 0.05

local enabled = false
local rocket

-- setup character safely
local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")

	-- R15 / R6 compatibility
	local root = character:WaitForChild("HumanoidRootPart")

	rocket = Instance.new("BodyPosition")
	rocket.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	rocket.P = 5000
	rocket.D = 100
	rocket.Parent = nil

	-- toggle
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.C then
			enabled = not enabled
			rocket.Parent = enabled and root or nil
		end
	end)

	-- movement
	RunService.RenderStepped:Connect(function()
		if not enabled then return end

		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			rocket.Position = root.Position + Vector3.new(
				moveDir.X * speed * 5.4,
				0,
				moveDir.Z * speed * 5.4
			)
		else
			rocket.Position = root.Position
		end
	end)
end

-- initial load
if player.Character then
	setupCharacter(player.Character)
end

-- respawn handling
player.CharacterAdded:Connect(setupCharacter)
