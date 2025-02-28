local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataClient : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local Player : Player = game.Players.LocalPlayer
local HiveFolder : Folder = workspace.GameSettings.Hives
local Remotes : Folder = ReplicatedStorage.Remotes
local StartHive : boolean = false
local Convert : boolean = false

local HiveModule = {}

function HiveModule:Start(Button : Part)
    local PData : table = DataClient:GetClient()
    if PData.FakeSettings.HiveOwner ~= Player.Name or Button:GetAttribute('HiveOwner') == "" then
        HiveOwnerClient(Button,PData)
    elseif PData.FakeSettings.HiveOwner == Player.Name and Button:GetAttribute('HiveOwner') == Player.Name then
        if not PData.FakeSettings.Making and PData.IStats.Pollen >= 0 then
            PData.FakeSettings.Making = true
            DataClient:WriteDataServer({"FakeSettings", "Making", true})
        elseif PData.FakeSettings.Making and PData.IStats.Pollen <= 0 then
            PData.FakeSettings.Making = false
            DataClient:WriteDataServer({"FakeSettings", "Making", false})
        end 
    end    
end

function HiveOwnerClient(Button: Part, PData : table)
    for _, index in next, HiveFolder:GetChildren() do        
        local function Touched(hit)
            if Player.Character == hit.Parent then

                if StartHive == false and PData.FakeSettings.HiveOwner == "" then
                    StartHive = true
                    Button.B.Enabled = false
                    Remotes.HiveOwner:FireServer(index,Button)
                end
            end
        end

        index.Platform.Up.Touched:Connect(Touched)
    end
end

function ButtonClientOwner(Button : Part, PDataServer : table, Hive : Folder)
    if PDataServer.FakeSettings.HiveOwner == Player.Name then
        Hive.Platform.Down.ParticleEmitter.Enabled = true
        Hive.Platform.Down.Highlight.Enabled = true
        Button.B.Enabled = true
        
    end
end

Remotes.HiveReturnClient.OnClientEvent:Connect(ButtonClientOwner)

return HiveModule