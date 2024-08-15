local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')
local QuestUI : StarterGui? = PlayerGui:WaitForChild('UIs').QuestModule -- ! Create
local CameraFolder : Folder = workspace.GameSettings.Camers
local Camera = workspace.CurrentCamera

local Remote : Folder = ReplicatedStorage.Remotes
local FolderNPCDiologs : ModuleScript = ReplicatedStorage.Modules.QuestModule
--Libary
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local Controls = require(Player.PlayerScripts.PlayerModule):GetControls()

local QuestModule = {}

QuestModule.GetNPCIcon = function(NPC)
    local Table : table = {
        ["Ladybug"] = "",
    }
    return Table[NPC] or "rbxassetid://18190727850"
end

function GetQuestType(NPC : string)
    local NPCData = Data:GetClient(Player)

    if not NPCData.Quests[NPC].Claim then
        return "Start"
    elseif NPCData.Quests[NPC].Claimed and not NPCData.Quests[NPC].Completed then
        return "During"
    else
        return "Finish"
    end
end

function ClickFrameQuest()
    
end

function QuestModule:StartModule(ScriptButton : Part?)
    local NPCName : string = ScriptButton:GetAttribute('NPCName')
    local QuestData = FolderNPCDiologs:FindFirstChild(NPCName)
    local Dialogue = {}

    if QuestData then
        require(QuestData)
    end

    if not QuestData then
        Dialogue = {"I don't have more quests right now!", "Return latter to claim quest"}
    else
        Dialogue = QuestData.Dialogues[GetQuestType(NPCName)]
    end

    local function CameraStart()
        local CameraNPC = CameraFolder[NPCName]
        
    end
    CameraStart()
    ClickFrameQuest()
end


function QuestFinish()
    
end


return QuestModule