local Items = {}

    Items.Tools = function(ToolName : string)
            local NewTableTools = setmetatable({}, Items)

            NewTableTools = {
                ['Shovel'] = {
                    ToolSettings = {
                        Regeniration = 0.15,
                        CollectField = 12,
                        SizeCollect = 0.25,
                        RayStamp = "Shovel",
                        Color = nil,
                        ColorMutltiplier = 1,
                        AnimTools = {
                            [1] = 'rbxassetid://18963714535',
                            [2] = 'rbxassetid://18963812407'
                        },
                        GuiItems = "rbxassetid://17180412078",
                    },
                    
                    ToolShop ={
                        Description = "",
                        Type = 'Tool',
                        Cost = 0,
                        Craft = {},
                    },
                }
            }
        return NewTableTools[ToolName]
    end

return Items