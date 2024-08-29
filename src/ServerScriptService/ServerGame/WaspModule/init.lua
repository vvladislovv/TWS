local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local FolderWasp : Folder = workspace.GameSettings.Wasps
local WaspModule : ModuleScript? = ReplicatedStorage.Wasps
local PosStart : boolean = true
local RunService = game:GetService("RunService")
local TweenService = game:GetService('TweenService')
--// Libary
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local ComeMe : boolean?
local WaspModule = {}
WaspModule.__index = WaspModule


function WaspModule.NewWasp(PData : table, PosSlot : Vector3?, WaspModel : ModuleScript,CheckSlot : number) -- до писать скрипт сделать так чтобы позиция была при вылета как у кублиона
    local self = setmetatable({}, WaspModule)
    self.PlayerData = PData;
    self.WaspSettings = require(WaspModel)
    self.FlyPos = Vector3.new(math.random(-10, 10), 1, math.random(-10, 10))
    self.SlotPos = PosSlot
    self.WaspData = PData.Wasps[CheckSlot]
    self.Model = WaspModel.Model
    WaspModel.Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z))

    TweenModule:CreateWaspHive(WaspModel.Model,PosSlot)

    if not WaspModule.SettingTable then
        WaspModule.SettingTable = {}
    end

    WaspModule.SettingTable[PData.Wasps[CheckSlot].Name] = self

    task.wait(0.5)
    --// Function One Start
   -- WaspModule:AIPos(PData.Wasps[CheckSlot])
    return self
end

function WaspModule:CollectPollen()
    
end

function WaspModule:ComeToMe(TableWaspSettings : table)-- вылет с улья и подлет к персонажу
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local NewPos : Vector3? = TableWaspSettings.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10), math.random(-0.5,1), math.random(-10,10))
    PartRandome.Position = NewPos
    --TweenModule:WaspPosition(Primary, NewPos)
    
    return true
end

function WaspModule:Sleep(TableWaspSettings : table) -- Sleep Wasp
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    if TableWaspSettings.WaspData.Energy <= 0  then -- подумать как сделать чтобы оно поварачивалось правильно

        PartRandome.CFrame *= CFrame.Angles(0,math.rad(60),0)
        PartRandome.CFrame *= CFrame.Angles(0,0,math.rad(-90))

    local TimeSleep : number = math.round(TableWaspSettings.WaspData.ELimit / 2) -- Какое ожидание будет 
    
    task.wait(TimeSleep) -- время сна
    TableWaspSettings.WaspData.Energy = TableWaspSettings.WaspData.ELimit
    print("sleep stop")
    end
end

function WaspModule:AIPosRandom(settings : table) -- рандомная позиция осе
    local NewPos : Vector3? 
    local BoalNewPos : boolean = false
    local TableWaspSettings : table = settings.TypeTable

    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = TableWaspSettings.Model:FindFirstChild('Primary')
    if settings ~= nil then task.wait()
        if settings.Type == ">" then -- если полный рюкзак 
        --print('a')
        elseif settings.Type == "<=" then -- если не полный рюкзак
            if not BoalNewPos then
                print('f')
                BoalNewPos = true
              --  NewPos = TableWaspSettings.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10), math.random(-1,2), math.random(-10,10))
              --  PartRandome.Position = NewPos

                --PartRandome.CFrame *= CFrame.new(NewPos,Primary.Position) * CFrame.Angles(0, math.rad(90),0)
                task.wait(6)
                BoalNewPos = false
            end
        end
    end
end

function WaspModule:MakeHoney() -- Cбор меба на поле
    print('MakeHoney')
end

function WaspModule:AttackMobs() -- Аттака моба осой
    print('AttackMobs')
end

