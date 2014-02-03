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

local threaders = {}
local interiors = {
	-- Houses
	[1]  = { 235.25,	 1186.68,	1080.26,	3},  -- House 1
	[2]  = { 226.79,	 1240.02,	1082.14,	2},  -- House 2
	[3]  = { 223.07,	 1287.09,	1082.14,	1},  -- House 3
	[4]  = { 327.94,	 1477.73,	1084.44,	15}, -- House 4
	[5]  = { 2468.84,	-1698.29,	1013.51,	2},  -- House 5
	[6]  = { 226.34,	 1114.23,	1080.89,	5},  -- House 6
	[7]  = { 387.23,	 1471.79,	1080.19,	15}, -- House 7
	[8]  = { 225.79,	 1021.46,	1084.02,	7},  -- House 8
	[9]  = { 295.16,	 1472.26,	1080.26,	15}, -- House 9
	[10] = { 2807.58,	-1174.75,	1025.57,	8},  -- House 10
	[11] = { 2270.42,	-1210.52,	1047.56,	10}, -- House 11
	[12] = { 2496.02,	-1692.08,	1014.74,	3},  -- House 12
	[13] = { 2259.38,	-1135.84,	1050.64,	10}, -- Motel Room 1
	[14] = { 2365.21,	-1135.60,	1050.88,	8},  -- House 14
	[15] = { 1531.36,	-6.84,		1002.01,	3},  -- Room 5
	[17] = { 2233.8,	-1115.36,	1050.89,	5},  -- Hotel Room 1
	[18] = { 2282.90,	-1140.27,	1050.9,		11}, -- House 18
	[19] = { 2196.75,	-1204.34,	1048.84,	6},  -- House 19
	[20] = { 2308.78,	-1212.91,	1048.82,	6},  -- House 20
	[21] = { 2218.14,	-1076.24, 	1050.48,	1},  -- Hotel Room 2
	[22] = { 2237.61,	-1081.48,	1048.91,	2},  -- House 22
	[23] = { 2317.83, 	-1026.46, 	1050.21,	9},  -- House 23
	[24] = { 260.98,	 1284.40,	1080.08,	4},  -- House 24
	[25] = { 140.29, 	 1365.99, 	1083.85,	5},  -- House 25
	[26] = { 83.02, 	 1322.51, 	1083.86,	9},  -- House 26
	[27] = {-42.61, 	 1405.71, 	1084.42,	8},  -- House 27
	[28] = { 2333.09,	-1077.06, 	1049.02,	6},  -- House 28
	[29] = { 1298.95,	-797.01,	1084.01,	5},  -- Madd Dogg's
	[30] = { 243.71,	 304.95,	999.14,		1},  -- Room 1
	[31] = { 266.50,	 305.01,	999.14,		2},  -- Room 2
	[32] = { 322.18,	 302.35,	999.14,		5},  -- Room 3
	[33] = { 343.71,	 304.98,	999.14,		6},  -- Room 4
	[34] = {-2102.16, 	 896.37, 	76.7,		0},  -- Small Garage 1
	[35] = { 2648.16, 	-2039.65, 	13.56,		0},  -- Small Garage 2
	-- Businesses
	[36] = {-25.89,		-188.24,	1003.54,	17}, -- 24/7 1
	[37] = { 6.11,		-31.75,		1003.54,	10}, -- 24/7 2
	[38] = {-25.89,		-188.24,	1003.54,	17}, -- 24/7 3
	[39] = {-25.77,		-141.55,	1003.55,	16}, -- 24/7 4
	[40] = {-27.30,		-31.76,		1003.56,	4},  -- 24/7 5
	[41] = {-27.34,		-58.26,		1003.55,	6},  -- 24/7 6
	[42] = { 285.50,	-41.80,		1001.52,	1},  -- Ammunation 1
	[43] = { 285.87,	-86.78,		1001.52,	4},	 -- Ammunation 2
	[44] = { 296.84,	-112.06,	1001.52,	6},  -- Ammunation 3
	[45] = { 315.70,	-143.66,	999.60,		7},  -- Ammunation 4
	[46] = { 316.32,	-170.30,	999.60,		6},  -- Ammunation 5
	[47] = { 1727.04,	-1637.84,	20.22,		18}, -- Atrium
	[48] = { 501.99,	-67.56,		998.75,		11}, -- Bar 1
	[49] = {-229.3,		 1401.28,	27.76,		18}, -- Bar 2
	[50] = { 1212.12,	-26.14,		1000.99,	3},  -- Bar 3
	[51] = { 681.58,	-450.89,	-25.37,		1},  -- Bar 4
	[52] = { 362.84,	-75.13,		1001.50,	10}, -- Burgershot
	[53] = { 207.63,	-111.26,	1005.13,	15}, -- Clothes Shop 1
	[54] = { 204.32,	-168.85,	1000.52,	14}, -- Clothes Shop 2
	[55] = { 207.07,	-140.37,	1003.51,	3},  -- Clothes Shop 3
	[56] = { 203.81,	-50.66,		1001.80,	1},  -- Clothes Shop 4
	[57] = { 227.56,	-8.06,		1002.21,	5},  -- Clothes Shop 5
	[58] = { 161.37,	-97.11,		1001.80,	18}, -- Clothes Shop 6
	[59] = { 493.50,	-24.95,		1000.67,	17}, -- Club 1
	[60] = {-2636.66,	 1402.36,	906.50,		3},  -- Club 2
	[61] = { 364.98,	-11.84,		1001.85,	9},  -- Cluckin' Bell
	[62] = { 460.53,	-88.62,		999.55,		4},  -- Diner 1
	[63] = { 441.90,	-49.70,		999.74,		6},  -- Diner 2
	[64] = { 377.08,	-193.30,	1000.63,	17}, -- Donut Shop
	[65] = {-2240.77,	 137.20,	1035.41,	6},  -- Electronics Shop
	[66] = { 964.93,	 2160.09,	1011.03,	1},  -- Slaughterhouse
	[67] = { 390.76,	 173.79,	1008.38,	3},  -- Office 1
	[68] = {-2026.86,	-103.60,	1035.18,	3},  -- Office 2
	[69] = { 1494.36,	 1303.57,	1093.28,	3},  -- office 3
	[70] = { 372.33,	-133.52,	1001.49,	5},  -- The Well Stacked Pizza Co.
	[71] = {-100.34,	-25.03,		1000.72,	3},  -- Sex Shop
	[72] = { 412,		-23,		1002,		2},  -- Reece's Barber Shop
	[73] = { 418.6,		-84.17,		1001.70,	3},  -- Barber Shop
	[74] = {-204.37,	-8.90,		1002.26,	17}, -- Tattoo Shop
	[75] = { 2541.71,	-1304.07,	1025.08,	2},  -- Factory
	[76] = {-977.72,	 1052.96,	1345.22,	10}, -- RC Battlefield
	[77] = { 2266.15,	 1647.42,	1084.29,	1},  -- Casino Hallway
	[78] = { 834.78,	 7.42,		1003.97,	3},  -- Betting Shop 1
	[79] = {-2158.58, 	 643.15,	1052.33,	1},  -- Betting Shop 2
	[80] = { 2214.38, 	-1150.48, 	1025.79,	15}, -- Jefferson Motel
	[81] = { 773.89,	-78.85, 	1000.66,	7},  -- Gym 1
	[82] = { 772.34, 	-5.52, 		1000.72,	5},  -- Gym 2
	[83] = { 774.18,	-50.42,		1000.60,	6},  -- Gym 3
	[85] = {-1426.14,	 928.44,	1036.35,	15}, -- Stadium 1
	[86] = {-1426.13,	 44.16,		1036.23,	1},  -- Stadium 2
	[87] = {-1464.72,	 1555.93,	1052.68,	14}, -- Stadium 3
	[89] = { 1420.15, 	 6.71, 		1002.39,	1},  -- Warehouse 2
	-- Government
	[90] = { 246.75,	 62.32,		1003.64,	6},  -- Los Santos Police Department
	[91] = { 246.48,	 107.30,	1003.22,	10}, -- San Fierro Police Department
	[92] = { 238.72,	 138.62,	1003.02,	3},	 -- Las Venturas Police Department
}

