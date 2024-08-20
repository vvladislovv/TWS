local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Mouse = game.Players.LocalPlayer:GetMouse()
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
            elseif Button.Name == "ResetData" then
                Button:SetAttribute('OpenButton', true)
            elseif Button.Name == "Shop" then
                Button:SetAttribute('OpenButton', true)
            end
        elseif Distation > 10  then
            TweenModule.CloseButton(Button.B)
            if Button.Name == "Hive" then
                Button:SetAttribute('OpenButton', false)
            elseif Button.Name == "Quest" then
                Button:SetAttribute('OpenButton', false)
            elseif Button.Name == "ResetData" then
                Button:SetAttribute('OpenButton', false)
            elseif Button.Name == "Shop" then
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
                    elseif ScriptButton.Name == "Quest" then
                        require(script.Parent.QuestModule):StartModule(ScriptButton)
                    elseif ScriptButton.Name == "Shop" then
                        require(script.Parent.ShopModule):StartModule(ScriptButton)
                    elseif ScriptButton.Name == "ResetData" then
                        Remotes.ResetData:FireServer()
                    end
                end
            end
        end

        local target = Mouse.Target
        if input.UserInputType == Enum.UserInputType.MouseButton1 then -- Mouse Click Button
            if ScriptButton ~= nil then
                if ScriptButton:GetAttribute('OpenButton') and target.Name == ScriptButton.Name then
                    AnimKeyCode(ScriptButton, input)
                    if ScriptButton.Name == "Hive" then
                        require(script.Parent.HiveModule):Start(ScriptButton)
                    elseif ScriptButton.Name == "Quest" then
                        require(script.Parent.QuestModule):StartModule(ScriptButton)
                    elseif ScriptButton.Name == "Shop" then
                        require(script.Parent.ShopModule):StartModule(ScriptButton)
                    elseif ScriptButton.Name == "ResetData" then
                        Remotes.ResetData:FireServer()
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
        while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
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
ReplicatedStorage.Remotes.ClientOpenServer:FireServer()
ReplicatedStorage.Remotes.ButtonClient.OnClientEvent:Connect(DistationButton)
return ButtonModule