local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local FolderWasp : Folder = workspace.GameSettings.Wasps
local WaspModule1 : ModuleScript? = ReplicatedStorage.Wasps
local RunService = game:GetService("RunService")
local StartSystems : boolean = true
local PosBooleChr : boolean = false
local PosBooleNow : boolean  = false
local DebWhile : boolean? = false
--// Libary
local FlowerCollect : ModuleScript = require(script.Parent.FlowerServerCollect)
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local WaspModule = {}
WaspModule.__index = WaspModule

WaspModule.GetDist = function(Character : Player, Flower : BasePart)
    if Character ~= nil and Flower ~= nil then
        if (Character.PrimaryPart.Position -  Flower.Position).Magnitude <= 20 then
            return true
        else
            return false
        end        
    end
end

WaspModule.GetDisHumanoid = function(Character : Player,Part : BasePart, PData : table)
    if Character and Part then
        repeat task.wait()
            if PData.FakeSettings.Making == false then
                break 
            end
        until (Character.PrimaryPart.Position -  Part.Position).Magnitude <= 10 
    else
        return false
    end
end

WaspModule.WaitInField = function(PartRandome : BasePart, Primary : BasePart, PData : table)
    if PartRandome and Primary then
        repeat task.wait()
            if PData.FakeSettings.Field =="" then
                break 
            end            
        until (PartRandome.Position - Primary.Position).Magnitude <= 0.5
    else
        return false
    end
end

WaspModule.WaitInHive = function(PartRandome : Model?, Primary: Model?, PData : table)
    if PartRandome and Primary then
        repeat task.wait()
            if PData.FakeSettings.Making == false and not Character:FindFirstChild('HumanoidRootPart') then
                break 
            end
        until (Primary.Position - PartRandome.Position).Magnitude <= 5
    else
        return false
    end
end

WaspModule.Rotation = function(WaspModel : Model, PData : table)

    local rotationSpeed = 1-- угол в градусах на кадр
    local totalAngle = 360 -- общее количество градусов поворота
    local elapsedTime = 0

    if WaspModel then
        while elapsedTime < totalAngle and PData.FakeSettings.Making do
            local deltaTime = RunService.Heartbeat:Wait() -- Ждем до следующего кадра
            elapsedTime = elapsedTime + rotationSpeed * (deltaTime * 120) -- Увеличиваем угол с учетом времени
            WaspModel.CFrame *= CFrame.Angles(0, math.rad(rotationSpeed), 0)
        end
    end
end

