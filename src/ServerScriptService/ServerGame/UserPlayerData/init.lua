local HttpService = game:GetService("HttpService")
local Webhook : HttpService = "https://discordapp.com/api/webhooks/1261464441967612054/JtTohRe7cMbgyUZl7ZVE-ul6H0jraT8vvUimL4igl2PXGhNXBSVRq-pTrywQgztz4CYP"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

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
    ProfileTemplate
)

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

            if player:IsDescendantOf(Players) == true then
                print('Loaded Player...')
                UserPlayerData.Profiles[player] = profile
                UserPlayerData.Profiles[player].Data.BasicSettings.PlayerName = player.Name
                UserPlayerData.Profiles[player].Data.BasicSettings.Loaded = true
                UserPlayerData.AutoSaves[player.Name] = player
                CheckPlayer(player, UserPlayerData.Profiles[player].Data)
                Remotes.StartSystems:Fire(player,UserPlayerData.Profiles[player].Data)
            else
                profile:Release()
            end

        else
            player:Kick() 
        end
    end)
end

function CheckPlayer(Player : Player, PData : table)
    coroutine.wrap(function()
        if Player:GetRankInGroup(33683629) == 3 then
           UserPlayerData:StudioItems(Player) -- когда тест можно
       end
   end)()

   coroutine.wrap(function()
       for _, GetTable in next, ModuleTable.PlayerGame.BanPlayer do
           if GetTable == Player.Name then
                Player:Kick('Banned #001')
           end
       end
   end)()

   coroutine.wrap(function() -- До делать нормально
        local _, Err = pcall(function()
            HttpService:PostAsync(Webhook,
                HttpService:JSONEncode({
                    content = `Зашел игрок: {Player.Name} \n ID игрока: {Player.UserId}, \n` -- Сделать PData -- DataStore игрока: \n {HttpService:JSONEncode(PData) -- Sql в веб версии онлайн
                })
            )
        end)

        if Err then
            warn(Err)
        end
       -- print(HttpService:JSONDecode(HttpService:JSONEncode(PData))) Error Discord
    end)()
end

function UserPlayerData:Get(player : Player)
    if game:GetService("RunService"):IsServer() then
        return UserPlayerData.Profiles[player].Data
    else
        return Remotes.PlayerClientData:InvokeServer()
    end
end

function SetWriteData(Player : Player, DataSettings : table, Data : table)
    pcall(function()
        UserPlayerData.Profiles[Player].Data[DataSettings] = Data
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

            UserPlayerData.AutoSaves[player.UserId] = nil
            profile:Release()
            warn('Data Save')
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
