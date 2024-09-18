local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Token = ReplicatedStorage.Assert.Token
local Remotes = ReplicatedStorage.Remotes
--Service
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local Utils = require(ReplicatedStorage.Libary.Utils)
local TokenInfoTable = require(script.TokenInfo)

local TokenModule = {}

function TokenRotation()
	-- ! Rotation
end

function TokenDelayWait()
	-- ! Rotation
end

function TokenUpField(NewToken : Model) --? Token Spawn Field 
	local startTime = tick()

	local heartbeatConnection
	local EndPosition = NewToken.PrimaryPart.CFrame + Vector3.new(0,3,0)

	local function onHeartbeat() task.wait()
		local elapsedTime = tick() - startTime
		local alpha = math.clamp(elapsedTime / 2, 0, 1)

		NewToken:PivotTo(NewToken.PrimaryPart.CFrame:Lerp(EndPosition, alpha))

		if alpha >= 1 then
			heartbeatConnection:Disconnect()
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
	
	TokenUpField(NewToken)

	--? Touched Token
	coroutine.wrap(function()
		NewToken.PrimaryPart.Touched:Connect(function()
			if workspace.GameSettings.Tokens:FindFirstChild(hit.Parent.Name) and workspace:FindFirstChild(hit.Parent.Name) and game.Players:FindFirstChild(hit.Parent.Name) then
				NewToken:FindFirstChild('CubeDown').CanTouch = false
				NewToken:FindFirstChild('CubeUp').CanTouch = false
			end
		end)
	end)


    --Remotes.TokenClient:FireAllClients(NewToken)

    --[[task.delay(TokenInfo.Timer, function() 
        if NewToken and NewToken:FindFirstChild('Inside') and NewToken:FindFirstChild('Outside') then
            TweenModule:DestroyToken(NewToken)
        end
    end)

    NewToken.Inside.Touched:Connect(function(hit)
        if workspace.GameSettings.Tokens:FindFirstChild(hit.Parent.Name) and workspace:FindFirstChild(hit.Parent.Name) and game.Players:FindFirstChild(hit.Parent.Name) then
            NewToken:FindFirstChild('Inside').CanTouch = false
            NewToken:FindFirstChild('Outside').CanTouch = false
            TweenModule:TouchedToken(NewToken)
        end
    end)]]

end

Remotes.TokenServerStart.OnServerEvent:Connect(function(Player : Player, TokenCloner : BasePart)
    TweenModule:FieldUpToken(TokenCloner)

    task.spawn(function()
        while true do task.wait()
            TweenModule:AnimationToken(TokenCloner)
        end
    end)

end)

return TokenModule