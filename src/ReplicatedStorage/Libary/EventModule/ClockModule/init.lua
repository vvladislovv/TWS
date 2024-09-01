local ClockModule = {}

local Player = game.Players.LocalPlayer
local Debounce : boolean = false

--// libary
local Data = require(script.Parent.Parent.ClientData)

function ClockModule:Starter(Button : GuiButton)
    print('Clock')
    local PData : table = Data:GetClient()

    if  not Debounce and  not PData.Couldown["Clock Boost"] then
            Debounce = true

            PData.Couldown["Clock Boost"] = time() + 3600
            Data:WriteDataServer({"Couldown", "Clock Boost", time() + 3600})
            --  Noffical
            print(PData.Couldown)
            Debounce = false
    elseif PData.Couldown["Clock Boost"] <= time() then
            --  Noffical
    end
end


return ClockModule