local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local FolderRSAmulet : Folder  = ReplicatedStorage.Assert.Amulets
local FolderAmuletWK : Folder  = workspace.GameSettings.AmuletsPlayers
local Remotes : Folder = ReplicatedStorage.Remotes
--// settings data Spawnt Amulet
local VisualAmulet : table = {}

--// libary
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local AmuletsModule = {}

function AmuletsModule:Starts(Player : Player)
   local PData : table = Data:Get(Player)
   local IndexNumber : number = 0
	if not FolderAmuletWK:FindFirstChild(Player.Name) then
		local NewFloder : Folder = Instance.new("Folder",FolderAmuletWK)
		NewFloder.Name = Player.Name
	end

	for i, GetStats in next, PData.Amulets do
		if i ~= nil then
			if VisualAmulet[i] == nil then
				local NewAmulets : Instance? = FolderRSAmulet[i]:Clone()
				local PlayerFolder : Folder = FolderAmuletWK:FindFirstChild(Player.Name)
				NewAmulets.Parent = PlayerFolder
				VisualAmulet[i] = GetStats
				task.spawn(function()
					Remotes.AmuletAnim:FireAllClients(PlayerFolder)
				end)
			else
				local PlayerFolder : Folder = FolderAmuletWK:FindFirstChild(Player.Name)
				task.spawn(function()
					Remotes.AmuletAnim:FireAllClients(PlayerFolder)
				end)
			end
		end
	end
end


return AmuletsModule