function WaspModule:LookVectorCharacter(Settings : table)
    local Character = Settings.Character
    local PartRandome : BasePart = Settings.Model:FindFirstChild('PartRandome')

    task.spawn(function()
        while true do task.wait()
            if Settings.LookVector then
                if PartRandome ~= nil and Character:FindFirstChild('HumanoidRootPart') then
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
    
	--* Wasp model Settings
	local GetWaspModel : Model = WaspModel.Model
	GetWaspModel.Tors.FacePart.Face.ImageLabel.Image = self.WaspSettings.Icon
	GetWaspModel.Tors.Level.TextLabel.Text = self.WaspData.Level
	GetWaspModel.Tors.NameWasp.TextLabel.Text = self.WaspData.Name
    --// Settings engine
    local AlignPosition : AlignPosition = WaspModel.Model.Primary:FindFirstChild('AlignPosition')
    AlignPosition.MaxVelocity = self.WaspData.Speed
    AlignPosition.Responsiveness = self.WaspData.Speed / 2

	local WaspMove : Animation = ReplicatedStorage.Assert.MoveWasp
	local Anim : Animation = WaspModel.Model:FindFirstChild('Humanoid'):LoadAnimation(WaspMove)

	if not Anim.IsPlaying then
		Anim:Play()
	end

    if not WaspModule.SettingTable then
        WaspModule.SettingTable = {}
    end

    WaspModule.SettingTable[PData.Wasps[CheckSlot].Name] = self

    task.wait(0.5)
    --// Function One Start
    WaspModule:AIPos(PData.Wasps[CheckSlot])
    return self
end

function WaspModule:CollectPollen(TableWaspSettings : table) -- дописать токены + исправить баг и написать по нормальному
    local Deb : boolean = false
    local FieldWasp : boolean = true
    local Character : CharacterAppearance = TableWaspSettings.Character
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = TableWaspSettings.Model:FindFirstChild('Primary')

    local NewPos : Vector3?
    local FieldTable : table = workspace.GameSettings.Fields:FindFirstChild(TableWaspSettings.PlayerData.FakeSettings.OldField):GetChildren()
    local Flower : number = FieldTable[math.random(1, #FieldTable)]


    if not Deb then
        Deb = true
        TableWaspSettings.LookVector = false
        if WaspModule.GetDist(Character, Flower) and TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then
            NewPos = Flower.Position + Vector3.new(0,2,0)
            PartRandome.CFrame = CFrame.new(PartRandome.Position, NewPos) * CFrame.Angles(0,math.rad(-90),0)
            PartRandome.Position = NewPos
            WaspModule.WaitInField(PartRandome,Primary,TableWaspSettings.PlayerData)
            if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then

                while FieldWasp do task.wait()
                    if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then
                        PartRandome.CFrame *= CFrame.Angles(0,0,math.rad(40))
                        task.wait(TableWaspSettings.WaspSettings.ConvertsTime)
                        break
                    else
                        PartRandome.CFrame *= CFrame.Angles(0,0,-math.rad(40))
                        task.wait(TableWaspSettings.WaspSettings.ConvertsTime)
                        break
                    end
                end

                FieldWasp = false
                FlowerCollect:ConnectWasp(TableWaspSettings.Player,Flower, {TSS = TableWaspSettings.WaspSettings})
                if TableWaspSettings.WaspSettings.Ability ~= {} and math.random(1,10) <= 10 and TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then -- 100
                    PartRandome.CFrame *= CFrame.Angles(0,0,-math.rad(40)) -- это было в функции  WaspModule.Rotation
                    WaspModule.Rotation(PartRandome, TableWaspSettings.PlayerData)
                    if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then
                        self:TokenSpawn(TableWaspSettings)
                    end
                end
            end
            TableWaspSettings.WaspData.Energy -= 1
       end
    end
end

function WaspModule:ComeToMe(TableWaspSettings : table)-- вылет с улья и подлет к персонажу
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local NewPos : Vector3? = TableWaspSettings.Character.HumanoidRootPart.Position + Vector3.new(math.random(-5,5), math.random(-0.5,1), math.random(-5,5))
    PartRandome.CFrame = CFrame.lookAt(PartRandome.Position, NewPos) --* CFrame.Angles(0,math.rad(-90),0)
    PartRandome.Position = NewPos
    task.wait(1)
    TableWaspSettings.LookVector = true
    self:LookVectorCharacter(TableWaspSettings)
    PosBooleNow = true
    PosBooleChr = true
end

function WaspModule:Sleep(TableWaspSettings : table) -- Sleep Wasp
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = TableWaspSettings.Model:FindFirstChild('Primary')
    PartRandome.Position = TableWaspSettings.SlotPos.WorldCFrame.Position
    PartRandome.CFrame = CFrame.lookAt(PartRandome.Position, Primary.Position) * CFrame.Angles(0,math.rad(90),0)
    if TableWaspSettings.WaspData.Energy <= 0 and WaspModule.GetDist(TableWaspSettings.Model, PartRandome) then -- подумать как сделать чтобы оно поварачивалось правильно
        PartRandome.CFrame *= CFrame.Angles(0,math.rad(90),0)
        PartRandome.CFrame *= CFrame.Angles(0,0,math.rad(-90))

        local TimeSleep : number = math.round(TableWaspSettings.WaspData.ELimit / 2) -- Какое ожидание будет 
    
        task.wait(TimeSleep) -- время сна
        TableWaspSettings.WaspData.Energy = TableWaspSettings.WaspData.ELimit
        --print("sleep stop")
    end
end

function WaspModule:SleepDiedPlayer(value,PData)
	for i, v in next, PData.Wasps do
		DebWhile = false;
		PData.FakeSettings.Making = false;
		self.SettingTable[v.Name].LookVector = false;
		v.Energy = 0
		WaspModule:Sleep(self.SettingTable[v.Name])
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

function WaspModule:MakeHoney(TableWaspSettings : table) -- БАГ в том что иногда багаеться 
    local Conversion : number?
    local NewPos : Vector3? = TableWaspSettings.Character.HumanoidRootPart.Position + Vector3.new(math.random(-8,8), 0, math.random(-8,8))
    local Character : CharacterAppearance = TableWaspSettings.Character
    local PartRandome : BasePart = TableWaspSettings.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = TableWaspSettings.Model:FindFirstChild('Primary')
    local PData : table = TableWaspSettings.PlayerData

    if PData.BoostGame.PlayerBoost["Total Converts"] < PData.IStats.Pollen and PData.FakeSettings.Making then
        Conversion = math.round(
            (TableWaspSettings.WaspSettings.Converts + PData.BoostGame.PlayerBoost["Convert Amount"]) 
            + ((TableWaspSettings.WaspSettings.Converts/4) * TableWaspSettings.WaspData.Level) 
            * (PData.BoostGame.PlayerBoost["Convert Rate"] / 25)
        )
    else
        Conversion = math.round(TableWaspSettings.PlayerData.IStats.Pollen)
    end

    task.spawn(function()
        while true do task.wait(0.5)
            for _, value in next, workspace.GameSettings.Button:GetChildren() do
                if value.Name == "Hive" then
                    if value:GetAttribute('HiveOwner') == TableWaspSettings.Player.Name then

						if TableWaspSettings.Character:FindFirstChild('Humanoid') then
							if (TableWaspSettings.Character.PrimaryPart.Position -  value.Position).Magnitude <= 10 then
								DebWhile = true;
							else
								--print(TableWaspSettings.PlayerData.FakeSettings.Making)
								TableWaspSettings.PlayerData.FakeSettings.Making = false;
							end
						end
                    end
                end
            end
        end
    end)
    if Conversion > 0 and PData.IStats.Pollen > 0 and PData.FakeSettings.Making and DebWhile then
        DebWhile = TableWaspSettings.PlayerData.FakeSettings.Making;
        PartRandome.CFrame = Character.HumanoidRootPart.CFrame 
        PartRandome.CFrame = CFrame.lookAt(PartRandome.Position, Primary.Position) * CFrame.Angles(0,math.rad(90),0)
        WaspModule.GetDisHumanoid(TableWaspSettings.Model, PartRandome, TableWaspSettings.PlayerData)
        TableWaspSettings.LookVector = false
        task.wait(1.5)
   -- WaspModule.WaitInField(PartRandome,Primary,TableWaspSettings.PlayerData)
        PartRandome.CFrame = CFrame.new(PartRandome.Position, TableWaspSettings.SlotPos.WorldCFrame.Position) * CFrame.Angles(0,-math.rad(90), 0)
        PartRandome.Position = TableWaspSettings.SlotPos.WorldCFrame.Position
        WaspModule.WaitInHive(PartRandome, TableWaspSettings.SlotPos.WorldCFrame, TableWaspSettings.PlayerData)
        task.wait(1.5)
        WaspModule.Rotation(PartRandome, PData)
        
        if PData.FakeSettings.Making and PData.IStats.Pollen >= 0 then
            PData.IStats.Pollen -= Conversion -- тут проблема
            PData.IStats.Honey += Conversion
            PData.IStats.DailyHoney += Conversion

            Remotes.VisualNumberEvent:FireClient(TableWaspSettings.Player,{Pos = Character, Amt = Conversion, Color = "Coin", Crit = false})
        elseif not PData.FakeSettings.Making then
            PData.FakeSettings.Making = false
            PartRandome.Position = NewPos
            TableWaspSettings.LookVector = true
        end 

    elseif Conversion < 0 and PData.IStats.Pollen <= 0 or not PData.FakeSettings.Making then
        PData.FakeSettings.Making = false
        PartRandome.Position = NewPos
        TableWaspSettings.LookVector = true
        PData.IStats.Pollen = 0
    end
    
end

function WaspModule:AccessoryWasp() -- Cбор меба на поле
    print('AccessoryWasp')
end

function WaspModule:AttackMobs() -- Аттака моба осой
    print('AttackMobs')
end

function WaspModule:TokenSpawn(TableWaspSettings : table) --Check
    if TableWaspSettings.WaspSettings.Ability then
        if TableWaspSettings.Model and TableWaspSettings.PlayerData.FakeSettings.Field ~= "" then
            local TokenTable : table = TableWaspSettings.WaspSettings.Ability
            local TokenType : table = TokenTable[math.random(1, #TableWaspSettings.WaspSettings.Ability)]
            local Deb : boolean = false

            if TokenType ~= nil and not Deb then
                Deb = true
                local FlowerRay : Ray = Ray.new(TableWaspSettings.Model:FindFirstChild('Primary').Position, Vector3.new(0,-8,0))
                local RayResult : RaycastResult = workspace:FindPartOnRayWithWhitelist(FlowerRay, {workspace.GameSettings.Fields})

                require(script.Parent.TokenModule):CreateToken({
                    Type = "Wasp",
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

function WaspModule:AIPos(NameWasp : string)
	self.SettingTable[NameWasp.Name].LookVector = false

    task.spawn(function()
        while true do task.wait()
			
			for _, player in pairs(game:GetService("Players"):GetPlayers()) do
				local character = player.Character or player.CharacterAdded:Wait()
				self.SettingTable[NameWasp.Name].Player = player
				self.SettingTable[NameWasp.Name].Character = character
				self.SettingTable[NameWasp.Name].Model.Primary:SetNetworkOwner(player)
				continue
			end

			local TableWaspSettings : table = self.SettingTable[NameWasp.Name]
            if TableWaspSettings.Character and TableWaspSettings.Model then
                if TableWaspSettings.WaspData.Energy <= 0 then -- Function Sleeps
                    self:Sleep(TableWaspSettings)
                elseif TableWaspSettings.WaspData.Energy > 0 then
                    if StartSystems then
                        StartSystems = false
                        self:ComeToMe(TableWaspSettings)
                        Remotes.ClientWasp:FireAllClients(TableWaspSettings)
                    end
                        if TableWaspSettings.PlayerData.FakeSettings.Attack then
                            self:AttackMobs();
                        else
                            if not TableWaspSettings.PlayerData.FakeSettings.Making then
                                if TableWaspSettings.PlayerData.FakeSettings.Field ~= "" and TableWaspSettings.PlayerData.IStats.Pollen < TableWaspSettings.PlayerData.IStats.Capacity then
                                    self:CollectPollen(TableWaspSettings)
                                elseif TableWaspSettings.PlayerData.FakeSettings.Field == "" or TableWaspSettings.PlayerData.IStats.Pollen >= TableWaspSettings.PlayerData.IStats.Capacity then
									if TableWaspSettings.Character:FindFirstChild('Humanoid') then
										if TableWaspSettings.Character:FindFirstChild('Humanoid').MoveDirection.Magnitude > 0 then -- !Error
											self:AIPosRandom({
												Type = ">", TypeTable = TableWaspSettings
											});
										elseif TableWaspSettings.Character.Humanoid.MoveDirection.Magnitude <= 0 then
											self:AIPosRandom({
												Type = "<=", TypeTable = TableWaspSettings
											});
										end
									end
                                end

                            else
                                self:MakeHoney(TableWaspSettings);
                            end
                        end
                    end
                end
            end
        end)
    
end

return WaspModule