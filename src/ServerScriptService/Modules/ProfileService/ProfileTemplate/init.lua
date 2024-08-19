local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProfileData = {}

function ProfileData:DataNew()
    local PData = {}
    PData.BasicSettings = {
        Loaded = nil,
        Rank = "",
        PlayerName = "",
        HP = 100,
        Premium = false,
		Banned = false,
        Tutorial = false,
    }

    PData.Equipment = {
        Tool = "Shovel",
        Bag = "Backpack",

        Shops = {
            Tools = {['Shovel'] = true},
            Bags = {['Backpack'] = true}
        }
    }

    PData.FakeSettings = {
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

        OpenShop = false
    }
    PData.IStats = {
        Honey = 0,
        DailyHoney = 0,
        Pollen = 0,
        Capacity = 350, --350
    }

   PData.BoostGame = {
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
    }
    
    PData.HiveModule = {
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
    }
    PData.SettingsMenu = {
        ['Pollen Text'] = true
    }
    PData.ProductDeveloper = {}
    
    PData.Quests = {}
    for _, v in ReplicatedStorage:WaitForChild('QuestDiologs'):GetChildren() do
		PData.Quests[v.Name] = { -- не может понять что его нету или на оборот
			Claimed = false,
			Tasks = {},
			Quest = 1,
			Completed = false,
		}
        print(PData.Quests)
	end

    return PData
end

return ProfileData