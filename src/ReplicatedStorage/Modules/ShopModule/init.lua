local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage.Remotes
local CameraFolder : Folder = workspace.GameSettings.Camers
local PlayerGui = Player:WaitForChild('PlayerGui')
local UIs : StarterGui = PlayerGui:WaitForChild('UIs')
local ShopsFrame : Frame = UIs:WaitForChild('Shops')
local Camera = workspace.CurrentCamera
local CameraNPC : Camera = nil
local ModuleShop : table = nil

-- // Libary
local DataClient : ModuleScript = require(ReplicatedStorage.Libary.ClientData)
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local ModuleTable : ModuleScript = require(ReplicatedStorage.Libary.ModuleTable)
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
        DataClient:WriteDataServer({"FakeSettings","OpenShop",false})
        CameraCloseShops()
        PData.FakeSettings.OpenShop = false
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
    BuyButtonFrame()
    if Type == "Start" then
        --[[local InfoTools : table = EquimentModule[Camers:GetAttribute('Items')]
        print(InfoTools)]]
        TweenModule:UseGuiFrame(ShopsFrame.BuyFrame, UDim2.new(0.418, 0,0.856, 0))
        TweenModule:UseGuiFrame(ShopsFrame.FrameDecs, UDim2.new(0.788, 0,0.195, 0))
        TweenModule:UseGuiFrame(ShopsFrame.LeftFrame, UDim2.new(0.359, 0,0.846, 0))
        TweenModule:UseGuiFrame(ShopsFrame.RightFrame, UDim2.new(0.608, 0,0.846, 0))
        TweenModule:UseGuiFrame(ShopsFrame.Ingredients, UDim2.new(0.95, 0,0.504, 0))
    elseif Type == "Update" then -- Сделать разбивку для ингридиентов
        TweenModule:UseCamera(Camera,CameraNPC[IndexCamera])
        local InfoTools : table = EquimentModule[CameraNPC[IndexCamera]:GetAttribute('TypeItem')]
        local ItemsInfo : table? = nil

        if not ItemsInfo then
            ItemsInfo = require(InfoTools)
        end

        ModuleShop = ItemsInfo[CameraNPC[IndexCamera]:GetAttribute('TypeItem')](CameraNPC[IndexCamera]:GetAttribute('NameItem'))
        BuyItems(ModuleShop, CameraNPC[IndexCamera]:GetAttribute('NameItem'))

        if ModuleShop.SetingsShop.Craft ~= nil then
            
            local CraftInfo : table = ModuleShop.SetingsShop.Craft
            local Ingred : Frame? = ShopsFrame.Ingredients
            
            for _, IngredientFrame in Ingred:GetChildren() do
                if IngredientFrame:IsA('Frame') then
                    IngredientFrame:Destroy()
                end 
            end

            local function SizeIngridiedFrame(index : number)
                local TableSize : table = {
                    [1] = {
                        Position = UDim2.new(0.756, 0,0.313, 0),
                        Size = UDim2.new(0.052, 0,0.112, 0)
                    },
                    [2] = {
                        Position = UDim2.new(0.756, 0,0.357, 0),
                        Size = UDim2.new(0.052, 0,0.2,0)
                    },
                    [3] = {
                        Position = UDim2.new(0.756, 0,0.403, 0),
                        Size = UDim2.new(0.052, 0,0.292, 0)
                    },
                    [4] = {
                        Position = UDim2.new(0.756, 0,0.453, 0),
                        Size = UDim2.new(0.052, 0,0.392, 0)
                    },
                    [5] = {
                        Position = UDim2.new(0.756, 0,0.504, 0),
                        Size = UDim2.new(0.052, 0,0.492, 0)
                    },
                    [6] = {
                        Position = UDim2.new(0.756, 0,0.592, 0),
                        Size = UDim2.new(0.052, 0, 0.555, 0)
                    },
                    [7] = {
                        Position = UDim2.new(0.756, 0,0.692, 0),
                        Size = UDim2.new(0.052, 0,0.611, 0)
                    },
                }
                for indexNum, value in TableSize do
                    if index == indexNum then
                        TweenModule:SizePositionGui(Ingred,value.Position,value.Size)
                    end
                end
            end

            for index, value in next, CraftInfo do
                local ItemTable : table = ModuleTable.Items(value.Name)
                local TempCraft : Frame = ReplicatedStorage.Assert.TemplateCraft:Clone()
                SizeIngridiedFrame(index)
                TempCraft.Parent = Ingred
                TempCraft.Name = value.Name
                TempCraft.LabelX.TextColor3 = Color3.fromRGB(255, 255, 255)
                TempCraft.Textture.Image = ItemTable.Image
                TempCraft.LabelX.Text = `x{value.Amt}`
            end
            --{0, 72},{0, 72}
            IngredientColorNumber(ModuleShop)
            TweenModule:UseGuiFrame(ShopsFrame.Ingredients, UDim2.new(0.756, 0,0.504, 0))
        else
            TweenModule:UseGuiFrame(ShopsFrame.Ingredients, UDim2.new(0.95, 0,0.504, 0))
        end

        
        local function GuiUpdate()
            local Decs : Frame = ShopsFrame.FrameDecs.Decs
            local MoneyText : Frame = ShopsFrame.FrameDecs.MoneyText
            local NameText : Frame = ShopsFrame.FrameDecs.NameText

           task.spawn(function()
                Utils:AnimateText(NameText, CameraNPC[IndexCamera]:GetAttribute('NameItem'))
                Utils:AnimateText(Decs, ModuleShop.SetingsShop.Description)
           end)
           --[[ Decs.TextLabel.Text = ModuleShop.ToolShop.Description -- можно добавить Utils анимацию текста
            NameText.TextLabel.Text = CameraNPC[IndexCamera]:GetAttribute('NameItem')]]
            MoneyText.TextLabel.Text = `{Utils:CommaNumber(ModuleShop.SetingsShop.Cost)} Money`
        end

        GuiUpdate()
    elseif Type == "Close" then
        TweenModule:UseGuiFrame(ShopsFrame.BuyFrame, UDim2.new(0.418, 0,1.5, 0))
        TweenModule:UseGuiFrame(ShopsFrame.FrameDecs, UDim2.new(1.5, 0,0.195, 0))
        TweenModule:UseGuiFrame(ShopsFrame.LeftFrame, UDim2.new(0.359, 0,1.5, 0))
        TweenModule:UseGuiFrame(ShopsFrame.RightFrame, UDim2.new(0.608, 0,1.5, 0))
        TweenModule:UseGuiFrame(ShopsFrame.Ingredients, UDim2.new(1.5, 0,0.504, 0))
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

