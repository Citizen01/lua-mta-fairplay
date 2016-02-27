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

local tempVehicles = {}

local addCommandHandler_ = addCommandHandler
	addCommandHandler = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					if (hasObjectPermissionTo(player, "command." .. commandName[1], not restricted)) then
						fn(player, ...)
					end
				end
			)
		end
	end
end

addCommandHandler({"veh", "tempveh"},
	function(player, cmd, model)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not model) then
				outputChatBox("SYNTAX: /" .. cmd .. " [model id]", player, 210, 160, 25, false)
			else
				local veh
				
				if (tonumber(model) and getVehicleNameFromModel(tonumber(model))) then
					local x, y, z = getElementPosition(player)
					local _, _, rz = getElementRotation(player)
					local x = x+((math.cos(math.rad(rz)))*3)
					local y = y+((math.sin(math.rad(rz)))*3)
					veh = createVehicle(tonumber(model), x, y, z, 0, 0, rz)
					setElementInterior(veh, getElementInterior(player))
					setElementDimension(veh, getElementDimension(player))
					setElementData(veh, "roleplay:vehicles.temp", true, false)
				elseif (getVehicleModelFromName(model)) then
					local x, y, z = getElementPosition(player)
					local _, _, rz = getElementRotation(player)
					local x = x+((math.cos(math.rad(rz)))*3)
					local y = y+((math.sin(math.rad(rz)))*3)
					veh = createVehicle(getVehicleModelFromName(model), x, y, z, 0, 0, rz)
					setElementInterior(veh, getElementInterior(player))
					setElementDimension(veh, getElementDimension(player))
					setElementData(veh, "roleplay:vehicles.temp", true, false)
				else
					outputChatBox("Invalid vehicle model entered.", player, 245, 20, 20, false)
				end
				
				if (getVehicleType(veh) == "Automobile") or (getVehicleType(veh) == "Bike") or (getVehicleType(veh) == "BMX") or (getVehicleType(veh) == "Quad") or (getVehicleType(veh) == "Boat") or (getVehicleType(veh) == "Monster Truck") then
					triggerEvent(":_toggleSnowHandling_:", root, veh)
				end
	
				if (getElementModel(veh) == 431) then
					setVehicleHandling(veh, "engineAcceleration", 4.7)
					setVehicleHandling(veh, "engineInertia", 80)
					setVehicleHandling(veh, "steeringLock", 46)
					setVehicleHandling(veh, "numberOfGears", 3)
					setVehicleHandling(veh, "maxVelocity", 100)
					setVehicleHandling(veh, "turnMass", 33190)
					setVehicleHandling(veh, "tractionMultiplier", 0.75)
					setVehicleHandling(veh, "tractionLoss", 0.85)
					setVehicleHandling(veh, "tractionBias", 0.4)
					setVehicleHandling(veh, "brakeDeceleration", 4.17)
					setVehicleHandling(veh, "brakeBias", 0.5)
				end
			end
		end
	end
)