local function addInterior(id, name, x, y, z, interior, dimension, lastused, locked, disabled, interiorid, interiortype, interiorcost, owner)
	local _model = 1318
	
	if (disabled == 0) then
		if (owner == 0) then
			if (interiortype == 1) or (interiortype == 3) then
				_model = 1273
			elseif (interiortype == 2) then
				_model = 1272
			end
		end
	else
		_model = 1314
	end
	
	local ownerName = "nil"
	if (owner > 0) then
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "characterName", "characters", "id", owner)
		local result = dbPoll(query, -1)
		ownerName = result[1]["characterName"]
	end
	
	local sMarker = createPickup(x, y, z, 3, _model, 0, 0)
	local sCol = createColSphere(x, y, z, 1)
	
	setElementParent(sCol, sMarker)
	setElementInterior(sMarker, interior)
	setElementDimension(sMarker, dimension)
	setElementInterior(sCol, interior)
	setElementDimension(sCol, dimension)
	setElementData(sMarker, "roleplay:interiors.id", id, true)
	setElementData(sMarker, "roleplay:interiors.name", name, true)
	setElementData(sMarker, "roleplay:interiors.lastused", lastused, true)
	setElementData(sMarker, "roleplay:interiors.locked", locked, true)
	setElementData(sMarker, "roleplay:interiors.disabled", disabled, true)
	setElementData(sMarker, "roleplay:interiors.type", interiortype, true)
	setElementData(sMarker, "roleplay:interiors.cost", interiorcost, true)
	setElementData(sMarker, "roleplay:interiors.ownerid", owner, true)
	setElementData(sMarker, "roleplay:interiors.ownername", ownerName, true)
	setElementData(sMarker, "roleplay:interiors.interiorid", interiorid, true)
	setElementData(sMarker, "roleplay:interiors.way", 0, false)
	
	local eMarker = createPickup(interiors[interiorid][1], interiors[interiorid][2], interiors[interiorid][3], 3, (disabled == 0 and 1318 or 1314), 0, 0)
	local eCol = createColSphere(interiors[interiorid][1], interiors[interiorid][2], interiors[interiorid][3], 1)
	
	setElementParent(eCol, eMarker)
	setElementInterior(eMarker, interiors[interiorid][4])
	setElementDimension(eMarker, id)
	setElementInterior(eCol, interiors[interiorid][4])
	setElementDimension(eCol, id)
	setElementData(eMarker, "roleplay:interiors.id", id, true)
	setElementData(eMarker, "roleplay:interiors.name", name, true)
	setElementData(eMarker, "roleplay:interiors.lastused", lastused, true)
	setElementData(eMarker, "roleplay:interiors.locked", locked, true)
	setElementData(eMarker, "roleplay:interiors.disabled", disabled, true)
	setElementData(eMarker, "roleplay:interiors.type", interiortype, true)
	setElementData(eMarker, "roleplay:interiors.cost", interiorcost, true)
	setElementData(eMarker, "roleplay:interiors.ownerid", owner, true)
	setElementData(eMarker, "roleplay:interiors.ownername", ownerName, true)
	setElementData(sMarker, "roleplay:interiors.interiorid", interiorid, true)
	setElementData(eMarker, "roleplay:interiors.way", 1, false)
	
	addEventHandler("onPickupHit", root,
		function(hitPlayer)
			if (source ~= sMarker) and (source ~= eMarker) then return end
			cancelEvent()
		end
	)
	
	--outputDebugString("Interior ID " .. id .. " loaded.")
	
	return sMarker,	eMarker
end

