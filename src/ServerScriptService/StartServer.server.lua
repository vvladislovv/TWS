local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Server : ModuleScript = script.Parent.ServerGame
require(Server.UserPlayerData)

local Equiment = require(Server.Equiment)
local AmuletsModule = require(Server.AmuletsModule)

function StartSystems()
    pcall(function()

        for _, index in next, Server:GetDescendants() do
            if index:IsA('ModuleScript') then
                require(index)
            end
        end

        ReplicatedStorage.Remotes.StartSystems.Event:Connect(function(player : Player, PData : table)
            Equiment:StartSysmes(player)
            AmuletsModule:Starts(player)
            ReplicatedStorage.Remotes.StartCleintSystems:FireClient(player)
            ReplicatedStorage.Remotes.DataUpdate:FireClient(player,PData)
            --require(script.Parent.ServerGame.ButtonServer):Start()
        end)
    end)
end

StartSystems()

-- сделать нормально клиент
