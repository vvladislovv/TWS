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
                    
                    SetingsShop ={
                        Description = "asjd;gljasl;djglasdgloiu9821359879(IUEIUFHIEWHISDKFkLKHSDLKFJHS",
                        Type = 'Tool',
                        Cost = 0,
                        Craft = nil,
                    },
                },
                ['Magnet'] = {
                    ToolSettings = {
                        Regeniration = 0.15,
                        CollectField = 12,
                        SizeCollect = 0.25,
                        RayStamp = "Magnet",
                        Color = nil,
                        ColorMutltiplier = 1,
                        AnimTools = {
                            [1] = 'rbxassetid://18963714535',
                            [2] = 'rbxassetid://18963812407'
                        },
                        GuiItems = "rbxassetid://17180412078",
                    },
                    
                    SetingsShop ={
                        Description = "ssssss",
                        Type = 'Tool',
                        Cost = 750,
                        Craft = {
                            [1] = {
                                Name = "Strawberry",
                                Amt = 25, -- Amount
                            },
                            [2] = {
                                Name = "Sugar",
                                Amt = 25, -- Amount
                            }
                        },
                    },
                },
                ['Scissors'] = {
                    ToolSettings = {
                        Regeniration = 0.15,
                        CollectField = 12,
                        SizeCollect = 0.25,
                        RayStamp = "Scissors",
                        Color = nil,
                        ColorMutltiplier = 1,
                        AnimTools = {
                            [1] = 'rbxassetid://18963714535',
                            [2] = 'rbxassetid://18963812407'
                        },
                        GuiItems = "rbxassetid://17180412078",
                    },
                    
                    SetingsShop ={
                        Description = "ssssss",
                        Type = 'Tool',
                        Cost = 1500,
                        Craft = {
                            [1] = {
                                Name = "Treat",
                                Amt = 125, -- Amount
                            },
                            [2] = {
                                Name = "Oil",
                                Amt = 1 -- Amount
                            }
                        },
                    },
                },
                
            }
        return NewTableTools[ToolName]
    end

return Items