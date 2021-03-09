-- AntiAFK Script for BeamMP Servers. (Client Side is Required to work!)
-- By jojos38, Gorg, Titch

local KICK_AFK_PLAYERS = true -- Should afk players be kicked or not
local MAX_AFK_TIME = 30 -- 600 -- How many seconds of afk do you want to kick them after?
local WARN_MESSAGE_TIME = 15 -- 300 -- How many seconds before a warn message is sent to the player(s)?

local KICK_SPECTATING_PLAYERS = true -- (RECOMMENDED) Should we kick spectating players
local MAX_SPECTATING_AFK_TIME = 60 -- How many seconds before we kick a spectating player

local BROADCAST_AFK_PLAYERS = true -- Should there be broadcast messages when a player is afk

local EXEMPT_PLAYERS = {
	-- 'Discord ID or BeamMP ID' = true
	
}

-------------------------------------------------------------------------------
-- DO NOT TOUCH ANYTHING BELOW HERE UNLESS YOU WANT TO CHANGE MESSAGES
-------------------------------------------------------------------------------



local playersTimer = {}
local autoKickDisable = false



local function exemptPlayer(playerID)
	local ids = GetPlayerIdentifiers(playerID)
	if not ids then return end
	local isExempt = false
	for k, _ in ids do
		if EXEMPT_PLAYERS[k] then
			isExempt = true
		end
	end
	return isExempt
end



local function isSpectating(playerID)
	local vehiclesCount = 0
	local playerVehicles = GetPlayerVehicles(playerID)
	if playerVehicles then
		for vehicleID, vehicleData in pairs(playerVehicles) do
			vehiclesCount = vehiclesCount + 1
		end
	end
	return vehiclesCount == 0
end



local function check()
	local vehiclesCount = 0
	local players = GetPlayers()
	if not players then return end
    for playerID, playerName in pairs(players) do
		if not playersTimer[playerID] then playersTimer[playerID] = 0 end
		local playerVehicles = GetPlayerVehicles(playerID)
		if playerVehicles then
			for vehicleID, vehicleData in pairs(playerVehicles) do
				vehiclesCount = vehiclesCount + 1
			end
		end
	end
	if KICK_AFK_PLAYERS then
		if vehiclesCount > 0 and autoKickDisable == false then
			autoKickDisable = true
			print("Afk kick is now enabled")
		elseif vehiclesCount == 0 and autoKickDisable == true then
			autoKickDisable = false
			print("No vehicles found, afk kick is disabled")
		end
	end
end



function TimerSystem()
	check() -- If no vehicles we disable afk kicking and check if a player joined
	for playerID, afkTime in pairs(playersTimer) do -- For each player
		-- if not exemptPlayer(playerID) then 	
			playersTimer[playerID] = afkTime + 1

			-- Set the afk time according to spectating or not
			local maxAfkTime = MAX_AFK_TIME
			if isSpectating(playerID) then maxAfkTime = MAX_SPECTATING_AFK_TIME end
			
			if playersTimer[playerID] >= maxAfkTime then
				if KICK_AFK_PLAYERS and autoKickDisable then
					DropPlayer(playerID, 'You have been afk for too long.')
					print("Player "..playerID.." was kicked for being afk")
				end
			elseif playersTimer[playerID] == WARN_MESSAGE_TIME then
				if KICK_AFK_PLAYERS and autoKickDisable then SendChatMessage(playerID, "Warning, you will get kicked in "..maxAfkTime - WARN_MESSAGE_TIME.." seconds if you don't move!") end
				if BROADCAST_AFK_PLAYERS then
					SendChatMessage(-1, GetPlayers()[playerID].." is now afk")
				end
			end
		-- end
	end
end



local function resetTimer(playerID)
	if BROADCAST_AFK_PLAYERS and playersTimer[playerID] > WARN_MESSAGE_TIME then
		SendChatMessage(-1, GetPlayers()[playerID].." is no longer afk")
	end
	playersTimer[playerID] = 0
end



local function onInit()
	log('i', "AntiAFK Initialising...")
	RegisterEvent("onPlayerJoin",		"onPlayerJoin")
	RegisterEvent("onPlayerDisconnect", "onPlayerDisconnect")
	RegisterEvent("onPlayerMoved", 		"onPlayerMoved")
	RegisterEvent("onVehicleEdited", 	"onVehicleEdited")
	RegisterEvent("onChatMessage", 		"onChatMessage")
	CreateThread("TimerSystem", 1)
	log('s', "AntiAFK initialized")
end


 
function onPlayerJoin(playerID)
	resetTimer(playerID)
	print(GetPlayerDiscordID(playerID))
end

function onPlayerDisconnect(playerID)
	playersTimer[playerID] = nil
end

function onPlayerMoved(playerID)
	resetTimer(playerID)
end

function onVehicleEdited(playerID, vehicleID, vehicleData)
	resetTimer(playerID)
end

function onChatMessage(playerID, senderName, message)
	resetTimer(playerID)
end

onInit()