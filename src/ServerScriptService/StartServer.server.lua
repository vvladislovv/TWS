--local Equiment = require(script.Equiment)

local Server : ModuleScript = script.Parent.ServerGame
local _, Err = pcall(function()
    --Equiment:StartSysmes()
    require(Server.UserPlayerData)
    task.wait(1)
    for _, index in next, Server:GetDescendants() do
        if index:IsA('ModuleScript') then
            require(index)
           -- print(index)
        end
    end
end)

coroutine.wrap(function()
    if Err then
        warn(Err)
    end
end)()