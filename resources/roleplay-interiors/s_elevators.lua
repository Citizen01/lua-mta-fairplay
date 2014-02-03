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

local function addElevator(id, x, y, z, interior, dimension, x2, y2, z2, interior2, dimension2, opentype)
	local sMarker = createPickup(x, y, z, 3, (opentype == 1 and 1318 or 1314), 0, 0)
	local sCol = createColSphere(x, y, z, 1)
	
	setElementParent(sCol, sMarker)
	setElementInterior(sMarker, interior)
	setElementDimension(sMarker, dimension)
	setElementInterior(sCol, interior)
	setElementDimension(sCol, dimension)
	setElementData(sMarker, "roleplay:elevators.id", id, true)
	setElementData(sMarker, "roleplay:elevators.opentype", opentype, true)
	
	local eMarker = createPickup(x2, y2, z2, 3, (opentype == 1 and 1318 or 1314), 0, 0)
	local eCol = createColSphere(x2, y2, z2, 1)
	
	setElementParent(eCol, eMarker)
	setElementInterior(eMarker, interior2)
	setElementDimension(eMarker, dimension2)
	setElementInterior(eCol, interior2)
	setElementDimension(eCol, dimension2)
	setElementData(eMarker, "roleplay:elevators.id", id, true)
	setElementData(eMarker, "roleplay:elevators.opentype", opentype, true)
	
	addEventHandler("onPickupHit", root,
		function(hitPlayer)
			if (source ~= sMarker) and (source ~= eMarker) then return end
			cancelEvent()
		end
	)
	
	--outputDebugString("Elevator ID " .. id .. " loaded.")
	
	return sMarker,	eMarker
end

function destroyElevator(id)
	for i,v in ipairs(getElementsByType("pickup")) do
		if (isElement(v)) then
			if (getElevatorID(v) == id) then
				destroyElement(v)
			end
		end
	end
end

local function enterElevator(elevator)
	if (source ~= client) then return end
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getElevatorID(v)) then
			if (v ~= elevator) then
				if (getElevatorID(v) == getElevatorID(elevator)) then
					local theInterior, theInterior2 = getInterior(getElementDimension(v))
					if (theInterior) and (theInterior2) then
						if (getElementDimension(elevator) ~= getElementDimension(v)) then
							if (isInteriorLocked(theInterior)) then
								outputChatBox("The interior door appears to be locked.", client, 245, 20, 20, false)
								return
							end
						end
					end
					
					if (getElementData(client, "roleplay:temp.intcooldown")) then
						outputChatBox("You have to wait a little before you can use the door again!", client, 245, 20, 20, false)
						return
					end
					
					local x, y, z = getElementPosition(v)
					setElementFrozen(client, true)
					setElementPosition(client, x, y, z)
					setElementInterior(client, getElementInterior(v))
					setElementDimension(client, getElementDimension(v))
					setElementRotation(client, 0, 0, 0)
					setTimer(setElementFrozen, 300, 1, client, false)
					
					if (getElementDimension(client) == getElevatorID(elevator)) then
						outputServerLog("Elevators: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] entered elevator ID " .. getElevatorID(elevator) .. ".")
					else
						outputServerLog("Elevators: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] exited elevator ID " .. getElevatorID(elevator) .. ".")
					end
					
					setElementData(client, "roleplay:temp.intcooldown", 1, true)
					setTimer(function(player)
						if (not isElement(player)) then return end
						removeElementData(player, "roleplay:temp.intcooldown")
					end, 2500, 1, client)
					
					if (not getElementData(client, "roleplay:temp.oninterior")) then
						setElementData(client, "roleplay:temp.oninterior", 1, false)
					end
					
					break
				end
			end
		end
	end
end
addEvent(":_doEnterElevator_:", true)
addEventHandler(":_doEnterElevator_:", root, enterElevator)

addEventHandler("onColShapeHit", root,
	function(hitElement, matchingDimension)
		if (getElementType(hitElement) ~= "player") or (not exports['roleplay-accounts']:isClientPlaying(hitElement)) then return end
		if (not matchingDimension) then return end
		
		if (getElementParent(source) and getElementData(getElementParent(source), "roleplay:elevators.id")) then
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
		
		if (getElementParent(source) and getElementData(getElementParent(source), "roleplay:elevators.id")) then
			if (getElementData(leaveElement, "roleplay:temp.oninterior")) then
				removeElementData(leaveElement, "roleplay:temp.oninterior")
			end
		end
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "elevators")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 elevator is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " elevators are about to be loaded.")
				end
				
				for result,row in pairs(result) do
					setTimer(function(row)
						addElevator(row["id"], row["posX"], row["posY"], row["posZ"], row["interior"], row["dimension"], row["posX2"], row["posY2"], row["posZ2"], row["interior2"], row["dimension2"], row["openType"])
					end, 100, 1, row)
				end
			else
				outputDebugString("0 elevators loaded. Does the elevators table contain data and are the settings correct?")
			end
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

local elevatorPositions = {}

addCommandHandler({"markelevator"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local pass = true
			local x, y, z = getElementPosition(player)
			
			for i,v in ipairs(getElementsByType("pickup")) do
				if (getElevatorID(v)) or (getInteriorID(v)) then
					local px, py, pz = getElementPosition(v)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 2) and (getElementInterior(v) == getElementInterior(player)) and (getElementDimension(v) == getElementDimension(player)) then
						outputChatBox("There is another interior too close to you. Try to find another position for the interior.", player, 245, 20, 20, false)
						pass = false
						break
					end
				end
			end
			
			if (pass) then
				elevatorPositions[player] = {x, y, z, getElementInterior(player), getElementDimension(player)}
				outputChatBox("Elevator position marked. Use /addelevator to create the elevator.", player, 20, 245, 20, false)
			end
		end
	end
)