local function destroyInterior(id, bExit)
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getInteriorID(v) == id) then
			if (bExit) then
				for _,p in ipairs(getElementsByType("player")) do
					if (getElementDimension(p) == id) then
						if (tonumber(getElementData(v, "roleplay:interiors.way")) == 0) then
							local x, y, z = getElementPosition(v)
							setElementPosition(p, x, y, z)
							setElementInterior(p, getElementInterior(v))
							setElementDimension(p, getElementDimension(v))
							outputChatBox("The interior was unloaded by the script and you were moved out of the interior.", p)
							
							if (getElementData(p, "roleplay:temp.intcooldown")) then
								removeElementData(p, "roleplay:temp.intcooldown")
							end
							
							if (getElementData(p, "roleplay:temp.oninterior")) then
								removeElementData(p, "roleplay:temp.oninterior")
							end
							
							for _,elevator in ipairs(getElementsByType("pickup")) do
								if (getElevatorID(elevator)) then
									if (getElementDimension(elevator) == id) then
										destroyElevator(getElevatorID(elevator))
									end
								end
							end
						end
					end
				end
			end
			destroyElement(v)
		end
	end
end

function setInteriorOwner(id, ownerID)
	local interior, interior2 = getInterior(id)
	if (interior) then
		if (tonumber(ownerID)) then
			local ownerID = tonumber(ownerID)
			local ix, iy, iz = getElementPosition(interior)
			if (ownerID > 0) then
				local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "characterName", "characters", "id", ownerID)
				if (query) then
					local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
					for result,row in pairs(result) do
						dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "userID", ownerID, "id", id)
						setElementData(interior, "roleplay:interiors.ownerid", id, true)
						setElementData(interior2, "roleplay:interiors.ownerid", id, true)
						
						local intData = {
							name = getInteriorName(v),
							posX = ix,
							posY = iy,
							posZ = iz,
							interior = getElementInterior(v),
							dimension = getElementDimension(v),
							lastused = getInteriorLastUsed(v),
							locked = 1,
							disabled = (isInteriorDisabled(v) == true and 1 or 0),
							interiorid = getInteriorInsideID(v),
							type = getInteriorType(v),
							cost = getInteriorCost(v),
							owner = ownerID
						}
						
						reloadInterior(id, intData, true)
						
						return true
					end
				end
			elseif (ownerID == 0) then
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "userID", 0, "id", id)
				setElementData(interior, "roleplay:interiors.ownerid", 0, true)
				setElementData(interior2, "roleplay:interiors.ownerid", 0, true)
				
				local intData = {
					name = getInteriorName(interior),
					posX = ix,
					posY = iy,
					posZ = iz,
					interior = getElementInterior(interior),
					dimension = getElementDimension(interior),
					lastused = getInteriorLastUsed(interior),
					locked = 1,
					disabled = (isInteriorDisabled(interior) == true and 1 or 0),
					interiorid = getInteriorInsideID(interior),
					type = getInteriorType(interior),
					cost = getInteriorCost(interior),
					owner = 0
				}
				
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??' AND `??` = '??'", "inventory", "value", id, "itemID", 6)
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??' AND `??` = '??'", "worlditems", "value", id, "itemID", 6)
				
				local itemRes = getResourceFromName("roleplay-items")
				if (itemRes) and (getResourceState(itemRes) == "running") then
					for i,v in ipairs(getElementsByType("player")) do
						if (exports['roleplay-accounts']:isClientPlaying(v)) then
							for index,value in pairs(exports['roleplay-items']:getPlayerItems(v)) do
								if (value[2] == 6) then
									if (value[3] == id) then
										exports['roleplay-items']:takeItem(v, 6, id, value[1])
									end
								end
							end
						end
					end
					
					for i,v in ipairs(getElementsByType("object", getResourceDynamicElementRoot(itemRes))) do
						local objData = exports['roleplay-items']:isWorldItem(v)
						if (objData) then
							if (objData[2] == 6) and (objData[3] == id) then
								destroyElement(v)
							end
						end
					end
				end
				
				reloadInterior(id, intData, true)
				
				return true
			end
		end
	end
	return false
end

function reloadInterior(id, data, bExit)
	local interior = getInterior(id)
	local x, y, z = getElementPosition(interior)
	local _data
	local c_data = {
		name = getElementData(interior, "roleplay:interiors.name"),
		posX = x,
		posY = y,
		posZ = z,
		interior = getElementInterior(interior),
		dimension = getElementDimension(interior),
		lastused = tonumber(getElementData(interior, "roleplay:interiors.lastused")),
		locked = tonumber(getElementData(interior, "roleplay:interiors.locked")),
		disabled = tonumber(getElementData(interior, "roleplay:interiors.disabled")),
		interiorid = tonumber(getElementData(interior, "roleplay:interiors.interiorid")),
		type = tonumber(getElementData(interior, "roleplay:interiors.type")),
		cost = tonumber(getElementData(interior, "roleplay:interiors.cost")),
		owner = tonumber(getElementData(interior, "roleplay:interiors.owner"))
	}
	
	if (not data) then
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??' LIMIT 1", "interiors", "id", id)
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				for result,row in pairs(result) do
					_data = {
						name = row["name"],
						posX = row["posX"],
						posY = row["posY"],
						posZ = row["posZ"],
						interior = row["interior"],
						dimension = row["dimension"],
						lastused = row["lastused"],
						locked = row["locked"],
						disabled = row["disabled"],
						interiorid = row["interiorID"],
						type = row["interiorType"],
						cost = row["interiorCost"],
						owner = row["userID"]
					}
					break
				end
			else
				outputServerLog("Error: MySQL query returned nothing when tried to reload interior pure data. Going with the current data...")
				_data = c_data
			end
		else
			outputServerLog("Error: MySQL query failed when trying to reload interior pure data. Going with the current data...")
			_data = c_data
		end
	else
		_data = data
	end
	
	destroyInterior(id, bExit)
	addInterior(id, _data.name, _data.posX, _data.posY, _data.posZ, _data.interior, _data.dimension, _data.lastused, _data.locked, _data.disabled, _data.interiorid, _data.type, _data.cost, _data.owner)