addCommandHandler({"addvehicle", "createvehicle", "makevehicle", "makeveh", "createveh", "cv", "addveh"},
	function(player, cmd, model, owner, faction, cost, tinted)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not owner) or (not tonumber(faction)) or (tonumber(faction) ~= 0 and tonumber(faction) ~= 1) or (tonumber(cost) < 0) or (not tonumber(tinted)) or (tonumber(tinted) ~= 0 and tonumber(tinted) ~= 1) then
				outputChatBox("SYNTAX: /" .. cmd .. " [model id/name] [player/faction id] [faction vehicle (0/1)] [cost] [tint (0/1)]", player, 210, 160, 25, false)
				return
			else
				local _model
				
				if (tonumber(model)) then
					if (not getVehicleNameFromModel(model)) then
						outputChatBox("Invalid vehicle model ID " .. model .. ".", player, 245, 20, 20, false)
						return
					else
						_model = tonumber(model)
					end
				else
					model = model:gsub("_", " ")
					if (not getVehicleModelFromName(model)) then
						outputChatBox("Invalid vehicle model name \"" .. model .. "\".", player, 245, 20, 20, false)
						return
					else
						_model = getVehicleModelFromName(model)
					end
				end
				
				local rotation = getPedRotation(player)
				local x, y, z = getElementPosition(player)
				local x = x+((math.cos(math.rad(rotation)))*5)
				local y = y+((math.sin(math.rad(rotation)))*5)
				
				local owner = owner
				local faction = tonumber(faction)
				local cost = tonumber(cost)
				local tinted = tonumber(tinted)
				local target
				
				if (faction == 0) then
					target = exports['roleplay-accounts']:getPlayerFromPartialName(owner, player)
					if (not target) then
						outputChatBox("Couldn't find such player with that ID.", player, 245, 20, 20, false)
						return
					else
						if (exports['roleplay-banking']:getBankValue(target) < cost) then
							outputChatBox("The character doesn't have enough money in their bank account to buy this vehicle.", player, 245, 20, 20, false)
							return
						end
					end
				elseif (faction == 1) then
					owner = tonumber(owner)
					target = exports['roleplay-factions']:getFactionByID(owner)
					if (not target) then
						outputChatBox("Couldn't find such faction with that ID.", player, 245, 20, 20, false)
						return
					else
						if (exports['roleplay-factions']:getFactionBank(target) < cost) then
							outputChatBox("The faction doesn't have enough money in its bank account to buy this vehicle.", player, 245, 20, 20, false)
							return
						end
					end
				end
				
				local time = getRealTime()
				local interior = getElementInterior(player)
				local dimension = getElementDimension(player)
				local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "vehicles", "modelid", "posX", "posY", "posZ", "rotZ", "interior", "dimension", "userID", "created", "tinted", _model, x, y, z, rotation, interior, dimension, (faction == 1 and -owner or exports['roleplay-accounts']:getCharacterID(target)), time.timestamp, tinted)
				
				if (query) then
					local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
					exports['roleplay-vehicles']:addVehicle(last_insert_id, _model, x, y, z, 0, 0, rotation, interior, dimension, x, y, z, 0, 0, rotation, interior, dimension, 0, (faction == 1 and -owner or exports['roleplay-accounts']:getCharacterID(target)), "[ [ 0, 0, 0 ] ]", "[ [ 0, 0, 0 ] ]", 0, 0, 0, 0, 0, 1000, 100, 0, "[ [ 0, 0, 0, 0, 0, 0, 0 ] ]", "[ [ 0, 0, 0, 0, 0, 0 ] ]", "[ [ 0, 0, 0, 0 ] ]", 0, 0)
					
					if (faction == 0) then
						exports['roleplay-banking']:takeBankValue(target, cost)
						exports['roleplay-items']:giveItem(target, 7, last_insert_id)
					else
						exports['roleplay-factions']:takeFactionBank(owner, cost)
					end
					
					outputChatBox("Created a new vehicle with ID " .. last_insert_id .. ".", player, 20, 245, 20, false)
					outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new vehicle (" .. getVehicleNameFromModel(_model) .. ") with ID " .. last_insert_id .. ".")
				else
					outputChatBox("MySQL error occured when tried to create the vehicle.", player, 245, 20, 20, false)
					outputServerLog("Error: MySQL query failed when tried to create a new vehicle (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
				end
			end
		end
	end
)

