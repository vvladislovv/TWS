local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Token = ReplicatedStorage.Assert.Token
local Remotes = ReplicatedStorage.Remotes
--Service
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local Utils = require(ReplicatedStorage.Libary.Utils)
local TokenInfoTable = require(script.TokenInfo)

local TokenModule = {}

function TokenModule:CreateToken(InfoToken : table)
    local NewToken : BasePart = Token:Clone()
    local TokenInfo : table, Public : boolean

    if InfoToken.Type == "Any" then
        for index, value in InfoToken.Item do
            TokenInfo = TokenInfoTable[index]
        end

    elseif InfoToken.Type == "Wasp" then
        TokenInfo = TokenInfoTable[InfoToken.Item]
   end
   
   if not workspace.GameSettings.Tokens:FindFirstChild(InfoToken.Player.Name) then
        local FolderOwner : Folder? = Instance.new("Folder",workspace.GameSettings.Tokens)
        FolderOwner.Name = InfoToken.Player.Name
        NewToken.Parent = FolderOwner
    else
        NewToken.Parent = workspace.GameSettings.Tokens:FindFirstChild(InfoToken.Player.Name)
   end
    for i = 1, 2 do
        NewToken.Inside['Decal'..i].Texture = TokenInfo.Decal
    end

    NewToken.Inside.Position = InfoToken.Pos
    NewToken.Outside.Position = InfoToken.Pos

    Remotes.TokenClient:FireAllClients(NewToken)

    task.delay(TokenInfo.Timer, function() 
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
    end)

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