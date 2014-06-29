--[[
	- FairPlay Gaming: Roleplay
	
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
	
	(c) Copyright 2014 FairPlay Gaming. All rights reserved.
]]

local checkMD5s = {}
local timers = {}
local reconnecting = false
local g_motd = false
local connection = nil
local databaseConfig = {
	["type"] = "mysql",
	["hostname"] = "127.0.0.1",
	["database"] = "",
	["username"] = "",
	["password"] = ""
}

local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, false)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end, false, false
			)
		end
	end
end

addCommandHandler("setmotd",
	function(player, cmd, ...)
		if (not isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local message = table.concat({...}, " ")
			if (not ...) or (not message) or (#message <= 1) then
				outputChatBox("SYNTAX: /" .. cmd .. " [message of the day]", player, 210, 160, 25, false)
			else
				g_motd = message
				outputAdminLog(getPlayerName(player) .. " updated the Message of the Day.")
				
				for i,v in ipairs(getElementsByType("player")) do
					triggerClientEvent(v, ":_updateFreshMOTD_:", v, g_motd)
					if (isClientPlaying(v)) then
						triggerClientEvent(v, ":_addNewMessage_:", v, "MESSAGE OF THE DAY: " .. message, 35000)
					end
				end
				
				dbExec(connection, "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "config", "value", message, "key", "motd")
			end
		end
	end
)

addCommandHandler("motd",
	function(player, cmd)
		if (not isClientPlaying(player)) then return end
		if (not getElementData(player, "roleplay:temp.motdcmd")) then
			triggerClientEvent(player, ":_addNewMessage_:", player, "MESSAGE OF THE DAY: " .. g_motd)
		end
		setElementData(player, "roleplay:temp.motdcmd", 1, false)
		setTimer(function(player)
			if (isElement(player)) then
				removeElementData(player, "roleplay:temp.motdcmd")
			end
		end, 20000, 1, player)
	end
)

addCommandHandler("saveme",
	function(player, cmd)
		if (not isClientLoggedIn(player)) then return end
		if (not getElementData(player, "roleplay:accounts.lastsave")) then
			saveCharacter(player, true)
			setElementData(player, "roleplay:accounts.lastsave", 1, false)
			setTimer(function(player)
				removeElementData(player, "roleplay:accounts.lastsave")
			end, 60000, 1, player)
		else
			outputChatBox("You cannot save so often! Please wait for a minute or so and try again then.", player, 245, 20, 20, false)
		end
	end
)

function getSQLConnection()
	if (not reconnecting) then
		return connection
	else
		setTimer(getSQLConnection, 150, 1)
	end
end

function reconnectSQL()
	outputServerLog("Notice: MySQL reconnect incoming.")
	reconnecting = true
	destroyElement(connection)
	connection = dbConnect(databaseConfig["type"], "dbname=" .. databaseConfig["database"] .. ";host=" .. databaseConfig["hostname"], databaseConfig["username"], databaseConfig["password"])
	if (not connection) then
		outputServerLog("Error: MySQL connection is not established!")
		setTimer(reconnectSQL, 1500, 1)
	else
		reconnecting = false
		outputServerLog("Notice: MySQL connection is established!")
		testSQLConnection()
		loadKilledCharacters()
	end
	return true
end

function testSQLConnection()
	if (connection) then
		local query = dbQuery(connection, "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "value", "config", "key", "motd")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) and (type(result) == "table") then
				for result,row in pairs(result) do
					if (row["value"]) then
						outputServerLog("Notice: Connection is working!")
						g_motd = row["value"]
					end
				end
			else
				outputServerLog("Error: MySQL query failed.")
			end	
		else
			outputServerLog("Error: MySQL query failed.")
		end
	else
		outputServerLog("Error: Could not test the query connection due to no stable MySQL connection.")
		outputServerLog("... attempting a repair ...")
		connection = dbConnect(databaseConfig["type"], "dbname=" .. databaseConfig["database"] .. ";host=" .. databaseConfig["hostname"], databaseConfig["username"], databaseConfig["password"])
		if (not connection) then
			outputServerLog("... repair failed!")
		else
			outputServerLog("... repair successful!")
		end
	end
end

setTimer(function()
	for i,v in ipairs(getElementsByType("player")) do
		if (getPlayerPing(v) > 5000) and (isClientLoggedIn(v)) then
			outputAdminLog(getPlayerName(v) .. " was kicked for high ping (" .. getPlayerPing(v) .. "/5000).")
			kickPlayer(v, "Autokick: Lower your ping!")
		end
	end
end, 30000, 0)

addEventHandler("onResourceStart", resourceRoot,
	function()
		aclReload()
		connection = dbConnect(databaseConfig["type"], "dbname=" .. databaseConfig["database"] .. ";host=" .. databaseConfig["hostname"], databaseConfig["username"], databaseConfig["password"])
		
		if (not connection) then
			outputServerLog("Error: MySQL connection is not established!")
		else
			outputServerLog("Notice: MySQL connection is established!")
			testSQLConnection()
		end
		
		setTimer(function()
			reconnectSQL()
		end, 60000*5, 0)
		
		for i,v in ipairs(getElementsByType("player")) do
			if (isClientInTutorial(v)) then
				local x, y, z = tonumber(getElementData(v, "roleplay:temp.x")), tonumber(getElementData(v, "roleplay:temp.y")), tonumber(getElementData(v, "roleplay:temp.z"))
				setElementPosition(v, x, y, z)
				setElementInterior(v, 0)
				setElementDimension(v, 0)
				setCameraTarget(v, v)
				setElementRotation(v, 0, 0, 90)
				setElementFrozen(v, false)
				setElementData(v, "roleplay:accounts.state", 2, true)
				removeElementData(v, "roleplay:temp.md5rofl")
				removeElementData(v, "roleplay:temp.x")
				removeElementData(v, "roleplay:temp.y")
				removeElementData(v, "roleplay:temp.z")
				setElementData(v, "roleplay:accounts.option3", 1, false)
				dbExec(connection, "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "accounts", "option_3", 1, "id", getAccountID(v))
				toggleAllControls(v, true, true, true)
			end
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		if (isElement(connection)) then destroyElement(connection) end
		for i,v in ipairs(getElementsByType("player")) do
			if (isClientPlaying(v)) then
				saveCharacter(v)
			end
			if (getElementData(v, "roleplay:temp.motdcmd")) then
				removeElementData(v, "roleplay:temp.motdcmd")
			end
		end
	end
)

addEvent(":_raiseGameHour_:", true)
addEventHandler(":_raiseGameHour_:", root,
	function()
		if (source ~= client) then
			if (isElement(source)) then
				kickPlayer(source, "no cheat plz!!")
			end
			
			if (isElement(client)) then
				kickPlayer(client, "no cheat plz!")
			end
			
			return
		end
		
		--outputDebugString("Just a note: " .. getPlayerName(client) .. " played for +1 minute (total: " .. getCharacterTime(client) .. ").")
		setElementData(client, "roleplay:characters.stime", tonumber(getElementData(client, "roleplay:characters.stime"))+1, false)
		setElementData(client, "roleplay:characters.time", tonumber(getElementData(client, "roleplay:characters.time"))+1, false)
	end
)

addEventHandler("onPlayerQuit", root,
	function(type, reason, responsible)
		if (isClientLoggedIn(source) and isClientPlaying(source)) then
			saveCharacter(source)
		end
		
		if (not exports['roleplay-accounts']:isClientPlaying(source)) then return end
		if (type ~= "Kicked") and (type ~= "Banned") and (type ~= "Quit") then
			local x, y, z = getElementPosition(source)
			for i,v in ipairs(getElementsByType("player")) do
				if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) < 30) then
					outputChatBox(" (( " .. getRealPlayerName(source) .. " left the game [" .. type .. "] ))", v, 190, 190, 190, false)
				end
			end
		end
	end
)

addEvent(":_submitLogin_:", true)
addEventHandler(":_submitLogin_:", root,
	function(username, password)
		if (source ~= client) then return end
		if (username) and (password) then
			local loggedin, errmsg = isClientLoggedIn(client)
			if (not loggedin) then
				if (connection == nil) then
					outputServerLog("Error: Connection is not established. Couldn't finish login attempt (" .. getPlayerName(client) .. ")")
					return
				end
				
				local query = dbQuery(connection, "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "id", "accounts", "username", username)
				if (query) then
					local result, num_affected_rows, errmsg = dbPoll(query, -1)
					if (num_affected_rows > 0) then
						local query = dbQuery(connection, "SELECT * FROM `??` WHERE `??` = '??' AND `??` = '??' LIMIT 1", "accounts", "username", username, "password", sha256(string.upper(password)))
						if (query) then
							local result, num_affected_rows = dbPoll(query, -1)
							if (num_affected_rows > 0) then
								for result,row in pairs(result) do
									for _,player in ipairs(getElementsByType("player")) do
										if (getAccountID(player) == row["id"]) then
											triggerClientEvent(client, ":_onFailedLogin_:", client, 5)
											return
										end
									end
									
									local realtime = getRealTime()
									local timestamp = realtime.timestamp
									local query = dbExec(connection, "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "accounts", "loginDate", timestamp, "lastIP", getPlayerIP(client), "lastSerial", getPlayerSerial(client), "id", row["id"])
									if (query) then
										outputServerLog("Login: " .. getPlayerName(client) .. " logged in to the server as " .. _base64decode(username))
										setElementData(client, "roleplay:accounts.loggedin", 1, true)
										setElementData(client, "roleplay:accounts.id", row["id"], true)
										setElementData(client, "roleplay:accounts.username", username, true)
										setElementData(client, "roleplay:accounts.state", 1, true)
										setElementData(client, "roleplay:accounts.admin_level", row["admin_level"], true)
										setElementData(client, "roleplay:accounts.admin_state", row["admin_state"], true)
										setElementData(client, "roleplay:accounts.admin_hidden", row["admin_hidden"], true)
										setElementData(client, "roleplay:accounts.option1", row["option_1"], true)
										setElementData(client, "roleplay:accounts.option2", row["option_2"], true)
										setElementData(client, "roleplay:accounts.option3", row["option_3"], true)
										setElementData(client, "roleplay:accounts.option4", row["option_4"], true)
										setElementData(client, "roleplay:accounts.option5", row["option_5"], true)
										setElementData(client, "roleplay:accounts.option6", row["option_6"], true)
										setElementData(client, "roleplay:accounts.option7", row["option_7"], true)
										setElementData(client, "roleplay:accounts.option8", row["option_8"], true)
										setElementData(client, "roleplay:accounts.jailed", row["jailed"], true)
										setElementData(client, "roleplay:accounts.jailedReason", row["jailedReason"], true)
										setElementData(client, "roleplay:accounts.jailedBy", row["jailedBy"], true)
										
										triggerClientEvent(client, ":_placeTheRealSettings_:", client, fromJSON(row["settings"]))
										triggerClientEvent(client, ":_doLoginSuccess_:", client)
									else
										outputServerLog("Error: MySQL query failed when trying to save new login date (" .. getPlayerName(client) .. ").")
									end
									break
								end
							else
								triggerClientEvent(client, ":_onFailedLogin_:", client)
								outputServerLog("Error: " .. getPlayerName(client) .. " tried to log in, but failed due to an unknown username and/or password.")
							end
						else
							outputServerLog("Error: MySQL query failed (" .. getPlayerName(client) .. ").")
						end
					else
						local realtime = getRealTime()
						local timestamp = realtime.timestamp
						local query = dbExec(connection, "INSERT INTO `??` (`??`, `??`, `??`) VALUES ('??', '??', '??')", "accounts", "username", "password", "registerDate", username, sha256(string.upper(password)), timestamp)
						if (query) then
							outputServerLog("Register: " .. getPlayerName(client) .. " registered a new account as " .. _base64decode(username))
							triggerClientEvent(client, ":_doRegisterSuccess_:", client)
						else
							outputServerLog("Error: MySQL query failed when trying to create a new account (" .. getPlayerName(client) .. ").")
						end
					end
				else
					outputServerLog("Error: MySQL query failed (" .. getPlayerName(client) .. ").")
				end
			else
				outputServerLog("Error: " .. getPlayerName(client) .. " tried to log in, but is already logged in.")
			end
		else
			outputServerLog("Error: Not enough parameters used in the ':_submitLogin_:' function (" .. getPlayerName(client) .. ").")
		end
	end
)

addEvent(":_fetchFreshMOTD_:", true)
addEventHandler(":_fetchFreshMOTD_:", root,
	function()
		if (source ~= client) then return end
		triggerClientEvent(client, ":_updateFreshMOTD_:", client, g_motd)
	end
)

addEvent(":_doPatchBrokenData_:", true)
addEventHandler(":_doPatchBrokenData_:", root,
	function()
		if (source ~= client) then return end
		setElementData(client, "roleplay:accounts.loggedin", 0, true)
		setElementData(client, "roleplay:accounts.id", 0, true)
		setElementData(client, "roleplay:accounts.username", "0xF0", true)
		setElementData(client, "roleplay:accounts.state", 0, true)
		setElementData(client, "roleplay:accounts.admin_level", 0, true)
		setElementData(client, "roleplay:accounts.admin_state", 0, true)
		setElementData(client, "roleplay:accounts.admin_hidden", 0, true)
		setElementData(client, "roleplay:accounts.option1", 0, true)
		setElementData(client, "roleplay:accounts.option2", "both", true)
		setElementData(client, "roleplay:accounts.option3", 0, true)
		setElementData(client, "roleplay:accounts.option4", 0, true)
		setElementData(client, "roleplay:accounts.option5", 1, true)
		setElementData(client, "roleplay:accounts.option6", 0, true)
		setElementData(client, "roleplay:accounts.option7", 1, true)
		setElementData(client, "roleplay:accounts.option8", 1, true)
		setElementData(client, "roleplay:accounts.jailed", -1, true)
		setElementData(client, "roleplay:accounts.jailedReason", "", true)
		setElementData(client, "roleplay:accounts.jailedBy", 0, true)
	end
)

function exitGameMode(player)
	saveCharacter(player)
	
	if (isPedInVehicle(player)) then
		removePedFromVehicle(player)
	end
	
	setElementInterior(player, 0)
	setElementDimension(player, 60000)
	setElementPosition(player, 0, 0, 0)
	setElementFrozen(player, true)
	setElementAlpha(player, 0)
	setCameraInterior(player, 0)
	showChat(player, false)
	
	setElementData(player, "roleplay:accounts.state", 1, true)
	removeElementData(player, "roleplay:characters.id")
	removeElementData(player, "roleplay:characters.name")
	removeElementData(player, "roleplay:characters.gender")
	removeElementData(player, "roleplay:characters.description")
	removeElementData(player, "roleplay:characters.race")
	removeElementData(player, "roleplay:characters.bank")
	removeElementData(player, "roleplay:characters.faction")
	removeElementData(player, "roleplay:characters.faction:privileges")
	removeElementData(player, "roleplay:characters.faction:rank")
	removeElementData(player, "roleplay:characters.weight")
	removeElementData(player, "roleplay:characters.maxweight")
	removeElementData(player, "roleplay:characters.job")
	removeElementData(player, "roleplay:characters.time")
	removeElementData(player, "roleplay:characters.stime")
	removeElementData(player, "roleplay:characters.dmv:license")
	removeElementData(player, "roleplay:characters.dmv:manual")
	removeElementData(player, "roleplay:languages.1")
	removeElementData(player, "roleplay:languages.2")
	removeElementData(player, "roleplay:languages.3")
	removeElementData(player, "roleplay:languages.1skill")
	removeElementData(player, "roleplay:languages.2skill")
	removeElementData(player, "roleplay:languages.3skill")
	
	for i,v in pairs(getAllElementData(player)) do
		if (string.find(i, ":temp.")) then
			removeElementData(player, i)
		end
	end
	
	if (isTimer(timers[player])) then
		killTimer(timers[player])
	end
	
	triggerEvent(":_fuckJailTimer_:", player, 1)
	triggerClientEvent(player, ":_closeAllMenus_:", player)
	triggerClientEvent(player, ":_characterCreationResponse_:", player, 2)
	triggerClientEvent(player, ":_updateScoreboardBind_:", player, 1)
end

addEvent(":_finishForceExit_:", true)
addEventHandler(":_finishForceExit_:", root,
	function()
		if (source ~= client) then return end
		exitGameMode(client)
	end
)

addEvent(":_doCharacterCreate_:", true)
addEventHandler(":_doCharacterCreate_:", root,
	function(name, description, gender, race, model, age, height, weight, language)
		if (source ~= client) then return end
		if (name) and (description) and (gender) and (race) and (model) and (age) and (height) and (weight) and (language) then
			local loggedin, errmsg = isClientLoggedIn(client)
			if (loggedin) then
				if (connection == nil) then
					outputServerLog("Error: Connection is not established. Couldn't finish character creation attempt (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]).")
					return
				end
				
				local query = dbQuery(connection, "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "id", "characters", "characterName", name:gsub(" ", "_"))
				if (query) then
					local result, num_affected_rows, errmsg = dbPoll(query, -1)
					if (num_affected_rows == 0) then
						local timestamp = getRealTime().timestamp
						local query = dbQuery(connection, "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "characters", "characterName", "registerDate", "gender", "race", "model", "description", "age", "height", "weight", "userID", name:gsub(" ", "_"), timestamp, gender, race, model, description, age, height, weight, getAccountID(client))
						if (query) then
							local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
							dbExec(connection, "INSERT INTO `??` (`??`, `??`) VALUES ('??', '??')", "languages", "lang1", "charID", language, last_insert_id)
							triggerClientEvent(client, ":_characterCreationResponse_:", client, 1)
							outputServerLog("Character: " .. getPlayerName(client) .. " [" .. getAccountName(client) .. "] created a new character with name '" .. name:gsub(" ", "_") .. "'.")
						else
							outputServerLog("Error: MySQL query failed when inserting new character to database (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]).")
						end
					else
						-- Character name is in use
						triggerClientEvent(client, ":_characterCreationResponse_:", client, 0)
					end
				else
					outputServerLog("Error: MySQL query failed when checking for similiar characters (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]).")
				end
			else
				outputServerLog("Error: (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]) tried to create a character, but isn't logged in. Reconnecting player...")
				redirectPlayer(client, getServerIP(), 22003)
			end
		else
			outputServerLog("Error: Not enough parameters used in the ':_doCharacterCreate_:' function (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]).")
		end
	end
)

addEvent(":_printCharacterError_:", true)
addEventHandler(":_printCharacterError_:", root,
	function(name, restrict)
		if (source ~= client) then return end
		outputServerLog("Error: (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]) tried to create a new character, but failed because of the name being restricted...")
		outputServerLog(" - Error Details: (NAME: " .. name .. ") (RESTRICTED: " .. restrict .. ").")
	end
)

addEvent(":_fetchUserCharacters_:", true)
addEventHandler(":_fetchUserCharacters_:", root,
	function()
		if (source ~= client) then return end
		if (isClientLoggedIn(client)) then
			local query = dbQuery(connection, "SELECT `??`, `??`, `??`, `??`, `??` FROM `??` WHERE `??` = '??'", "characterName", "gender", "race", "loginDate", "cked", "characters", "userID", getAccountID(client))
			if (query) then
				local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
				triggerClientEvent(client, ":_addUserCharacters_:", client, result, num_affected_rows)
				outputServerLog("Character: " .. getPlayerName(client) .. " [" .. getAccountName(client) .. "] fetched all characters on their account (" .. num_affected_rows .. " characters sent).")
			else
				outputServerLog("Error: MySQL query failed when fetching the new character ID from database (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]).")
			end
		else
			outputServerLog("Error: (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]) tried to fetch characters, but isn't logged in. Reconnecting player...")
			redirectPlayer(client, getServerIP(), 22003)
		end
	end
)

addEvent(":_setCurrentCharacter_:", true)
addEventHandler(":_setCurrentCharacter_:", root,
	function(characterName)
		if (source ~= client) then return end
		local loggedin, errmsg = isClientLoggedIn(client)
		if (loggedin) then
			local query = dbQuery(connection, "SELECT * FROM `??` WHERE `??` = '??' AND `??` = '??' LIMIT 1", "characters", "characterName", characterName, "userID", getAccountID(client))
			if (query) then
				local result, num_affected_rows, errmsg = dbPoll(query, -1)
				if (num_affected_rows > 0) then
					for result,row in pairs(result) do
						if (row["cked"] == 0) then -- Nasty freaks trying to get through with injections >:)
							for i=1,50 do
								outputChatBox(" ", client)
							end
							
							setPlayerName(client, row["characterName"])
							spawnPlayer(client, row["posX"], row["posY"], row["posZ"], row["rotZ"], row["model"], row["interior"], row["dimension"], nil)
							setElementRotation(client, row["rotX"], row["rotY"], row["rotZ"])
							setElementFrozen(client, false)
							setElementAlpha(client, 255)
							setPlayerMoney(client, row["cash"])
							setCameraTarget(client, client)
							
							setElementData(client, "roleplay:characters.id", row["id"], false)
							setElementData(client, "roleplay:characters.name", row["characterName"], false)
							setElementData(client, "roleplay:characters.gender", row["gender"], false)
							setElementData(client, "roleplay:characters.race", row["race"], false)
							setElementData(client, "roleplay:characters.bank", row["bank"], false)
							setElementData(client, "roleplay:characters.weight", 0, true)
							setElementData(client, "roleplay:characters.maxweight", 10, true)
							setElementData(client, "roleplay:characters.job", row["jobID"], true)
							setElementData(client, "roleplay:characters.time", row["playedTime"], false)
							setElementData(client, "roleplay:characters.stime", 0, false)
							setElementData(client, "roleplay:characters.dmv:license", row["driversLicense"], true)
							setElementData(client, "roleplay:characters.dmv:manual", row["transmissionLicense"], true)
							
							-- Faction
							setElementData(client, "roleplay:characters.faction", row["factionID"], true)
							setElementData(client, "roleplay:characters.faction:privileges", row["factionPrivileges"], true)
							setElementData(client, "roleplay:characters.faction:rank", row["factionRank"], true)
							
							local faction = exports['roleplay-factions']:getFactionByID(row["factionID"])
							if (faction) then
								setPlayerTeam(client, faction)
							end
							
							-- Languages
							local query2 = dbQuery(connection, "SELECT * FROM `??` WHERE `??` = '??'", "languages", "charID", tonumber(getElementData(client, "roleplay:characters.id")))
							local result2, num_affected_rows2 = dbPoll(query2, -1)
							if (num_affected_rows2 ~= 0) then
								for _,row2 in pairs(result2) do
									setElementData(client, "roleplay:languages.1", row2["lang1"], true)
									setElementData(client, "roleplay:languages.1skill", row2["skill1"], true)
									setElementData(client, "roleplay:languages.2", row2["lang2"], true)
									setElementData(client, "roleplay:languages.2skill", row2["skill2"], true)
									setElementData(client, "roleplay:languages.3", row2["lang3"], true)
									setElementData(client, "roleplay:languages.3skill", row2["skill3"], true)
								end
							else
								setElementData(client, "roleplay:languages.1", 1, true)
								setElementData(client, "roleplay:languages.1skill", 100, true)
								setElementData(client, "roleplay:languages.2", 0, true)
								setElementData(client, "roleplay:languages.2skill", 0, true)
								setElementData(client, "roleplay:languages.3", 0, true)
								setElementData(client, "roleplay:languages.3skill", 0, true)
							end
							
							exports['roleplay-items']:loadItems(client)
							
							if (tonumber(getElementData(client, "roleplay:accounts.option3")) == 1) then
								setElementData(client, "roleplay:accounts.state", 2, true)
								if (row["loginDate"] ~= "0") then
									outputChatBox("Your last login was on " .. row["loginDate"] .. ".", client, 240, 225, 30, false)
									outputChatBox("Welcome back, " .. getRealPlayerName(client) .. ".", client, 240, 225, 30, false)
								else
									outputChatBox("Welcome to your new character, " .. getRealPlayerName(client) .. ".", client, 240, 225, 30, false)
								end
							else
								local md5player = string.sub(md5(getRealTime().timestamp), 10)
								setElementData(client, "roleplay:accounts.state", 3, true)
								setElementData(client, "roleplay:temp.md5rofl", md5player, false)
								setElementData(client, "roleplay:temp.x", row["posX"], false)
								setElementData(client, "roleplay:temp.y", row["posY"], false)
								setElementData(client, "roleplay:temp.z", row["posZ"], false)
								checkMD5s[client] = md5player
								toggleAllControls(client, false, true, true)
								outputChatBox("Welcome to roleplay, " .. getPlayerName(client):gsub("_", " ") .. "!", client, 240, 225, 30, false)
								outputChatBox("You can find our server rules and information by pressing TAB button on your keyboard. Have fun and enjoy!", client, 240, 225, 30, false)
							end
							
							dbExec(connection, "UPDATE `??` SET `??` = NOW() WHERE `??` = '??'", "characters", "loginDate", "id", row["id"])
							
							if (tonumber(getElementData(client, "roleplay:accounts.option3")) == 1) then
								triggerClientEvent(client, ":_spawnPlayerSuccess_:", client, row["posX"], row["posY"], row["posZ"], false)
							else
								triggerClientEvent(client, ":_spawnPlayerSuccess_:", client, row["posX"], row["posY"], row["posZ"], true)
							end
							
							triggerClientEvent(client, ":_updateScoreboardBind_:", client)
							triggerClientEvent(client, ":_updateAccountSettings_:", client)
							triggerEvent(":_getRealJobs_:", client)
							
							if (tonumber(getElementData(client, "roleplay:accounts.jailed"))) and (tonumber(getElementData(client, "roleplay:accounts.jailed")) > -1) then
								triggerEvent(":_initializeJailTimer_:", client)
							end
							
							outputServerLog("Character: " .. getPlayerName(client) .. " [" .. getAccountName(client) .. "] loaded their character '" .. characterName .. "' and is now spawning.")
						else
							triggerClientEvent(client, ":_itsackdchardammit_:", client)
							outputChatBox("That character has been character killed. Please select or create another one.", client, 245, 20, 20, false)
						end
						break
					end
				else
					outputServerLog("Error: MySQL query resulted nothing when trying to fetch info from database with '" .. characterName .. "' (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]).")
				end
			else
				outputServerLog("Error: MySQL query failed when spawning a new character '" .. characterName .. "' (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]).")
			end
		else
			outputServerLog("Error: (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]) tried to fetch characters, but isn't logged in. Reconnecting player...")
			redirectPlayer(client, getServerIP(), 22003)
		end
	end
)

addEvent(":_makeMeWorkOK_:", true)
addEventHandler(":_makeMeWorkOK_:", root,
	function(x, y, z)
		if (source ~= client) then return end
		if (getElementData(client, "roleplay:temp.md5rofl")) and (isClientInTutorial(client)) and (checkMD5s[client]) and (checkMD5s[client] == getElementData(client, "roleplay:temp.md5rofl")) then
			setElementPosition(client, x, y, z)
			setElementRotation(client, 0, 0, 90)
			setElementData(client, "roleplay:accounts.state", 2, true)
			removeElementData(client, "roleplay:temp.md5rofl")
			removeElementData(client, "roleplay:temp.x")
			removeElementData(client, "roleplay:temp.y")
			removeElementData(client, "roleplay:temp.z")
			setElementData(client, "roleplay:accounts.option3", 1, false)
			checkMD5s[client] = nil
			dbExec(connection, "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "accounts", "option_3", 1, "id", getAccountID(client))
			toggleAllControls(client, true, true, true)
		else
			if (isClientLeader(client)) then return end
			outputAdminLog(getPlayerName(client) .. " tried to abuse the tutorial system to become an in-game player.", 5)
		end
	end
)

addEvent(":_updateAccountSettings_:", true)
addEventHandler(":_updateAccountSettings_:", root,
	function(x, y, z)
		if (source ~= client) then return end
		if (getElementData(client, "roleplay:temp.md5rofl")) and (isClientInTutorial(client)) and (checkMD5s[client]) and (checkMD5s[client] == getElementData(client, "roleplay:temp.md5rofl")) then
			setElementPosition(client, x, y, z)
			setElementRotation(client, 0, 0, 90)
			setElementData(client, "roleplay:accounts.state", 2, true)
			removeElementData(client, "roleplay:temp.md5rofl")
			removeElementData(client, "roleplay:temp.x")
			removeElementData(client, "roleplay:temp.y")
			removeElementData(client, "roleplay:temp.z")
			setElementData(client, "roleplay:accounts.option3", 1, false)
			checkMD5s[client] = nil
			dbExec(connection, "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "accounts", "option_3", 1, "id", getAccountID(client))
			toggleAllControls(client, true, true, true)
		else
			if (isClientLeader(client)) then return end
			outputAdminLog(getPlayerName(client) .. " tried to abuse the tutorial system to become an in-game player.", 5)
		end
	end
)

addEvent(":_updateAccountSettingsF10_:", true)
addEventHandler(":_updateAccountSettingsF10_:", root,
	function(watershader, nametags, gtadefault, customradio, chatbubbles)
		if (watershader) then
			setElementData(source, "roleplay:accounts.option4", 1, true)
		else
			setElementData(source, "roleplay:accounts.option4", 0, true)
		end
		
		if (nametags) then
			setElementData(source, "roleplay:accounts.option5", 1, true)
		else
			setElementData(source, "roleplay:accounts.option5", 0, true)
		end
		
		if (gtadefault) then
			setElementData(source, "roleplay:accounts.option6", 1, true)
		else
			setElementData(source, "roleplay:accounts.option6", 0, true)
		end
		
		if (customradio) then
			setElementData(source, "roleplay:accounts.option7", 1, true)
		else
			setElementData(source, "roleplay:accounts.option7", 0, true)
		end
		
		if (chatbubbles) then
			setElementData(source, "roleplay:accounts.option8", 1, true)
		else
			setElementData(source, "roleplay:accounts.option8", 0, true)
		end
		
		triggerClientEvent(source, ":_updateAccountSettings_:", source)
	end
)

addEventHandler("onPlayerChangeNick", root,
	function(old, new)
		if (string.find(new, exports['roleplay-anticheat']:getSafeNamePrefix() .. ".")) then return end
		cancelEvent()
		outputChatBox("Sorry, but we do not allow the change of nicknames on our server. Disconnect and change your nickname then instead.", source, 245, 20, 20, false)
	end
)

addEvent(":_doDeleteCharacter_:", true)
addEventHandler(":_doDeleteCharacter_:", root,
	function(characterName)
		if (source ~= client) then return end
		local loggedin, errmsg = isClientLoggedIn(client)
		if (loggedin) then
			local query = dbQuery(getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' AND `??` = '??' LIMIT 1", "id", "characters", "characterName", characterName, "userID", getAccountID(client))
			if (query) then
				local result = dbPoll(query, -1)
				for result,row in pairs(result) do
					dbExec(getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "languages", "charID", row["id"])
					dbExec(getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "characters", "id", row["id"])
					if (query) then
						triggerClientEvent(client, ":_deleteCharacterSuccess_:", client)
						outputServerLog("Character: " .. getPlayerName(client) .. " [" .. getAccountName(client) .. "] deleted a character on their account (" .. characterName .. ").")
					end
				end
			end
		else
			outputServerLog("Error: (" .. getPlayerName(client) .. " [" .. getAccountName(client) .. "]) tried to delete a character, but isn't logged in. Reconnecting player...")
			redirectPlayer(client)
		end
	end
)