addCommandHandler({"makecivveh", "addcivveh", "createcivveh", "makecivcar", "addcivcar", "ccv", "acv", "mcv", "createcivcar"},
	function(player, cmd, model, jobID)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local jobID = tonumber(jobID)
			if (not model) or (not jobID) or (jobID < 1) or (jobID > 3) then
				outputChatBox("SYNTAX: /" .. cmd .. " [model id/name] [job id: 1 = bus, 2 = taxi, 3 = dmv]", player, 210, 160, 25, false)
				return
			else
				local _model
				
				if (tonumber(model)) then
					if (not getVehicleNameFromModel(model)) then
						outputChatBox("Invalid vehicle model ID " .. model .. ".", player, 245, 20, 20, false)
						return
					else
						_model = tonumber(model)
					end
				else
					model = model:gsub("_", " ")
					if (not getVehicleModelFromName(model)) then
						outputChatBox("Invalid vehicle model name \"" .. model .. "\".", player, 245, 20, 20, false)
						return
					else
						_model = getVehicleModelFromName(model)
					end
				end
				
				local rotation = getPedRotation(player)
				local x, y, z = getElementPosition(player)
				local x = x+((math.cos(math.rad(rotation)))*5)
				local y = y+((math.sin(math.rad(rotation)))*5)
				
				local time = getRealTime()
				local interior = getElementInterior(player)
				local dimension = getElementDimension(player)
				local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??')", "vehicles", "modelid", "posX", "posY", "posZ", "rotZ", "interior", "dimension", "jobID", "created", _model, x, y, z, rotation, interior, dimension, jobID, time.timestamp)
				
				if (query) then
					local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
					exports['roleplay-vehicles']:addVehicle(last_insert_id, _model, x, y, z, 0, 0, rotation, interior, dimension, x, y, z, 0, 0, rotation, interior, dimension, 0, 0, "[ [ 0, 0, 0 ] ]", "[ [ 0, 0, 0 ] ]", 0, 0, 0, 0, 0, 1000, 100, 0, "[ [ 0, 0, 0, 0, 0, 0, 0 ] ]", "[ [ 0, 0, 0, 0, 0, 0 ] ]", "[ [ 0, 0, 0, 0 ] ]", 0, jobID, 0)
					outputChatBox("Created a new civilian vehicle with ID " .. last_insert_id .. " to job ID " .. jobID .. " (" .. (jobID == 1 and "Bus" or (jobID == 2 and "Taxi" or "DMV")) .. ").", player, 20, 245, 20, false)
					outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new civilian vehicle (" .. getVehicleNameFromModel(_model) .. ") with ID " .. last_insert_id .. " to job ID " .. jobID .. ".")
				else
					outputChatBox("MySQL error occured when tried to create the civilian vehicle.", player, 245, 20, 20, false)
					outputServerLog("Error: MySQL query failed when tried to create a new civilian vehicle (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
				end
			end
		end
	end
)

addCommandHandler({"setcolor", "setvehcolor", "setvehiclecolor", "color", "vehcolor"},
	function(player, cmd, r1, g1, b1, r2, g2, b2)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local r1 = tonumber(r1)
			local g1 = tonumber(g1)
			local b1 = tonumber(b1)
			local r2 = tonumber(r2)
			local g2 = tonumber(g2)
			local b2 = tonumber(b2)
			if ((not r1) or (r1 and (r1 < 0) or (r1 > 255))) or ((not g1) or (g1 and (g1 < 0) or (g1 > 255))) or ((not b1) or (b1 and (b1 < 0) or (b1 > 255))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [red: 0-255] [green: 0-255] [blue: 0-255]...", player, 210, 160, 25, false)
				return
			else
				if (r2) then
					if ((r2 and (r2 < 0) or (r2 > 255))) or ((not g2) or (g2 and (g2 < 0) or (g2 > 255))) or ((not b2) or (b2 and (b2 < 0) or (b2 > 255))) then
						outputChatBox("SYNTAX: /" .. cmd .. " [red: 0-255] [green: 0-255] [blue: 0-255]...", player, 210, 160, 25, false)
						return
					end
				end
				
				local vehicle = getPedOccupiedVehicle(player)
				if (not vehicle) then
					outputChatBox("You have to be in a vehicle in order to set a vehicle color.", player, 245, 20, 20, false)
					return
				else
					if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) or (getElementData(vehicle, "roleplay:vehicles.temp")) then
						local cr2, cg2, cb2 = getVehicleColor(vehicle, true)
						local color1 = toJSON({r1, g1, b1})
						local color2 = (b2 and toJSON({r2, g2, b2}) or toJSON({cr2, cg2, cb2}))
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??' WHERE `??` = '??'", "vehicles", "color1", color1, "color2", color2, "id", exports['roleplay-vehicles']:getVehicleRealID(vehicle))
						if (query) then
							setVehicleColor(vehicle, r1, g1, b1, (r2 and r2 or cr2), (g2 and g2 or cg2), (b2 and b2 or cb2))
							outputChatBox("Vehicle color has been changed.", player, 20, 245, 20, false)
							outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set vehicle ID " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. "'s colors.")
						else
							outputChatBox("MySQL query failed when tried to save color data to database.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to save color data to database (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("This is an invalid vehicle.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"setvehicleowner", "setvehowner", "setcarowner"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(player)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "vehicles", "userID", exports['roleplay-accounts']:getCharacterID(target), "id", exports['roleplay-vehicles']:getVehicleRealID(vehicle))
							setElementData(vehicle, "roleplay:vehicles.owner", exports['roleplay-accounts']:getCharacterID(target), true)
							
							if (player ~= target) then
								outputChatBox("Set the vehicle's owner to " .. exports['roleplay-accounts']:getRealPlayerName(target) .. ".", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle's owner to them (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ", Character ID: " .. exports['roleplay-accounts']:getCharacterID(target) .. ").")
							else
								outputChatBox("You now own the vehicle.", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] owns their vehicle now (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ", Character ID: " .. exports['roleplay-accounts']:getCharacterID(player) .. ").")
							end
						else
							outputChatBox("The vehicle type is invalid and it cannot have an owner.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("You are not in a vehicle.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"sgb", "gearbox", "setgear", "setgearbox", "setvehiclegear", "setvehiclegearbox"},
	function(player, cmd, name, type)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local type = tonumber(type)
			if (not name) or (not type) or (type < 0 or type > 1) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [type: 0 = automatic, 1 = manual]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(target)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "vehicles", "manualGearbox", type, "id", exports['roleplay-vehicles']:getVehicleRealID(vehicle))
							setElementData(vehicle, "roleplay:vehicles.geartype", type, true)
							
							outputChatBox("Set the vehicle gear type to " .. (type == 1 and "'Manual'" or "'Automatic'") .. ".", player, 20, 245, 20, false)
						else
							outputChatBox("The vehicle type is invalid and it cannot have an owner.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"sll", "suspensionlowerlevel", "suspensionlower", "suspensionlevel", "suspension"},
	function(player, cmd, name, amount)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local amount = tonumber(amount)
			if (not name) or (not amount or (amount < -0.6 or amount > 0.1)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] <[amount: -0.6 to 0.1]>", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(target)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "vehicles", "suspension", amount, "id", exports['roleplay-vehicles']:getVehicleRealID(vehicle))
							setVehicleHandling(vehicle, "suspensionLowerLimit", tonumber(amount) or nil)
							
							outputChatBox("Set the vehicle suspension level to " .. amount .. ".", player, 20, 245, 20, false)
						else
							outputChatBox("The vehicle type is invalid and it cannot have an owner.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"setvehiclefaction", "setvehfaction", "setcarfaction"},
	function(player, cmd, name, factionID)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local factionID = tonumber(factionID)
			if (not name) or ((not factionID) or (factionID and (factionID < 0))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [faction id]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(target)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
							if (not exports['roleplay-factions']:getFactionByID(factionID)) and (factionID ~= 0) then
								outputChatBox("Couldn't find such faction with that ID.", player, 245, 20, 20, false)
								return
							end
							
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "vehicles", "userID", (factionID == 0 and -666 or -factionID), "id", exports['roleplay-vehicles']:getVehicleRealID(vehicle))
							setElementData(vehicle, "roleplay:vehicles.owner", (factionID == 0 and -666 or -factionID), true)
							
							if (player ~= target) then
								if (factionID == 0) then
									outputChatBox("Removed " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle from faction.", player, 20, 245, 20, false)
									outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] removed " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle from faction (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ").")
								else
									outputChatBox("Set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle's faction to '" .. exports['roleplay-factions']:getFactionName(exports['roleplay-factions']:getFactionByID(factionID)) .. "' (ID: " .. factionID .. ").", player, 20, 245, 20, false)
									outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle's faction to '" .. exports['roleplay-factions']:getFactionName(exports['roleplay-factions']:getFactionByID(factionID)) .. "' (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ", Faction ID: " .. factionID .. ").")
								end
							else
								if (factionID == 0) then
									outputChatBox("Removed this vehicle from its faction.", player, 20, 245, 20, false)
									outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] removed their vehicle from its faction (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ").")
								else
									outputChatBox("Set this vehicle's faction to '" .. exports['roleplay-factions']:getFactionName(exports['roleplay-factions']:getFactionByID(factionID)) .. "' (ID: " .. factionID .. ").", player, 20, 245, 20, false)
									outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set their vehicle's faction to '" .. exports['roleplay-factions']:getFactionName(exports['roleplay-factions']:getFactionByID(factionID)) .. "' (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ", Faction ID: " .. factionID .. ").")
								end
							end
						else
							outputChatBox("The vehicle type is invalid and cannot be set to a faction.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"setvehicletint", "setvehtint", "setcartint", "settint"},
	function(player, cmd, name, onOrOff)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local onOrOff = tonumber(onOrOff)
			if (not name) or ((not onOrOff) or (onOrOff and (onOrOff ~= 0) and (onOrOff ~= 1))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [tint (0/1)]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(target)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "vehicles", "tinted", onOrOff, "id", exports['roleplay-vehicles']:getVehicleRealID(vehicle))
							setElementData(vehicle, "roleplay:vehicles.tinted", onOrOff, true)
							
							if (player ~= target) then
								outputChatBox((onOrOff == 0 and "Removed tint from" or "Set tint to") .. " " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle.", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] " .. (onOrOff == 0 and "removed tint from" or "set tint to") .. " " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ").")
							else
								outputChatBox((onOrOff == 0 and "Removed tint from" or "Set tint to") .. " this vehicle.", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] " .. (onOrOff == 0 and "removed tint from" or "set tint to") .. " their vehicle (Vehicle ID: " .. exports['roleplay-vehicles']:getVehicleRealID(vehicle) .. ").")
							end
						else
							outputChatBox("The vehicle type is invalid and its tint cannot be set.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"delveh", "delvehicle", "delcar", "deletevehicle", "deletecar"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if ((not id) or (id and (id < 0))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
			else
				local vehicle = exports['roleplay-vehicles']:getVehicle(id)
				if (vehicle) then
					if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
						local x, y, z = getElementPosition(player)
						local vx, vy, vz = getElementPosition(vehicle)
						if (getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 10) then
							local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "vehicles", "id", id)
							if (query) then
								destroyElement(vehicle)
								outputChatBox("Vehicle ID " .. id .. " has been deleted.", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] deleted vehicle ID " .. id .. ".")
							else
								outputChatBox("MySQL query failed when tried to delete the vehicle.", player, 245, 20, 20, false)
								outputServerLog("Error: MySQL query failed when tried to delete vehicle ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
							end
						else
							outputChatBox("You need to be near the vehicle you want to delete.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("This is an invalid vehicle.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find a vehicle with ID " .. id .. ".", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"delthisveh", "deletethisveh", "deletethiscar", "deletethisvehicle"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
		else
			local vehicle = getPedOccupiedVehicle(player)
			if (vehicle) then
				if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
					local id = exports['roleplay-vehicles']:getVehicleRealID(vehicle)
					local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "vehicles", "id", id)
					if (query) then
						destroyElement(vehicle)
						outputChatBox("Vehicle ID " .. id .. " has been deleted.", player, 20, 245, 20, false)
						outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] deleted vehicle ID " .. id .. ".")
					else
						outputChatBox("MySQL query failed when tried to delete the vehicle.", player, 245, 20, 20, false)
						outputServerLog("Error: MySQL query failed when tried to delete vehicle ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
					end
				else
					outputChatBox("This is an invalid vehicle.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("You're not in a vehicle.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"gotocar", "gotoveh", "gotovehicle", "tptoveh", "tptocar", "tptovehicle"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if ((not id) or (id and (id < 0))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
			else
				local vehicle = exports['roleplay-vehicles']:getVehicle(id)
				if (vehicle) then
					if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
						local rx, ry, rz = getVehicleRotation(vehicle)
						local x, y, z = getElementPosition(vehicle)
						local x = x+((math.cos(math.rad(rz)))*5)
						local y = y+((math.sin(math.rad(rz)))*5)
						setElementPosition(player, x, y, z)
						setPedRotation(player, rz)
						setElementInterior(player, getElementInterior(vehicle))
						setElementDimension(player, getElementDimension(vehicle))
						outputChatBox("Teleported to vehicle ID " .. id .. ".", player, 20, 245, 20, false)
						outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] teleported to vehicle ID " .. id .. ".")
					else
						outputChatBox("This is an invalid vehicle.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find a vehicle with ID " .. id .. ".", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"getcar", "getveh", "getvehicle", "tpvehicle", "tpcar", "tpveh"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if ((not id) or (id and (id < 0))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
			else
				local vehicle = exports['roleplay-vehicles']:getVehicle(id)
				if (vehicle) then
					if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) then
						local rotation = getPedRotation(player)
						local x, y, z = getElementPosition(player)
						local x = x+((math.cos(math.rad(rotation)))*5)
						local y = y+((math.sin(math.rad(rotation)))*5)
						setElementPosition(vehicle, x, y, z)
						setVehicleRotation(vehicle, 0, 0, rotation)
						setElementInterior(vehicle, getElementInterior(player))
						setElementDimension(vehicle, getElementDimension(player))
						outputChatBox("Teleported vehicle ID " .. id .. " to you.", player, 20, 245, 20, false)
						outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] teleported vehicle ID " .. id .. " to them.")
					else
						outputChatBox("This is an invalid vehicle.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find a vehicle with ID " .. id .. ".", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"fixveh", "fixvehicle", "repairveh", "repairvehicle", "repair", "fix", "fixcar", "repaircar"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(target)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) or (getElementData(vehicle, "roleplay:vehicles.temp")) then
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							fixVehicle(vehicle)
							setElementHealth(vehicle, 1000)
							
							if (player ~= target) then
								outputChatBox("Fixed " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle.", player, 20, 245, 20, false)
								outputChatBox("Administrator fixed your vehicle.", target, 210, 160, 25, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] fixed " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle.")
							else
								outputChatBox("Fixed your vehicle.", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] fixed their vehicle.")
							end
						else
							outputChatBox("The vehicle type is invalid and cannot be repaired.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"fuelveh", "fuel", "refuelveh", "refuel"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(target)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) or (getElementData(vehicle, "roleplay:vehicles.temp")) then
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							setElementData(vehicle, "roleplay:vehicles.fuel", 100, false)
							setElementData(vehicle, "roleplay:vehicles.fuel;", 100, true)
							
							triggerClientEvent(target, ":_syncFuelAmount_:", target, 100)
							
							if (player ~= target) then
								outputChatBox("Refueled " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle.", player, 20, 245, 20, false)
								outputChatBox("Administrator refueled your vehicle.", target, 210, 160, 25, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] refueled " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle.")
							else
								outputChatBox("Refueled your vehicle.", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] refueled their vehicle.")
							end
						else
							outputChatBox("The vehicle type is invalid and cannot be refueled.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"unflipveh", "flipveh", "unflipcar", "flipcar", "unflipvehicle", "flipvehicle", "unflip", "flip"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					local vehicle = getPedOccupiedVehicle(target)
					if (vehicle) then
						if (exports['roleplay-vehicles']:getVehicleRealID(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle)) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) > 0) or (getElementData(vehicle, "roleplay:vehicles.temp")) then
							if (getElementHealth(vehicle) == 0) then
								outputChatBox("That vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
								return
							end
							
							local rx, ry, rz = getVehicleRotation(vehicle)
							setVehicleRotation(vehicle, 0, ry, rz)
							
							if (player ~= target) then
								outputChatBox("Unflipped " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle.", player, 20, 245, 20, false)
								outputChatBox("Administrator unflipped your vehicle.", target, 210, 160, 25, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] unflipped " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle.")
							else
								outputChatBox("Fixed your vehicle.", player, 20, 245, 20, false)
								outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] unflipped their vehicle.")
							end
						else
							outputChatBox("The vehicle type is invalid and cannot be unflipped.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"respawnveh", "respawnvehicle", "respawncar"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [vehicle id]", player, 210, 160, 25, false)
			else
				local vehicle = exports['roleplay-vehicles']:getVehicle(id)
				if (not vehicle) then
					outputChatBox("Couldn't find a vehicle with that ID.", player, 245, 20, 20, false)
					return
				end
				
				fixVehicle(vehicle)
				setVehicleEngineState(vehicle, false)
				setVehicleOverrideLights(vehicle, 1)
				setElementFrozen(vehicle, true)
				
				if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) then
					setVehicleLocked(vehicle, true)
				else
					setVehicleLocked(vehicle, false)
				end
				
				setElementData(vehicle, "roleplay:vehicles.fuel", 100, true)
				setElementData(vehicle, "roleplay:vehicles.fuel;", 100, true)
				setElementData(vehicle, "roleplay:vehicles.engine", 0, true)
				setElementData(vehicle, "roleplay:vehicles.winstate", 0, true)
				setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
				setElementData(vehicle, "roleplay:vehicles.handbrake", 1, true)
				respawnVehicle(vehicle)
				
				outputChatBox("Vehicle ID " .. id .. " (" .. getVehicleName(vehicle) .. ") respawned to its original location.", player, 20, 245, 20, false)
				outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] respawned vehicle ID " .. id .. ".")
			end
		end
	end
)

addCommandHandler("respawnfaction",
	function(player, cmd, factionID, seconds)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local factionID = tonumber(factionID)
			if (not factionID) or (factionID <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [faction id] <[seconds until respawn]>", player, 210, 160, 25, false)
				return
			end
			
			local seconds = (seconds or 30)
			
			if (seconds) then
				if (not tonumber(seconds)) or (tonumber(seconds) < 10) or (tonumber(seconds) > 60) then
					seconds = 30
				end
			end
			
			local faction = exports['roleplay-factions']:getFactionByID(factionID)
			if (not faction) then
				outputChatBox("Couldn't find a faction with that name.", player, 245, 20, 20, false)
				return
			end
			
			exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " started a faction respawn on " .. exports['roleplay-factions']:getFactionName(factionID) .. ".")
			for i,v in ipairs(getElementsByType("player")) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					if (exports['roleplay-accounts']:getPlayerFaction(v)) and (exports['roleplay-accounts']:getPlayerFaction(v) == factionID) then
						outputChatBox(" * FACTION BROADCAST: All unoccupied vehicles in this faction will be respawned in " .. seconds .. " seconds.", v, 220, 205, 25, false)
					end
				end
			end
			
			setTimer(function(name, account, factionID)
				for i,v in ipairs(getElementsByType("vehicle")) do
					if (exports['roleplay-vehicles']:getVehicleRealType(v) and exports['roleplay-vehicles']:getVehicleRealType(v) > 0) then
						if (exports['roleplay-vehicles']:getVehicleFaction(v)) and (exports['roleplay-vehicles']:getVehicleFaction(v) == factionID) then
							if (isVehicleEmpty(v)) then
								fixVehicle(v)
								setVehicleEngineState(v, false)
								setVehicleOverrideLights(v, 1)
								setElementFrozen(v, true)
								
								if (not tonumber(getElementData(v, "roleplay:vehicles.job"))) then
									setVehicleLocked(v, true)
								else
									setVehicleLocked(v, false)
								end
								
								setElementData(v, "roleplay:vehicles.fuel", 100, true)
								setElementData(v, "roleplay:vehicles.fuel;", 100, true)
								setElementData(v, "roleplay:vehicles.engine", 0, true)
								setElementData(v, "roleplay:vehicles.winstate", 0, true)
								setElementData(v, "roleplay:vehicles.currentGear", 0, true)
								setElementData(v, "roleplay:vehicles.handbrake", 1, true)
								respawnVehicle(v)
							end
						end
					end
				end
				
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientPlaying(v)) then
						if (exports['roleplay-accounts']:getPlayerFaction(v)) and (exports['roleplay-accounts']:getPlayerFaction(v) == factionID) then
							outputChatBox(" * FACTION BROADCAST: All unoccupied vehicles in this faction have been respawned.", v, 220, 205, 25, false)
						end
					end
				end
				
				exports['roleplay-accounts']:outputAdminLog(name:gsub("_", " ") .. " respawned all vehicles in " .. exports['roleplay-factions']:getFactionName(factionID) .. ".")
				outputServerLog("Admin-Vehicle: " .. name .. " [" .. account .. "] respawned all vehicles in " .. exports['roleplay-factions']:getFactionName(factionID) .. ".")
			end, seconds*1000, 1, getPlayerName(player), exports['roleplay-accounts']:getAccountName(player), factionID)
			
			outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command - respawn pending at " .. seconds .. " seconds.")
		end
	end
)

