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

local gates = {}

local function createGate(dbEntryID, modelID, x, y, z, rx, ry, rz, interior, dimension, ex, ey, ez, erx, ery, erz, einterior, edimension, moveSpeed, openTime, openCondition, easingMethod, lockMethod, easingPeriod, easingAmplitude, easingOvershoot, radius, gateName)
	local object = createObject(modelID, x, y, z, rx, ry, rz)
	setElementInterior(object, interior)
	setElementDimension(object, dimension)
	setElementData(object, "roleplay:gates.id", dbEntryID, true)
	
	local marker = createMarker(x, y, z-1, "cylinder", (radius and radius or 2), 0, 0, 0, 0)
	setElementInterior(marker, interior)
	setElementDimension(marker, dimension)
	setElementData(marker, "roleplay:gates.id", dbEntryID, true)
	
	setElementParent(object, marker)
	
	gates[dbEntryID] = {
		["id"] = dbEntryID,
		["element"] = object,
		["gateName"] = gateName,
		["modelID"] = modelID,
		["posX"] = x,
		["posY"] = y,
		["posZ"] = z,
		["rotX"] = rx,
		["rotY"] = ry,
		["rotZ"] = rz,
		["interior"] = interior,
		["dimension"] = dimension,
		["endPosX"] = ex,
		["endPosY"] = ey,
		["endPosZ"] = ez,
		["endRotX"] = erx,
		["endRotY"] = ery,
		["endRotZ"] = erz,
		["endInterior"] = einterior,
		["endDimension"] = edimension,
		["lockMethod"] = lockMethod,
		["openCondition"] = openCondition,
		["moveSpeed"] = moveSpeed,
		["openTime"] = openTime,
		["easingMethod"] = easingMethod,
		["easingPeriod"] = easingPeriod,
		["easingAmplitude"] = easingAmplitude,
		["easingOvershoot"] = easingOvershoot,
		["radius"] = (radius and radius or 2),
		["timer"] = nil,
		["open"] = false
	}
end

local function fixRotation(value)
	local invert = false
	if (value < 0) then
		while (value < -360) do
			value = value+360
		end
		if (value < -180) then
			value = value+180
			value = value-value-value
		end
	else
		while (value > 360) do
			value = value-360
		end
		if (value > 180) then
			value = value-180
			value = value-value-value
		end
	end
	return value
end

function moveGate(gateID, player)
	if (isTimer(gates[gateID]["timer"])) then return end
	local targetX, targetY, targetZ, targetRX, targetRY, targetRZ, targetInterior, targetDimension
	
	if (not gates[gateID]["open"]) then
		targetX = gates[gateID]["endPosX"]
		targetY = gates[gateID]["endPosY"]
		targetZ = gates[gateID]["endPosZ"]
		targetRX = gates[gateID]["endRotX"]-gates[gateID]["rotX"]
		targetRY = gates[gateID]["endRotY"]-gates[gateID]["rotY"]
		targetRZ = gates[gateID]["endRotZ"]-gates[gateID]["rotZ"]
		targetInterior = gates[gateID]["endInterior"]
		targetDimension = gates[gateID]["endDimension"]
	else
		targetX = gates[gateID]["posX"]
		targetY = gates[gateID]["posY"]
		targetZ = gates[gateID]["posZ"]
		targetRX = gates[gateID]["rotX"]-gates[gateID]["endRotX"]
		targetRY = gates[gateID]["rotY"]-gates[gateID]["endRotY"]
		targetRZ = gates[gateID]["rotZ"]-gates[gateID]["endRotZ"]
		targetInterior = gates[gateID]["interior"]
		targetDimension = gates[gateID]["dimension"]
	end
	
	local targetRX = fixRotation(targetRX)
	local targetRY = fixRotation(targetRY)
	local targetRZ = fixRotation(targetRZ)
	
	moveObject(gates[gateID]["element"], gates[gateID]["moveSpeed"], targetX, targetY, targetZ, targetRX, targetRY, targetRZ, gates[gateID]["easingMethod"], gates[gateID]["easingPeriod"], gates[gateID]["easingAmplitude"], gates[gateID]["easingOvershoot"])
	setElementInterior(gates[gateID]["element"], targetInterior)
	setElementDimension(gates[gateID]["element"], targetDimension)
	
	if (gates[gateID]["openTime"] > 0) then
		gates[gateID]["timer"] = setTimer(function(gateID)
			gates[gateID]["timer"] = nil
			gates[gateID]["open"] = not gates[gateID]["open"]
			if (gates[gateID]["open"]) then moveGate(gateID) end
		end, gates[gateID]["openTime"], 1, gateID)
	else
		gates[gateID]["timer"] = setTimer(function(gateID)
			gates[gateID]["timer"] = nil
			gates[gateID]["open"] = not gates[gateID]["open"]
		end, gates[gateID]["moveSpeed"], 1, gateID)
	end
