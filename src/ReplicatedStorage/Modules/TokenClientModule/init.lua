local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local TokenClient = {}

function TokenAnim(NewToken)
    coroutine.wrap(function()
        while true do task.wait()
            NewToken.Inside.CFrame *= CFrame.Angles(0, 0, math.rad(3))
            NewToken.Inside.CFrame *= CFrame.Angles(0, 0, math.rad(3))
            --TweenModule:AnimationToken(NewToken)
        end
    end)()
end

Remotes.TokenClient.OnClientEvent:Connect(TokenAnim)

return TokenClient