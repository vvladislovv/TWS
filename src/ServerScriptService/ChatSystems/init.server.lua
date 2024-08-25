local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CountriesModule = require(script.Countries)

local ServerScriptService = game:GetService("ServerScriptService")
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner").ChatService)
print(ChatService)


local function speakerAdded(speakerName)
    local speaker = ChatService:GetSpeaker(speakerName)
    local player = speaker:GetPlayer()
	local success, code = pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, player)
	
	if success and code then
		print(CountriesModule[code])
    -- Safe, as if statement fails if first condition is falsy
		speaker:SetExtraData("Tags", {{TagText =`{CountriesModule[code]}`,TagColor = Color3.fromRGB(255, 255, 255)}})
	end
end

ChatService.SpeakerAdded:Connect(speakerAdded)
for _, speaker in ipairs(ChatService:GetSpeakerList()) do
    speakerAdded(speaker)
end
-- Обработчик входящих сообщений
