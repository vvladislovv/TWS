local Items = {}

    Items.Bags = function(ToolName : string)
            local NewTableBags = setmetatable({}, Items)

            NewTableBags = {
                ['Pouch'] = {
                    BagSettings = {
                        Capacity = 350,
                        Buff = {},
                        GuiItems = "rbxassetid://17180412078",
                    },
                    
                    SetingsShop ={
                        Description = "asd232134WER@##$",
                        Type = 'Bag',
                        Cost = 0,
                        Craft = nil,
                    },
                },
                ['Small Backpack'] = {
                    BagSettings = {
                        Capacity = 900,
                        Buff = {},
                        GuiItems = "rbxassetid://17180412078",
                    },
                    
                    SetingsShop ={
                        Description = "asdafsdvazxcv@##$",
                        Type = 'Bag',
                        Cost = 650,
                        Craft = {
                            [1] = {
                                Name = "Strawberry",
                                Amt = 30,
                            },
                            [2] = {
                                Name = "Blueberry",
                                Amt = 30,
                            },
                            [3] = {
                                Name = "Oil",
                                Amt = 30,
                            }
                        }
                    },
                },
                ['Bundle of hay'] = {
                    BagSettings = {
                        Capacity = 5000,
                        Buff = {},
                        GuiItems = "rbxassetid://17180412078",
                    },
                    
                    SetingsShop ={
                        Description = "asdgasdgasdgasdgasd",
                        Type = 'Bag',
                        Cost = 1700,
                        Craft = {
                            [1] = {
                                Name = "Blueberry",
                                Amt = 10,
                            },
                            [2] = {
                                Name = "Seed",
                                Amt = 5,
                            }
                        },
                    },
                },
                
            }
        return NewTableBags[ToolName]
    end

return Items