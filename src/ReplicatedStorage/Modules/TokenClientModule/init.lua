local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Remotes = ReplicatedStorage.Remotes
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local TokenClient = {}
local heartbeatConnection

function onTokenAdded(child)
    if child.Name == "Token" then
        child:PivotTo(child:GetPivot() * CFrame.Angles(0, math.rad(2), 0)) -- Вращение токена
    end
end

function RotationToken()
	RunService.RenderStepped:Connect(function() task.wait()
		if workspace.GameSettings.Tokens:FindFirstChild(Player.Name) then
			local TokenFolder : Folder = workspace.GameSettings.Tokens:FindFirstChild(Player.Name)

			for _, child in ipairs(TokenFolder:GetChildren()) do
				if child:GetAttribute('StopPos') then
					onTokenAdded(child)
				end
			end
			
			TokenFolder.ChildAdded:Connect(function(child)
				if child:GetAttribute('StopPos') then
					onTokenAdded(child)
				end
			end)

		end
	end)
end
RotationToken()
return TokenClient