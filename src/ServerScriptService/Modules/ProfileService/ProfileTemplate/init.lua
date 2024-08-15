return {
    BasicSettings = {
        Loaded = nil,
        Rank = "",
        PlayerName = "",
        HP = 100,
        Premium = false,
		Banned = false,
        Tutorial = false,
    },
    Equipment = {
        Tool = "Shovel",
        Bag = "Backpack",

        Shops = {
            Tools = {['Shovel'] = true},
            Bags = {['Backpack'] = true}
        }
    },
    FakeSettings = {
        --Field Settings
        Field = "",
        OldField = "",
        GuiField = false,

        -- Mobs Settings
        MobsAttack = false,
        ModsField = nil,
        PlayerAttack = false,
        
        --Hive Settings
        HiveOwner = "",
        HiveNumberOwner = "",
    },
    IStats = {
        Honey = 0,
        DailyHoney = 0,
        Pollen = 0,
        Capacity = 10000000000000000000, --350
    },
    BoostGame = {
        FieldBoost = {},
        PlayerBoost = {
            ["Instant"] = 0,
            ["Pupler Instant"] = 0,
            ["White Instant"] = 0,
            ["Blue Instant"] = 0,

            ['Pollen'] = 100,
            ["Pupler Pollen"] = 100,
            ["White Pollen"] = 100,
            ["Blue Pollen"] = 100,

            ['Movement Collection'] = 100,

            --// Field Boost 
            ['SunflowerPath1'] = 100            
        },
        TokenBoost = {},
        CraftBoost = {}
    },
    

    Qusets = {},

    HiveModule = {
        HiveSlotAll = 1, -- PlayerSlots
        
        WaspSlotHive = {
            [1] = {
                Name  = 'Test',
                Level = 1,
                Rarity = "★",
                Color = "Pupler",
				Band = 0,
            },
        }
    },
    SettingsMenu = {
        ['Pollen Text'] = true
    },
    ProductDeveloper = {}
}