local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes


--// Libary
local EquimentModule = require(script.Parent.Equiment)
local Data = require(script.Parent.UserPlayerData)
local ShopServer = {}

function DestroyEquipment(Character, Item)
    if Character:FindFirstChild(Item) then
        Character:WaitForChild(Item):Destroy()
        if Item.Type == "Boot" then
            Character:WaitForChild(Item):Destroy()
        end
    end
end

function RemoteShop(Player : Player, TypeText : string, TypeTable : table, ItemsType : string)
    local PData : table = Data:Get(Player)
    local Humanoid = Player.Character:FindFirstChild("Humanoid")
    if TypeText == "Purchase" or TypeText == "Equip" then
        if not PData.Equipment.Shops[TypeTable.SetingsShop.Type.."s"][ItemsType] then
            PData.Equipment.Shops[TypeTable.SetingsShop.Type.."s"][ItemsType] = true
        end

        if PData.Equipment[TypeTable.SetingsShop.Type] ~= ItemsType then -- добавить вещи
            PData.Equipment[TypeTable.SetingsShop.Type] = ItemsType
            DestroyEquipment(Player,TypeTable.SetingsShop.Type)
            EquimentModule:EquipItem(Player,Humanoid,TypeTable.SetingsShop.Type)
            print("Nofficall")
        end
    elseif TypeText == "Can't Affod" then
        print("Nofficall")
    end
end

Remotes.ShopServerRemote.OnServerEvent:Connect(RemoteShop)

return ShopServer