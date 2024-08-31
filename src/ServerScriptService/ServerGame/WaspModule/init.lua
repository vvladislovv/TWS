local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local FolderWasp : Folder = workspace.GameSettings.Wasps
local WaspModule1 : ModuleScript? = ReplicatedStorage.Wasps
local PosStart : boolean = true
local RunService = game:GetService("RunService")
local TweenService = game:GetService('TweenService')
--// Libary
local PosBooleChr : boolean = false
local PosBooleNow : boolean  = false
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local WaspModule = {}
WaspModule.__index = WaspModule


function WaspModule:LookVectorCharacter(Settings : table)
    local Character = Settings.Character
    local PartRandome : BasePart = Settings.Model:FindFirstChild('PartRandome')

    task.spawn(function()
        while true do task.wait()
            if Settings.LookVector then
                if PartRandome ~= nil then
                    PartRandome.CFrame = CFrame.new(PartRandome.Position, PartRandome.Position + Character.HumanoidRootPart.CFrame.LookVector) * CFrame.Angles(0,math.rad(-90),0) 
                end
            end
        end
    end)

end

function WaspModule.NewWasp(PData : table, PosSlot : Vector3?, WaspModel : ModuleScript,CheckSlot : number) -- до писать скрипт сделать так чтобы позиция была при вылета как у кублиона
    local self = setmetatable({}, WaspModule)
    self.PlayerData = PData;
    self.WaspSettings = require(WaspModel)
    self.FlyPos = Vector3.new(math.random(-10, 10), 1, math.random(-10, 10))
    self.SlotPos = PosSlot
    self.WaspData = PData.Wasps[CheckSlot]
    self.Model = WaspModel.Model
    self.SpeedWasp = self.WaspData.Speed
    WaspModel.Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z) * CFrame.Angles(0,math.rad(180),0))
    
    --// Settings engine
    local AlignPosition : AlignPosition = WaspModel.Model.Primary:FindFirstChild('AlignPosition')
    AlignPosition.MaxVelocity = self.WaspData.Speed
    AlignPosition.Responsiveness = self.WaspData.Speed / 2

    if not WaspModule.SettingTable then
        WaspModule.SettingTable = {}
    end

    WaspModule.SettingTable[PData.Wasps[CheckSlot].Name] = self

    task.wait(0.5)
    --// Function One Start
    WaspModule:AIPos(PData.Wasps[CheckSlot])
    return self
end

