-- AntiAFK Script for BeamMP Servers. (Client Side is Required to work!)
-- By jojos38, Gorg, Titch

local KICK_AFK_PLAYERS = true -- Should afk players be kicked or not
local MAX_AFK_TIME = 30 -- 600 -- How many seconds of afk do you want to kick them after?
local WARN_MESSAGE_TIME = 15 -- 300 -- How many seconds before a warn message is sent to the player(s)?

local KICK_SPECTATING_PLAYERS = true -- (RECOMMENDED) Should we kick spectating players
local MAX_SPECTATING_AFK_TIME = 60 -- How many seconds before we kick a spectating player

local BROADCAST_AFK_PLAYERS = true -- Should there be broadcast messages when a player is afk
local BROADCAST_SPECTATING_AFK_PLAYERS = true -- Should spectating players broadcast a message in the chat when afk

local EXEMPT_PLAYERS = {
	-- Discord ID or BeamMP ID, There should be a comma after every line but the last
	-- Example:
	-- "discord:258329053910663168",
	-- "beammp:780"
}

-------------------------------------------------------------------------------
-- DO NOT TOUCH ANYTHING BELOW HERE UNLESS YOU WANT TO CHANGE THE MESSAGES
-------------------------------------------------------------------------------



local playersTimer = {}
local autoKickDisable = false



local function exemptPlayer(playerID)
	local ids = GetPlayerIdentifiers(playerID)
	if not ids then return end
	local isExempt = false
	for idType, id in pairs(ids) do -- For each id of the player to verify
		for _, exemptID in pairs(EXEMPT_PLAYERS) do -- For each exempt player
			if exemptID == id then -- If one of his ids matches
				isExempt = true
				break
			end
		end
	end
	return isExempt
end



-- We check the amount of vehicles the player has
-- to know if he is spectating or not
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
			log('i', "At least one vehicle is spawned, afk kick is now enabled")
		elseif vehiclesCount == 0 and autoKickDisable == true then
			autoKickDisable = false
			log('i', "No vehicles found, afk kick is disabled")
		end
	end
end



function TimerSystem()
	check() -- If no vehicles we disable afk kicking and check if a player joined
	for playerID, afkTime in pairs(playersTimer) do -- For each player
		-- Variables
		local playerName = GetPlayerName(playerID)
		local kickEnabled = KICK_AFK_PLAYERS and autoKickDisable and not exemptPlayer(playerID)
		local spectator = isSpectating(playerID)

		-- Set the afk time according to spectating or not
		local maxAfkTime = MAX_AFK_TIME
		if spectator then maxAfkTime = MAX_SPECTATING_AFK_TIME end
		
		-- If a player exceed the afk time
		if afkTime >= maxAfkTime then
			-- If kick afk players and there is a least one vehicle and the player is not exempt
			if kickEnabled then
				DropPlayer(playerID, 'You have been afk for too long.') -- Bye
				log('i', "Player "..playerName.." was kicked for being afk")
			end
		elseif afkTime == WARN_MESSAGE_TIME then
			if kickEnabled then SendChatMessage(playerID, "Warning, you will get kicked in "..maxAfkTime - WARN_MESSAGE_TIME.." seconds if you don't move!") end
			-- If we broadcast afk players and is not a spectator or we broadcast spectator and is a spectator
			if (BROADCAST_AFK_PLAYERS and not spectator) or (BROADCAST_SPECTATING_AFK_PLAYERS and spectator) then
				SendChatMessage(-1, playerName.." is now afk")
			end
		end
		
		-- Leave a 5 seconds margin to prevent instant kick when spawning a vehicle
		if afkTime > maxAfkTime - 5 and not kickEnabled then return end
		-- Increment timer
		playersTimer[playerID] = afkTime + 1
	end
end



local function resetTimer(playerID)
	if BROADCAST_AFK_PLAYERS and playersTimer[playerID] > WARN_MESSAGE_TIME then
		SendChatMessage(-1, GetPlayerName(playerID).." is no longer afk")
	end
	playersTimer[playerID] = 0
end



local function onInit()
	log('i', "AntiAFK Initialising...")
	RegisterEvent("onPlayerJoin",		"onPlayerJoin")
	RegisterEvent("onPlayerDisconnect", "onPlayerDisconnect")
	RegisterEvent("onPlayerMoved", 		"onPlayerMoved")
	RegisterEvent("onVehicleEdited", 	"onVehicleEdited")
	RegisterEvent("onVehicleSpawned", 	"onVehicleSpawned")
	RegisterEvent("onChatMessage", 		"onChatMessage")
	CreateThread("TimerSystem", 1)
	log('s', "AntiAFK initialized")
end


 
function onPlayerJoin(playerID)
	resetTimer(playerID)
	if exemptPlayer(playerID) then
		log('i', "Joined player "..GetPlayerName(playerID).." is exempt from afk kick")
		SendChatMessage(playerID, "You are exempt from afk kick")
	end
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

function onVehicleSpawn(playerID, vehicleID, vehicleData)
	resetTimer(playerID)
end

function onChatMessage(playerID, senderName, message)
	resetTimer(playerID)
end

onInit()
