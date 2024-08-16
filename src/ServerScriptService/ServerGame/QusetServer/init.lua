local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local QusetFolder = game.ReplicatedStorage.QuestDiologs
-- libary
local Data : ModuleScript = require(script.Parent.UserPlayerData)

local QuestServer = {}

function QuestServer:CompleteQuset(Player : Player, Type : string, Progress: table)
    local PData : table = Data:Get(Player)

    for NPC, NPCDATA in PData.Quests do
        if NPCDATA.Claimed and not NPCDATA.Completed then
            local Completed : number = 0
            local QusetInfo : ModuleScript = require(QusetFolder[NPC][NPCDATA.Quest])
            for index, Task in NPCDATA.Tasks do
                local TaskInfo : table = QusetInfo.Tasks[index]

                if (TaskInfo == nil) then
                    warn("TaskInfo is nil! Plese report this to developers")
                    continue;
                end

                if TaskInfo.Type == Type then
                    if Type == "CollectPollen" then
                        if not TaskInfo.Color and not TaskInfo.Field then
                            NPCDATA.Tasks[index] += (Progress.White + Progress.Red + Progress.Blue)
                        elseif TaskInfo.Color and not TaskInfo.Field then
                            NPCDATA.Tasks[index] += (Progress[TaskInfo.Color] or 0)
                        elseif not TaskInfo.Color and TaskInfo.Field then
                            NPCDATA.Tasks[index] += (Progress.Field == TaskInfo.Field and (Progress.White + Progress.Red + Progress.Blue) or 0)
                        elseif TaskInfo.Color and TaskInfo.Fieldthen then
                            NPCDATA.Tasks[index] += (Progress.Field == TaskInfo.Field and Progress[TaskInfo.Color] or 0)
                        end
                    elseif Type == "ConvertPollen" then
                        NPCDATA.Tasks[index] += Progress.Amount
                    elseif Type == "CollectToken" then
                        if TaskInfo.Token then
                            NPC.Tasks[index] += (Progress.Item == TaskInfo.Item and (Progress.Amount or 1) or 0)
                        else
                            NPCDATA.Tasks[index] += Progress.Amount or 0
                        end
                    elseif Type == "UseItem" then
                        if TaskInfo.Item then
                            NPCDATA.Tasks[index] += (Progress.Item == TaskInfo.Item and (Progress.Amount or 1) or 0)
                        else
                            NPCDATA.Tasks[index] += Progress.Amount or 0
                        end
                    elseif Type == "BuyItem" then
                        if TaskInfo.BuyItem then
                            NPCDATA.Tasks[index] += (Progress.BuyItem == TaskInfo.BuyItem and (Progress.Amount or 1) or 0)
                        else
                            NPCDATA.Tasks[index] += Progress.Amount or 0
                        end
                    elseif Type == "DefeatItem" then
                        if TaskInfo.DefeatItem then
                            NPCDATA.Tasks[index] += (Progress.DefeatItem == TaskInfo.DefeatItem and (Progress.Amount or 1) or 0)
                        else
                            NPCDATA.Tasks[index] += Progress.Amount or 0
                        end
                    elseif Type == "CompleteItem" then
                        if TaskInfo.CompleteItem then
                            NPCDATA.Tasks[index] += (Progress.CompleteItem == TaskInfo.CompleteItem and (Progress.Amount or 1) or 0)
                        else
                            NPCDATA.Tasks[index] += Progress.Amount or 0
                        end
                    elseif Type == "FindItem" then
                        if TaskInfo.FindItem then
                            NPCDATA.Tasks[index] += (Progress.FindItem == TaskInfo.FindItem and (Progress.Amount or 1) or 0)
                        else
                            NPCDATA.Tasks[index] += Progress.Amount or 0
                        end
                    elseif Type == "ObtainItem" then
                        if TaskInfo.ObtainItem then
                            NPCDATA.Tasks[index] += (Progress.ObtainItem == TaskInfo.ObtainItem and (Progress.Amount or 1) or 0)
                        else
                            NPCDATA.Tasks[index] += Progress.Amount or 0
                        end
                    elseif Type == "WaitTimer" then
                        NPCDATA.Tasks[index] += Progress.Amount or 0
                    end
                end

                if NPCDATA.Tasks[index] > TaskInfo.Amount then
                    NPCDATA.Tasks[index] = TaskInfo.Amount
                end
            end

            for index, Task in NPCDATA.Tasks do
                local TaskInfo = QusetInfo.Tasks[index]
                if Task == TaskInfo.Amount then
                    Completed += 1
                end

                if Completed == #NPCDATA.Tasks then
                    NPCDATA.Completed = true
                end

                --remote DataUpdate
            end
        end
    end
end

function ClaimQuset(Player : Player, QuestGiver: string)
    local PData : table = Data:Get(Player)
    local NPCFolder : Folder = QusetFolder:FindFirstChild(QuestGiver)
    if not NPCFolder then return end
    if not PData.Quests[QuestGiver].Claimed and not PData.Quests[QuestGiver].Completed then
        local QusetData : ModuleScript = NPCFolder:FindFirstChild(PData.Quests[QuestGiver].Quest)
        print(QusetData)
        if not QusetData then
            return warn("All quests completed!")
        end

        QusetData = require(QusetData)
        for index, value in QusetData.Tasks do
            PData.Quests[QuestGiver].Tasks[index] = 0
        end

        PData.Quests[QuestGiver].Claimed = true
        print(PData.Quests)
        --remote Update
    elseif PData.Quests[QuestGiver].Claimed and PData.Quests[QuestGiver].Completed then
        local QusetData : ModuleScript = require(QusetFolder[PData.Quests[QuestGiver].Quest])


        for _, Reward in QusetData.Rewards do
            print(Reward)
            if Reward.Type == "Item" then
                
            elseif Reward.Type == "Currency" then

            end
        end

        local PDataQuest : table = PData.Quests[QuestGiver]
        PDataQuest.Claimed = false
        PDataQuest.Completed = false
        PDataQuest.Tasks = {}
        PDataQuest.Quest += 1
        --PData.Bages.Quset.Amount += 1 
        --Remote DataUpdate
    end
end

Remotes.ClaimQuest.OnServerEvent:Connect(ClaimQuset)

return QuestServer