function BuyButtonFrame()
    local Button : string = ShopsFrame.BuyFrame.Buy.TextLabel
    local originalSize = UDim2.new(0.896, 0,0.792, 0)
    local smallerSize = UDim2.new(0.848, 0,0.749, 0)
    if ShopVisual then
        
        if Denounce then return end
        Denounce = true
        Button.MouseButton1Down:Connect(function()
            local TNameItems = CameraNPC[IndexCamera]:GetAttribute('NameItem')
            Remotes.ShopServerRemote:FireServer(Button.Text, ModuleShop, TNameItems)
            ShopsFrame.BuyFrame.Buy:TweenSize(smallerSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .25, true)
        end)
        
        Button.MouseButton1Up:Connect(function()
            ShopsFrame.BuyFrame.Buy:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .25, true)
        end)

        task.delay(0.3, function()
            Denounce = false
        end)
    end
end

function IngredientColorNumber(ModuleShop : table)
    local PData : table = DataClient:GetClient()
    local Inventory : table = PData.Inventory
    local CraftSettings : table = ModuleShop.SetingsShop.Craft
    local IntegerFrame : Frame = ShopsFrame.Ingredients
    local CraftInfo : table? = nil

    for index, value in CraftSettings do
        CraftInfo = value
    end

    for _, Framee in next, IntegerFrame:GetChildren() do
        if Framee:IsA('Frame') then
            if Inventory[Framee.Name] then
                if Inventory[Framee.Name] >= CraftInfo.Amt then
                    Framee.LabelX.TextColor3 = Color3.fromRGB(255, 255, 255)
                elseif Inventory[Framee.Name] < CraftInfo.Amt then
                    Framee.LabelX.TextColor3 = Color3.fromRGB(255, 0, 4)
                end
            elseif Inventory[Framee.Name] == nil then
                Framee.LabelX.TextColor3 = Color3.fromRGB(255, 0, 4)
            end
        end
    end
end

function BuyItems(ModuleShop : table, NameItem)
    local ButtonBuy : Frame = ShopsFrame.BuyFrame
    local PData : table = DataClient:GetClient()

    if PData.IStats.Honey >= ModuleShop.SetingsShop.Cost and PData.Equipment.Shops[ModuleShop.SetingsShop.Type.."s"][NameItem] == nil and PData.Equipment[ModuleShop.SetingsShop.Type] ~= NameItem then
        if ModuleShop.SetingsShop.Craft ~= nil then
            for _, v in next, ModuleShop.SetingsShop.Craft do
                for index, value in next, PData.Inventory do
                    if index == v.Name then
                        if value >= v.Amt then
                            TweenModule:ColorUpdate(ButtonBuy.Buy, Color3.fromRGB(133, 255, 133))
                            ButtonBuy.Buy.TextLabel.Text = "Purchase"
                            
                        elseif value < v.Amt then
                           -- ButtonBuy.Buy.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
                            TweenModule:ColorUpdate(ButtonBuy.Buy, Color3.fromRGB(255, 0, 4)) 
                            ButtonBuy.Buy.TextLabel.Text = "Can't Affod"
                          
                        end
                    end
                end

                if not PData.Inventory[v.Name] then
                    TweenModule:ColorUpdate(ButtonBuy.Buy, Color3.fromRGB(255, 0, 4)) 
                    ButtonBuy.Buy.TextLabel.Text = "Can't Affod"
                   
                end

            end
        end
    elseif PData.IStats.Honey < ModuleShop.SetingsShop.Cost then
        TweenModule:ColorUpdate(ButtonBuy.Buy, Color3.fromRGB(255, 0, 4))
        ButtonBuy.Buy.TextLabel.Text = "Can't Affod"
       -- IngredientColorNumber()

    elseif PData.Equipment.Shops[ModuleShop.SetingsShop.Type.."s"][NameItem] ~= nil and PData.Equipment[ModuleShop.SetingsShop.Type] == NameItem  then
        TweenModule:ColorUpdate(ButtonBuy.Buy, Color3.fromRGB(255, 130, 41))
        ButtonBuy.Buy.TextLabel.Text = "Equipped"
      
    elseif PData.Equipment[ModuleShop.SetingsShop.Type] == NameItem then
        TweenModule:ColorUpdate(ButtonBuy.Buy, Color3.fromRGB(207, 131, 255))
        ButtonBuy.Buy.TextLabel.Text = "Equip"
        
    end
end


ShopsFrame.LeftFrame.Buy.TextButton.MouseButton1Click:Connect(LeftCamera)
ShopsFrame.RightFrame.Buy.TextButton.MouseButton1Click:Connect(RigthCamera)

return ShopsModule