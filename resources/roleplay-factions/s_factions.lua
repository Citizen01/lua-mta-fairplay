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

local factionTimer = {}
local factionTypes = {
	[1] = {"Law", 			1000000},
	[2] = {"Medical", 		1000000},
	[3] = {"Government",	1000000},
	[4] = {"News",			0},
	[5] = {"Gang",			0},
	[6] = {"Mafia",			0},
	[7] = {"Triad",			0},
	[8] = {"Other",			0}
}

function loadFactions()
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "factions")
	if (query) then
		local result, num_affected_rows, errmsg = dbPoll(query, -1)
		if (num_affected_rows > 0) then
			if (num_affected_rows == 1) then
				outputDebugString("1 faction loaded.")
			else
				outputDebugString(num_affected_rows .. " factions are about to be loaded.")
			end
			
			for result,row in pairs(result) do
				local faction = createTeam(row["name"])
				setElementData(faction, "roleplay:factions.id", row["id"], false)
				setElementData(faction, "roleplay:factions.type", row["type"], false)
				setElementData(faction, "roleplay:factions.name", row["name"], false)
				setElementData(faction, "roleplay:factions.description", row["description"], false)
				setElementData(faction, "roleplay:factions.motd", row["motd"], false)
				setElementData(faction, "roleplay:factions.ranks", row["ranks"], false)
				setElementData(faction, "roleplay:factions.wages", row["wages"], false)
				setElementData(faction, "roleplay:factions.cooldown", 0, false)
				setElementData(faction, "roleplay:factions.invites", row["inviteCount"], false)
				setElementData(faction, "roleplay:factions.bank", row["bankValue"], false)
				
				for _,player in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:getPlayerFaction(player)) then
						if (exports['roleplay-accounts']:getPlayerFaction(player) == row["id"]) then
							setPlayerTeam(player, faction)
						end
					end
				end
			end
		else
			outputDebugString("0 factions loaded. Does the factions table contain data and are the settings correct?")
		end
	end
end

function refreshFactionMenu(factionID)
	for i,v in ipairs(getElementsByType("player")) do
		if (exports['roleplay-accounts']:getPlayerFaction(v) == factionID) then
			if (getElementData(v, "roleplay:gui.isFactionMenu")) then
				triggerClientEvent(v, ":_closeFactionMenu_:", v)
				removeElementData(v, "roleplay:gui.isFactionMenu")
				showFactionMenu(v)
			end
		end
	end
end

