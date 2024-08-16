local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local Data : ModuleScript = require(ServerScriptService.ServerGame.UserPlayerData)
local GenerationField : ModuleScript = require(ServerScriptService.ServerGame.GeneratorField)
local Zone : ModuleScript = require(ReplicatedStorage.Libary.Zone)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local TokenModule : ModuleScript = require(ServerScriptService.ServerGame.TokenModule)
local DecAmTable : table = {}
local FlowerServerCollect = {}
FlowerServerCollect.FlowerPlayerTable = {}

function FlowerDataBoots(PData : table, Coollected : number, FlowerTable : table, TSS : table, DecAmt : number)
    --// Boosts
    if PData.FakeSettings.OldField ~= "" then
        Coollected *= (PData.BoostGame.PlayerBoost['Pollen'] / 100)
        Coollected *= (PData.BoostGame.PlayerBoost[FlowerTable.Color..' Pollen'] / 100)
        Coollected *= (PData.BoostGame.PlayerBoost[PData.FakeSettings.OldField] / 100)

        if TSS.Boots then
            Coollected *= (PData.BoostGame.PlayerBoost['Movement Collection'])
        end
    end

    if FlowerTable.Color == TSS.Color then
        Coollected *= TSS.ColorMutltiplier
    end

    if FlowerTable.Stat.Value == "1" then
        Coollected *= 1
        if DecAmt > 0 then
            DecAmt /= 1
        end
    elseif FlowerTable.Stat.Value == "2" then
        Coollected *= 1.5
        if DecAmt > 0 then
            DecAmt /= 1.5
        end
    elseif FlowerTable.Stat.Value == "3" then
        Coollected *= 2
        if DecAmt > 0 then
            DecAmt /= 2
        end
    end
end

function CollectFlower(Player : Player, Flower : Part , Tabss : table)
    local PData = Data:Get(Player)

    if PData.IStats.Capacity > PData.IStats.Pollen and PData.FakeSettings.FallingDown ~= "" and (Flower.Position.Y - GenerationField.Flowers[Flower:GetAttribute('ID')].MinP) > 0.2 then
        local FlowerTable : table = GenerationField.Flowers[Flower:GetAttribute('ID')]
        local FieldName : string = PData.FakeSettings.Field
        local FieldFolder : Instance = workspace.GameSettings:FindFirstChild(FieldName)
        local Conversion : number = math.round(PData.BoostGame.PlayerBoost[FlowerTable.Color.." Instant"] + PData.BoostGame.PlayerBoost['Instant'])
        local Collected : number = Tabss.TSS.CollectField
        local DecAmt : number = Tabss.TSS.SizeCollect

        local Honeyy, Pollenn : number = 0, 0

        FlowerDataBoots(PData, Collected, FlowerTable, Tabss,DecAmt)

        if Conversion > 100 then
            Conversion = 100
        end

        local Convert = math.round(Collected * (Conversion / 100))
        if Pollenn < 0 then
            Pollenn = 0
        elseif Convert < 0 then
            Convert = 0
        end

        Honeyy += Convert
        Pollenn = math.round(Collected - Convert)

        Remotes.FlowerDownSize:FireAllClients(Player,Flower,DecAmt)

        task.spawn(function()
            task.wait(0.01)
            if FlowerServerCollect.FlowerPlayerTable[Player.Name] then 
                if PData.SettingsMenu['Pollen Text'] and (Flower.Position.Y - GenerationField.Flowers[Flower:GetAttribute('ID')].MinP) > 0.2 then
                    for v ,index in next, (FlowerServerCollect.FlowerPlayerTable[Player.Name]) do
                        if index > 0 then
                            Remotes.VisualNumberEvent:FireClient(Player,{Pos = Flower.Position, Amt = index, Color = v, Crit = false})
                        end
                    end
                end
                FlowerServerCollect.FlowerPlayerTable[Player.Name] = {White = 0, Blue = 0, Honey = 0,  Pupler = 0}
            end
        end)


        if (PData.IStats.Pollen + math.round(Pollenn)) > PData.IStats.Capacity then
            Pollenn = PData.IStats.Capacity - PData.IStats.Pollen
        end

        PData.IStats.Pollen += math.round(Pollenn)
        PData.IStats.Honey = math.round(Honeyy)
        PData.IStats.DailyHoney = math.round(Honeyy)

        if FlowerServerCollect.FlowerPlayerTable[Player.Name] then
            FlowerServerCollect.FlowerPlayerTable[Player.Name][FlowerTable.Color] += math.round(Pollenn)
            FlowerServerCollect.FlowerPlayerTable[Player.Name].Honey += math.round(Honeyy)
        end

        local DropChance : Random? = Utils:ChanceRandome(math.random(2,100))

        if true then -- DropChance <= 10
            local Items = GenerationField.FieldDrops(PData.FakeSettings.Field)
            TokenModule:CreateToken({
                Type = "Any",
                Item = Items,
                Model = nil,
                Player = Player,
                Pos = Flower.Position, -- + Vector3.new(0, 2.5, 0)
                Amt = 1,
                Resource = `from {PData.FakeSettings.OldField} Field`
            })
        end
    end
end

Remotes.CollercterFlower.OnServerEvent:Connect(CollectFlower)

coroutine.wrap(function()
    game.Players.PlayerAdded:Connect(function(Player : Player)
        FlowerServerCollect.FlowerPlayerTable[Player.Name] = {White = 0, Blue = 0, Honey = 0,  Pupler = 0}
    end)

    game.Players.PlayerRemoving:Connect(function(Player : Player)
        FlowerServerCollect.FlowerPlayerTable[Player.Name] = nil
    end)
end)()

for _, FieldFolder in next, workspace.GameSettings.FieldZone:GetChildren() do
    local ZonePlus : Instance = Zone.new(FieldFolder)

    ZonePlus.playerEntered:Connect(function(Player : Player)
        local PData : table = Data:Get(Player)
        PData.FakeSettings.Field = GenerationField.Correspondant[FieldFolder.Name]
        PData.FakeSettings.OldField = FieldFolder.Name

    end)

end

return FlowerServerCollect