end

local function enterInterior(interior)
	if (source ~= client) then return end
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getInteriorID(v)) then
			if (v ~= interior) then
				if (getInteriorID(v) == getInteriorID(interior)) then
					if (getElementData(client, "roleplay:temp.intcooldown")) then
						outputChatBox("You have to wait a little before you can interact the door handle again!", client, 245, 20, 20, false)
						return
					end
					
					if ((getInteriorOwner(interior) > 0) or (getInteriorOwner(interior) == 0 and not isInteriorLocked(interior))) then
						local x, y, z = getElementPosition(v)
						setElementFrozen(client, true)
						setElementPosition(client, x, y, z)
						setElementInterior(client, getElementInterior(v))
						setElementDimension(client, getElementDimension(v))
						setElementRotation(client, 0, 0, 0)
						setTimer(setElementFrozen, 300, 1, client, false)
						
						if (getElementDimension(client) == getInteriorID(interior)) then
							outputServerLog("Interiors: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] entered interior ID " .. getInteriorID(interior) .. ".")
						else
							outputServerLog("Interiors: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] exited interior ID " .. getInteriorID(interior) .. ".")
						end
						
						setElementData(client, "roleplay:temp.intcooldown", 1, true)
						setTimer(function(player)
							if (not isElement(player)) then return end
							removeElementData(player, "roleplay:temp.intcooldown")
						end, 2500, 1, client)
						
						if (not getElementData(client, "roleplay:temp.oninterior")) then
							setElementData(client, "roleplay:temp.oninterior", 1, false)
						end
						
						local time = getRealTime()
						if (time.timestamp-getInteriorLastUsed(interior) > 3600) then
							local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "lastused", time.timestamp, "id", getInteriorID(interior))
							if (query) then
								setElementData(interior, "roleplay:interiors.lastused", time.timestamp, true)
								outputServerLog("Notice: Last used information was saved for interior ID " .. getInteriorID(interior))
							else
								outputServerLog("Error: MySQL query failed when tried to save 'lastused' data to the database (Interior ID " .. getInteriorID(interior) .. ").")
							end
						end
						
						break
					elseif (isInteriorLocked(interior)) and (getInteriorType(interior) == 0) then
						outputChatBox("The interior door appears to be locked.", client, 245, 20, 20, false)
					else
						triggerClientEvent(client, ":_displayPurchaseOptions:INT_:", client, getInteriorCost(interior), exports['roleplay-banking']:getBankValue(client), getPlayerMoney(client), getInteriorID(interior))
					end
				end
			end
		end
	end
end
addEvent(":_doEnterInterior_:", true)
addEventHandler(":_doEnterInterior_:", root, enterInterior)

local function lockInterior(interior)
	if (source ~= client) then return end
	if (exports['roleplay-items']:hasItem(client, 6, getInteriorID(interior))) or (exports['roleplay-accounts']:isClientTrialAdmin(client) and exports['roleplay-accounts']:getAdminState(client) == 1) then
		for i,v in ipairs(getElementsByType("pickup")) do
			if (v ~= interior) then
				if (getInteriorID(v)) then
					if (getInteriorID(v) == getInteriorID(interior)) then
						if (getElementData(client, "roleplay:temp.intlockcooldown")) then
							outputChatBox("You have to wait a little before you can interact with the door lock again!", client, 245, 20, 20, false)
							return
						end
						
						setElementData(v, "roleplay:interiors.locked", (isInteriorLocked(interior) and 0 or 1), true)
						setElementData(interior, "roleplay:interiors.locked", (isInteriorLocked(interior) and 0 or 1), true)
						
						exports['roleplay-chat']:outputLocalActionMe(client, (isInteriorLocked(interior) and "locked" or "unlocked") .. " the interior door.")
						outputServerLog("Interiors: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] " ..(isInteriorLocked(interior) and "locked" or "unlocked") .. " interior ID " .. getInteriorID(interior) .. ".")
						
						setElementData(client, "roleplay:temp.intlockcooldown", 1, true)
						setTimer(function(player)
							if (not isElement(player)) then return end
							removeElementData(player, "roleplay:temp.intlockcooldown")
						end, 1000, 1, client)
						
						if (not getElementData(client, "roleplay:temp.oninterior")) then
							setElementData(client, "roleplay:temp.oninterior", 1, false)
						end
						
						dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "locked", (isInteriorLocked(interior) and 1 or 0), "id", getInteriorID(interior))
						
						break
					end
				elseif (getElevatorID(v)) then
					if (getElevatorID(v) == getElevatorID(interior)) then
						local theInterior, theInterior2 = getInterior(getElementDimension(v))
						if (theInterior) and (theInterior2) then
							if (getElementData(client, "roleplay:temp.intlockcooldown")) then
								outputChatBox("You have to wait a little before you can interact with the door lock again!", client, 245, 20, 20, false)
								return
							end
							
							setElementData(theInterior, "roleplay:interiors.locked", (isInteriorLocked(theInterior) and 0 or 1), true)
							setElementData(theInterior2, "roleplay:interiors.locked", (isInteriorLocked(theInterior) and 0 or 1), true)
							
							exports['roleplay-chat']:outputLocalActionMe(client, (isInteriorLocked(theInterior) and "locked" or "unlocked") .. " the interior door.")
							outputServerLog("Interiors: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] " ..(isInteriorLocked(theInterior) and "locked" or "unlocked") .. " interior ID " .. getInteriorID(theInterior) .. " via elevator ID " .. getElevatorID(interior) .. ".")
							
							setElementData(client, "roleplay:temp.intlockcooldown", 1, true)
							setTimer(function(player)
								if (not isElement(player)) then return end
								removeElementData(player, "roleplay:temp.intlockcooldown")
							end, 1000, 1, client)
							
							if (not getElementData(client, "roleplay:temp.oninterior")) then
								setElementData(client, "roleplay:temp.oninterior", 1, false)
							end
							
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "locked", (isInteriorLocked(theInterior) and 1 or 0), "id", getInteriorID(theInterior))
							
							break
						end
					end
				end
			end
		end
	else
		outputChatBox("You need a key in order to " .. (isInteriorLocked(v) and "unlock" or "lock") .. " this interior.", client, 245, 20, 20, false)
	end
