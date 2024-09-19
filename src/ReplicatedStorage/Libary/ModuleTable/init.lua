local ModuleTable = {} do

    ModuleTable.PlayerGame = {
        Admins = {
            [1] = 'vlad060108',
            [2] = 'bnnuyman',
            [3] = 'Helaliky',
        },
        BanPlayer = {
            [1] = 'dima0tu3',
            [2] = 'iQlemjo',
            [3] = 'CblH_Cengdopa',
            [4] = 'dima0tu17',
            [5] = 'KtotoVBSS',
           -- [6] = 'StepanVIP123',
            [6] = 'Nerason_Dev',
            [7] = 'user_443210',
        }
    }

    
    ModuleTable.LevelWasp = {
        [1] = 125,
        [2] = 375,
        [3] = 695,
        [4] = 1200,
        [5] = 1900,
        [6] = 2750,
        [7] = 4650,
        [8] = 6075,
        [9] = 7950,
        [10] = 11500,
        [11] = 19950,
        --[[[12] = 27950,
        [13] = 45000,
        [14] = 90000,
        [15] = 250000,
        [16] = 500000,
        [17] = 1200000,
        [18] = 4000000,
        [19] = 12000000,
        [20] = 35000000,]]
    }

    ModuleTable.TagsColors = function(TextTag : string)
        local TagColors = {
            ['Snail'] = Color3.fromRGB(202, 255, 179),
            ['Tester'] = Color3.fromRGB(255, 167, 43),
            ['Worker'] = Color3.fromRGB(25, 125, 255),
            ['Developer Game'] = Color3.fromRGB(255, 0, 4),
        }
        for index, value in next, TagColors do
            if index == TextTag then
                return value
            end
        end
    end

    ModuleTable.Rarity = function(Rarity : string)
        local TableRarity = {
            ["★"] = {[1] = "Сommon", [2] = Color3.fromRGB(148, 102, 50)}, 
            ["★★"] = {[1] = "Rare", [2] = Color3.fromRGB(126, 126, 126)},
            ["★★★"] = {[1] = "Unusual", [2] = Color3.fromRGB(150, 107, 104)},
            ["★★★★"] = {[1] = "Epic", [2] = Color3.fromRGB(86, 46, 143)}, 
            ["★★★★★"] = {[1] = "Legandary",[2] = Color3.fromRGB(53, 113, 138)},
            ["★★★★★★"] = {[1] = "Mystical", [2] = Color3.fromRGB(150, 101, 142)},
            ["★★★★★★★"] = {[1] = "Event", [2] = Color3.fromRGB(48, 143, 86)},
            ["★★★★★★★★"] = {[1] = "Special", [2] = Color3.fromRGB(150, 78, 79)},
        }
        
        for index, value in next, TableRarity do
            if index == Rarity then
                return value
            end
        end
    end

    ModuleTable.Items = function(Name : string)
        local TableItems = {
            ['Strawberry'] = {
                Decs = "",
                Image = "rbxassetid://17180412078",
                
                --Recept
                Type = "",
                CanInput = true,
			    Amount = 50,
            },
            ['Sugar'] = {
                Decs = "",
                Image = "rbxassetid://17180412078",
                
                --Recept
                Type = "",
                CanInput = true,
			    Amount = 50,
            },
            ['Treat'] = {
                Decs = "",
                Image = "rbxassetid://17180412078",
                
                --Recept
                Type = "",
                CanInput = true,
			    Amount = 50,
            },
            ['Oil'] = {
                Decs = "",
                Image = "rbxassetid://17180412078",
                
                --Recept
                Type = "",
                CanInput = true,
			    Amount = 50,
            },
            ['Blueberry'] = {
                Decs = "",
                Image = "rbxassetid://17180412078",
                
                --Recept
                Type = "",
                CanInput = true,
			    Amount = 50,
            },
            ['Seed'] = {
                Decs = "",
                Image = "rbxassetid://17180412078",
                
                --Recept
                Type = "",
                CanInput = true,
			    Amount = 50,
            },
        }

        for index, value in next, TableItems do
            if index == Name then
                return value
            end
        end
    end 

end


return ModuleTable