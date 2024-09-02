local HttpService = game:GetService("HttpService")
local Webhook : HttpService = "https://discordapp.com/api/webhooks/1261464441967612054/JtTohRe7cMbgyUZl7ZVE-ul6H0jraT8vvUimL4igl2PXGhNXBSVRq-pTrywQgztz4CYP"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Remotes : Folder = ReplicatedStorage.Remotes

local ModuleTable = require(ReplicatedStorage.Libary.ModuleTable)
local ProfileService : ModuleScript = require(game.ServerScriptService.Modules.ProfileService)
local ProfileStoreIndex : ModuleScript = require(game.ServerScriptService.Modules.ProfileService.ProfileStoreIndex)
local ProfileTemplate : ModuleScript = require(game.ServerScriptService.Modules.ProfileService.ProfileTemplate)

local UserPlayerData = {}
UserPlayerData.Profiles = {}
UserPlayerData.AutoSaves = {}

local ProfileStore : FunctionalTest? = ProfileService.GetProfileStore(
    ProfileStoreIndex,
    ProfileTemplate:DataNew()
)

function UserPlayerData:StudioItems(Player : Player)
    local TesetData = require(game.ServerScriptService.Modules.ProfileService.ProfileStudioStoreIndex):DataNew()

    if TesetData then
    warn('Loaded Test Player <Data not Save>')
        UserPlayerData.Profiles[Player].Data = TesetData
    else
        warn('Loaded Player <Data Save>')
    end
end

function LoadUserData(player : Player)
    pcall(function()
        local profile : table = ProfileStore:LoadProfileAsync("Player" .. player.UserId)
        if profile ~= nil then
            profile:AddUserId(player.UserId) -- GDPR compliance
            profile:Reconcile() 

            profile:ListenToRelease(function()
                UserPlayerData.Profiles[player] = nil
                player:Kick()
            end)

            if player:IsDescendantOf(Players) == true then -- Сделать для тестроващиков
                task.wait()
                UserPlayerData.Profiles[player] = profile
                CheckPlayer(player, UserPlayerData.Profiles[player].Data)
                UserPlayerData.Profiles[player].Data.BasicSettings.PlayerName = player.Name
                UserPlayerData.Profiles[player].Data.BasicSettings.Loaded = true
               --print(UserPlayerData.Profiles[player].Data)
                UserPlayerData.AutoSaves[player.Name] = player
                Remotes.StartSystems:Fire(player,UserPlayerData.Profiles[player].Data)
            else
                profile:Release()
            end

        else
            player:Kick() 
        end
    end)
end

function TagsPlayer(Player)
    local Tags : BillboardGui = ReplicatedStorage.Assert.Tags:Clone()

        local Head :CharacterMesh = Player.Character:FindFirstChild('Head')
        local Uppertext : TextLabel = Tags.UpperText -- Rank Gruop
		local Lowertext : TextLabel = Tags.LowerText -- Name Player
		local Humanoid : Humanoid = Player.Character.Humanoid

		Humanoid.DisplayDistanceType = "None"

		--Create Text character
		Tags.Parent = Head
		Tags.Adornee = Head
		Lowertext.Text = Player.DisplayName -- Player Name 
        print('f')
        if Player:GetRankInGroup(33683629) == 3 then
            Uppertext.Text = "Tester"
            Uppertext.TextColor3 = ModuleTable.TagsColors("Tester")
        elseif Player:GetRankInGroup(33683629) == 1 then
            Uppertext.Text = "Snail"
            Uppertext.TextColor3 = ModuleTable.TagsColors("Snail")
        elseif Player:GetRankInGroup(33683629) == 4 then
            Uppertext.Text = "Worker"
            Uppertext.TextColor3 = ModuleTable.TagsColors("Worker")
        elseif Player:GetRankInGroup(33683629) == 255 then
            Uppertext.Text = "Developer Game" 
            Uppertext.TextColor3 = ModuleTable.TagsColors("Developer Game")
        elseif Player:GetRankInGroup(33683629) == 0 then
            Uppertext.Visible = false
        end
