local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)

local Remotes : Folder = ReplicatedStorage.Remotes
local Player : Player = game.Players.LocalPlayer

local ScriptButton : nil = nil
local ButtonModule = {} -- через мету таблицу

function DistationButton(Button : Part, Distation)
    local suc, err = pcall(function()
        if Distation < 10 then
            ScriptButton = Button
            TweenModule.OpenButton(Button.B)
            if Button.Name == "Hive" then
                Button:SetAttribute('OpenButton', true)
            elseif Button.Name == "Quest" then
                Button:SetAttribute('OpenButton', true)
            end
        elseif Distation > 10  then
            TweenModule.CloseButton(Button.B)
            if Button.Name == "Hive" then
                Button:SetAttribute('OpenButton', false)
            elseif Button.Name == "Quest" then
                Button:SetAttribute('OpenButton', false)
            end
        end
    end)
    if err then
        warn(err)
    end
end

function KeyCode(input, GPE)
    if not GPE then
        if input.KeyCode == Enum.KeyCode.E or input.UserInputType == Enum.UserInputType.Touch then
            if ScriptButton ~= nil then
                if ScriptButton:GetAttribute('OpenButton') then
                    AnimKeyCode(ScriptButton, input)
                    if ScriptButton.Name == "Hive" then
                        require(script.Parent.HiveModule):Start(ScriptButton)
                        print('a')
                    elseif ScriptButton.Name == "Quest" then
                        print('f')
                    end
                end
            end
        end
    end
end

function AnimKeyCode(Button : Part, input)
    task.spawn(function()
        Button.B.ButtonE.ImageColor3 = Color3.fromRGB(255, 255, 255)

        while UserInputService:IsKeyDown(input.KeyCode.EnumType.E) do
            task.wait()
            if ScriptButton:GetAttribute('OpenButton') then
                Button.B.ButtonE.ImageColor3 = Color3.fromRGB(166, 166, 166)
                TweenModule:KeyCode(Button.B)
            end
        end

        if not UserInputService:IsKeyDown(input.KeyCode.EnumType.E) then
            Button.B.ButtonE.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end

    end)
end


UserInputService.InputBegan:Connect(KeyCode)
print('f')
ReplicatedStorage.Remotes.ClientOpenServer:FireServer()
ReplicatedStorage.Remotes.ButtonClient.OnClientEvent:Connect(DistationButton)
return ButtonModule