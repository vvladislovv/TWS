local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Remote : Folder = ReplicatedStorage.Remotes
local WaspClientModule = {}

function FlyWasp(Settings : table)
    local Primary = Settings.Model:FindFirstChild('Primary')
    RunService.RenderStepped:Connect(function()
        Primary.CFrame = Primary.CFrame * CFrame.Angles(math.rad(math.cos(time() * 9) / 2), 0, 0)
    end)
end

Remote.ClientWasp.OnClientEvent:Connect(FlyWasp)
return WaspClientModule