end
addEvent(":_doLockInterior_:", true)
addEventHandler(":_doLockInterior_:", root, lockInterior)

addEvent(":_clearSuchTempVehData_:", true)
addEventHandler(":_clearSuchTempVehData_:", root,
	function()
		if (source ~= client) then return end
		removeElementData(client, "roleplay:temp.stopvehlocking")
	end
)

addEvent(":_purchaseProperty_:", true)
addEventHandler(":_purchaseProperty_:", root,
	function(bankOrNot, id)
		if (source ~= client) then return end
		local id = tonumber(id)
		if (id) and (id > 0) then
			local x, y, z = getElementPosition(client)
			for i,v in ipairs(getElementsByType("pickup")) do
				if (getInteriorID(v)) and (getInteriorID(v) == id) then
					if (getInteriorType(v) > 0) and (getInteriorOwner(v) == 0) then
						local ix, iy, iz = getElementPosition(v)
						local distance = getDistanceBetweenPoints3D(x, y, z, ix, iy, iz)
						if (distance <= 1.6) and (getElementInterior(v) == getElementInterior(client)) and (getElementDimension(v) == getElementDimension(client)) then
							if (getInteriorPrice(v) <= (bankOrNot and exports['roleplay-banking']:getBankValue(client) or getPlayerMoney(client))) then
								local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "userID", exports['roleplay-accounts']:getAccountID(client), "id", getInteriorID(v))
								if (query) then
									if (bankOrNot) then
										exports['roleplay-banking']:takeBankValue(client, getInteriorPrice(v))
									else
										takePlayerMoney(client, getInteriorPrice(v))
									end
									
									if (getInteriorType(v) ~= 3) then
										outputChatBox("Congratulations! You've bought this property for " .. exports['roleplay-banking']:getFormattedValue(getInteriorCost(v)) .. " USD.", client, 20, 245, 20, false)
										outputServerLog("Interiors: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] bought interior ID " .. getInteriorID(v) .. " for " .. exports['roleplay-banking']:getFormattedValue(getInteriorCost(v)) .. " USD (" .. (bankOrNot and "by bank" or "by cash") .. ").")
									else
										outputChatBox("Congratulations! You're now renting this property for " .. exports['roleplay-banking']:getFormattedValue(getInteriorCost(v)) .. " USD.", client, 20, 245, 20, false)
										outputServerLog("Interiors: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] rented interior ID " .. getInteriorID(v) .. " for " .. exports['roleplay-banking']:getFormattedValue(getInteriorCost(v)) .. " USD (" .. (bankOrNot and "by bank" or "by cash") .. ").")
									end
									
									local intData = {
										name = getInteriorName(v),
										posX = ix,
										posY = iy,
										posZ = iz,
										interior = getElementInterior(v),
										dimension = getElementDimension(v),
										lastused = getInteriorLastUsed(v),
										locked = (isInteriorLocked(v) == true and 1 or 0),
										disabled = (isInteriorDisabled(v) == true and 1 or 0),
										interiorid = getInteriorInsideID(v),
										type = getInteriorType(v),
										cost = getInteriorCost(v),
										owner = exports['roleplay-accounts']:getCharacterID(client)
									}
									
									exports['roleplay-items']:giveItem(client, 6, getInteriorID(v))
									reloadInterior(getInteriorID(v), intData)
								else
									outputServerLog("Error: MySQL query failed when trying to update owner data to database for interior ID " .. getInteriorID(v) .. ".")
								end
							else
								outputChatBox("You have insufficient funds in order to purchase this property by " .. (bankOrNot and "bank" or "cash") .. ".", client, 245, 20, 20, false)
							end
						else
							outputChatBox("You need to be near the interior you want to buy.", client, 245, 20, 20, false)
							exports['roleplay-accounts']:outputAdminLog(getPlayerName(client):gsub("_", " ") .. " tried to purchase an interior as far away as " .. distance .. " meters.")
						end
					else
						outputChatBox("This interior doesn't seem to be no longer purchasable.", client, 245, 20, 20, false)
					end
					break
				end
			end
		else
			outputChatBox("Invalid interior ID.", client, 245, 20, 20, false)
		end
		triggerClientEvent(client, ":_closePropertyPurchaseMenu_:", client)
	end
)

addEventHandler("onColShapeHit", root,
	function(hitElement, matchingDimension)
		if (getElementType(hitElement) ~= "player") or (not exports['roleplay-accounts']:isClientPlaying(hitElement)) then return end
		if (not matchingDimension) then return end
		
		if (getElementParent(source) and getElementData(getElementParent(source), "roleplay:interiors.id")) then
			if (not getElementData(hitElement, "roleplay:temp.oninterior")) then
				setElementData(hitElement, "roleplay:temp.oninterior", 1, false)
			end
		end
	end
)

addEventHandler("onColShapeLeave", root,
	function(leaveElement, matchingDimension)
		if (getElementType(leaveElement) ~= "player") or (not exports['roleplay-accounts']:isClientPlaying(leaveElement)) then return end
		if (not matchingDimension) then return end
		
		if (getElementParent(source) and getElementData(getElementParent(source), "roleplay:interiors.id")) then
			if (getElementData(leaveElement, "roleplay:temp.oninterior")) then
				removeElementData(leaveElement, "roleplay:temp.oninterior")
			end
		end
	end
)

