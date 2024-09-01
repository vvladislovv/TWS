local Player = game.Players.LocalPlayer
local Debounce : boolean = false

--// libary
local Data = require(script.Parent.Parent.ClientData)
local ConvertModule = {}

function ConvertModule:Starter(Button : GuiButton)
    print('Convert')
    local PData : table = Data:GetClient()
    local Inventory : table = PData.Inventory
    local IStats : table = PData.IStats
    local ConverNumeber : number = Button:GetAttribute('ConverNum')

    if Player:IsInGroup(33683629) and not PData.Couldown[`Convert {ConverNumeber}`] then
        if Inventory['Ticket'] >= 1 and not Debounce then
            Debounce = true
            Inventory['Ticket'] -= 1
            Data:WriteDataServer({"Inventory", `Ticket`, Inventory['Ticket']})

            PData.Couldown[`Convert {ConverNumeber}`] = time() + 3600
            Data:WriteDataServer({"Couldown", `Convert {ConverNumeber}`, time() + 3600})

            IStats.Pollen += IStats.Honey * (PData.BoostGame.PlayerBoost['Convert +'] / 100)
            IStats.Pollen = 0
            Data:WriteDataServer({"IStats", `Pollen`, 0})
            Debounce = false
            -- noffical
            print(IStats.Pollen)
            print(IStats.Honey)
        end
    elseif Player:IsInGroup(33683629) and PData.Couldown[`Convert {ConverNumeber}`] <= time() then
        --noffical
        print('NONONO')
    end
end

return  ConvertModule