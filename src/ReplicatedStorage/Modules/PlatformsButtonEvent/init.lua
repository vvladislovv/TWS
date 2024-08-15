local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UIs = PlayerGui:WaitForChild('UIs')
local PlatformFolder = workspace.GameSettings.PlatformGame
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local isTouched = false
local ButtonGuiEvent = {}
ButtonGuiEvent.Debounce = false

function PlatformDist(Platform, HRP)
	if (HRP.Position - Platform.Position).Magnitude <= 10 then
		return true
	else
		return false
	end
end

coroutine.wrap(function()
    for index, value in next, PlatformFolder:GetChildren() do -- Переменная для отслеживания состояния касания
        
        value.Up.Touched:Connect(function(Hit)
            if Hit.Parent == Player.Character then
                task.spawn(function()
                    while true do
                        task.wait()
                        if (Player.Character.HumanoidRootPart.Position - value.Up.Position).Magnitude <= 10 then
                            TweenModule:ButtonTween(UIs.ButtonUpEvent, true)
                        else
                            TweenModule:ButtonTween(UIs.ButtonUpEvent, false)
                            break
                        end
                    end
                end)
            end
        end)

        
    end
end)()

return ButtonGuiEvent