local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Remotes = ReplicatedStorage.Remotes
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local TokenClient = {}

function TokenRotation(NewToken)
   -- TweenModule:FieldUpToken(NewToken)
    Remotes.TokenServerStart:FireServer(NewToken)
    RunService.Heartbeat:Connect(function()
        task.wait()
        local Tokens = {}
        if workspace.GameSettings.Tokens:FindFirstChild(Player.Name) then
            for i, v in workspace.GameSettings.Tokens[Player.Name]:GetChildren() do
                table.insert(Tokens, v)
            end

            for _, TokenClone in Tokens do
                if TokenClone:FindFirstChild('Inside') and TokenClone:FindFirstChild('Outside') or TokenClone:GetAttribute('Touched') then
                    TweenModule:AnimationToken(TokenClone) 
                end
            end
        end
    end)

end

Remotes.TokenClient.OnClientEvent:Connect(TokenRotation)
return TokenClient