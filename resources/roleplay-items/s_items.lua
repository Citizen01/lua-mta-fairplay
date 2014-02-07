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

local data = {}

function getPlayerItems(player)
	if (data[player]) then
		return data[player].items
	else
		return false
	end
end

function loadItems(player)
	data[player] = {
		["items"] = {}
	}
	
	setElementData(player, "roleplay:characters.weight", 0, true)
	setElementData(player, "roleplay:characters.maxweight", 10, true)
	
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??'", "inventory", "charID", exports['roleplay-accounts']:getCharacterID(player))
	if (query) then
		local result, num_affected_rows, errmsg = dbPoll(query, -1)
		if (num_affected_rows > 0) then
			for result,row in pairs(result) do
				if (getItems()[row["itemID"]]) then
					giveItem(player, row["itemID"], row["value"], row["id"], row["ringtoneID"], row["messagetoneID"])
				else
					outputDebugString("Items: Invalid item spawn via loadItems() by " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "].", 2)
					outputDebugString(" - Items: (Item ID " .. row["itemID"] .. ", Value: " .. row["value"] .. ", DB Entry ID: " .. row["id"] .. ").", 2)
				end
			end
		end
	end
end

function giveItem(player, itemID, value, dbEntryID, ringtoneID, messagetoneID)
	if (getItems()[itemID]) then
		local _dbEntryID
		local _value = ""
		
		if (value) then
			if (string.len(value) > 0) and (value ~= "") then
				_value = value
			end
		end
		
		if ((tonumber(getElementData(player, "roleplay:characters.weight"))+getItemWeight(itemID)) > (tonumber(getElementData(player, "roleplay:characters.maxweight")))) then
			return false, 1
		end
		
		if (not dbEntryID) then
			local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (??, ??, ??, ??, ??, ??) VALUES ('??', '??', '??', '??', '??', '??')", "inventory", "charID", "itemID", "value", "ringtoneID", "messagetoneID", "timestamp", exports['roleplay-accounts']:getCharacterID(player), itemID, _value, (ringtoneID and ringtoneID or 1), (messagetoneID and messagetoneID or 1), getRealTime().timestamp)
			local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
			_dbEntryID = last_insert_id
		else
			_dbEntryID = dbEntryID
		end
		
		if (itemID == 8) then
			setElementData(player, "roleplay:characters.maxweight", 20, true)
		elseif (itemID == 9) then
			setElementData(player, "roleplay:characters.maxweight", 30, true)
		end
		
		setElementData(player, "roleplay:characters.weight", tonumber(getElementData(player, "roleplay:characters.weight"))+getItemWeight(itemID), true)
		table.insert(data[player].items, {_dbEntryID, itemID, _value, (ringtoneID and ringtoneID or 1), (messagetoneID and messagetoneID or 1)})
		outputServerLog("Items: Gave item " .. getItemName(itemID) .. " (dbid: " .. _dbEntryID .. ", item id: " .. itemID .. ", type: " .. getItemType(itemID) .. ") to " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "].")
		triggerClientEvent(player, ":_syncInventory_:", player, data[player].items)
		
		return true
	else
		return false
	end
end

function takeItem(player, itemID, value, dbEntryID)
	local _dbEntryID
	local _value
	
	if (data[player]) then
		for i,v in pairs(data[player].items) do
			if (data[player].items[i][2] == itemID) then
				if (value) then
					_value = value
					if (not dbEntryID) then
						if (data[player].items[i][3] == value) then
							_dbEntryID = data[player].items[i][1]
							table.remove(data[player].items, i)
							break
						end
					else
						if (data[player].items[i][1] == dbEntryID) then
							_dbEntryID = dbEntryID
							table.remove(data[player].items, i)
							break
						end
					end
				else
					_value = data[player].items[i][3]
					_dbEntryID = data[player].items[i][1]
					table.remove(data[player].items, i)
					break
				end
			end
		end
	else
		return false
	end
	
	-- If they don't have a key, then kill the function
	if (not _dbEntryID) then
		return
	end
	
	setElementData(player, "roleplay:characters.weight", tonumber(getElementData(player, "roleplay:characters.weight"))-getItemWeight(itemID), true)
	dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "inventory", "id", _dbEntryID)
	outputServerLog("Items: Took item " .. getItemName(itemID) .. " (dbid: " .. _dbEntryID .. ", item id: " .. itemID .. ", type: " .. getItemType(itemID) .. ") from " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "].")
	triggerClientEvent(player, ":_syncInventory_:", player, data[player].items)
	
	return true, _value