local amountsUsed = {}
function showFactionMenu(player)
	if (not player) or (not isElement(player)) or (getElementType(player) ~= "player") then return end
	if (getElementData(player, "roleplay:gui.isFactionMenu")) then
		triggerClientEvent(player, ":_closeFactionMenu_:", player)
		removeElementData(player, "roleplay:gui.isFactionMenu")
	else
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local factionID = exports['roleplay-accounts']:getPlayerFaction(player)
		local faction = getFactionByID(factionID)
		if (not factionID) or (not faction) then
			outputChatBox("You're not in a faction.", player, 245, 20, 20, false)
			return
		end
		
		if (amountsUsed[player]) and (amountsUsed[player] >= 2) then
			outputChatBox("Please wait before using the faction menu again.", player, 245, 20, 20, false)
			return
		else
			amountsUsed[player] = (amountsUsed[player] and amountsUsed[player]+1 or 1)
		end
		
		local factionName = getFactionName(faction)
		local factionType = getFactionType(faction)
		local factionMOTD = getFactionMOTD(faction)
		local factionRanks = getFactionRanks(faction)
		local factionWages = getFactionWages(faction)
		local factionPlayers = {}
		
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??`, `??`, `??`, `??`, DATEDIFF(NOW(), `??`) AS `??` FROM `??` WHERE `??` = '??' ORDER BY `??` DESC, `??` ASC", "id", "characterName", "factionRank", "factionPrivileges", "loginDate", "loginDate", "characters", "factionID", factionID, "factionRank", "characterName")
		if (not query) then
			outputChatBox("An error occured when tried to fetch faction members.", player, 245, 20, 20, false)
			return
		end
		
		local result, num_affected_rows = dbPoll(query, -1)
		if (not result) then
			outputChatBox("An error occured when tried to fetch faction members.", player, 245, 20, 20, false)
			return
		elseif (num_affected_rows == 0) then
			outputChatBox("You're not in a faction.", player, 245, 20, 20, false)
			return
		end
		
		for _,row in pairs(result) do
			table.insert(factionPlayers, {
				["id"] = row["id"],
				["name"] = row["characterName"],
				["rank"] = row["factionRank"],
				["privileges"] = row["factionPrivileges"],
				["lastOnline"] = row["lastOnline"]
			})
		end
		
		setElementData(player, "roleplay:gui.isFactionMenu", 1, false)
		triggerClientEvent(player, ":_showFactionMenu_:", player, factionID, factionName, factionType, factionMOTD, factionRanks, factionWages, factionPlayers)
		setTimer(function(player) if (not isElement(player)) then amountsUsed[player] = nil else amountsUsed[player] = 0 end end, 3000, 1, player)
	end
end

addEvent(":_syncFactionChange_:", true)
addEventHandler(":_syncFactionChange_:", root,
	function(type, ...)
		local type = tonumber(type)
		if (source ~= client) or (not type) or (type <= 0) or (type > 6) then return end
		local factionID = exports['roleplay-accounts']:getPlayerFaction(client)
		local faction = getFactionByID(factionID)
		if (not factionID) or (not faction) or (not exports['roleplay-accounts']:getFactionPrivileges(client)) then
			outputChatBox("You're not in a faction.", client, 245, 20, 20, false)
			return
		end
		
		if (exports['roleplay-accounts']:getFactionPrivileges(client) <= 0) then
			outputChatBox("Your privileges are too low for that action.", client, 245, 20, 20, false)
			return
		end
		
		local args = {...}
		
		if (type == 1) then
			local newMotd = args[1]
			setElementData(faction, "roleplay:factions.motd", newMotd, false)
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "factions", "motd", newMotd, "id", factionID)
			
			for i,v in ipairs(getPlayersInTeam(faction)) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" [FactionAct] " .. getPlayerName(client):gsub("_", " ") .. " updated the Message of the Day.", v, 50, 210, 220, false)
				end
			end
		elseif (type == 2) then
			local newRanks = toJSON(args[1])
			local newWages = toJSON(args[2])
			setElementData(faction, "roleplay:factions.ranks", newRanks, false)
			setElementData(faction, "roleplay:factions.wages", newWages, false)
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??' WHERE `??` = '??'", "factions", "ranks", newRanks, "wages", newWages, "id", factionID)
			
			for i,v in ipairs(getPlayersInTeam(faction)) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" [FactionAct] " .. getPlayerName(client):gsub("_", " ") .. " updated the ranks.", v, 50, 210, 220, false)
				end
			end
		elseif (type == 3) then
			local charName = args[1]:gsub(" ", "_")
			local newRank = args[2]
			local ranks = fromJSON(getFactionRanks(faction))
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??' AND `??` = '??'", "characters", "factionRank", newRank, "characterName", charName, "factionID", factionID)
			
			local player = getPlayerFromName(charName)
			if (player) then
				setElementData(player, "roleplay:characters.faction:rank", newRank, true)
			end
			
			for i,v in ipairs(getPlayersInTeam(faction)) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" [FactionAct] " .. getPlayerName(client):gsub("_", " ") .. " set " .. exports['roleplay-accounts']:getRealPlayerName(charName) .. " rank to \"" .. ranks[newRank] .. "\".", v, 50, 210, 220, false)
				end
			end
		elseif (type == 4) then
			local charName = args[1]:gsub(" ", "_")
			local newRights = args[2]-1
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??' AND `??` = '??'", "characters", "factionPrivileges", newRights, "characterName", charName, "factionID", factionID)
			
			local player = getPlayerFromName(charName)
			if (player) then
				setElementData(player, "roleplay:characters.faction:privileges", newRights, true)
			end
			
			for i,v in ipairs(getPlayersInTeam(faction)) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" [FactionAct] " .. getPlayerName(client):gsub("_", " ") .. " set " .. exports['roleplay-accounts']:getRealPlayerName(charName) .. " rights to \"" .. (newRights == 0 and "Member" or (newRights == 1 and "Leader" or "Owner")) .. "\".", v, 50, 210, 220, false)
				end
			end
		elseif (type == 5) then
			for _,vehicle in ipairs(getElementsByType("vehicle")) do
				if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) then
					if (exports['roleplay-vehicles']:getVehicleFaction(vehicle)) and (exports['roleplay-vehicles']:getVehicleFaction(vehicle) == factionID) then
						if (exports['roleplay-vehicles']:isVehicleEmpty(vehicle)) then
							fixVehicle(vehicle)
							setVehicleEngineState(vehicle, false)
							setVehicleOverrideLights(vehicle, 1)
							setElementFrozen(vehicle, true)
							setVehicleLocked(vehicle, true)
							setElementData(vehicle, "roleplay:vehicles.fuel", 100, true)
							setElementData(vehicle, "roleplay:vehicles.fuel;", 100, true)
							setElementData(vehicle, "roleplay:vehicles.engine", 0, true)
							setElementData(vehicle, "roleplay:vehicles.winstate", 0, true)
							setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
							setElementData(vehicle, "roleplay:vehicles.handbrake", 1, true)
							respawnVehicle(vehicle)
						end
					end
				end
			end
			
			for i,v in ipairs(getPlayersInTeam(faction)) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" [FactionAct] " .. getPlayerName(client):gsub("_", " ") .. " respawned all unoccupied vehicles.", v, 50, 210, 220, false)
				end
			end
		elseif (type == 6) then
			local vehicleID = args[1]
			local vehicle = exports['roleplay-vehicles']:getVehicle(vehicleID)
			if (vehicle) then
				if (exports['roleplay-vehicles']:getVehicleFaction(vehicle)) and (exports['roleplay-vehicles']:getVehicleFaction(vehicle) == factionID) then
					fixVehicle(vehicle)
					setVehicleEngineState(vehicle, false)
					setVehicleOverrideLights(vehicle, 1)
					setElementFrozen(vehicle, true)
					setVehicleLocked(vehicle, true)
					setElementData(vehicle, "roleplay:vehicles.fuel", 100, true)
					setElementData(vehicle, "roleplay:vehicles.fuel;", 100, true)
					setElementData(vehicle, "roleplay:vehicles.engine", 0, true)
					setElementData(vehicle, "roleplay:vehicles.winstate", 0, true)
					setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
					setElementData(vehicle, "roleplay:vehicles.handbrake", 1, true)
					respawnVehicle(vehicle)
				else
					outputChatBox("Couldn't find such vehicle with that ID.", client, 245, 20, 20, false)
				return
				end
			else
				outputChatBox("Couldn't find such vehicle with that ID.", client, 245, 20, 20, false)
				return
			end
			
			for i,v in ipairs(getPlayersInTeam(faction)) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" [FactionAct] " .. getPlayerName(client):gsub("_", " ") .. " respawned vehicle ID " .. vehicleID .. " (" .. getVehicleName(vehicle) .. ").", v, 50, 210, 220, false)
				end
			end
		else
			return
		end
		
		refreshFactionMenu(factionID)
	end
)

addEvent(":_invitePlayerToFaction_:", true)
addEventHandler(":_invitePlayerToFaction_:", root,
	function(player)
		if (source ~= client) or (not player) or (not isElement(player)) or (getElementType(player) ~= "player") or (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local factionID = exports['roleplay-accounts']:getPlayerFaction(client)
		local faction = getFactionByID(factionID)
		if (not factionID) or (not faction) or (not exports['roleplay-accounts']:getFactionPrivileges(client)) then
			outputChatBox("You're not in a faction.", client, 245, 20, 20, false)
			return
		end
		
		if (exports['roleplay-accounts']:getFactionPrivileges(client) <= 0) then
			outputChatBox("Your privileges are too low for that action.", client, 245, 20, 20, false)
			return
		end
		
		if (exports['roleplay-accounts']:getPlayerFaction(player)) then
			outputChatBox("That player is already in a faction.", client, 245, 20, 20, false)
			return
		end
		
		if (getElementData(player, "roleplay:temp.isInvited")) then
			outputChatBox("That player is already invited to a faction.", client, 245, 20, 20, false)
			return
		end
		
		setElementData(player, "roleplay:temp.isInvited", 1, true)
		triggerClientEvent(player, ":_doInviteWindow_:", player, getPlayerName(client):gsub("_", " "), getFactionName(faction), factionID)
	end
)

addEvent(":_factionInviteResult_:", true)
addEventHandler(":_factionInviteResult_:", root,
	function(acceptOrDecline, byPlayer, factionID)
		local factionID = tonumber(factionID)
		if (source ~= client) or (not byPlayer) or (not factionID) then return end
		local faction = getFactionByID(factionID)
		if (not faction) then
			outputChatBox("That's not a faction any longer.", client, 245, 20, 20, false)
			return
		end
		
		if (exports['roleplay-accounts']:getPlayerFaction(client)) then
			outputChatBox("You're already in a faction.", client, 245, 20, 20, false)
			return
		end
		
		if (not getElementData(player, "roleplay:temp.isInvited")) then
			outputChatBox("Your invitation session has expired, try again.", client, 245, 20, 20, false)
			return
		end
		
		local by = getPlayerFromName(byPlayer:gsub(" ", "_"))
		if (by) then
			local _factionID = exports['roleplay-accounts']:getPlayerFaction(by)
			if (not _factionID) or (_factionID and _factionID ~= factionID) then
				outputChatBox("Unfortunately this invitation session expired as the source left the faction.", client, 245, 20, 20, false)
				return
			end
		end
		
		removeElementData(client, "roleplay:temp.isInvited")
		
		if (acceptOrDecline == 1) then
			for i,v in ipairs(getPlayersInTeam(faction)) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" [FactionAct] " .. byPlayer:gsub("_", " ") .. " invited " .. getPlayerName(client):gsub("_", " ") .. " to the faction.", v, 50, 210, 220, false)
				end
			end
			
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "characters", "factionID", factionID, "factionPrivileges", 0, "factionRank", 1, "id", exports['roleplay-accounts']:getCharacterID(client))
			setElementData(client, "roleplay:characters.faction", factionID, true)
			setElementData(client, "roleplay:characters.faction:privileges", 0, true)
			setElementData(client, "roleplay:characters.faction:rank", 1, true)
			setPlayerTeam(client, faction)
		else
			if (by) then
				outputChatBox(getPlayerName(client):gsub("_", " ") .. " declined your faction invitation.", by, 245, 20, 20, false)
			end
		end
	end
)

addEventHandler( "onPlayerJoin", root,
	function( )
		bindKey( source, "F1", "down", showFactionMenu )
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		loadFactions()
		for i,v in ipairs(getElementsByType("player")) do
			bindKey(v, "F1", "down", showFactionMenu)
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			unbindKey(v, "F1", "down", showFactionMenu)
			if (getElementData(v, "roleplay:gui.isFactionMenu")) then
				removeElementData(v, "roleplay:gui.isFactionMenu")
			end
		end
	end
)

addEvent(":_closeFactionMenu_:", true)
addEventHandler(":_closeFactionMenu_:", root,
	function()
		triggerClientEvent(source, ":_closeFactionMenu_:", source)
		if (getElementData(source, "roleplay:gui.isFactionMenu")) then
			removeElementData(source, "roleplay:gui.isFactionMenu")
		end
	end
)

-- Commands
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

MTAoutputChatBox = outputChatBox
function outputLongChatBox(text, visibleTo, r, g, b, colorCoded)
	if (string.len(text) > 120) then
		MTAoutputChatBox(string.sub(text, 1, 119), visibleTo, r, g, b, colorCoded)
		outputChatBox(" " .. string.sub(text, 120), visibleTo, r, g, b, colorCoded)
	else
		MTAoutputChatBox(text, visibleTo, r, g, b, colorCoded)
	end
end

addCommandHandler({"createfaction", "makefaction", "addfaction"},
	function(player, cmd, factionType, ...)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local factionType = tonumber(factionType)
			if (not factionType) or (not ...) or (factionType and not factionTypes[factionType]) then
				outputChatBox("SYNTAX: /" .. cmd .. " [faction type] [faction name]", player, 210, 160, 25, false)
				outputChatBox("Faction types: 1 = law, 2 = medical, 3 = gov, 4 = news, 5 = gang, 6 = mafia, 7 = triad, 8 = other/biz", player, 210, 160, 25, false)
			else
				local name = table.concat({...}, " ")
				if (#name > 1) then
					if (getFactionByName(name)) then
						outputChatBox("There is another faction with that name already.", player, 245, 20, 20, false)
					else
						local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (name, type, bankValue, motd) VALUES ('??', '??', '??', '??')", "factions", name, factionType, factionTypes[factionType][2], "Welcome to the faction menu!")
						if (query) then
							local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
							local faction = createTeam(name)
							setElementData(faction, "roleplay:factions.id", last_insert_id, true)
							setElementData(faction, "roleplay:factions.type", factionType, true)
							setElementData(faction, "roleplay:factions.name", name, true)
							setElementData(faction, "roleplay:factions.description", "", true)
							setElementData(faction, "roleplay:factions.motd", "Welcome to the faction menu!", true)
							setElementData(faction, "roleplay:factions.ranks", '[ [ "Rank 1", "Rank 2", "Rank 3", "Rank 4", "Rank 5", "Rank 6", "Rank 7", "Rank 8", "Rank 9", "Rank 10", "Rank 11", "Rank 12", "Rank 13", "Rank 14", "Rank 15", "Rank 16", "Rank 17", "Rank 18", "Rank 19", "Rank 20" ] ]', true)
							setElementData(faction, "roleplay:factions.wages", '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]', true)
							setElementData(faction, "roleplay:factions.cooldown", 0, true)
							setElementData(faction, "roleplay:factions.invites", 0, true)
							setElementData(faction, "roleplay:factions.bank", factionTypes[factionType][2], true)
							
							outputLongChatBox("You created a faction with ID " .. last_insert_id .. " and name \"" .. name .. "\".", player, 20, 245, 20, false)
							outputServerLog("Factions: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new faction with ID " .. last_insert_id .. " and name \"" .. name .. "\".")
						end
					end
				else
					outputChatBox("SYNTAX: /" .. cmd .. " [faction type] [faction name]", player, 210, 160, 25, false)
					outputChatBox("Faction types: 1 = law, 2 = medical, 3 = gov, 4 = news, 5 = gang, 6 = mafia, 7 = triad, 8 = other/biz", player, 210, 160, 25, false)
				end
			end
		end
	end
)

addCommandHandler("setfaction",
	function(player, cmd, name, factionID)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local factionID = tonumber(factionID)
			if (not name) or (not factionID) or (factionID and factionID < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [faction id]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (factionID == exports['roleplay-accounts']:getPlayerFaction(target)) then
						if (factionID ~= 0) then
							outputChatBox("That player is already in that faction.", player, 245, 20, 20, false)
						else
							outputChatBox("That player is not in a faction.", player, 245, 20, 20, false)
						end
						return
					end
					
					local faction = getFactionByID(factionID)
					if (faction) or (factionID == 0) then
						dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "characters", "factionID", factionID, "factionPrivileges", 0, "factionRank", 1, "id", exports['roleplay-accounts']:getCharacterID(target))
						if (factionID ~= 0) then
							setPlayerTeam(target, getFactionByID(factionID))
							setElementData(target, "roleplay:characters.faction", factionID, true)
							setElementData(target, "roleplay:characters.faction:privileges", 0, true)
							setElementData(target, "roleplay:characters.faction:rank", 1, true)
							outputLongChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " faction to '" .. getFactionName(faction) .. "' (" .. factionID .. ").", player, 20, 245, 20, false)
							outputLongChatBox("Administrator set you to faction '" .. getFactionName(faction) .. "'.", target, 20, 245, 20, false)
							outputServerLog("Factions: " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " to faction '" .. getFactionName(faction) .. "' (" .. exports['roleplay-accounts']:getPlayerFaction(target) .. ").")
							refreshFactionMenu(exports['roleplay-accounts']:getPlayerFaction(target))
							refreshFactionMenu(factionID)
						else
							if (exports['roleplay-accounts']:getPlayerFaction(target)) then
								setPlayerTeam(target, nil)
								setElementData(target, "roleplay:characters.faction", factionID, true)
								setElementData(target, "roleplay:characters.faction:privileges", 0, true)
								setElementData(target, "roleplay:characters.faction:rank", 1, true)
								outputChatBox("You removed " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " from their faction.", player, 20, 245, 20, false)
								outputChatBox("Administrator removed you from your faction.", target, 20, 245, 20, false)
								outputServerLog("Factions: " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] removed " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " from their faction.")
								refreshFactionMenu(exports['roleplay-accounts']:getPlayerFaction(target))
							else
								outputChatBox("That player isn't in a faction.", player, 245, 20, 20, false)
							end
						end
					else
						outputChatBox("Invalid faction ID.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"setfactionleader", "setfactionprivileges"},
	function(player, cmd, name, leader)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local leader = tonumber(leader)
			if (not name) or (not leader) or (leader and leader ~= 0 and leader ~= 1 and leader ~= 2) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [leader status: 0 = player, 1 = leader, 2 = owner]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (exports['roleplay-accounts']:getPlayerFaction(target)) and (exports['roleplay-accounts']:getPlayerFaction(target) > 0) then
						local _leader = "Member"
						
						if (leader == 1) then
							_leader = "Leader"
						elseif (leader == 2) then
							_leader = "Owner"
						end
						
						dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "characters", "factionPrivileges", leader, "id", exports['roleplay-accounts']:getCharacterID(target))
						setElementData(target, "roleplay:characters.faction:privileges", leader, true)
						refreshFactionMenu(exports['roleplay-accounts']:getPlayerFaction(target))
						
						outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " faction privileges to '" .. _leader .. "' (" .. leader .. ").", player, 20, 245, 20, false)
						outputChatBox("Administrator set your faction privileges to '" .. _leader .. "'.", target, 20, 245, 20, false)
						outputServerLog("Factions: " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " faction privileges to '" .. _leader .. "' (" .. leader .. ") (Faction ID: " .. exports['roleplay-accounts']:getPlayerFaction(target) .. ").")
					else
						outputChatBox("That player isn't in a faction.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"setfactionbalance", "setfactionbank"},
	function(player, cmd, factionID, value)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local factionID = tonumber(factionID)
			local value = tonumber(value)
			if (not factionID) or (factionID and factionID <= 0) or (not value) then
				outputChatBox("SYNTAX: /" .. cmd .. " [faction id] [value]", player, 210, 160, 25, false)
				return
			else
				local faction = getFactionByID(factionID)
				if (not faction) then
					outputChatBox("Couldn't find a faction with that ID.", player, 245, 20, 20, false)
				else
					local factionName = getFactionName(faction)
					dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "factions", "bankValue", value, "id", factionID)
					setElementData(target, "roleplay:factions.bank", value, false)
					outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(factionName) .. " bank balance to " .. value .. ".", player, 20, 245, 20, false)
					outputServerLog("Factions: " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(factionName) .. " faction balance to " .. exports['roleplay-banking']:getFormattedValue(value) .. " USD (Faction ID: " .. factionID .. ").")
				end
			end
		end
	end
)

addCommandHandler({"showfactions", "factions"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local foundFaction
			
			outputChatBox("Factions:", player, 210, 160, 25, false)
			for _,faction in ipairs(getElementsByType("team")) do
				if (getFactionID(faction)) then
					foundFaction = true
					outputLongChatBox("   ID " .. getFactionID(faction) .. " - " .. getFactionName(faction) .. " (" .. factionTypes[getFactionType(faction)][1] .. ") - Balance: " .. exports['roleplay-banking']:getFormattedValue(getFactionBank(faction)) .. " USD", player)
				end
			end
			
			if (not foundFaction) then
				outputChatBox("   None.", player, 245, 20, 20, false)
			end
		end
	end
)
