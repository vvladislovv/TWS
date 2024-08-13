local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players : Player = game:GetService("Players")

local Data : ModuleScript = require(ServerScriptService.ServerGame.UserPlayerData)


local ServerButton = {}

local function Distation(Button : Part, HRP : Humanoid)
    return function ()
        return (Button.Position - HRP.Position).Magnitude
    end
end


local function handlePlayer(player)
    local function onHeartbeat()
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        local humRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local pData = Data:Get(player)
        if pData ~= nil then
            if humanoid and humanoid.Health > 0 and humRootPart and pData.BasicSettings.Loaded then
                for _, button in next, game.Workspace.GameSettings.Button:GetChildren() do
                    local distance = Distation(button, humRootPart)()
                    local remote = ReplicatedStorage.Remotes:WaitForChild('ButtonClient')
                    if remote then
                        ReplicatedStorage.Remotes:WaitForChild('ButtonClient'):FireClient(player, button, distance)
                    end
                end

                humanoid.Died:Connect(function()
                    for _, button in next, game.Workspace.GameSettings.Button:GetChildren() do
                        local Character = player.CharacterAdded:Wait()
                        print(Character)
                        if Character then
                            local distance = Distation(button, humRootPart)()
                            ReplicatedStorage.Remotes:WaitForChild('ButtonClient'):FireClient(player, button, distance) 
                        end
                    end
                end)
            end 
        end
    end

    -- Подключаем обработчик Heartbeat для этого игрока
    local heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(onHeartbeat)

    -- Завершаем соединение при удалении игрока
    player.CharacterRemoving:Connect(function()
        heartbeatConnection:Disconnect()
    end)
end

function Start()
    task.spawn(function()
        task.wait(0.35) -- Задержка перед началом

        local success, err = pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                handlePlayer(player) -- Обработка игрока
            end
        end)

        if not success then
            warn(err) -- Сообщаем об ошибке
        end
    end)
end
ReplicatedStorage.Remotes.ClientOpenServer.OnServerEvent:Connect(Start)
-- Можно подключить обработчик PlayerAdded для каждого нового игрока

return ServerButton