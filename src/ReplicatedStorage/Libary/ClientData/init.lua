local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local DataClient = {}
-- Придумать как сделать постонное обновление 
-- Добавить истязание улья
DataClient[Player.Name] = {}
function DataClient:GetClient() -- Вместо _G.PData модуль
    local _,Err = pcall(function()
        repeat task.wait()
            if game:GetService("RunService"):IsClient() then
                DataClient[Player.Name] = Remotes.PlayerClientData:InvokeServer()
            end
        until DataClient[Player.Name] ~= {}
    end)

    if Err then
        warn(Err)
    end

    return DataClient[Player.Name]
end

function UpdateData(PDataNew)
    local _, Err = pcall(function()
        if PDataNew ~= nil then
            DataClient[Player.Name] = PDataNew
            DataClient:GetClient()
        end
    end)

    if Err then
       warn(Err)
    end
end

function DataClient:WriteDataServer(Data)
    Remotes.ClientOnServer:FireServer(Data)
end

Remotes.DataUpdate.OnClientEvent:Connect(UpdateData)

return DataClient