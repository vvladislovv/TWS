local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')
local UIs : StarterGui = PlayerGui:WaitForChild('UIs')
local QuestUI : StarterGui? = UIs.QuestModule -- ! Create
local CameraFolder : Folder = workspace.GameSettings.Camers
local Camera = workspace.CurrentCamera

local Remote : Folder = ReplicatedStorage.Remotes
local FolderNPCDiologs : ModuleScript = ReplicatedStorage.QuestDiologs
--Libary
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local Controls = require(Player.PlayerScripts.PlayerModule):GetControls()
local OldPosCamera : Vector3? = nil

local QuestModule = {}

QuestModule.GetNPCIcon = function(NPC)
    local Table : table = {
        ["Ladybug"] = "rbxassetid://18190727850",
    }
    return Table[NPC] or "rbxassetid://18190727850"
end



function QuestModule:Update(Npc : string)
    local PData = Data:GetClient(Player)

    -- Remove Quest
    if not PData.Quests[Npc].Claimed then
        local PreviousQuest : ModuleScript = require(FolderNPCDiologs[Npc][PData.Quests[Npc].Quest - 1])
        local QuesetFrame : Frame = QuestUI.Icon.List:FindFirstChild(PreviousQuest.Quest) -- "Этого нет тк гуишки на это еще не сделана
    
        if QuesetFrame then
            QuesetFrame:Destroy()
        end
        if #QuesetFrame.Icon.List:GetChildren() - 1 == 0 then
            QuesetFrame.Icon.NoQuests.Visible = true
        end
        return
    end

    local QuestData : ModuleScript = FolderNPCDiologs[Npc]:FindFirstChild(PData.Quests[Npc].Quest)
    
    if not QuestData then
        return
    end

    QuestData = require(QuestData)

    local function QusetFrame()
        local QuesetFrame : Frame = QuestUI.Icon.List:FindFirstChild(QuestData.Quest) -- "Этого нет тк гуишки на это еще не сделана
        QuesetFrame.Icon.NoQuests.Visible = false

        if not QuesetFrame then
            QuesetFrame = UIs.Client.Quest:Clone()
            --Settings Quest Ui

            for Index, Task in QuestData.Tasks do
                local TaskFrame = UIs.Client.Task:Clone()
                --settings Quest UI
            end
        end

        for index, value in QuestData.Tasks do
            local TaskFrame = QuesetFrame.Tasks:FindFirstChild(index)
            if TaskFrame then
                --[[TaskFrame.Bar.Amount.Text = string.format("%s / %s", Utils:CommaNumber(math.round(PlayerData.Quests[NPC].Tasks[Index]) or 0), Utils:CommaNumber(math.round(Task.Amount)))
				TaskFrame.Bar.Amount.Amount.Text = TaskFrame.Bar.Amount.Text
				TweenService:Create(TaskFrame.Bar.Fill, TweenInfo.new(0.2), {
					Size = UDim2.fromScale(PlayerData.Quests[NPC].Tasks[Index] / Task.Amount, 1)
				}):Play()]]
            end
        end
    end
    QusetFrame()

end

function GetQuestType(NPC : string)
    local NPCData = Data:GetClient(Player)

    if not NPCData.Quests[NPC].Claimed then
        return "Start"
    elseif NPCData.Quests[NPC].Claimed and not NPCData.Quests[NPC].Completed then
        return "During"
    else
        return "Finish"
    end
end

function FinishQuest(NPC : string, TypeFunc : string)
    TweenModule:UseCloseCamera(Camera,OldPosCamera)
    TweenModule:UseGui(QuestUI,UDim2.new(0.324, 0,2, 0))
    Controls:Enable()
    Camera.CameraType = Enum.CameraType.Custom
    if TypeFunc == "Skip" then
        -- + Remote QuestServer
    elseif TypeFunc == "Cancel" then
    
    elseif TypeFunc == "" then
        Remote.ClaimQuest:FireServer(NPC)
    end
end


function GetGuiFrame(NPCName : string, NPCData : table, DialogueTable : table)
    local Icon : ImageLabel = QuestUI.Icon
    local ButtonQuset : GuiButton = QuestUI.QuestNumber
    local ButtonSkip : GuiButton = QuestUI.Skip
    local ButtonCancel : GuiButton = QuestUI.Cancel
    local NameNPC : TextLabel = QuestUI.NameNPC

    --// Button
    local SkipConnect : GuiButton? = nil
    local CancelConnect : GuiButton? = nil
    local ClickConnect : GuiButton? = nil
    local Index = 1
    Icon.Icon1.ImageLabel.Image = QuestModule.GetNPCIcon(NPCName)
    ButtonQuset.Text = `Quest: {NPCData.Quests[NPCName].Quest}`
    NameNPC.Text = `{NPCName}`


    SkipConnect = ButtonSkip.MouseButton1Click:Connect(function()
        SkipConnect:Disconnect()
        if ClickConnect then
            ClickConnect:Disconnect()
            FinishQuest(NPCName,"Skip")
            NPCData.Quests[NPCName].Talking = false
        end
    end)

    CancelConnect = ButtonCancel.MouseButton1Click:Connect(function()
        SkipConnect:Disconnect()
        if ClickConnect then
            ClickConnect:Disconnect()
            FinishQuest(NPCName,"Cancel")
            NPCData.Quests[NPCName].Talking = false
        end
    end)

    Utils:AnimateText(QuestUI,DialogueTable[1])
    ClickConnect = game.UserInputService.InputBegan:Connect(function(Input, gpe)
        if not gpe and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            if QuestUI.TextLabel.MaxVisibleGraphemes == -1 then
                Index = Index + 1
                if not DialogueTable[Index] then
                    ClickConnect:Disconnect()
                    FinishQuest(NPCName, "")
                    if SkipConnect then
                        SkipConnect:Disconnect()
                    elseif CancelConnect then
                        CancelConnect:Disconnect()
                    end
                else
                    Utils:AnimateText(QuestUI,DialogueTable[Index])
                end
            end
        end
    end)

end

function QuestModule:StartModule(ScriptButton : Part?)
    local NPCData : table = Data:GetClient(Player)
    local NPCName : string = ScriptButton:GetAttribute('NPCName')
    local QuestData = FolderNPCDiologs[NPCName]:FindFirstChild(NPCData.Quests[NPCName].Quest)
    if QuestData then
        QuestData = require(QuestData)
    end
    local Dialogue = {}
    if not QuestData then
        Dialogue = {"I don't have more quests right now!", "Return latter to claim quest"}
    else

        Dialogue = QuestData.Dialogues[GetQuestType(NPCName)]
    end
    local function CameraStart()
        if not NPCData.Quests[NPCName].Talking then
            NPCData.Quests[NPCName].Talking = true

            local CameraNPC : Camera = CameraFolder[NPCName]
            OldPosCamera = Camera.CFrame
            Camera.CameraType = Enum.CameraType.Scriptable
            GetGuiFrame(NPCName, NPCData, Dialogue)
            TweenModule:UseCamera(Camera,CameraNPC) -- CameraStart, CameraFinish
            Controls:Disable()
            TweenModule:UseGui(QuestUI,UDim2.new(0.324, 0,0.769, 0))
        end
    end
    CameraStart()
end


return QuestModule