local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local enabled = false
local rocket
local speedMultiplier = 32 -- you can tweak this

-- get proper root part
local function getRoot(character)
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local root = getRoot(character)

	if not root then return end

	-- create BodyPosition
	rocket = Instance.new("BodyPosition")
	rocket.MaxForce = Vector3.new(1e6, 1e6, 1e6) -- strong enough to fight gravity
	rocket.P = 5000
	rocket.D = 100
	rocket.Parent = nil

	-- toggle flight with C
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.C then
			enabled = not enabled
			rocket.Parent = enabled and root or nil
		end
	end)

	-- flight movement
	RunService.RenderStepped:Connect(function()
		if not enabled then return end
		local moveDir = humanoid.MoveDirection
		local targetPos = root.Position + moveDir * speedMultiplier
		rocket.Position = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
	end)
end

-- initial setup
if player.Character then
	setupCharacter(player.Character)
end

-- respawn handling
player.CharacterAdded:Connect(setupCharacter)
