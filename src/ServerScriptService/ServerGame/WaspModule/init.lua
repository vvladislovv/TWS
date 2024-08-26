local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local FolderWasp : Folder = workspace.GameSettings.Wasps
local WaspModule : ModuleScript? = ReplicatedStorage.Wasps
local TweenService = game:GetService('TweenService')
--// Libary
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Data : ModuleScript = require(script.Parent.UserPlayerData)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)

local WaspModule = {}
WaspModule.__index = WaspModule

local function WaitUntilReached2(Model, Magnitude, HRP, Character)
	if Model and Model.PrimaryPart then
		repeat task.wait() if not Model.PrimaryPart or Character.Humanoid.MoveDirection.Magnitude > 0 or Character.Humanoid.Health <= 0 then break end
		until (Model.PrimaryPart.Position - Model.Primary.Position).Magnitude <= (Magnitude or 0.7)
	else
		return
	end
end

function WaspModule.NewWasp(PData : table,PosSlot : Vector3?,WaspModel : ModuleScript,CheckSlot : number)
    local NewWaspTable : table = {}
        NewWaspTable.PlayerData = PData
        NewWaspTable.WaspSettings = require(WaspModel)
        NewWaspTable.FlyPos = Vector3.new(math.random(-10, 10), 1, math.random(-10, 10))
        NewWaspTable.SlotPos = PosSlot
        NewWaspTable.WaspData = PData.Wasps[CheckSlot]
        NewWaspTable.Model = WaspModel.Model
        WaspModel.Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z) * CFrame.Angles(0,90,0)) 
        TweenModule:CreateWaspHive(WaspModel.Model,PosSlot)
        WaspModule:AIPos(NewWaspTable)
        WaspModule:Animate(NewWaspTable)
        setmetatable(NewWaspTable, WaspModule)
    return NewWaspTable
end

function WaspModule:Animate(NewWaspTable) -- сделать анимацию, пока что лагано 
    local Model = NewWaspTable.Model
    local Primary : BasePart = Model:FindFirstChild('Primary')
    local AO : AlignOrientation = Primary:FindFirstChild('AlignOrientation')
    while Model do task.wait()
        if NewWaspTable.Animate then
            task.wait(0.1)
            Primary.CFrame *= CFrame.Angles(math.rad(-15),0, 0)
            task.wait(0.1)
            --TweenModule:FlyWasp(Primary,CFrame.Angles(math.rad(15),0, 0))
            Primary.CFrame *= CFrame.Angles(math.rad(15),0, 0)
        end
    end
end

function WaspModule:AIPos(NewWaspTable)
    self = NewWaspTable

    local PosRandome : BasePart = self.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = self.Model:FindFirstChild('Primary')
    local AP : AlignPosition = Primary:FindFirstChild('AlignPosition')
    local AO : AlignOrientation = Primary:FindFirstChild('AlignOrientation')
    task.spawn(function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            local character = player.Character or player.CharacterAdded:Wait()
            self.Character = character
            TweenModule:WaspPosition(PosRandome, character.HumanoidRootPart.Position)
            while self.Model and self.Character do task.wait()
                if self.WaspData.Energy <= 0 then
                    --self:Sleep()
                    continue
                end
                    if self.PlayerData.FakeSettings.Attack then
                        --self:Attack(self.Player)
                    else
                        if not self.PlayerData.FakeSettings.Making then
                            if self.PlayerData.FakeSettings.Field ~= "" and self.PlayerData.IStats.Pollen < self.PlayerData.IStats.Capacity then
                                --self:CollectPollen()
                            elseif self.PlayerData.FakeSettings.Field == "" or self.PlayerData.IStats.Pollen >= self.PlayerData.IStats.Capacity then
                                local NewPos : Vector3?
                                local LookVect = {}

                                if character.Humanoid.MoveDirection.Magnitude > 0 then
                                    NewPos = character.HumanoidRootPart.Position + self.FlyPos
                                    PosRandome.Position = NewPos
                                    AO.CFrame =  CFrame.new(Primary.Position, NewPos) * CFrame.Angles(0, math.rad(-90), 0)
                                    self.Animate = true
                                elseif character.Humanoid.MoveDirection.Magnitude <= 0 then
                                    
                                    NewPos = character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10), math.random(-0.5,1.5), math.random(-10,10))
                                    
                                    TweenModule:WaspPosition(PosRandome, NewPos)
                                    TweenModule:WaspOrintation(AO,CFrame.new(Primary.Position, NewPos))
                                    TweenModule:WaspOrintation(PosRandome,CFrame.new(Primary.Position, NewPos) * CFrame.Angles(0, math.rad(-90), 0))
                                    
                                  --  TweenService:Create(PosRandome, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = CFrame.new(Primary.Position, NewPos) * CFrame.Angles(0, math.rad(-90), 0)}):Play()
                                    self.Animate = true
                                    --TweenService:Create(PosRandome, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = CFrame.lookAt(Primary.Position, character.HumanoidRootPart.CFrame.LookVector * )}):Play()
                                   -- PosRandome.Orientation *= character.HumanoidRootPart.CFrame.LookVector
                                    --PosRandome.CFrame *= CFrame.Angles(0,math.rad(90),0)
                                    if (Primary.Position - PosRandome.Position).Magnitude <= 1 and character.Humanoid.Health > 0 then
                                        TweenModule:WaspOrintation(AO,character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0))
                                        --AO.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)                                   
                                    end
                                    task.wait(2.5)
                                end
                            end
                        else
                            -- Self:MakeHoney()
                        end
                    end
            end
        end
    end)

end

return WaspModule