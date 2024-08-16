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
    
    TweenModule:FieldUpToken(NewToken, InfoToken)

    --Remotes.TokenClient:FireAllClients(NewToken) -- Проблема в том что есть баг который багает анимку. Ушел не смог пофиксить 17.08
end

return TokenModule