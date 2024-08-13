game:IsLoaded()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.Remotes
local Player = game.Players.LocalPlayer

Remote.StartCleintSystems.OnClientEvent:Connect(function()
    local ClientScript : ModuleScript = game.ReplicatedStorage.Modules
    require(ReplicatedStorage.Libary.ClientData)
    local _, Err = pcall(function()
        for _, index in next, ClientScript:GetDescendants() do
            if index:IsA('ModuleScript') then
                require(index)
            end
        end
    end)
    
    coroutine.wrap(function()
        if Err then
            warn(Err)
        end
    end)
end)