end

local function getLockMethodID(name)
	if (name == "Everybody") then
		return 1
	elseif (name == "Faction") then
		return 2
	elseif (name == "Item ID") then
		return 3
	elseif (name == "Item ID & Value") then
		return 4
	elseif (name == "Item Value") then
		return 5
	elseif (name == "Password") then
		return 6
	else
		return 0
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "gates")
		if (query) then
			local result, num_affected_rows = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 gate is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " gates are about to be loaded.")
				end
				
				for i=1,1000 do
					gates[i] = {}
				end
				
				for result,row in pairs(result) do
					createGate(row["id"], row["modelID"], row["posX"], row["posY"], row["posZ"], row["rotX"], row["rotY"], row["rotZ"], row["interior"], row["dimension"], row["endPosX"], row["endPosY"], row["endPosZ"], row["endRotX"], row["endRotY"], row["endRotZ"], row["endInterior"], row["endDimension"], row["moveSpeed"], row["openTime"], row["openCondition"], row["easingMethod"], row["lockMethod"], row["easingPeriod"], row["easingAmplitude"], row["easingOvershoot"], row["radius"], row["gateName"])
				end
			else
				outputDebugString("0 gates loaded. Does the gates table contain data and are the settings correct?")
			end
		end
	end
)

addEvent(":_getReturnOfGates_:", true)
addEventHandler(":_getReturnOfGates_:", root,
	function()
		triggerClientEvent(source, ":_placeAllGatesInGUI_:", source, gates)
	end
)

addEvent(":_openGate_:", true)
addEventHandler(":_openGate_:", root,
	function(id)
		if (gates[id]) then
			local x, y, z = getElementPosition(getElementParent(gates[id]["element"]))
			if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= tonumber(gates[id]["radius"])) then
				if (gates[id]["timer"]) then return end
				moveGate(id, source)
			else
				outputChatBox("Get closer to the gate.", source, 245, 20, 20, false)
			end
		else
			outputChatBox("Invalid gate element with ID '" .. tostring(id) .. "'.", source, 245, 20, 20, false)
		end
	end
)

addEvent(":_deleteGate_:", true)
addEventHandler(":_deleteGate_:", root,
	function(id)
		local id = tonumber(id)
		if (gates[id]) then
			if (isElement(gates[id]["element"])) then
				destroyElement(getElementParent(gates[id]["element"]))
				if (isTimer(gates[dbEntryID]["timer"])) then
					killTimer(gates[dbEntryID]["timer"])
				end
			end
			
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "gates", "id", id)
			
			outputChatBox("Gate successfully deleted.", source, 20, 245, 20, false)
			outputServerLog("Gates: " .. getPlayerName(source) .. " [" .. exports['roleplay-accounts']:getAccountName(source) .. "] deleted gate ID " .. id .. ".")
			
			gates[id] = nil
			
			triggerClientEvent(root, ":_refreshGateGUI_:", root, gates)
		else
			outputChatBox("Invalid gate element with ID '" .. tostring(id) .. "'.", source, 245, 20, 20, false)
		end
	end
)

addEvent(":_goToGate_:", true)
addEventHandler(":_goToGate_:", root,
	function(id)
		local id = tonumber(id)
		if (gates[id]) then
			if (isElement(gates[id]["element"])) then
				local x, y, z = getElementPosition(gates[id]["element"])
				local _, _, rz = getElementRotation(gates[id]["element"])
				local x = x+((math.cos(math.rad(rz-90)))*1.4)
				local y = y+((math.sin(math.rad(rz-90)))*1.4)
				setElementPosition(source, x, y, z)
				setElementInterior(source, getElementInterior(gates[id]["element"]))
				setElementDimension(source, getElementDimension(gates[id]["element"]))
				outputChatBox("Teleported to gate ID " .. id .. ".", source, 20, 245, 20, false)
				outputServerLog("Gates: " .. getPlayerName(source) .. " [" .. exports['roleplay-accounts']:getAccountName(source) .. "] teleported to gate ID " .. id .. ".")
			else
				outputChatBox("Gate ID " .. tostring(id) .. " doesn't seem to be an element anymore.", source, 245, 20, 20, false)
			end
		else
			outputChatBox("Invalid gate element with ID " .. tostring(id) .. ".", source, 245, 20, 20, false)
		end
	end
)