addCommandHandler({"addelevator", "createelevator", "makeelevator", "adde", "makee", "createe"},
	function(player, cmd, x, y, z, int, dim)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (x) then
				if (not tonumber(x)) or (not tonumber(y)) or (not tonumber(z)) or (not tonumber(int)) or (not tonumber(dim)) or (tonumber(int) < 0) or (tonumber(int) > 255) or (tonumber(dim) < 0) or (tonumber(dim) > 65535) then
					outputChatBox("SYNTAX: /" .. cmd .. " [x] [y] [z] [interior] [dimension]", player, 210, 160, 25, false)
					return
				else
					local x = tonumber(x)
					local y = tonumber(y)
					local z = tonumber(z)
					local int = tonumber(int)
					local dim = tonumber(dim)
					local pass = true
					local px, py, pz = getElementPosition(player)
					
					for i,v in ipairs(getElementsByType("pickup")) do
						if (getElevatorID(v)) or (getInteriorID(v)) then
							local ix, iy, iz = getElementPosition(v)
							if (getDistanceBetweenPoints3D(px, py, pz, ix, iy, iz) <= 2) and (getElementInterior(v) == getElementInterior(player)) and (getElementDimension(v) == getElementDimension(player)) then
								outputChatBox("There is another interior too close to you. Try to find another position for the interior.", player, 245, 20, 20, false)
								pass = false
								break
							end
						end
					end
					
					if (pass) then
						local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "elevators", "posX", "posY", "posZ", "interior", "dimension", "posX2", "posY2", "posZ2", "interior2", "dimension2", px, py, pz, getElementInterior(player), getElementDimension(player), x, y, z, int, dim)
						if (query) then
							local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
							addElevator(last_insert_id, px, py, pz, getElementInterior(player), getElementDimension(player), x, y, z, int, dim, 1)
							outputChatBox("Created a new elevator with ID " .. last_insert_id .. ".", player, 20, 245, 20, false)
							outputServerLog("Elevators: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new elevator with ID " .. last_insert_id .. ".")
							if (elevatorPositions[player]) then
								elevatorPositions[player] = nil
							end
						else
							outputChatBox("MySQL error occured when tried to create the elevator.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to create a new elevator (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					end
				end
			else
				local pass = true
				local x, y, z = getElementPosition(player)
				
				for i,v in ipairs(getElementsByType("pickup")) do
					if (getElevatorID(v)) then
						local px, py, pz = getElementPosition(v)
						if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 2) and (getElementInterior(v) == getElementInterior(player)) and (getElementDimension(v) == getElementDimension(player)) then
							outputChatBox("There is another interior too close to you. Try to find another position for the interior.", player, 245, 20, 20, false)
							pass = false
							break
						end
					end
				end
				
				if (pass) then
					if (elevatorPositions[player]) then
						local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "elevators", "posX", "posY", "posZ", "interior", "dimension", "posX2", "posY2", "posZ2", "interior2", "dimension2", x, y, z, getElementInterior(player), getElementDimension(player), elevatorPositions[player][1], elevatorPositions[player][2], elevatorPositions[player][3], elevatorPositions[player][4], elevatorPositions[player][5])
						if (query) then
							local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
							addElevator(last_insert_id, x, y, z, getElementInterior(player), getElementDimension(player), elevatorPositions[player][1], elevatorPositions[player][2], elevatorPositions[player][3], elevatorPositions[player][4], elevatorPositions[player][5], 1)
							outputChatBox("Created a new elevator with ID " .. last_insert_id .. ".", player, 20, 245, 20, false)
							outputServerLog("Elevators: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new elevator with ID " .. last_insert_id .. ".")
							elevatorPositions[player] = nil
						else
							outputChatBox("MySQL error occured when tried to create the elevator.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to create a new elevator (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("Mark the other end of the elevator with /markelevator before adding the elevator.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"delelevator", "deleteelevator", "delele"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not tonumber(id) or tonumber(id) <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
			else
				local id = tonumber(id)
				local elevator, elevator2 = getElevator(id)
				
				if (elevator) then
					local x, y, z = getElementPosition(player)
					if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(elevator)) <= 10) or (getDistanceBetweenPoints3D(x, y, z, getElementPosition(elevator2)) <= 10) then
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "elevators", "id", id)
						if (query) then
							destroyElement(elevator)
							destroyElement(elevator2)
							outputChatBox("Elevator ID " .. id .. " deleted.", player, 20, 245, 20, false)
							outputServerLog("Elevators: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] deleted an elevator with ID " .. id .. ".")
						else
							outputChatBox("MySQL error occured when tried to delete the elevator.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to delete an elevator with ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You have to be near the elevator you want to delete.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find an elevator with that ID.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)

addCommandHandler({"nearbyelevators", "nearbyelevs"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientModerator(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local pass = false
			local px, py, pz = getElementPosition(player)
			outputChatBox("Nearby elevators:", player, 210, 160, 25, false)
			for i,v in ipairs(getElementsByType("pickup")) do
				if (getElevatorID(v) and getElementInterior(v) == getElementInterior(player) and getElementDimension(v) == getElementDimension(player)) then
					local x, y, z = getElementPosition(v)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) then
						outputChatBox("  Elevator with ID: " .. getElevatorID(v), player)
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