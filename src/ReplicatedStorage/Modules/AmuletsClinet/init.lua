local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local Player = game.Players.LocalPlayer
local AmuletClient = {}

local Circle : number = math.pi * 2
local MinimCircle : number = 1
local db : Vector3? = false
local hrp : Humanoid?

function AnimationAmulets(PlayerFolder : Folder)
	if PlayerFolder ~= nil and #PlayerFolder:GetChildren() then
		local numAmulets = #PlayerFolder:GetChildren()
		local Radius = MinimCircle + numAmulets

		for i, GetAmulet in ipairs(PlayerFolder:GetChildren()) do
			local Angle = i * (Circle / numAmulets) + tick() -- Adding tick() for rotation over time
			local x = math.cos(Angle) * Radius
			local z = math.sin(Angle) * Radius

			-- Calculate the new CFrame for the amulet
			if PlayerFolder ~= nil and numAmulets ~= nil then
				local AmuletCFrame = CFrame.Angles(0, 0, 0) 
				* CFrame.new(x, math.sin(tick()*2) / 1, z) 
				+ game.Players.LocalPlayer.Character.HumanoidRootPart.Position

				-- Smoothly interpolate the position
				GetAmulet:PivotTo(AmuletCFrame)
			end
		end
	end
end

function AnimAmuletCircle(PlayerFolder : Folder)
	local RunService = game:GetService("RunService")

	game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
		if PlayerFolder ~= nil and #PlayerFolder:GetChildren() then
			local numAmulets = #PlayerFolder:GetChildren()
			local Radius = MinimCircle + numAmulets

			for i, GetAmulet in ipairs(PlayerFolder:GetChildren()) do
				local Angle = i * (Circle / numAmulets) + tick() -- Adding tick() for rotation over time
				local x = math.cos(Angle) * Radius
				local z = math.sin(Angle) * Radius

				-- Calculate the new CFrame for the amulet
				if PlayerFolder ~= nil and numAmulets ~= nil then
					local AmuletCFrame = CFrame.Angles(0, 0, 0) 
					* CFrame.new(x, math.sin(tick()*2) / 1, z) 
					+ game.Players.LocalPlayer.Character.HumanoidRootPart.Position

					-- Smoothly interpolate the position
					GetAmulet:PivotTo(AmuletCFrame)
				end
			end
		end
	end)

	task.spawn(function()
		RunService.RenderStepped:Connect(function() task.wait()
				AnimationAmulets(PlayerFolder)
		end)
	end)

end


Remotes.AmuletAnim.OnClientEvent:Connect(AnimAmuletCircle)

return AmuletClient