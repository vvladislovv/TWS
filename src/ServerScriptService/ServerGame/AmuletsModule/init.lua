local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local FolderRSAmulet : Folder  = ReplicatedStorage.Assert.Amulets
local FolderAmuletWK : Folder  = workspace.GameSettings.AmuletsPlayers
local Remotes : Folder = ReplicatedStorage.Remotes
--// settings data Spawnt Amulet


--// libary
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local AmuletsModule = {}

function AmuletsModule:Starts(Player)
    local PData : table = Data:Get(Player)
    
    if not FolderAmuletWK:FindFirstChild(Player.Name) then
        local NewFloder : Folder = Instance.new("Folder",FolderAmuletWK)
        NewFloder.Name = Player.Name
    end

    if PData.Amulets ~= {} then
        for i, index in next, PData.Amulets do
            local NewAmulets : Instance? = FolderRSAmulet[i]:Clone()
            local PlayerFolder : Folder = FolderAmuletWK:FindFirstChild(Player.Name)
            NewAmulets.Parent = PlayerFolder
            
            task.spawn(function()
                Remotes.AmuletAnim:FireAllClients(PlayerFolder)
            end)
  
        end
    end
end


return AmuletsModule