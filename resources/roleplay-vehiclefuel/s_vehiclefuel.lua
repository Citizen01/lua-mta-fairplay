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

local function createFuelPoint(dbEntryID, posX, posY, posZ, rotZ, interior, dimension, modelID, name)
	local _dbEntryID
	if (dbEntryID) then
		_dbEntryID = dbEntryID
	else
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (??, ??, ??, ??, ??, ??, ??, ??) VALUES ('??', '??', '??', '??', '??', '??', '??', '??')", "fuelstations", "posX", "posY", "posZ", "rotZ", "interior", "dimension", "modelID", "name", posX, posY, posZ, rotZ, interior, dimension, modelID, name)
		if (not query) then return end
		local _, _, last_insert_id = dbPoll(query, -1)
		if (last_insert_id) then _dbEntryID = last_insert_id else return end
	end
	
	local ped = createPed(modelID, posX, posY, posZ, rotZ)
	setElementInterior(ped, interior)
	setElementDimension(ped, dimension)
	setElementData(ped, "roleplay:peds.name", name, true)
	setElementData(ped, "roleplay:refuel.id", _dbEntryID, true)
	setTimer(setPedAnimation, 500, 1, ped, "COP_AMBIENT", "Coplook_loop", -1, false, true, false, true)
	setTimer(function(ped, posX, posY, posZ, rotZ)
		if (not isElement(ped)) then return end
		setPedAnimation(ped, "COP_AMBIENT", "Coplook_loop", -1, false, true, false, true)
		setElementPosition(ped, posX, posY, posZ)
		setElementRotation(ped, 0, 0, rotZ)
	end, 5000, 0, ped, posX, posY, posZ, rotZ)
	
	--outputDebugString("Fuel station ID " .. id .. " loaded.")
	return _dbEntryID
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "fuelstations")
		if (query) then
			local result, num_affected_rows = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 fuel station is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " fuel stations are about to be loaded.")
				end
				
				for _,row in pairs(result) do
					createFuelPoint(row["id"], row["posX"], row["posY"], row["posZ"], row["rotZ"], row["interior"], row["dimension"], row["modelID"], row["name"])
				end
			else
				outputDebugString("0 fuel stations loaded. Does the fuel stations table contain data and are the settings correct?")
			end
		end
	end
)

addEventHandler("onResourceStop", root,
	function(res)
		if (getResourceName(res) == "roleplay-vehicles") or (res == getThisResource()) then
			for i,v in ipairs(getElementsByType("player")) do
				if (getElementData(v, "roleplay:temp.isRefueling")) then
					setPedAnimation(v)
					removeElementData(v, "roleplay:temp.isRefueling")
				end
			end
		end
	end
)

addEvent(":_doRefuelAction_:", true)
addEventHandler(":_doRefuelAction_:", root,
	function()
		if (source ~= client) then return end
		local vehicle = getPedOccupiedVehicle(client)
		if (not vehicle) or (getVehicleController(vehicle) ~= client) then return end
		setVehicleLocked(vehicle, false)
		setVehicleEngineState(vehicle, false)
		setVehicleOverrideLights(vehicle, 1)
		setElementFrozen(vehicle, true)
		setElementData(vehicle, "roleplay:vehicles.engine", 0, true)
		setElementData(vehicle, "roleplay:vehicles.handbrake", 1, true)
		setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
		setControlState(client, "enter_exit", true)
		setTimer(setControlState, 100, 1, client, "enter_exit", false)
		setTimer(function(client, vehicle)
			setElementData(client, "roleplay:temp.isRefueling", exports['roleplay-vehicles']:getVehicleRealID(vehicle), true)
			local _, _, rz = getElementRotation(vehicle)
			setElementRotation(client, 0, 0, rz-90)
			setPedAnimation(client, "CAR_CHAT", "car_talkm_loop", -1, true, false, false)
			outputChatBox("To refuel your " .. getVehicleName(vehicle) .. ", hold your left mouse button pressed on the vehicle. It will refuel as you hold.", client, 210, 160, 25, false)
			outputChatBox("When you have enough of fuel, you can press your right mouse button on the vehicle and you will proceed to the payment part.", client, 210, 160, 25, false)
		end, 2000, 1, client, vehicle)
	end
)