addEvent(":_editGate_:", true)
addEventHandler(":_editGate_:", root,
	function(dbEntryID, posX, posY, posZ, rotX, rotY, rotZ, interior, dimension, endPosX, endPosY, endPosZ, endRotX, endRotY, endRotZ, endInterior, endDimension, moveSpeed, openTime, openCondition, objectID, easingMethod, lockMethod, easingPeriod, easingAmplitude, easingOvershoot, gateName)
		if (gates[dbEntryID]) then
			if (isElement(gates[dbEntryID]["element"])) then
				destroyElement(getElementParent(gates[dbEntryID]["element"]))
				if (isTimer(gates[dbEntryID]["timer"])) then
					killTimer(gates[dbEntryID]["timer"])
				end
				gates[dbEntryID] = nil
			end
			
			--27 fucking idiot query tbh
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `gates` SET `modelID` = '" .. objectID .. "', `posX`= '" .. posX .. "', `posY` = '" .. posY .. "', `posZ` = '" .. posZ .. "', `rotX` = '" .. rotX .. "', `rotY`= '" .. rotY .. "', `rotZ` = '" .. rotZ .. "', `interior`= '" .. interior .. "', `dimension`= '" .. dimension .. "', `endPosX`= '" .. endPosX .. "', `endPosY`= '" .. endPosY .. "', `endPosZ`= '" .. endPosZ .. "', `endRotX`= '" .. endRotX .. "', `endRotY` = '" .. endRotY .. "', `endRotZ` = '" .. endRotZ .. "', `endInterior`= '" .. endInterior .. "', `endDimension` = '" .. endDimension .. "', `lockMethod`= '" .. lockMethod .. "', `openCondition` = '" .. openCondition .. "', `moveSpeed`= '" .. moveSpeed .. "', `openTime`= '" .. openTime .. "', `easingMethod` = '" .. easingMethod .. "', `easingPeriod` = '" .. easingPeriod .. "', `easingAmplitude` = '" .. easingAmplitude .. "', `easingOvershoot` = '" .. easingOvershoot .. "', `gateName` = '" .. gateName .. "' WHERE `id` = '" .. dbEntryID .. "'")
			
			createGate(dbEntryID, objectID, posX, posY, posZ, rotX, rotY, rotZ, interior, dimension, endPosX, endPosY, endPosZ, endRotX, endRotY, endRotZ, endInterior, endDimension, moveSpeed, openTime, openCondition, easingMethod, (getLockMethodID(lockMethod) and getLockMethodID(lockMethod) or 0), easingPeriod, easingAmplitude, easingOvershoot, gateName)
			outputChatBox("Gate with ID " .. dbEntryID .. " edited!", source, 20, 245, 20, false)
			outputServerLog("Gates: " .. getPlayerName(source) .. " [" .. exports['roleplay-accounts']:getAccountName(source) .. "] updated gate with ID " .. dbEntryID .. ".")
			triggerClientEvent(root, ":_refreshGateGUI_:", root, gates)
		end
	end
)