addCommandHandler({"respawndistrict", "respawnarea", "respawnzone"},
	function(player, cmd, seconds)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local district = getElementZoneName(player, false)
			local city = getElementZoneName(player, true)
			local seconds = (seconds or 30)
			
			if (seconds) then
				if (not tonumber(seconds)) or (tonumber(seconds) < 10) or (tonumber(seconds) > 60) then
					seconds = 30
				end
			end
			
			exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " started a district respawn at " .. district .. ", " .. city .. " in " .. seconds .. " seconds.")
			for i,v in ipairs(getElementsByType("player")) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					if (getElementZoneName(v, false) == district) then
						outputChatBox(" * DISTRICT BROADCAST: All unoccupied vehicles in this district (" .. district .. ") will be respawned in " .. seconds .. " seconds.", v, 220, 205, 25, false)
					end
				end
			end
			
			setTimer(function(name, account, district, city)
				for i,v in ipairs(getElementsByType("vehicle")) do
					if (exports['roleplay-vehicles']:getVehicleRealType(v) and exports['roleplay-vehicles']:getVehicleRealType(v) > 0) then
						if (getElementZoneName(v, false) == district) then
							if (isVehicleEmpty(v)) then
								fixVehicle(v)
								setVehicleEngineState(v, false)
								setVehicleOverrideLights(v, 1)
								setElementFrozen(v, true)
								
								if (not tonumber(getElementData(v, "roleplay:vehicles.job"))) then
									setVehicleLocked(v, true)
								else
									setVehicleLocked(v, false)
								end
								
								setElementData(v, "roleplay:vehicles.fuel", 100, true)
								setElementData(v, "roleplay:vehicles.fuel;", 100, true)
								setElementData(v, "roleplay:vehicles.engine", 0, true)
								setElementData(v, "roleplay:vehicles.winstate", 0, true)
								setElementData(v, "roleplay:vehicles.currentGear", 0, true)
								setElementData(v, "roleplay:vehicles.handbrake", 1, true)
								respawnVehicle(v)
							end
						end
					end
				end
				
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientPlaying(v)) then
						if (getElementZoneName(v, false) == district) then
							outputChatBox(" * DISTRICT BROADCAST: All unoccupied vehicles in this district have been respawned.", v, 220, 205, 25, false)
						end
					end
				end
				
				exports['roleplay-accounts']:outputAdminLog(name:gsub("_", " ") .. " respawned all vehicles at " .. district .. ", " .. city .. ".")
				outputServerLog("Admin-Vehicle: " .. name .. " [" .. account .. "] respawned all vehicles at " .. district .. ", " .. city .. ".")
			end, seconds*1000, 1, getPlayerName(player), exports['roleplay-accounts']:getAccountName(player), district, city)
			
			outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command - respawn pending at " .. seconds .. " seconds.")
		end
	end
)