end

function hasItem(player, itemID, value, dbEntryID)
	if (getItems()[itemID]) then
		for i,v in pairs(data[player].items) do
			if (tonumber(v[2]) == tonumber(itemID)) then
				if (not value) then
					return true, v[3]
				else
					if (value) and (tostring(v[3]) == tostring(value)) then
						if (not dbEntryID) then
							return true
						else
							if (tostring(v[1]) == tostring(dbEntryID)) then
								return true
							end
						end
					else
						if (dbEntryID) then
							if (tostring(v[1]) == tostring(dbEntryID)) then
								return true, v[3]
							end
						end
					end
				end
			end
		end
	end
	return false
end

function getPlayerItemValue(player, itemID, dbEntryID)
	local itemFound, itemValue = hasItem(player, itemID, nil, dbEntryID)
	if (itemFound) then
		return itemValue
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			if (not exports['roleplay-accounts']:isClientPlaying(v)) then return end
			loadItems(v)
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			if (not exports['roleplay-accounts']:isClientPlaying(v)) then return end
			setElementData(v, "roleplay:characters.weight", 0, true)
			setElementData(v, "roleplay:characters.maxweight", 10, true)
		end
	end
)

addEvent(":_doGetInventory_:", true)
addEventHandler(":_doGetInventory_:", root,
	function()
		if (source ~= client) then return end
		loadItems(client)
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

addCommandHandler("giveitem",
	function(player, cmd, name, itemID, ...)
		if (not exports['roleplay-accounts']:isClientModerator(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local itemID = tonumber(itemID)
			if (not name) or (not itemID) or (itemID and itemID <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [item id] <[value]>", player, 210, 160, 25, false)
				return
			else
				local value_ = ""
				
				if (...) then
					local value = table.concat({...}, " ")
					if (string.len(value) > 0) then
						value_ = value
					end
				end
				
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (getItems()[itemID]) then
						if (data[target]) then
							if ((tonumber(getElementData(target, "roleplay:characters.weight"))+getItemWeight(itemID)) <= tonumber(getElementData(target, "roleplay:characters.maxweight"))) then
								if (giveItem(target, itemID, value_)) then
									outputChatBox("Gave " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " item " .. getItemName(itemID) .. " (" .. itemID .. ").", player, 20, 245, 20, false)
								else
									outputChatBox("Error occurred - 0x0220.", player, 245, 20, 20, false)
								end
							else
								outputChatBox("That player doesn't have enough space for that item.", player, 245, 20, 20, false)
							end
						else
							outputChatBox("That player doesn't have item data initialized yet.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("Invalid item ID.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler("takeitem",
	function(player, cmd, name, itemID, value, dbEntryID)
		if (not exports['roleplay-accounts']:isClientModerator(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local itemID = tonumber(itemID)
			local dbEntryID_Z = tonumber(dbEntryID_Z)
			if (not name) or (not itemID) or (itemID and itemID <= 0) or (value and string.len(value) < 2) or (dbEntryID and dbEntryID <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [item id] <[value]> <[entry id]>", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (getItems()[itemID]) then
						if (data[target]) then
							local bDeleted, rvalue = takeItem(target, itemID, value, dbEntryID)
							if (bDeleted) then
								if (isPedInVehicle(target)) then
									local vehicle = getPedOccupiedVehicle(target)
									if (getVehicleController(vehicle) == target) and (exports['roleplay-vehicles']:getVehicleRealID(vehicle) == tonumber(rvalue)) then
										setElementData(vehicle, "roleplay:vehicles.engine", 0, false)
										setVehicleEngineState(vehicle, false)
									end
								end
								outputChatBox("Took " .. getItemName(itemID) .. " from " .. exports['roleplay-accounts']:getRealPlayerName(target) .. ".", player, 20, 245, 20, false)
							else
								outputChatBox("That player doesn't have an item.", player, 245, 20, 20, false)
							end
						else
							outputChatBox("That player doesn't have item data initialized yet.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("Invalid item ID.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)