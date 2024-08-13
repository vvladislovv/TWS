local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataClient : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local Player : Player = game.Players.LocalPlayer
local HiveFolder : Folder = workspace.GameSettings.Hives
local Remotes : Folder = ReplicatedStorage.Remotes
local StartHive : boolean = false
print(DataClient)

local HiveModule = {}

function HiveModule:Start(Button : Part)
    local PData : table = DataClient:GetClient()
    if PData.FakeSettings.HiveOwner ~= Player.Name or Button:GetAttribute('HiveOwner') == "" then
        HiveOwnerClient(Button,PData)
    end
end

function HiveOwnerClient(Button: Part, PData : table)
    for _, index in next, HiveFolder:GetChildren() do        
        print(index)
        local function Touched(hit)
            if Player.Character == hit.Parent then
                print(PData)
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
        print('f')
        Hive.Platform.Down.ParticleEmitter.Enabled = true
        Hive.Platform.Down.Highlight.Enabled = true
        Button.B.Enabled = true
        
    end
end

Remotes.HiveReturnClient.OnClientEvent:Connect(ButtonClientOwner)

return HiveModule