local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StampsFolder : Folder = ReplicatedStorage.Assert.StampsGame
local DataClient : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Zone : ModuleScript = require(ReplicatedStorage.Libary.Zone)

local LocalPlayer : Player = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Remotes : Folder = ReplicatedStorage.Remotes
GetField = Remotes.GetField:InvokeServer()

local FlowerCollect = {}

local function GetRotation()
    local Orientation = CFrame.Angles(0, math.rad(0), 0)
    if Character then
        local HOrient = Character.PrimaryPart.Orientation

			if HOrient.Magnitude >= 50 and HOrient.Magnitude < 110 then
				Orientation = CFrame.Angles(0, math.rad(90), 0)
			end

			if HOrient.Magnitude > -90 and HOrient.Magnitude < 90 then
				Orientation = CFrame.Angles(0, math.rad(-90), 0)
			end

			if HOrient.Magnitude > 0 and HOrient.Magnitude < 50 then
				Orientation = CFrame.Angles(0, math.rad(-180), 0)
			end

			if HOrient.Magnitude <= 110 and HOrient.Magnitude >= 180 then
				Orientation = CFrame.Angles(0, math.rad(0), 0)
			end

			if HOrient.Magnitude > 110 and HOrient.Magnitude < 180 then
				Orientation = CFrame.Angles(0, math.rad(0), 0)
			end
    end
    return Orientation 
end

function FlowerCollect:FlowerRayCost(TSS : table)
    local PData : table = DataClient:GetClient(LocalPlayer)
    local ToolStamps : Folder = StampsFolder[TSS.RayStamp]:Clone()
    ToolStamps.Parent = workspace.GameSettings.Stamp
    game.Debris:AddItem(ToolStamps, 1)
    local RayFlower1 : Ray = Ray.new(not TSS.Position and Character.PrimaryPart.Position or TSS.Positionn, Vector3.new(0,-12,0))
    local Rayy : table = workspace:FindPartOnRayWithWhitelist(RayFlower1, {workspace.GameSettings.Fields})
    local _,err = pcall(function()
        coroutine.wrap(function()
            if Rayy.Name == "Flower" then

                if ToolStamps:IsA('Model') then
                    ToolStamps:PivotTo(CFrame.new(Rayy.Position + Vector3.new(0,3,0)) * GetRotation())
                else
                    ToolStamps.CFrame = CFrame.new(Rayy.Position) * GetRotation()
                end
            end
    
            if ToolStamps:IsA('Model') then
                for _, OBJ in next, (ToolStamps:GetChildren()) do
                    if OBJ.Name ~= "Root" then
                        local RayFlower : Ray = Ray.new(OBJ.Position, Vector3.new(0,-12,0))
                        local Ray2 : table = workspace:FindPartOnRayWithWhitelist(RayFlower, {workspace.GameSettings.Fields})

                        if Ray2.Name == "Flower" and PData.FakeSettings.Field ~= "" then
                            Remotes.CollercterFlower:FireServer(Ray2, TSS)
                        end
                    end
                end
            else
                local RayFlower3 : Ray = Ray.new(ToolStamps.Position, Vector3.new(0,-12,0))
                local Ray3 : table = workspace:FindPartOnRayWithWhitelist(RayFlower3, {workspace.GameSettings.Fields})
                
                if tostring(Ray3.Name) == "Flower" and PData.FakeSettings.Field ~= "" then
                    Remotes.CollercterFlower:FireServer(Ray3, TSS)
                end
            end
    
        end)()

    end)

    if err then
       -- warn(err)
    end
end

--FlowerCollect:FlowerRayCost({Stamp = "Testers"}) -- Test


function FlowerCollect:Regeneration(Field)
    local InfoFieldGame = GetField[Field.Name]
        task.spawn(function()
            while Field do task.wait(math.random(2,6))
                for i, Pollen in pairs(Field:GetChildren()) do
                    if Pollen:IsA("BasePart") then
                    InfoFieldGame = GetField.Flowers[Pollen:GetAttribute('ID')]
                        if math.floor(Pollen.Position.Y) <= InfoFieldGame.MaxP then -- Возможны баги
                            local ToMaxFlower = tonumber(InfoFieldGame.MaxP - Pollen.Position.Y)
                            local FlowerPos = Pollen.Position + Vector3.new(0, ToMaxFlower, 0)
                            local FlowerPosTime = Pollen.Position + Vector3.new(0,InfoFieldGame.RegenFlower,0)
                            TweenModule:RegenUp(Pollen,ToMaxFlower,InfoFieldGame,FlowerPos,FlowerPosTime)
                        end
                    end 
                end
            end
        end)
end



function FlowerEffect(Flower : Part)
    Flower.ParticleEmitter.Enabled = true
    task.wait(0.35)
    Flower.ParticleEmitter.Enabled = false
end

function DownFlower(Player,Flower : Part, DecAm : Vector3)
    local FlowerPos = Flower.Position - Vector3.new(0,DecAm,0)
    local infofield = GetField.Flowers[Flower:GetAttribute('ID')]
    if (Flower.Position.Y - infofield.MinP) > 0.25 then -- исправить баг 
        TweenModule:FlowerDown(Flower,FlowerPos)
    end
end

Remotes.FlowerDownSize.OnClientEvent:Connect(DownFlower)


for _, FieldFolder in next, workspace.GameSettings.FieldZone:GetChildren() do
    local ZonePlus : Instance = Zone.new(FieldFolder)

    ZonePlus.playerEntered:Connect(function(Player : Player)
        local PData : table = DataClient:GetClient(Player)
        PData.FakeSettings.Field = GetField.Correspondant[FieldFolder.Name]
        PData.FakeSettings.OldField = FieldFolder.Name
    end)

    ZonePlus.localPlayerExited:Connect(function(Player : Player)
        local PData : table = DataClient:GetClient(Player)

        PData.FakeSettings.Field = ""
        
    end)
end

for _, Field in next, workspace.GameSettings.Fields:GetChildren() do
    FlowerCollect:Regeneration(Field)
end

return FlowerCollect