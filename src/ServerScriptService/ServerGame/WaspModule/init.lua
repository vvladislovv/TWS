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

local WaspModule = {}
WaspModule.__index = WaspModule


function WaspModule.NewWasp(PData : table,PosSlot : Vector3?, WaspModel : ModuleScript,CheckSlot : number)
    local NewWaspTable : table = {}
        NewWaspTable.PlayerData = PData;
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

function WaspModule:Sleep()
    local PosRandome : BasePart = self.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = self.Model:FindFirstChild('Primary')
    self.Model:SetPrimaryPartCFrame(CFrame.new(self.SlotPos.WorldCFrame.Position.X, self.SlotPos.WorldCFrame.Position.Y, self.SlotPos.WorldCFrame.Position.Z) * CFrame.Angles(0,90,0)) 

    Primary.CFrame = CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
end

function WaspModule:AIPos(NewWaspTable) -- переписать движения чтобы была загрузка другая
    self = NewWaspTable
    local PosRandome : BasePart = self.Model:FindFirstChild('PartRandome')
    local Primary : BasePart = self.Model:FindFirstChild('Primary')
    local AO : AlignOrientation = Primary:FindFirstChild('AlignOrientation')
    local StartWasp : boolean = false
    task.spawn(function()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            local character = player.Character or player.CharacterAdded:Wait()
            self.Character = character

            TweenModule:WaspPosition(PosRandome, character.HumanoidRootPart.Position + Vector3.new(math.random(-6,6), math.random(-0.1,1), math.random(-6,6)))
            task.wait(1)

            while true do task.wait()
                if self.WaspData.Energy <= 0 then
                    self:Sleep()
                    print('f')
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
    end)
    
end

return WaspModule