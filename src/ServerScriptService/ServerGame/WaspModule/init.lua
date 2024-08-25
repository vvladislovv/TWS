local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local FolderWasp : Folder = workspace.GameSettings.Wasps
local WaspModule : ModuleScript? = ReplicatedStorage.Wasps

--// Libary
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)

local WaspModule = {}
WaspModule.__index = WaspModule

function WaspModule:NewWasp(PData : table,PosSlot : Vector3?,WaspModel : ModuleScript,Hive)
    local NewWaspTable : table = {}
    NewWaspTable.WaspSettings = require(WaspModel)
    WaspModel.Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z) * CFrame.Angles(0,90,0)) 
    TweenModule:CreateWaspHive(WaspModel.Model,PosSlot)
    setmetatable(NewWaspTable, WaspModule)
    WaspModule:AIPos()
end

function WaspModule:Animate(WaspModel)
    local Model = WaspModel.Model
end

function WaspModule:AIPos()

    task.spawn(function()
        while true do task.wait()
            
        end
    end)

end

return WaspModule