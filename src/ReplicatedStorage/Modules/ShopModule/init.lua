local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local CameraFolder : Folder = workspace.GameSettings.Camers
local PlayerGui = Player:WaitForChild('PlayerGui')
local UIs : StarterGui = PlayerGui:WaitForChild('UIs')
local ShopsFrame : Frame = UIs:WaitForChild('Shops')
local Camera = workspace.CurrentCamera
local CameraNPC : Camera = nil

-- // Libary
local DataClient : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local EquimentModule : Folder = ReplicatedStorage.Equiment
local Controls = require(Player.PlayerScripts.PlayerModule):GetControls()

local OldPosCamera : Vector3? = nil
local IndexCamera : number = 1
local ShopVisual : nil = nil
local Denounce : boolean = false
local ShopsModule = {}

function ShopsModule:StartModule(Button : BasePart)
    if CameraFolder[Button:GetAttribute('Shop')] then
        CameraShops(Button)
    end
end

function CameraShops(Button : BasePart)
    local PData : table = DataClient:GetClient()
    if not PData.FakeSettings.OpenShop then
        PData.FakeSettings.OpenShop = true
        DataClient:WriteDataServer({"FakeSettings","OpenShop",true})
        ShopVisual = #CameraFolder[Button:GetAttribute('Shop')]:GetChildren()
        CameraNPC = CameraFolder[Button:GetAttribute('Shop')]
        OldPosCamera = Camera.CFrame
        Camera.CameraType = Enum.CameraType.Scriptable
        GuiFrameShop("Start")
        GuiFrameShop("Update")
        TweenModule:UseCamera(Camera,CameraNPC[IndexCamera])
        Controls:Disable()
    else
        PData.FakeSettings.OpenShop = false
        DataClient:WriteDataServer({"FakeSettings","OpenShop",false})
        CameraCloseShops()
    end
end

function CameraCloseShops()
    IndexCamera = 1
    GuiFrameShop("Close")
    TweenModule:UseCloseCamera(Camera,OldPosCamera)
    Controls:Enable()
    Camera.CameraType = Enum.CameraType.Custom
end

function GuiFrameShop(Type : string)
    if Type == "Start" then
        --[[local InfoTools : table = EquimentModule[Camers:GetAttribute('Items')]
        print(InfoTools)]]
        TweenModule:UseGuiFrame(ShopsFrame.BuyFrame, UDim2.new(0.418, 0,0.856, 0))
        TweenModule:UseGuiFrame(ShopsFrame.FrameDecs, UDim2.new(0.788, 0,0.195, 0))
        TweenModule:UseGuiFrame(ShopsFrame.LeftFrame, UDim2.new(0.359, 0,0.846, 0))
        TweenModule:UseGuiFrame(ShopsFrame.RightFrame, UDim2.new(0.608, 0,0.846, 0))
    elseif Type == "Update" then -- Сделать разбивку для ингридиентов
        TweenModule:UseCamera(Camera,CameraNPC[IndexCamera])
        local InfoTools : table = EquimentModule[CameraNPC[IndexCamera]:GetAttribute('TypeItem')]
        local ItemsInfo : table? = nil

        if not ItemsInfo then
            ItemsInfo = require(InfoTools)
        end

        local ModuleShop = ItemsInfo[CameraNPC[IndexCamera]:GetAttribute('TypeItem')](CameraNPC[IndexCamera]:GetAttribute('NameItem'))

        local function GuiUpdate()
            local Decs : Frame = ShopsFrame.FrameDecs.Decs
            local MoneyText : Frame = ShopsFrame.FrameDecs.MoneyText
            local NameText : Frame = ShopsFrame.FrameDecs.NameText

            Utils:AnimateText(NameText, CameraNPC[IndexCamera]:GetAttribute('NameItem'))
            Utils:AnimateText(Decs, ModuleShop.ToolShop.Description)
           --[[ Decs.TextLabel.Text = ModuleShop.ToolShop.Description -- можно добавить Utils анимацию текста
            NameText.TextLabel.Text = CameraNPC[IndexCamera]:GetAttribute('NameItem')]]
            MoneyText.TextLabel.Text = `{Utils:CommaNumber(ModuleShop.ToolShop.Cost)} Money`
        end

        GuiUpdate()
    elseif Type == "Close" then
        TweenModule:UseGuiFrame(ShopsFrame.BuyFrame, UDim2.new(0.418, 0,1.5, 0))
        TweenModule:UseGuiFrame(ShopsFrame.FrameDecs, UDim2.new(1.5, 0,0.195, 0))
        TweenModule:UseGuiFrame(ShopsFrame.LeftFrame, UDim2.new(0.359, 0,1.5, 0))
        TweenModule:UseGuiFrame(ShopsFrame.RightFrame, UDim2.new(0.608, 0,1.5, 0))
        -- {0.756, 0},{0.504, 0} -- Ingredients
    end
end

function LeftCamera()
    if ShopVisual then
        
        if Denounce then return end

        Denounce = true
        IndexCamera -= 1
        
        if IndexCamera == 0 then
            IndexCamera = ShopVisual
        end

        task.delay(0.3, function()
            Denounce = false
        end)
        GuiFrameShop("Update")
    end
end

function RigthCamera()
    if ShopVisual then
        
        if Denounce then return end

        Denounce = true
        IndexCamera += 1
        
        if IndexCamera > ShopVisual then
            IndexCamera = 1
        end

        task.delay(0.3, function()
            Denounce = false
        end)
        GuiFrameShop("Update")
    end
end

function BuyItems()
    
end

function Ingredients()
    
end

ShopsFrame.LeftFrame.Buy.TextButton.MouseButton1Click:Connect(LeftCamera)
ShopsFrame.RightFrame.Buy.TextButton.MouseButton1Click:Connect(RigthCamera)

return ShopsModule