end


function CheckPlayer(Player : Player, PData : table)
    for _, GetTable in next, ModuleTable.PlayerGame.Admins do
        if Player:GetRankInGroup(33683629) == 3 or GetTable == Player.Name then
            UserPlayerData:StudioItems(Player) -- когда тест можно
        end
    end

   coroutine.wrap(function()
        task.wait()
       for _, GetTable in next, ModuleTable.PlayerGame.BanPlayer do
           if GetTable == Player.Name then
            if not PData.BasicSettings.Banned then
                PData.BasicSettings.Banned = true
                Player:Kick('You have a ban in the game, you need to contact the support of our discord server!')
            else
                Player:Kick('You have a ban in the game, you need to contact the support of our discord server!')
            end
           end
       end
   end)()

   --[[coroutine.wrap(function() -- До делать нормально
        local _, Err = pcall(function()
            HttpService:PostAsync(Webhook,
                HttpService:JSONEncode({
                    --content = `Зашел игрок: {Player.Name} \n ID игрока: {Player.UserId}, \n` -- Сделать PData -- DataStore игрока: \n {HttpService:JSONEncode(PData) -- Sql в веб версии онлайн
                })
            )
        end)

        if Err then
            warn(Err)
        end
       -- print(HttpService:JSONDecode(HttpService:JSONEncode(PData))) Error Discord
    end)()]]

    TagsPlayer(Player) 
end

function ResetDataPlayer(player : Player)
    local PData = UserPlayerData:Get(player)
    PData = {}
    player:Kick("DataReset")
end

function UserPlayerData:Get(player : Player)
    if game:GetService("RunService"):IsServer() then
        if UserPlayerData.Profiles[player] ~= nil then
            return UserPlayerData.Profiles[player].Data
        end
    else
        return Remotes.PlayerClientData:InvokeServer()
    end
end

function SetWriteData(Player : Player, DataSettings : string)
    pcall(function()
        UserPlayerData.Profiles[Player].Data[DataSettings[1]][DataSettings[2]] = DataSettings[3]
       print(UserPlayerData.Profiles[Player].Data[DataSettings[1]][DataSettings[2]])
    end)
end

function SaveData(Player : Player, DataSettings : table)
    pcall(function()
        UserPlayerData.Profiles[Player].Data = DataSettings
        Remotes.DataUpdate:FireClient(Player,DataSettings)
    end)
end

function UserPlayerRemove(player : Player)
    pcall(function()
        local profile = UserPlayerData.Profiles[player]
        if profile ~= nil then

            profile.Data.FakeSettings = {
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
            }

            if RunService:IsStudio() then
                profile.Data = {}
                warn('Not Data Save')
            else
                warn('Data Save')
                profile:Release()
                print(profile.Data)
            end
            UserPlayerData.AutoSaves[player.UserId] = nil

        end
    end)
end

game.ReplicatedStorage.Remotes.PlayerClientData.OnServerInvoke = function(client)
    local PData : table = UserPlayerData:Get(client)
    return PData
end

do
    game.Players.PlayerAdded:Connect(LoadUserData)
    game.Players.PlayerRemoving:Connect(UserPlayerRemove)
    Remotes.ClientOnServer.OnServerEvent:Connect(SetWriteData)
    Remotes.ResetData.OnServerEvent:Connect(ResetDataPlayer)
    local SaveTimer : number = 0
    pcall(function()
        coroutine.wrap(function()
            local _, Err = pcall(function()
                while true do task.wait(1)
                    SaveTimer += 1
                    if SaveTimer > 3 then
                        for _, Player in pairs(UserPlayerData.AutoSaves) do
                            if Player ~= nil then
                                local PData = UserPlayerData:Get(Player)
                                SaveData(Player,PData)
                            end
                        end
                        SaveTimer = 0
                    end
                end
            end)
        end)()
    end)
end


return UserPlayerData