function threaderResume()
	for _,threadedLoad in ipairs(threaders) do
		coroutine.resume(threadedLoad)
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "interiors")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 interior is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " interiors are about to be loaded.")
				end
				
				setTimer(function()
					for result,row in pairs(result) do
						local threadedLoad = coroutine.create(addInterior)
						coroutine.resume(threadedLoad, row["id"], row["name"], row["posX"], row["posY"], row["posZ"], row["interior"], row["dimension"], row["lastused"], row["locked"], row["disabled"], row["interiorID"], row["interiorType"], row["interiorCost"], row["userID"])
						table.insert(threaders, threadedLoad)
						setTimer(threaderResume, 1000, 4)
					end
				end, 100, 1)
			else
				outputDebugString("0 interiors loaded. Does the interiors table contain data and are the settings correct?")
			end
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			if (getElementData(v, "roleplay:temp.intcooldown")) then
				removeElementData(v, "roleplay:temp.intcooldown")
			end
			
			if (getElementData(v, "roleplay:temp.oninterior")) then
				removeElementData(v, "roleplay:temp.oninterior")
			end
			
			if (getElementData(v, "roleplay:temp.intlockcooldown")) then
				removeElementData(v, "roleplay:temp.intlockcooldown")
			end
		end
	end
)

addEventHandler("onVehicleStartEnter", root,
	function(player, seat, jacked, door)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) or (getElementData(player, "roleplay:temp.oninterior")) then
			cancelEvent()
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