addEvent(":_finishRefuel_:", true)
addEventHandler(":_finishRefuel_:", root,
	function(vehicle, newFuel)
		if (source ~= client) or (not vehicle) or (not isElement(vehicle)) or (not isElement(client)) or (getElementType(vehicle) ~= "vehicle") then return end
		setPedAnimation(client, "CAR_CHAT", "car_talkm_out", 2500, false, false, false, false)
		setTimer(function(client, vehicle)
			setControlState(client, "enter_exit", true)
			setTimer(setControlState, 100, 1, client, "enter_exit", false)
			removeElementData(client, "roleplay:temp.isRefueling")
		end, 3000, 1, client, vehicle)
		
		if (newFuel ~= math.ceil(tonumber(getElementData(vehicle, "roleplay:vehicles.fuel")))) then
			local diff = newFuel-math.ceil(tonumber(getElementData(vehicle, "roleplay:vehicles.fuel")))
			local price = diff*3
			
			if (getPlayerMoney(client) >= price) then
				takePlayerMoney(client, price)
				exports['roleplay-chat']:outputLocalActionMe(client, "takes out their wallet and hands over a few bills to the employee.")
				outputChatBox("Thanks for visiting! You've paid " .. exports['roleplay-banking']:getFormattedValue(price) .. " USD for the refuel of your " .. getVehicleName(vehicle) .. ".", client, 20, 245, 20, false)
			else
				if (exports['roleplay-banking']:getBankValue(client) >= price) then
					exports['roleplay-banking']:takeBankValue(client, price)
					exports['roleplay-chat']:outputLocalActionMe(client, "takes out their wallet and glances inside, swallowing deeply as " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " notices an empty wallet.")
					exports['roleplay-chat']:outputLocalActionMe(client, "slides out a plastic card, handing it over to the employee instead.")
					outputChatBox("Thanks for visiting! You've paid " .. exports['roleplay-banking']:getFormattedValue(price) .. " USD by bank for the refuel of your " .. getVehicleName(vehicle) .. ".", client, 20, 245, 20, false)
				else
					exports['roleplay-chat']:outputLocalActionMe(client, "takes out their wallet and glances inside, swallowing deeply as " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " notices an empty wallet.")
					
					local x, y, z = getElementPosition(client)
					for i,v in ipairs(getElementsByType("player")) do
						local px, py, pz = getElementPosition(v)
						local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
						if (distance < 30 and getElementInterior(client) == getElementInterior(v) and getElementDimension(client) == getElementDimension(v)) then
							outputChatBox(" *The employee looks at " .. getPlayerName(client):gsub("_", " ") .. " with an angry emotion - complaining how much of a problem this is.", v, 237, 116, 136, false)
						end
					end
					
					outputChatBox("Make sure you have enough money in your pocket next time! The employee had to suck all the extra fuel out.", client, 20, 245, 20, false)
					return
				end
			end
		else
			return
		end
		
		setElementData(vehicle, "roleplay:vehicles.fuel", newFuel, false)
		setElementData(vehicle, "roleplay:vehicles.fuel;", newFuel, true)
	end
)

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler = function(commandName, fn, restricted, caseSensitive)
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

addCommandHandler({"makefuelpoint", "createfuelpoint", "addfuelpoint", "makefuelped", "createfuelped", "addfuelped"},
	function(player, cmd, modelID, ...)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
		else
			if (not modelID) or (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [model id (default: 50)] [name]", player, 210, 160, 25, false)
			else
				local name = table.concat({...}, " ")
				if (not name) or (#name <= 5) then
					outputChatBox("The name is too short.", player, 245, 20, 20, false)
				else
					local ped = createPed(modelID, 0, 0, 0)
					if (ped) then
						destroyElement(ped)
						local x, y, z = getElementPosition(player)
						local _, _, rz = getElementRotation(player)
						local id = createFuelPoint(nil, x, y, z, rz, getElementInterior(player), getElementDimension(player), (modelID and modelID or 50), name)
						if (id) then
							outputChatBox("Created a new fuel point with ID " .. id .. ".", player, 245, 20, 20, false)
							outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new fuel station with ID " .. id .. ".")
						end
					else
						outputChatBox("Invalid model ID entered.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"deletefuelpoint", "delfuelpoint", "deletefuelped", "delfuelped"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
		else
			local id = tonumber(id)
			if (not id) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
			else
				local station = getFuelPointByID(id)
				if (not station) then
					outputChatBox("Cannot find a fuel station with that ID.", player, 245, 20, 20, false)
				else
					destroyElement(station)
					outputChatBox("Destroyed fuel point with ID " .. id .. ".", player, 245, 20, 20, false)
					outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] destroyed fuel station with ID " .. id .. ".")
				end
			end
		end
	end
)

addCommandHandler({"nearbyfuelpoints", "nearbyfuelpeds"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
		else
			local pass = false
			local px, py, pz = getElementPosition(player)
			outputChatBox("Nearby fuel points:", player, 210, 160, 25, false)
			for i,v in ipairs(getElementsByType("ped")) do
				local id = getFuelPointID(v)
				if (id) and (getElementInterior(v) == getElementInterior(player) and getElementDimension(v) == getElementDimension(player)) then
					local x, y, z = getElementPosition(v)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) then
						outputChatBox("  Fuel point (" .. getElementModel(v) .. ") with ID: " .. id .. " (Name: " .. getFuelPointName(v) .. ").", player)
						if (not pass) then pass = true end
					end
				end
			end
			
			if (not pass) then
				outputChatBox("  None.", player)
			end
			outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] checked for nearby fuel points at approximately '" .. (math.floor(px*100)/100) .. ", " .. (math.floor(py*100)/100) .. ", " .. (math.floor(pz*100)/100) .. ", " .. getElementInterior(player) .. ", " .. getElementDimension(player) .. "'.")
		end
	end
)