local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player : Player = game.Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid : Humanoid = Character:FindFirstChildOfClass("Humanoid")

--// Libary
local DataClient : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local ToolsFolder : ModuleScript = require(ReplicatedStorage.Equiment.Tools)
local FlowerCollect : ModuleScript = require(ReplicatedStorage.Modules.FlowerCollect)
--local ModuleTable : ModuleScript = require(ReplicatedStorage.Libary.ModuleTable)
local Mouse : Mouse = Player:GetMouse()

local Collecting : boolean, Debounce : boolean = false

local PData : table = nil

local _, err = pcall(function()
    repeat
        PData = ReplicatedStorage.Remotes.PlayerClientData:InvokeServer()
    until PData ~= nil
end)

if err then
    warn(err)
end

local ToolInfo : table = ToolsFolder.Tools(PData.Equipment.Tool)

function CheckAnimTool()
    local AnimNumber : number = 0
    for _,i in next, (ToolInfo.ToolSettings.AnimTools) do
        AnimNumber += 1
    end
    
    if AnimNumber > 1 then
        local RandomeAnim : Random = math.random(1, AnimNumber)
        return ToolInfo.ToolSettings.AnimTools[RandomeAnim]
    else
        return ToolInfo.ToolSettings.AnimTools[AnimNumber]
    end
end


Mouse.Button1Down:Connect(function()
    Collecting = true
end)

Mouse.Button1Up:Connect(function()
    Collecting = false
end)

function FlowerModule()
    FlowerCollect:FlowerRayCost({
        TSS = ToolInfo.ToolSettings,
        RayStamp = ToolInfo.ToolSettings.RayStamp
    })
end

RunService.RenderStepped:Connect(function()
    if Collecting and not Debounce then
        Debounce = true
        local Animation : Animation = Instance.new('Animation')
        Animation.AnimationId = CheckAnimTool()
        local PData = DataClient:GetClient(Player)
        local Couldown : number = ToolInfo.ToolSettings.Regeniration -- / (PData.AllStats["Tools Speed"] / 100)
        local AnimationTrack : AnimationTrack = Humanoid:LoadAnimation(Animation)
        AnimationTrack.Priority = Enum.AnimationPriority.Action
        AnimationTrack:Play()
        if PData.IStats.Pollen >= PData.IStats.Capacity then
            -- noffical
        else
            FlowerModule()
        end
        task.wait(AnimationTrack.Length)
        task.wait(Couldown)
        Debounce = not Debounce

        task.spawn(function()
            task.wait(AnimationTrack.Length)
            Animation:Destroy()
        end)
    end
end)