function WaspModule:CollectPollen(TableWaspSettings : table) -- Проблема тут 
    local Deb : boolean = false
    local Character : CharacterAppearance = TableWaspSettings.Character
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = TableWaspSettings.Model:FindFirstChild('Primary')

    local NewPos : Vector3? 
    local FieldTable : table = workspace.GameSettings.Fields:FindFirstChild(TableWaspSettings.PlayerData.FakeSettings.OldField):GetChildren()
    local Flower : number = FieldTable[math.random(1, #FieldTable)]
    if not Deb then
        Deb = true
        TableWaspSettings.LookVector = false
        if (Character.PrimaryPart.Position -  Flower.Position).Magnitude <= 20 and TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then
            NewPos = Flower.Position + Vector3.new(0,2,0)
            PartRandome.CFrame *= CFrame.Angles(0,0,math.rad(1))
            PartRandome.CFrame = CFrame.lookAt(PartRandome.Position, NewPos) * CFrame.Angles(0,math.rad(-90),0)
            PartRandome.Position = NewPos
            if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then
                if PartRandome.Position == NewPos then
                    print('a')
                else
                    print('f')
                end
                PartRandome.CFrame *= CFrame.Angles(0,0,math.rad(40))
                task.wait(TableWaspSettings.WaspSettings.ConvertsTime)
                task.wait(0.35)
                PartRandome.CFrame = CFrame.Angles(0,0,0)
                Deb = false
            end
        end
    end
end

function WaspModule:ComeToMe(TableWaspSettings : table)-- вылет с улья и подлет к персонажу
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local NewPos : Vector3? = TableWaspSettings.Character.HumanoidRootPart.Position + Vector3.new(math.random(-5,5), math.random(-0.5,1), math.random(-5,5))
    PartRandome.CFrame = CFrame.lookAt(PartRandome.Position, NewPos) * CFrame.Angles(0,math.rad(-90),0)
    PartRandome.Position = NewPos
    task.wait(1)
    TableWaspSettings.LookVector = true
    self:LookVectorCharacter(TableWaspSettings)
    PosBooleNow = true
    PosBooleChr = true
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
    local TableWaspSettings : table = settings.TypeTable
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    if settings ~= nil then task.wait()
        if settings.Type == ">" then -- если полный рюкзак 
            if PosBooleChr and PartRandome ~= nil then
                PosBooleChr = not PosBooleChr
                TableWaspSettings.LookVector = false

                NewPos = TableWaspSettings.Character.HumanoidRootPart.Position + TableWaspSettings.FlyPos
                PartRandome.CFrame = CFrame.lookAt(PartRandome.Position, NewPos) * CFrame.Angles(0,math.rad(-90),0)
                PartRandome.Position = NewPos
                task.wait(1.5)
                TableWaspSettings.LookVector = true
                PosBooleChr = true
            end
        elseif settings.Type == "<=" then -- если не полный рюкзак
            if PosBooleNow and PartRandome ~= nil then

                PosBooleNow = not PosBooleNow
                TableWaspSettings.LookVector = false
                NewPos = TableWaspSettings.Character.HumanoidRootPart.Position + Vector3.new(math.random(-8,8), math.random(-0.5,2), math.random(-8,8))
                PartRandome.CFrame = CFrame.lookAt(PartRandome.Position, NewPos) * CFrame.Angles(0,math.rad(-90),0)
                PartRandome.Position = NewPos

                task.spawn(function() task.wait(0.5)
                    TableWaspSettings.LookVector = true
                end)

                task.wait(3)
                PosBooleNow = true
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

function WaspModule:TokenSpawn(TableWaspSettings : table) --Check
    if TableWaspSettings.WaspSettings.Ability then
        if TableWaspSettings.Model then
            local TokenTable : table = require(ReplicatedStorage.Libary.TokensGame)
            local TokenType : table = TokenTable[math.random(1, #TableWaspSettings.WaspSettings.Ability)]
            local Deb : boolean = false
            if TokenType ~= nil and not Deb then
                Deb = true
                
                local FlowerRay : Ray = Ray.new(TableWaspSettings.Model:FindFirstChild('Primary').Position, Vector3.new(0,-8,0))
                local RayResult : RaycastResult = WaspModule:FindPartOnRayWithWhitelist(FlowerRay, {workspace.GameSettings.Fields})

                require(script.Parent.TokenModule):CreateToken({
                    Type = "Any",
                    Item = TokenType,
                    Model = nil,
                    Player = TableWaspSettings.Character,
                    Pos = RayResult.Position, -- + Vector3.new(0, 2.5, 0)
                    Amt = 1,
                    Resource = `from {TableWaspSettings.PlayerData.FakeSettings.OldField} Field`
                })
                task.wait(0.3)
                Deb = false
            end
        end
    end
end

function WaspModule:AIPos(NameWasp : string) -- переписать движения чтобы была загрузка другая
    task.spawn(function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            local character = player.Character or player.CharacterAdded:Wait()
            self.SettingTable[NameWasp.Name].Character = character
            self.SettingTable[NameWasp.Name].Model.Primary:SetNetworkOwner(player)
            self.SettingTable[NameWasp.Name].LookVector = false
            continue
        end
        
        local TableWaspSettings : table = self.SettingTable[NameWasp.Name]
        self:ComeToMe(TableWaspSettings)
        Remotes.ClientWasp:FireAllClients(TableWaspSettings)

        while true do task.wait()
            if TableWaspSettings.Character and TableWaspSettings.Model then
                if TableWaspSettings.WaspData.Energy <= 0 then -- Function Sleeps
                    self:Sleep(TableWaspSettings)
                elseif TableWaspSettings.WaspData.Energy > 0 then
                        if TableWaspSettings.PlayerData.FakeSettings.Attack then
                            self:AttackMobs();
                        else
                            if not TableWaspSettings.PlayerData.FakeSettings.Making then
                                if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" and TableWaspSettings.PlayerData.IStats.Pollen < TableWaspSettings.PlayerData.IStats.Capacity then
                                    self:CollectPollen(TableWaspSettings)
                                elseif TableWaspSettings.PlayerData.FakeSettings.Field == "" or TableWaspSettings.PlayerData.IStats.Pollen >= TableWaspSettings.PlayerData.IStats.Capacity then
                                    if TableWaspSettings.Character.Humanoid.MoveDirection.Magnitude > 0 then
                                        self:AIPosRandom({
                                            Type = ">", TypeTable = TableWaspSettings
                                        });
                                    elseif TableWaspSettings.Character.Humanoid.MoveDirection.Magnitude <= 0 then
                                        self:AIPosRandom({
                                            Type = "<=", TypeTable = TableWaspSettings
                                        });
                                    end
                                    
                                end

                            else
                                self:MakeHoney();
                            end
                        end
                    end
                end
            end
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