addEvent(":_createGate_:", true)
addEventHandler(":_createGate_:", root,
	function(posX, posY, posZ, rotX, rotY, rotZ, interior, dimension, endPosX, endPosY, endPosZ, endRotX, endRotY, endRotZ, endInterior, endDimension, moveSpeed, openTime, openCondition, objectID, easingMethod, lockMethod, easingPeriod, easingAmplitude, easingOvershoot, gateName)
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (posX, posY, posZ, rotX, rotY, rotZ, interior, dimension, endPosX, endPosY, endPosZ, endRotX, endRotY, endRotZ, endInterior, endDimension, moveSpeed, openTime, openCondition, modelID, easingMethod, lockMethod, easingPeriod, easingAmplitude, easingOvershoot, gateName, createdBy, createdOn) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "gates", posX, posY, posZ, rotX, rotY, rotZ, interior, dimension, endPosX, endPosY, endPosZ, endRotX, endRotY, endRotZ, endInterior, endDimension, moveSpeed, openTime, openCondition, objectID, easingMethod, lockMethod, easingPeriod, easingAmplitude, easingOvershoot, gateName, exports['roleplay-accounts']:getAccountID(source), getRealTime().timestamp)
		if (query) then
			local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
			createGate(last_insert_id, objectID, posX, posY, posZ, rotX, rotY, rotZ, interior, dimension, endPosX, endPosY, endPosZ, endRotX, endRotY, endRotZ, endInterior, endDimension, moveSpeed, openTime, openCondition, easingMethod, (getLockMethodID(lockMethod) and getLockMethodID(lockMethod) or 0), easingPeriod, easingAmplitude, easingOvershoot, gateName)
			outputChatBox("Gate with ID " .. last_insert_id .. " created!", source, 20, 245, 20, false)
			outputServerLog("Gates: " .. getPlayerName(source) .. " [" .. exports['roleplay-accounts']:getAccountName(source) .. "] created gate with ID " .. last_insert_id .. ".")
			triggerClientEvent(root, ":_refreshGateGUI_:", root, gates)
		end
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		setTimer(function()
			for i,v in ipairs(getElementsByType("player")) do
				triggerClientEvent(v, ":_placeAllGatesInGUI_:", v, gates)
			end
		end, 1000, 1)
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		triggerClientEvent(source, ":_placeAllGatesInGUI_:", source, gates)
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

addCommandHandler("gate",
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local x, y, z = getElementPosition(player)
		for i,v in ipairs(getElementsByType("object")) do
			local id = getGateID(v)
			if (id) then
				if (isElementWithinMarker(player, getElementParent(v))) then
					if (gates[id]["timer"]) then return end
					local condition = gates[id]["openCondition"]
					if (gates[id]["lockMethod"] == 1) then
						moveGate(id, player)
					elseif (gates[id]["lockMethod"] == 2) then
						if (exports['roleplay-accounts']:getPlayerFaction(player)) and (exports['roleplay-accounts']:getPlayerFaction(player) == tonumber(condition)) then
							moveGate(id, player)
						else
							outputChatBox("You can't open this gate.", player, 245, 20, 20, false)
						end
					elseif (gates[id]["lockMethod"] == 3) then
						if (exports['roleplay-items']:hasItem(player, tonumber(condition))) then
							moveGate(id, player)
						else
							outputChatBox("You can't open this gate.", player, 245, 20, 20, false)
						end
					elseif (gates[id]["lockMethod"] == 4) then
						local splitted = split(condition, ":")
						if (exports['roleplay-items']:hasItem(player, tonumber(splitted[1]), splitted[2])) then
							moveGate(id, player)
						else
							outputChatBox("You can't open this gate.", player, 245, 20, 20, false)
						end
					elseif (gates[id]["lockMethod"] == 5) then
						-- doesn't work yet
					elseif (gates[id]["lockMethod"] == 6) then
						if (...) then
							local pwd = table.concat({...}, " ")
							if (pwd == condition) then
								moveGate(id, player)
							else
								outputChatBox("You can't open this gate.", player, 245, 20, 20, false)
							end
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [gate password]", player, 210, 160, 25, false)
						end
					end
				end
			end
		end
	end
)

addCommandHandler("setgateradius",
	function(player, cmd, gateID, newRadius)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local gateID = tonumber(gateID)
			local newRadius = tonumber(newRadius)
			if (not gateID) or (gateID <= 0) or (not newRadius) or (newRadius <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [gate id] [radius]", player, 210, 160, 25, false)
			else
				if (not gates[gateID]) then
					outputChatBox("Couldn't find a gate with that ID.", player, 245, 20, 20, false)
				else
					gates[gateID]["radius"] = newRadius
					setMarkerSize(getElementParent(gates[gateID]["element"]), newRadius)
					dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "gates", "radius", newRadius, "id", gateID)
					outputChatBox("Gate radius set to " .. newRadius .. " units.", player, 20, 245, 20, false)
				end
			end
		end
	end
)