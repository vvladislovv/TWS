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
        Bag = "Pouch",

        Shops = {
            Tools = {['Shovel'] = true},
            Bags = {['Pouch'] = true} -- исправить
        }
    }

    PData.Inventory = {
        ['Sugar'] = 30,
        ['Ticket'] = 30,
        ['Strawberry'] = 30,
        ['Treat'] = 125,
        ['Oil'] = 15
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
        --SHOP settings
        OpenShop = false,

        --Wasp settings
        Making = false,
        Attack = false,
    }
    PData.IStats = {
        Honey = 15000,
        DailyHoney = 0,
        Pollen = 30000,
        Capacity = 100000000000000000, --350
    }

    PData.Amulets = {
        ['Moon'] = {
            ['Pollen From Collecter'] = 15,
           -- ['']
        },
        ['Bees'] = {
            ['Pollen From Collecter'] = 15,
           -- ['']
        },
        ['Crocodile'] = {
            ['Pollen From Collecter'] = 15,
           -- ['']
        },
        ['Gear'] = {
            ['Pollen From Collecter'] = 15,
           -- ['']
        },
        ['Star'] = {
            ['Pollen From Collecter'] = 15,
           -- ['']
        },
        ['Eye'] = {
            ['Pollen From Collecter'] = 15,
           -- ['']
        },
        ['Drum'] = {
            ['Pollen From Collecter'] = 15,
           -- ['']
        },
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
            ['Convert +'] = 100,
            --['Clock Boost'] = 100,

            ["Pollen From Bees"] = 100,
            ["Pollen From Tools"] = 100,
            --// Field Boost 
            ['SunflowerPath1'] = 100   
            
            
        },
        TokenBoost = {},
        CraftBoost = {}
    }
    PData.Couldown = {}
    
    PData.HiveModule = {
        HiveSlotAll = 1, -- PlayerSlots
        HiveAllGame = 33,
    }
    PData.Wasps = {}
    for slot = 1, PData.HiveModule.HiveAllGame do
        PData.Wasps[slot] = {
            Name = "Test Wasp",
            Color = "Purple",
            Rarity = "★",
            Attack = 0,
            Slot = slot,
            Speed = 15,
            Energy = 15,
            ELimit = 10,
            Bond = 0,
            Level = 1,
        }
    end

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
	end

    return PData
end

return ProfileData