addCommandHandler({"respawnvehs", "respawnallvehs", "respawnall", "respawnvehicles", "respawnallvehicles", "respawncars", "respawnallcars"},
	function(player, cmd, seconds)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local seconds = (seconds or 30)
			if (seconds) then
				if (not tonumber(seconds)) or (tonumber(seconds) < 10) or (tonumber(seconds) > 60) then
					seconds = 30
				end
			end
			
			exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " started a full respawn in " .. seconds .. " seconds.")
			for i,v in ipairs(getElementsByType("player")) do
				if (exports['roleplay-accounts']:isClientPlaying(v)) then
					outputChatBox(" * GLOBAL BROADCAST: All unoccupied vehicles will be respawned in " .. seconds .. " seconds.", v, 220, 205, 25, false)
				end
			end
			
			setTimer(function(name, account)
				for i,v in ipairs(getElementsByType("vehicle")) do
					if (exports['roleplay-vehicles']:getVehicleRealType(v) and exports['roleplay-vehicles']:getVehicleRealType(v) > 0) then
						if (isVehicleEmpty(v)) then
							fixVehicle(v)
							setVehicleEngineState(v, false)
							setVehicleOverrideLights(v, 1)
							setElementFrozen(v, true)
							
							if (not tonumber(getElementData(v, "roleplay:vehicles.job"))) then
								setVehicleLocked(v, true)
							else
								setVehicleLocked(v, false)
							end
							
							setElementData(v, "roleplay:vehicles.fuel", 100, true)
							setElementData(v, "roleplay:vehicles.fuel;", 100, true)
							setElementData(v, "roleplay:vehicles.engine", 0, true)
							setElementData(v, "roleplay:vehicles.winstate", 0, true)
							setElementData(v, "roleplay:vehicles.currentGear", 0, true)
							setElementData(v, "roleplay:vehicles.handbrake", 1, true)
							respawnVehicle(v)
						end
					end
				end
				
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientPlaying(v)) then
						outputChatBox(" * GLOBAL BROADCAST: All unoccupied vehicles have been respawned.", v, 220, 205, 25, false)
					end
				end
				
				outputServerLog("Admin-Vehicle: " .. name .. " [" .. account .. "] respawned all vehicles.")
			end, seconds*1000, 1, getPlayerName(player), exports['roleplay-accounts']:getAccountName(player))
			
			outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command - respawn pending at " .. seconds .. " seconds.")
		end
	end
)

