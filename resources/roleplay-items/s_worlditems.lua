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

local worlditems = {}

addEvent(":_dropItem_:", true)
addEventHandler(":_dropItem_:", root,
	function(element, dbEntryID, itemID, value, ringtoneID, messagetoneID, x, y, z)
		if (source ~= client) then return end
		
		if (not hasItem(client, itemID, value)) then
			outputChatBox("Apparently you don't own that item any longer.", client, 245, 20, 20, false)
			return
		end
		
		local rx, ry, rz = getElementRotation(client)
		
		if (not element) or (element and getElementType(element) ~= "player") or (not exports['roleplay-accounts']:isClientPlaying(element)) then
			local x, y, z = x+getItems()[itemID][5], y+getItems()[itemID][6], z+getItems()[itemID][7]
			local rx, ry, rz = rx+getItems()[itemID][8], ry+getItems()[itemID][9], rz+getItems()[itemID][10]
			local item = createObject(getItems()[itemID][4], x, y, z, rx, ry, rz)
			setElementInterior(item, getElementInterior(client))
			setElementDimension(item, getElementDimension(client))
			setElementAlpha(item, getItems()[itemID][11])
			setElementCollisionsEnabled(item, getItems()[itemID][12])
			
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (??, ??, ??, ??, ??, ??, ??, ??, ??, ??, ??, ??, ??, ??) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "worlditems", "itemID", "value", "posX", "posY", "posZ", "rotX", "rotY", "rotZ", "interior", "dimension", "ringtoneID", "messagetoneID", "created", "userID", itemID, value, x, y, z, rx, ry, rz, getElementInterior(item), getElementDimension(item), ringtoneID, messagetoneID, getRealTime().timestamp, exports['roleplay-accounts']:getCharacterID(client))
			local result = dbPoll(dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT LAST_INSERT_ID()"), -1)
			local lastid = result[1]["LAST_INSERT_ID()"]
			
			worlditems[lastid] = {itemID, value, exports['roleplay-accounts']:getCharacterID(client), x, y, z, rx, ry, rz, item}
			setElementData(item, "roleplay:worlditems.id", lastid, true)
			setElementData(item, "roleplay:worlditems.itemID", itemID, true)
			setElementData(item, "roleplay:worlditems.value", value, true)
			setElementData(item, "roleplay:worlditems.ringtone", ringtoneID, true)
			setElementData(item, "roleplay:worlditems.messagetone", messagetoneID, true)
			
			exports['roleplay-chat']:outputLocalActionMe(client, "dropped down a " .. getItems()[itemID][1] .. ".")
			outputServerLog("World items: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] dropped a '" .. getItems()[itemID][1] .. "' to world (" .. itemID .. ").")
			takeItem(client, itemID, value, dbEntryID)
			
			if (itemID == 10) then
				triggerClientEvent(client, ":_exitPhoneWindows_:", client, value)
			end
		else
			exports['roleplay-chat']:outputLocalActionMe(client, "gave " .. exports['roleplay-accounts']:getRealPlayerName(element) .. " a " .. getItems()[itemID][1] .. ".")
			outputServerLog("World items: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] gave " .. getPlayerName(element) .. " [" .. exports['roleplay-accounts']:getAccountName(element) .. "] a '" .. getItems()[itemID][1] .. "' (" .. itemID .. ").")
			takeItem(client, itemID, value, dbEntryID)
			giveItem(element, itemID, value)
		end
	end
)

addEvent(":_pickItemFromWorld_:", true)
addEventHandler(":_pickItemFromWorld_:", root,
	function(tableID, object)
		if (source ~= client) then return end
		if (not worlditems[tableID]) or (not isElement(object)) then
			outputChatBox("Sorry! The world item is no longer.", client, 245, 20, 20, false)
			return
		end
		
		exports['roleplay-chat']:outputLocalActionMe(client, "picked up a " .. getItems()[worlditems[tableID][1]][1] .. ".")
		outputServerLog("World items: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] took a '" .. getItems()[worlditems[tableID][1]][1] .. "' from world (" .. worlditems[tableID][1] .. ").")
		
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "worlditems", "id", tableID)
		
		destroyElement(object)
		giveItem(client, worlditems[tableID][1], worlditems[tableID][2])
		table.remove(worlditems, tableID)
	end
)

addEvent(":_updateWorldItemPosition_:", true)
addEventHandler(":_updateWorldItemPosition_:", root,
	function(tableID, item, x, y, z)
		if (source ~= client) then return end
		if (not isElement(item)) then
			outputChatBox("Sorry! The world item is no longer.", client, 245, 20, 20, false)
			return
		end
		
		exports['roleplay-chat']:outputLocalActionMe(client, "moved a " .. getItems()[worlditems[tableID][1]][1] .. ".")
		outputServerLog("World items: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] moved a '" .. getItems()[worlditems[tableID][1]][1] .. "' in world (" .. worlditems[tableID][1] .. ").")
		
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "worlditems", "posX", x, "posY", y, "posZ", z, "id", tableID)
		
		setElementPosition(item, x, y, z)
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "worlditems")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 world item is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " world items are about to be loaded.")
				end
				
				for result,row in pairs(result) do
					local x, y, z = row["posX"]+getItems()[row["itemID"]][5], row["posY"]+getItems()[row["itemID"]][6], row["posZ"]+getItems()[row["itemID"]][7]
					local rx, ry, rz = row["rotX"]+getItems()[row["itemID"]][8], row["rotY"]+getItems()[row["itemID"]][9], row["rotZ"]+getItems()[row["itemID"]][10]
					local object = createObject(getItems()[row["itemID"]][4], x, y, z, rx, ry, rz)
					setElementInterior(object, row["interior"])
					setElementDimension(object, row["dimension"])
					setElementAlpha(object, getItems()[row["itemID"]][11])
					setElementCollisionsEnabled(object, getItems()[row["itemID"]][12])
					worlditems[row["id"]] = {row["itemID"], row["value"], row["value"], x, y, z, rx, ry, rz, object}
					setElementData(object, "roleplay:worlditems.id", row["id"], true)
					setElementData(object, "roleplay:worlditems.itemID", row["itemID"], true)
					setElementData(object, "roleplay:worlditems.value", row["value"], true)
				end
			else
				outputDebugString("0 world items loaded. Does the world items table contain data and are the settings correct?")
			end
		end
	end
)