function WaspModule:AIPos(NameWasp : string) -- переписать движения чтобы была загрузка другая
    task.spawn(function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            local character = player.Character or player.CharacterAdded:Wait()
            self.SettingTable[NameWasp.Name].Character = character
            self.SettingTable[NameWasp.Name].Model.Primary:SetNetworkOwner(player)
            continue
        end
        
        local TableWaspSettings : table = self.SettingTable[NameWasp.Name]
        self:ComeToMe(TableWaspSettings)
        Remotes.ClientWasp:FireAllClients(TableWaspSettings)

            --[[while true do task.wait()
            if TableWaspSettings.Character and TableWaspSettings.Model then
                if TableWaspSettings.WaspData.Energy <= 0 then
                    self:Sleep(TableWaspSettings)
                elseif TableWaspSettings.WaspData.Energy > 0 then
               -- print(ComeMe)
                    if ComeMe ~= nil then
                        if TableWaspSettings.PlayerData.FakeSettings.Attack then
                            self:AttackMobs();
                        else
                            if not TableWaspSettings.PlayerData.FakeSettings.Making then

                                if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" and TableWaspSettings.PlayerData.IStats.Pollen < TableWaspSettings.PlayerData.IStats.Capacity then
                                    self:CollectPollen()
                                elseif TableWaspSettings.PlayerData.FakeSettings.Field == "" or TableWaspSettings.PlayerData.IStats.Pollen >= TableWaspSettings.PlayerData.IStats.Capacity then
                                    if TableWaspSettings.Character.Humanoid.MoveDirection.Magnitude > 0 then
                                       -- self:AIPosRandom({
                                     ---       Type = ">", TypeTable = TableWaspSettings
                                      --  });
                                    elseif TableWaspSettings.Character.Humanoid.MoveDirection.Magnitude <= 0 then
                                      --  self:AIPosRandom({
                                      --      Type = "<=", TypeTable = TableWaspSettings
                                      --  });
                                    end
                                    
                                end

                            else
                                self:MakeHoney();
                            end
                        end
                    else
                        ComeMe = self:ComeToMe(TableWaspSettings)
                    end
                end
            end
        end]]
        end)


    --[[task.spawn(function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            local character = player.Character or player.CharacterAdded:Wait()
            self.Character = character

            TweenModule:WaspPosition(PosRandome, character.HumanoidRootPart.Position + Vector3.new(math.random(-6,6), math.random(-0.1,1), math.random(-6,6)))
            task.wait(1)

            while true do task.wait()
                if self.WaspData.Energy <= 0 then
                    self:Sleep()
                    break
                elseif self.WaspData.Energy > 0 then 
                    print(self.WaspData.Energy)
                    if self.PlayerData.FakeSettings.Attack then
                        --self:Attack(self.Player)
                    else
                        if not self.PlayerData.FakeSettings.Making then
                            if self.PlayerData.FakeSettings.Field ~= "" and self.PlayerData.IStats.Pollen < self.PlayerData.IStats.Capacity then
                                --self:CollectPollen()
                            elseif self.PlayerData.FakeSettings.Field == "" or self.PlayerData.IStats.Pollen >= self.PlayerData.IStats.Capacity then
                                local NewPos : Vector3?

                                if character.Humanoid.MoveDirection.Magnitude > 0 then

                                    NewPos = character.HumanoidRootPart.Position + self.FlyPos
                                    self.NewPos = NewPos
                                    TweenModule:WaspPosition(PosRandome, NewPos)
                                    TweenModule:WaspOrintation(PosRandome,CFrame.new(Primary.Position, NewPos) * CFrame.Angles(0, math.rad(-90), 0))
                                    task.wait(2)

                                elseif character.Humanoid.MoveDirection.Magnitude <= 0 then
                                    NewPos = character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10), math.random(-0.5,1.5), math.random(-19,10))
                                    self.NewPos = NewPos
                                    
                                    TweenModule:WaspPosition(PosRandome, NewPos)
                                    TweenModule:WaspOrintation(PosRandome,CFrame.new(Primary.Position, NewPos) * CFrame.Angles(0, math.rad(-90), 0))
                                    task.wait(2.5)
                                    if (Primary.Position - PosRandome.Position).Magnitude <= 1 and character.Humanoid.Health > 0 then
                                        TweenModule:WaspOrintation(PosRandome, CFrame.new(Primary.Position, NewPos) * CFrame.Angles(0, math.rad(-90), 0))                                
                                    end 
                                end
                            end
                        else
                            -- Self:MakeHoney()
                        end
                    end
                end
            end
        end
    end)]]
    
end

return WaspModule