addCommandHandler({"nearbyvehs", "nearbyvehicles", "nearbycars"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local pass = false
			local px, py, pz = getElementPosition(player)
			outputChatBox("Nearby vehicles:", player, 210, 160, 25, false)
			for i,v in ipairs(getElementsByType("vehicle")) do
				if (exports['roleplay-vehicles']:getVehicleRealType(v) and exports['roleplay-vehicles']:getVehicleRealType(v) > 0) and (getElementInterior(v) == getElementInterior(player) and getElementDimension(v) == getElementDimension(player)) then
					local x, y, z = getElementPosition(v)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) then
						if (not tonumber(getElementData(v, "roleplay:vehicles.job"))) or (tonumber(getElementData(v, "roleplay:vehicles.job")) == 0) then
							outputChatBox("  " .. getVehicleName(v) .. " (" .. getElementModel(v) .. ") with ID: " .. exports['roleplay-vehicles']:getVehicleRealID(v) .. " (Owner: " .. (exports['roleplay-vehicles']:getVehicleFaction(v) and exports['roleplay-factions']:getFactionName(exports['roleplay-factions']:getFactionByID(getVehicleFaction(v))) or exports['roleplay-vehicles']:getVehicleOwnerName(v)) .. ")", player)
						elseif (tonumber(getElementData(v, "roleplay:vehicles.job"))) or (tonumber(getElementData(v, "roleplay:vehicles.job")) > 0 and tonumber(getElementData(v, "roleplay:vehicles.job")) ~= 3) then
							outputChatBox("  " .. getVehicleName(v) .. " (" .. getElementModel(v) .. ") with ID: " .. exports['roleplay-vehicles']:getVehicleRealID(v) .. " (Owner: Los Santos Transit)", player)
						elseif (tonumber(getElementData(v, "roleplay:vehicles.job"))) or (tonumber(getElementData(v, "roleplay:vehicles.job")) > 0 and tonumber(getElementData(v, "roleplay:vehicles.job")) == 3) then
							outputChatBox("  " .. getVehicleName(v) .. " (" .. getElementModel(v) .. ") with ID: " .. exports['roleplay-vehicles']:getVehicleRealID(v) .. " (Owner: Department of Motor Vehicles)", player)
						end
						if (not pass) then pass = true end
					end
				end
			end
			
			if (not pass) then
				outputChatBox("  None.", player)
			end
			outputServerLog("Admin-Vehicle: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] checked for nearby vehicles at approximately '" .. (math.floor(px*100)/100) .. ", " .. (math.floor(py*100)/100) .. ", " .. (math.floor(pz*100)/100) .. ", " .. getElementInterior(player) .. ", " .. getElementDimension(player) .. "'.")
		end
	end
)
