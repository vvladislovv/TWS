local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Token = ReplicatedStorage.Assert.Token
local Remotes = ReplicatedStorage.Remotes
--Service
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local Utils = require(ReplicatedStorage.Libary.Utils)
local TokenInfoTable = require(script.TokenInfo)

local TokenModule = {}

function TokenDelayWait()
	-- ! TaskWait

end

function TouchedCollect(NewToken : Model) -- ? Touched Collect
	--! Проблема в том что при подборе подлет лаганый также нет определенный позиции. Скорее всего проблема в том что какой то рансервис ебет мазга
	local heartbeatConnection
	local startTime = tick()
	local EndPosition = NewToken.PrimaryPart.CFrame + Vector3.new(0,8,0)

	local function onHeartbeat() task.wait()
		local elapsedTime = tick() - startTime
		local alpha = math.clamp(elapsedTime * 2, 0, 1)
		if NewToken ~= nil and NewToken then task.wait()
			NewToken:PivotTo(NewToken.PrimaryPart.CFrame:Lerp(EndPosition, alpha))

			if alpha >= 1 then
				heartbeatConnection:Disconnect()
				TweenModule:DestroyToken(NewToken)
				task.wait(0.25)
				NewToken:Destroy()
			end
		end
	end

	heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
end

function TokenUpField(NewToken : Model) --? Token Spawn Field 
	local startTime = tick()

	local heartbeatConnection
	local EndPosition = NewToken.PrimaryPart.CFrame + Vector3.new(0,3.5,0)

	local function onHeartbeat() task.wait()
		local elapsedTime = tick() - startTime
		local alpha = math.clamp(elapsedTime * 4, 0, 1)
		if NewToken:GetAttribute("Visible") then
			NewToken:PivotTo(NewToken.PrimaryPart.CFrame:Lerp(EndPosition, alpha))
			if alpha >= 1 then
				NewToken:SetAttribute('StopPos', true)
				heartbeatConnection:Disconnect()
			end
		end
	end

	heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
end

function TokenModule:CreateToken(InfoToken : table) --? Create Token
    local NewToken : BasePart = Token:Clone()
    local TokenInfo : table

    if InfoToken.Type == "Any" then -- ? all token
        for index, _ in InfoToken.Item do
            TokenInfo = TokenInfoTable[index]
        end 
    elseif InfoToken.Type == "Wasp" then --? Wasp Token
        TokenInfo = TokenInfoTable[InfoToken.Item]
   	end
   
	if not workspace.GameSettings.Tokens:FindFirstChild(InfoToken.Player.Name) then -- ? Create Folder
		local FolderOwner : Folder? = Instance.new("Folder",workspace.GameSettings.Tokens)
		FolderOwner.Name = InfoToken.Player.Name
		NewToken.Parent = FolderOwner
	else
		NewToken.Parent = workspace.GameSettings.Tokens:FindFirstChild(InfoToken.Player.Name)
	end

    --* New Token Create
	local ImageToken : MeshPart = NewToken.CubeDown
	ImageToken.Bottom.ImageLabel.Image = TokenInfo.Decal
	ImageToken.Top.ImageLabel.Image = TokenInfo.Decal

	NewToken:MoveTo(InfoToken.Pos)
	NewToken:SetAttribute('StopPos', false)
	NewToken:SetAttribute('Visible', true)
	TokenUpField(NewToken)

	--? Touched Token
	NewToken.PrimaryPart.Touched:Connect(function(hit)
		if workspace.GameSettings.Tokens:FindFirstChild(hit.Parent.Name) and workspace:FindFirstChild(hit.Parent.Name) and game.Players:FindFirstChild(hit.Parent.Name) then
			NewToken:FindFirstChild('CubeDown').CanTouch = false
			NewToken:FindFirstChild('CubeUp').CanTouch = false
			NewToken:SetAttribute("Visible", false)
			NewToken:SetAttribute('StopPos', false)
			TouchedCollect(NewToken)
		end
	end)

end



return TokenModule