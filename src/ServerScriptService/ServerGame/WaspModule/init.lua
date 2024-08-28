local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local FolderWasp : Folder = workspace.GameSettings.Wasps
local WaspModule : ModuleScript? = ReplicatedStorage.Wasps
local Side : boolean = false
local RunService = game:GetService("RunService")
local TweenService = game:GetService('TweenService')
--// Libary
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local ComeMe : boolean?
local SleepWasp : boolean? = false
local WaspModule = {}
WaspModule.__index = WaspModule


function WaspModule.NewWasp(PData : table,PosSlot : Vector3?, WaspModel : ModuleScript,CheckSlot : number)
    local self = setmetatable({}, WaspModule)
    self.PlayerData = PData;
    self.WaspSettings = require(WaspModel)
    self.FlyPos = Vector3.new(math.random(-10, 10), 1, math.random(-10, 10))
    self.SlotPos = PosSlot
    self.WaspData = PData.Wasps[CheckSlot]
    self.Model = WaspModel.Model

    WaspModel.Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z) * CFrame.Angles(0,90,0)) 
    TweenModule:CreateWaspHive(WaspModel.Model,PosSlot)

    if not WaspModule.SettingTable then
        WaspModule.SettingTable = {}
    end

    WaspModule.SettingTable[PData.Wasps[CheckSlot].Name] = self

    --// Function One Start
    WaspModule:AIPos(PData.Wasps[CheckSlot])
    return self
end

function WaspModule:Animate() -- сделать анимацию, пока что лагано 
    local Model = self.Model -- поменять
    local Primary : BasePart = Model:FindFirstChild('Primary')

    task.spawn(function()
        while true do task.wait()
            if not Side then
                for i = -0, -5, -1 do
                    Primary.CFrame *= CFrame.Angles(math.rad(i),0,0)
                    task.wait(0.01)
                end
                Side = true
            elseif Side then
                for i = 0, 5, 1 do
                    Primary.CFrame *= CFrame.Angles(math.rad(i),0,0)
                    task.wait(0.01)
                end
                Side = false
            end
        end
    end)

end

function WaspModule:ComeToMe()-- вылет с улья и подлет к персонажу
    print('ComeToMe')
    return true
end

function WaspModule:Sleep(TableWaspSettings) -- Sleep Wasp
    task.wait(2)
    local Primary : BasePart = TableWaspSettings.Model:FindFirstChild('Primary')
    local AlignOrientation : AlignOrientation = Primary:FindFirstChild('AlignOrientation')
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local PosSlotWasp = TableWaspSettings.SlotPos
    if TableWaspSettings.WaspData.Energy <= 0 and not SleepWasp then -- подумать как сделать чтобы оно поварачивалось правильно
        print('f')
        for i = -0, -60, -30 do task.wait(0.1)
            print(i)
            TableWaspSettings.Model:PivotTo(TableWaspSettings.Model:GetPivot() * CFrame.Angles(0,0,math.rad(i)))
        end
        SleepWasp = true
    end
end

function WaspModule:AIPosRandom(settings : table) -- рандомная позиция осе
    print('AIPosRandom')
    if settings ~= nil then
        if settings.Type == "<" then -- если полный рюкзак 

        elseif settings.Type == ">=" then -- если не полный рюкзак

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
    coroutine.wrap(function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            local character = player.Character or player.CharacterAdded:Wait()
            self.SettingTable[NameWasp.Name].Character = character
            continue
        end
        
        local TableWaspSettings : table = self.SettingTable[NameWasp.Name]

        while true do task.wait()
            if TableWaspSettings.Character and TableWaspSettings.Model then
                    if TableWaspSettings.WaspData.Energy <= 0 then
                        self:Sleep(TableWaspSettings)
                    elseif TableWaspSettings.WaspData.Energy > 0 then
                        ComeMe = self:ComeToMe()

                        if ComeMe then
                            if TableWaspSettings.PlayerData.FakeSettings.Attack then
                                self:AttackMobs();
                            else
                                if not TableWaspSettings.PlayerData.FakeSettings.Making then

                                    if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" and TableWaspSettings.PlayerData.IStats.Pollen < TableWaspSettings.PlayerData.IStats.Capacity then
                                        WaspModule:AIPosRandom({
                                            Type = "<"
                                        });
                                    elseif TableWaspSettings.PlayerData.FakeSettings.Field == "" or TableWaspSettings.PlayerData.IStats.Pollen >= TableWaspSettings.PlayerData.IStats.Capacity then
                                        WaspModule:AIPosRandom({
                                            Type = ">="
                                        });
                                    end

                                else
                                    self:MakeHoney();
                                end
                            end
                        else
                            repeat return until ComeMe == true
                        end
                    end
                end
            end
        end)()


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