addCommandHandler({"addinterior", "createinterior", "makeinterior", "createint", "makeint", "addint"},
	function(player, cmd, interiorid, interiortype, interiorcost, ...)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(interiorid) or tonumber(interiorid) <= 0) or (not tonumber(interiortype)) or ((not tonumber(interiortype) == 0) and (not tonumber(interiortype) == 1) and (not tonumber(interiortype) == 2) and (not tonumber(interiortype) == 3)) or (not tonumber(interiorcost) or tonumber(interiorcost) < 0) or (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [interior id] [interior type] [interior cost] [name]", player, 210, 160, 25, false)
				outputChatBox("Interior type: 0 = government, 1 = house, 2 = business, 3 = rentable", player, 210, 160, 25, false)
				return
			else
				local pass = true
				local x, y, z = getElementPosition(player)
				
				for i,v in ipairs(getElementsByType("pickup")) do
					if (getInteriorID(v)) or (getElevatorID(v)) then
						local px, py, pz = getElementPosition(v)
						if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 2) and (getElementInterior(v) == getElementInterior(player)) and (getElementDimension(v) == getElementDimension(player)) then
							outputChatBox("There is another interior too close to you. Try to find another position for the interior.", player, 245, 20, 20, false)
							pass = false
							break
						end
					end
				end
				
				if (pass) then
					local interiorid = tonumber(interiorid)
					local interiortype = tonumber(interiortype)
					local interiorcost = tonumber(interiorcost)
					local interiorname = table.concat({...}, " ")
					if (interiors[interiorid]) then
						if (interiorname) and (interiorname ~= "") then
							local time = getRealTime()
							local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "interiors", "name", "posX", "posY", "posZ", "interior", "dimension", "interiorid", "interiortype", "interiorcost", "created", interiorname, x, y, z, getElementInterior(player), getElementDimension(player), interiorid, interiortype, interiorcost, time.timestamp)
							if (query) then
								local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "id", "interiors", "created", time.timestamp)
								if (query) then
									local result, num_affected_rows, errmsg = dbPoll(query, -1)
									if (num_affected_rows > 0) then
										for result,row in pairs(result) do
											addInterior(row["id"], interiorname, x, y, z, getElementInterior(player), getElementDimension(player), 0, 1, 0, interiorid, interiortype, interiorcost, 0)
											outputChatBox("Created a new interior with ID " .. row["id"] .. ".", player, 20, 245, 20, false)
											outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new interior with ID " .. row["id"] .. ".")
										end
									else
										outputChatBox("MySQL query returned nothing when tried to fetch the interior ID.", player, 245, 20, 20, false)
										outputServerLog("Error: MySQL query returned nothing when tried to fetch the new interior's ID (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
									end
								else
									outputChatBox("MySQL error occured when tried to fetch the interior ID.", player, 245, 20, 20, false)
									outputServerLog("Error: MySQL query failed when tried to fetch the new interior's ID (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
								end
							else
								outputChatBox("MySQL error occured when tried to create the interior.", player, 245, 20, 20, false)
								outputServerLog("Error: MySQL query failed when tried to create a new interior (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
							end
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [interior id] [interior type] [interior cost] [name]", player, 210, 160, 25, false)
							outputChatBox("Interior type: 0 = government, 1 = house, 2 = business, 3 = rentable", player, 210, 160, 25, false)
						end
					else
						outputChatBox("Couldn't find such interior ID with the passed value.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"delinterior", "deleteinterior", "delint", "deleteint"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(player)
					local px, py, pz = getElementPosition(interior)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) or (getElementDimension(player) == getElementDimension(interior2)) then
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "interiors", "id", id)
						if (query) then
							destroyInterior(id, true)
							outputChatBox("Interior ID " .. id .. " deleted.", player, 20, 245, 20, false)
							outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] deleted an interior with ID " .. id .. ".")
						else
							outputChatBox("MySQL error occured when tried to delete the interior.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to delete an interior with ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You have to be near the interior you want to delete.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)

addCommandHandler({"setinteriorname", "setintname"},
	function(player, cmd, id, ...)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) or (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id] [name]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(player)
					local px, py, pz = getElementPosition(interior)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) or (getElementDimension(player) == getElementDimension(interior2)) then
						local name = table.concat({...}, " ")
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "name", name, "id", id)
						if (query) then
							setElementData(interior, "roleplay:interiors.name", name, true)
							setElementData(interior2, "roleplay:interiors.name", name, true)
							outputChatBox("Interior name changed to \"" .. name .. "\".", player, 20, 245, 20, false)
							outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] changed the interior name of interior ID " .. id .. ".")
						else
							outputChatBox("MySQL error occured when tried to change the interior name.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to change interior name on interior ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You have to be near the interior you want to change name of.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"setinteriortype", "setinttype"},
	function(player, cmd, id, type)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) or (not tonumber(type)) or (tonumber(type) ~= 0 and tonumber(type) ~= 1 and tonumber(type) ~= 2 and tonumber(type) ~= 3) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id] [type]", player, 210, 160, 25, false)
				outputChatBox("Interior type: 0 = government, 1 = house, 2 = business, 3 = rentable", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local type = tonumber(type)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(player)
					local px, py, pz = getElementPosition(interior)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) or (getElementDimension(player) == getElementDimension(interior2)) then
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "interiorType", type, "id", id)
						if (query) then
							setElementData(interior, "roleplay:interiors.type", type, true)
							setElementData(interior2, "roleplay:interiors.type", type, true)
							
							local intData = {
								name = getInteriorName(interior),
								posX = px,
								posY = py,
								posZ = pz,
								interior = getElementInterior(interior),
								dimension = getElementDimension(interior),
								lastused = getInteriorLastUsed(interior),
								locked = (isInteriorLocked(interior) == true and 1 or 0),
								disabled = (isInteriorDisabled(interior) == true and 1 or 0),
								interiorid = getInteriorInsideID(interior),
								type = getInteriorType(interior),
								cost = getInteriorCost(interior),
								owner = (getInteriorType(interior) == 0 and 0 or getInteriorOwner(interior))
							}
							
							reloadInterior(getInteriorID(interior), intData)
							outputChatBox("Interior type changed to \"" .. (type == 0 and "Government" or (type == 1 and "House" or "Business")) .. "\".", player, 20, 245, 20, false)
							outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] changed the interior type of interior ID " .. id .. " to " .. (type == 0 and "Government" or (type == 1 and "House" or "Business")) .. ".")
						else
							outputChatBox("MySQL error occured when tried to change the interior type.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to change interior type on interior ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You have to be near the interior you want to change type of.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"setinteriorprice", "setintprice", "setintcost", "setinteriorcost"},
	function(player, cmd, id, cost)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) or (not tonumber(cost) or tonumber(cost) < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id] [cost]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local cost = tonumber(cost)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(player)
					local px, py, pz = getElementPosition(interior)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) or (getElementDimension(player) == getElementDimension(interior2)) then
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "interiorCost", cost, "id", id)
						if (query) then
							setElementData(interior, "roleplay:interiors.cost", cost, true)
							setElementData(interior2, "roleplay:interiors.cost", cost, true)
							outputChatBox("Interior cost changed to " .. exports['roleplay-banking']:getFormattedValue(cost) .. " USD.", player, 20, 245, 20, false)
							outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] changed the interior cost of interior ID " .. id .. " to " .. exports['roleplay-banking']:getFormattedValue(cost) .. " USD.")
						else
							outputChatBox("MySQL error occured when tried to change the interior cost.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to change interior cost on interior ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You have to be near the interior you want to change cost of.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"setinteriorid", "setintid"},
	function(player, cmd, id, _interiorid)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) or (not tonumber(_interiorid) or tonumber(_interiorid) <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id] [interior id]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local _interiorid = tonumber(_interiorid)
				local interior, interior2 = getInterior(id)
				
				if (interiors[_interiorid]) then
					if (interior) then
						local x, y, z = getElementPosition(player)
						local px, py, pz = getElementPosition(interior)
						if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) or (getElementDimension(player) == getElementDimension(interior2)) then
							local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "interiorID", _interiorid, "id", id)
							if (query) then
								local intData = {
									name = getInteriorName(interior),
									posX = px,
									posY = py,
									posZ = pz,
									interior = getElementInterior(interior),
									dimension = getElementDimension(interior),
									lastused = getInteriorLastUsed(interior),
									locked = (isInteriorLocked(interior) == true and 1 or 0),
									disabled = (isInteriorDisabled(interior) == true and 1 or 0),
									interiorid = _interiorid,
									type = getInteriorType(interior),
									cost = getInteriorCost(interior),
									owner = getInteriorOwner(interior)
								}
								
								for i,v in ipairs(getElementsByType("player")) do
									if (getElementDimension(v) == getElementDimension(interior2)) then
										setElementFrozen(v, true)
										setElementPosition(v, interiors[_interiorid][1], interiors[_interiorid][2], interiors[_interiorid][3])
										setElementRotation(v, 0, 0, 0)
										setElementInterior(v, interiors[_interiorid][4])
										setTimer(function(player)
											if (not isElement(player)) then return end
											setElementFrozen(player, false)
										end, 800, 1, v)
									end
								end
								
								reloadInterior(id, intData, false)
								
								outputChatBox("Interior changed to ID " .. _interiorid .. ".", player, 20, 245, 20, false)
								outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] changed the interior of interior ID " .. id .. " to ID " .. _interiorid .. ".")
							else
								outputChatBox("MySQL error occured when tried to change the interior.", player, 245, 20, 20, false)
								outputServerLog("Error: MySQL query failed when tried to change interior on interior ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
							end
						else
							outputChatBox("You have to be near the interior you want to change interior of.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find such interior ID with the passed value.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"toggleintlock", "toggleinteriorlock"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(player)
					local px, py, pz = getElementPosition(interior)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) or (getElementDimension(player) == getElementDimension(interior2)) then
						local state = not isInteriorLocked(interior)
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "locked", (state == true and 1 or 0), "id", id)
						if (query) then
							setElementData(interior, "roleplay:interiors.locked", (state == true and 1 or 0), true)
							setElementData(interior2, "roleplay:interiors.locked", (state == true and 1 or 0), true)
							outputChatBox("Interior is now " .. (state == true and "locked" or "unlocked") .. ".", player, 20, 245, 20, false)
							outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] " .. (state == true and "locked" or "unlocked") .. " interior ID " .. id .. " remotely.")
						else
							outputChatBox("MySQL error occured when tried to toggle interior lock.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to toggle interior lock on interior ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You have to be near the interior you want to toggle the lock of.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"togint", "toginterior", "toggleinterior", "toggleint", "disableint", "disableinterior"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(player)
					local px, py, pz = getElementPosition(interior)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) or (getElementDimension(player) == getElementDimension(interior2)) then
						local disabled = (tonumber(getElementData(interior, "roleplay:interiors.disabled")) == 0 and 0 or 1)
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "interiors", "disabled", (disabled == 0 and 1 or 0), "id", id)
						if (query) then
							local intData = {
								name = getInteriorName(interior),
								posX = px,
								posY = py,
								posZ = pz,
								interior = getElementInterior(interior),
								dimension = getElementDimension(interior),
								lastused = getInteriorLastUsed(interior),
								locked = isInteriorLocked(interior),
								disabled = (disabled == 0 and 1 or 0),
								interiorid = getInteriorInsideID(interior),
								type = getInteriorType(interior),
								cost = getInteriorCost(interior),
								owner = getInteriorOwner(interior)
							}
							
							reloadInterior(id, intData)
							outputChatBox("Interior has now been " .. (disabled == 0 and "disabled" or "enabled") .. ".", player, 20, 245, 20, false)
							outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] " .. (disabled == 0 and "disabled" or "enabled") .. " interior ID " .. id .. ".")
						else
							outputChatBox("MySQL error occured when tried to change the interior cost.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to change interior cost on interior ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You have to be near the interior you want to change cost of.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"sellinterior", "sellint", "sell", "unrent"},
	function(player, cmd)
		local id = getElementDimension(player)
		if (id > 0) then
			local interior, interior2 = getInterior(id)
			if (interior) then
				if (exports['roleplay-items']:hasItem(player, 6, id)) or (exports['roleplay-accounts']:isClientTrialAdmin(player) and exports['roleplay-accounts']:getAdminState(player) == 1) then
					if (getInteriorType(interior) ~= 0) then
						local x, y, z = getElementPosition(player)
						local px, py, pz = getElementPosition(interior)
						if (getElementDimension(player) == getElementDimension(interior2)) then
							local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??' WHERE `??` = '??'", "interiors", "userID", 0, "locked", 1, "id", id)
							if (query) then
								local intData = {
									name = getInteriorName(interior),
									posX = px,
									posY = py,
									posZ = pz,
									interior = getElementInterior(interior),
									dimension = getElementDimension(interior),
									lastused = getInteriorLastUsed(interior),
									locked = 1,
									disabled = (isInteriorDisabled(interior) == true and 1 or 0),
									interiorid = getInteriorInsideID(interior),
									type = getInteriorType(interior),
									cost = getInteriorCost(interior),
									owner = 0
								}
								
								if (getInteriorType(interior) ~= 3) then
									givePlayerMoney(player, getInteriorCost(interior)/2)
									outputChatBox("Interior is now sold! You received " .. exports['roleplay-banking']:getFormattedValue(getInteriorCost(interior)/2) .. " USD.", player, 20, 245, 20, false)
									outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] sold interior ID " .. id .. " for " .. exports['roleplay-banking']:getFormattedValue(getInteriorCost(interior)/2) .. " USD.")
								else
									outputChatBox("You're no longer renting this property.", player, 20, 245, 20, false)
									outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] unrent interior ID " .. id .. ".")
								end
								
								exports['roleplay-items']:takeItem(player, 6, id) -- Take the key from the player
								dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??' AND `??` = '??'", "inventory", "itemID", 6, "value", tostring(id)) -- Take all keys from everybody
								
								reloadInterior(id, intData, true)
							else
								outputServerLog("Error: MySQL query failed when tried to unrent/sell interior ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
							end
						else
							outputChatBox("You have to be inside your interior in order to sell one.", player, 245, 20, 20, false)
						end
					end
				else
					outputChatBox("You don't have a key to the interior.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("This interior is not an actual interior, unfortunately.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"gotoint", "gotointerior", "tptointerior", "warptointerior"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientModerator(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(interior)
					setElementPosition(player, x, y, z)
					setElementInterior(player, getElementInterior(interior))
					setElementDimension(player, getElementDimension(interior))
					outputChatBox("Teleported to interior ID " .. id .. ".", player, 20, 245, 20, false)
					outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] teleported to interior ID " .. id .. ".")
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"gotointi", "gotointeriori", "tptointeriori", "warptointeriori", "gotointeriorinside"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientModerator(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local interior, interior2 = getInterior(id)
				
				if (interior) then
					local x, y, z = getElementPosition(interior2)
					setElementPosition(player, x, y, z)
					setElementInterior(player, getElementInterior(interior2))
					setElementDimension(player, getElementDimension(interior2))
					outputChatBox("Teleported to interior ID " .. id .. ".", player, 20, 245, 20, false)
					outputServerLog("Interiors: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] teleported to interior ID " .. id .. " (inside).")
				else
					outputChatBox("Couldn't find an interior with that ID.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"nearbyinteriors", "nearbyints", "nearbyint"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientModerator(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local pass = false
			local px, py, pz = getElementPosition(player)
			outputChatBox("Nearby interiors:", player, 210, 160, 25, false)
			for i,v in ipairs(getElementsByType("pickup")) do
				if (getInteriorID(v) and getElementInterior(v) == getElementInterior(player) and getElementDimension(v) == getElementDimension(player)) then
					local x, y, z = getElementPosition(v)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) then
						outputChatBox("  Interior (" .. getInteriorInsideID(v) .. ") with ID: " .. getInteriorID(v) .. " (Owner: " .. (getInteriorType(v) == 0 and "Government" or getInteriorOwnerName(v)) .. ")", player)
						if (not pass) then pass = true end
					end
				end
			end
			
			if (not pass) then
				outputChatBox("  None.", player)
			end
		end
	end
)