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

local dmvTruckModels = {[403]=true}
local windowless = {[568]=true, [601]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [528]=true, [530]=true, [531]=true, [532]=true, [571]=true, [572]=true}
local roofless = {[568]=true, [500]=true, [439]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [530]=true, [531]=true, [533]=true, [536]=true, [555]=true, [571]=true, [572]=true, [575]=true, [536]=true, [567]=true, [555]=true}
local enginelessVehicle = {[510]=true, [509]=true, [481]=true}
local lightlessVehicle = {[592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [497]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true}
local locklessVehicle = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true}
local armoredCars = {[427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true}
local platelessVehicles = {[592]=true, [553]=true, [577]=true, [488]=true, [511]=true, [497]=true, [548]=true, [563]=true, [512]=true, [476]=true, [593]=true, [447]=true, [425]=true, [519]=true, [520]=true, [460]=true, [417]=true, [469]=true, [487]=true, [513]=true, [509]=true, [481]=true, [510]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [571]=true}
local bike = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true}

function addVehicle(id, model, x, y, z, rx, ry, rz, interior, dimension, respawnX, respawnY, respawnZ, respawnRX, respawnRY, respawnRZ, respawnInterior, respawnDimension, handbraked, owner, rgb1, rgb2, engineState, lightState, damageProof, tinted, lastused, health, fuel, locked, description, panelState, doorState, wheelState, windowsDown, jobID, manualGearbox, plateText, isInitialization)
	local vehicle
	
	if (jobID) and (jobID > 0) then
		vehicle = createVehicle(model, respawnX, respawnY, respawnZ, respawnRX, respawnRY, respawnRZ)
		setElementInterior(vehicle, respawnInterior)
		setElementDimension(vehicle, respawnDimension)
		setVehicleLocked(vehicle, false)
		setElementRotation(vehicle, respawnRX, respawnRY, respawnRZ)
		setElementFrozen(vehicle, true)
		setElementData(vehicle, "roleplay:vehicles.handbrake", 1, true)
		setVehicleEngineState(vehicle, false)
		setElementData(vehicle, "roleplay:vehicles.fuel", 100, false)
		setElementData(vehicle, "roleplay:vehicles.fuel;", 100, true)
		setElementData(vehicle, "roleplay:vehicles.winstate", 0, true)
		setElementData(vehicle, "roleplay:vehicles.engine", 0, true)
	else
		vehicle = createVehicle(model, x, y, z, rx, ry, rz)
		setElementInterior(vehicle, (interior and interior or 0))
		setElementDimension(vehicle, (dimension and dimension or 0))
		setVehicleLocked(vehicle, ((locked and locked == 1) and true or false))
		setElementHealth(vehicle, (health and health or 1000))
		setElementRotation(vehicle, rx, ry, rz)
		
		if (handbraked) then
			setElementFrozen(vehicle, (handbraked == 1 and true or false))
			setElementData(vehicle, "roleplay:vehicles.handbrake", handbraked, true)
		else
			setElementFrozen(vehicle, false)
			setElementData(vehicle, "roleplay:vehicles.handbrake", 0, true)
		end
		
		setElementData(vehicle, "roleplay:vehicles.fuel", (fuel and math.floor(fuel) or 100), false)
		setElementData(vehicle, "roleplay:vehicles.fuel;", (fuel and math.floor(fuel) or 100), true)
		setElementData(vehicle, "roleplay:vehicles.winstate", (windowsDown and windowsDown or 0), true)
		setElementData(vehicle, "roleplay:vehicles.engine", (engineState and engineState or 0), true)
	end
	
	setVehicleRespawnPosition(vehicle, respawnX, respawnY, respawnZ, respawnRX, respawnRY, respawnRZ)
	
	if (plateText) then
		setVehiclePlateText(vehicle, plateText)
	else
		setVehiclePlateText(vehicle, generateString(math.random(6, 8)))
	end
	
	local ownerName = "nil"
	if (owner > 0) then
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "characterName", "characters", "id", owner)
		local result = dbPoll(query, -1)
		ownerName = result[1]["characterName"]
	end
	
	setElementData(vehicle, "roleplay:vehicles.id", id, true)
	setElementData(vehicle, "roleplay:vehicles.owner", (owner and owner or 0), true)
	setElementData(vehicle, "roleplay:vehicles.ownername", ownerName, true)
	setElementData(vehicle, "roleplay:vehicles.tinted", (tinted and tinted or 0), true)
	setElementData(vehicle, "roleplay:vehicles.lastused", (lastused and lastused or 0), true)
	setElementData(vehicle, "roleplay:vehicles.type", 1, true)
	setElementData(vehicle, "roleplay:vehicles.respawn.int", (respawnInterior and respawnInterior or 0), false)
	setElementData(vehicle, "roleplay:vehicles.respawn.dim", (respawnDimension and respawnDimension or 0), false)
	setElementData(vehicle, "roleplay:vehicles.oldx", x, false)
	setElementData(vehicle, "roleplay:vehicles.oldy", y, false)
	setElementData(vehicle, "roleplay:vehicles.oldz", z, false)
	setElementData(vehicle, "roleplay:vehicles.job", (jobID and jobID or 0), true)
	setElementData(vehicle, "roleplay:vehicles.description", (description and description or ""), true)
	setElementData(vehicle, "roleplay:vehicles.geartype", (manualGearbox and manualGearbox or 1), true)
	setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
	
	local color1 = fromJSON(rgb1)
	local color2 = fromJSON(rgb2)
	setVehicleColor(vehicle, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], 0, 0, 0, 0, 0, 0)
	
	if (not jobID) or (jobID == 0) then
		if (engineState) and (math.floor(fuel) > 0) then
			setVehicleEngineState(vehicle, (engineState == 1 and true or false))
		else
			setVehicleEngineState(vehicle, false)
		end
		
		setVehicleOverrideLights(vehicle, (lightState == 0 and 1 or 2))
		
		if (panelState) then
			local panelStates = fromJSON(panelState)
			if (panelState) then
				for panel,state in ipairs(panelStates) do
					setVehiclePanelState(vehicle, panel-1, (tonumber(state) or 0))
				end
			end
		end
		
		if (doorState) then
			local doorStates = fromJSON(doorState)
			if (doorStates) then
				for door,state in ipairs(doorStates) do
					setVehicleDoorState(vehicle, door-1, (tonumber(state) or 0))
				end
			end
		end
		
		if (wheelState) then
			local wheelStates = fromJSON(wheelState)
			if (wheelStates) then
				setVehicleWheelStates(vehicle, tonumber(wheelStates[1]), tonumber(wheelStates[2]), tonumber(wheelStates[3]), tonumber(wheelStates[4]))
			end
		end
	end
	
	setVehicleDamageProof(vehicle, (damageProof == 1 and true or false))
	setVehicleDoorsUndamageable(vehicle, (damageProof == 1 and true or false))
	
	if (not isInitialization) then
		triggerEvent(":_toggleSnowHandling_:", root, vehicle)
	end
	
	if (getVehicleName(vehicle) == "Bus") then
		setVehicleHandling(vehicle, "engineAcceleration", 4.7)
		setVehicleHandling(vehicle, "engineInertia", 80)
		setVehicleHandling(vehicle, "steeringLock", 46)
		setVehicleHandling(vehicle, "numberOfGears", 3)
		setVehicleHandling(vehicle, "maxVelocity", 100)
		setVehicleHandling(vehicle, "turnMass", 33190)
		setVehicleHandling(vehicle, "tractionMultiplier", 0.75)
		setVehicleHandling(vehicle, "tractionLoss", 0.85)
		setVehicleHandling(vehicle, "tractionBias", 0.4)
		setVehicleHandling(vehicle, "brakeDeceleration", 4.17)
		setVehicleHandling(vehicle, "brakeBias", 0.5)
		
		--[[
		-- Bus
		setModelHandling(431, "engineAcceleration", 4.7)
		setModelHandling(431, "engineInertia", 80)
		setModelHandling(431, "steeringLock", 46)
		setModelHandling(431, "numberOfGears", 3)
		setModelHandling(431, "maxVelocity", 100)
		setModelHandling(431, "turnMass", 33190)
		setModelHandling(431, "tractionMultiplier", 0.75)
		setModelHandling(431, "tractionLoss", 0.85)
		setModelHandling(431, "tractionBias", 0.4)
		setModelHandling(431, "brakeDeceleration", 4.17)
		setModelHandling(431, "brakeBias", 0.5)
		]]
	end
	
	--outputDebugString("Vehicle ID " .. id .. " loaded.")
end

function saveVehicle(vehicle)
	local x, y, z = getElementPosition(vehicle)
	local rx, ry, rz = getElementRotation(vehicle)
	local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle)
	local color1 = toJSON({r1, g1, b1})
	local color2 = toJSON({r2, g2, b2})
	local plateText = getVehiclePlateText(vehicle)

	local panel0 = getVehiclePanelState(vehicle, 0)
	local panel1 = getVehiclePanelState(vehicle, 1)
	local panel2 = getVehiclePanelState(vehicle, 2)
	local panel3 = getVehiclePanelState(vehicle, 3)
	local panel4 = getVehiclePanelState(vehicle, 4)
	local panel5 = getVehiclePanelState(vehicle, 5)
	local panel6 = getVehiclePanelState(vehicle, 6)
	local panelState = toJSON({panel0, panel1, panel2, panel3, panel4, panel5, panel6})

	local door0 = getVehicleDoorState(vehicle, 0)
	local door1 = getVehicleDoorState(vehicle, 1)
	local door2 = getVehicleDoorState(vehicle, 2)
	local door3 = getVehicleDoorState(vehicle, 3)
	local door4 = getVehicleDoorState(vehicle, 4)
	local door5 = getVehicleDoorState(vehicle, 5)
	local doorState = toJSON({door0, door1, door2, door3, door4, door5})

	local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(vehicle)
	local wheelState = toJSON({wheel1, wheel2, wheel3, wheel4})

	local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "vehicles", "posX", x, "posY", y, "posZ", z, "rotX", rx, "rotY", ry, "rotZ", rz, "interior", getElementInterior(vehicle), "dimension", getElementDimension(vehicle), "health", (getElementHealth(vehicle) == 0 and 350 or getElementHealth(vehicle)), "userID", getVehicleOwner(vehicle), "engineState", (isVehicleEngineOn(vehicle) == true and 1 or 0), "lightState", (getVehicleOverrideLights(vehicle) == 1 and 0 or 1), "handbraked", (isVehicleHandbraked(vehicle) == true and 1 or 0), "damageproof", (isVehicleDamageProof(vehicle) == true and 1 or 0), "tinted", isVehicleTinted(vehicle), "lastused", getVehicleLastUsed(vehicle), "color1", color1, "color2", color2, "fuel", getVehicleRealFuel(vehicle), "locked", (isVehicleLocked(vehicle) and 1 or 0), "description", getVehicleDescription(vehicle), "wheelState", wheelState, "panelState", panelState, "doorState", doorState, "manualGearbox", (getVehicleGearType(vehicle)), "plateText", plateText, "id", getVehicleRealID(vehicle))

	if (query) then
		outputDebugString("Saved vehicle ID " .. getVehicleRealID(vehicle) .. ".")
	else
		outputDebugString("Failed to save vehicle ID " .. getVehicleRealID(vehicle) .. " to the database when querying.", 1)
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		for _,v in ipairs(getElementsByType("player")) do
			if (not isKeyBound(v, "j", "down", toggleEngine)) then
				bindKey(v, "j", "down", toggleEngine)
			end
			
			if (not isKeyBound(v, "k", "down", toggleLock)) then
				bindKey(v, "k", "down", toggleLock)
			end
			
			if (not isKeyBound(v, "l", "down", toggleLights)) then
				bindKey(v, "l", "down", toggleLights)
			end
		end
		
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "vehicles")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 vehicle is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " vehicles are about to be loaded.")
				end
				
				for result,row in pairs(result) do
					addVehicle(row["id"], row["modelid"], row["posX"], row["posY"], row["posZ"], row["rotX"], row["rotY"], row["rotZ"], row["interior"], row["dimension"], row["rPosX"], row["rPosY"], row["rPosZ"], row["rRotX"], row["rRotY"], row["rRotZ"], row["respawnInterior"], row["respawnDimension"], row["handbraked"], row["userID"], row["color1"], row["color2"], row["engineState"], row["lightState"], row["damageproof"], row["tinted"], row["lastused"], row["health"], row["fuel"], row["locked"], row["description"], row["panelState"], row["doorState"], row["wheelState"], row["windowsDown"], row["jobID"], row["manualGearbox"], row["plateText"], 1)
				end
				
				setTimer(triggerEvent, 7500, 1, ":_toggleSnowHandling_:", root)
			else
				outputDebugString("0 vehicles loaded. Does the vehicles table contain data and are the settings correct?")
			end
		else
			outputServerLog("Error: MySQL query failed when tried to fetch all vehicles.")
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("vehicle")) do
			if (getVehicleRealID(v)) and (getVehicleRealType(v)) and (getVehicleRealType(v) > 0) then
				saveVehicle(v)
			end
		end
		
		for i,v in ipairs(getElementsByType("player")) do
			if (getElementData(v, "roleplay:characters.invehicle")) then
				removeElementData(v, "roleplay:characters.invehicle")
			end
			
			toggleControl(v, "accelerate", true)
			toggleControl(v, "brake_reverse", true)
			toggleControl(v, "steer_forward", true)
			
			if (isKeyBound(v, "j", "down", toggleEngine)) then
				unbindKey(v, "j", "down", toggleEngine)
			end
			
			if (isKeyBound(v, "k", "down", toggleLock)) then
				unbindKey(v, "k", "down", toggleLock)
			end
			
			if (isKeyBound(v, "l", "down", toggleLights)) then
				unbindKey(v, "l", "down", toggleLights)
			end
		end
	end
)

addEventHandler("onVehicleExplode", root,
	function()
		if (getVehicleRealID(source) and getVehicleRealType(source) and getVehicleRealType(source) > 0) then
			outputServerLog("Vehicles: Vehicle ID " .. getVehicleRealID(source) .. " (" .. getVehicleName(source) .. ") exploded.")
			setTimer(function(vehicle)
				if (isElement(vehicle)) then
					fixVehicle(vehicle)
					setVehicleEngineState(vehicle, false)
					setVehicleOverrideLights(vehicle, 1)
					setElementFrozen(vehicle, true)
					setElementData(vehicle, "roleplay:vehicles.fuel", 100, true)
					setElementData(vehicle, "roleplay:vehicles.fuel;", 100, true)
					setElementData(vehicle, "roleplay:vehicles.engine", 0, true)
					setElementData(vehicle, "roleplay:vehicles.winstate", 0, true)
					setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
					setElementData(vehicle, "roleplay:vehicles.handbrake", 1, true)
					respawnVehicle(vehicle)
					setElementInterior(vehicle, tonumber(getElementData(vehicle, "roleplay:vehicles.respawn.int")))
					setElementDimension(vehicle, tonumber(getElementData(vehicle, "roleplay:vehicles.respawn.dim")))
					outputServerLog("Vehicles: Respawned vehicle ID " .. getVehicleRealID(vehicle) .. " (Explosion).")
				end
			end, 1000*60, 1, source)
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function(type, reason, responsible)
		if (not exports['roleplay-accounts']:isClientPlaying(source)) then return end
		local vehicle = getPedOccupiedVehicle(source)
		if (vehicle) and (getVehicleController(vehicle) == source) then
			if (type ~= "Kicked") and (type ~= "Banned") and (type ~= "Quit") then
				setElementFrozen(vehicle, true)
				setElementData(vehicle, "roleplay:vehicles.handbraked", 1, true)
			end
		end
	end
)

addEventHandler("onVehicleEnter", root,
	function(player, seat, jacked)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then removePedFromVehicle(player) return end
		if (isVehicleLocked(source)) then
			if (locklessVehicle[getElementModel(source)]) then
				setVehicleLocked(source, false)
			else
				removePedFromVehicle(player)
				setVehicleLocked(source, true)
				return
			end
		end
		
		if (tonumber(getElementData(source, "roleplay:vehicles.job"))) and (tonumber(getElementData(source, "roleplay:vehicles.job")) > 0) then
			if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) or (exports['roleplay-accounts']:isClientTrialAdmin(player) and exports['roleplay-accounts']:getAdminState(player) == 0) then
				if (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= 3) then
					if (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= exports['roleplay-accounts']:getCharacterJob(player)) then
						removePedFromVehicle(player)
						outputChatBox("You're not working for that city job at the moment.", player, 245, 20, 20, false)
						return
					end
				else
					if (exports['roleplay-accounts']:hasDriversLicense(player)) then
						if (dmvTruckModels[getElementModel(source)]) then
							if (exports['roleplay-accounts']:hasTruckLicense(player)) then
								removePedFromVehicle(player)
								fixVehicle(source)
								setVehicleEngineState(source, false)
								setVehicleOverrideLights(source, 1)
								setElementFrozen(source, true)
								setVehicleLocked(source, false)
								setElementData(source, "roleplay:vehicles.fuel", 100, true)
								setElementData(source, "roleplay:vehicles.fuel;", 100, true)
								setElementData(source, "roleplay:vehicles.engine", 0, true)
								setElementData(source, "roleplay:vehicles.winstate", 0, true)
								setElementData(source, "roleplay:vehicles.currentGear", 0, true)
								setElementData(source, "roleplay:vehicles.handbrake", 1, true)
								respawnVehicle(source)
								outputChatBox("You already have a Heavy Duty driver's license.", player, 245, 20, 20, false)
								return
							end
						else
							if (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == tonumber(getElementData(player, "roleplay:characters.dmv:manual"))) or (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == 0 and tonumber(getElementData(player, "roleplay:characters.dmv:manual")) == 1) then
								removePedFromVehicle(player)
								fixVehicle(source)
								setVehicleEngineState(source, false)
								setVehicleOverrideLights(source, 1)
								setElementFrozen(source, true)
								setVehicleLocked(source, false)
								setElementData(source, "roleplay:vehicles.fuel", 100, true)
								setElementData(source, "roleplay:vehicles.fuel;", 100, true)
								setElementData(source, "roleplay:vehicles.engine", 0, true)
								setElementData(source, "roleplay:vehicles.winstate", 0, true)
								setElementData(source, "roleplay:vehicles.currentGear", 0, true)
								setElementData(source, "roleplay:vehicles.handbrake", 1, true)
								respawnVehicle(source)
								outputChatBox("You already have a Standard driver's license for " .. (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == 0 and "Automatic" or "Manual") .. " transmission.", player, 245, 20, 20, false)
								return
							end
						end
					end
				end
			end
		end
		
		if (not getElementData(source, "roleplay:vehicles.temp")) then
			if (not enginelessVehicle[getElementModel(source)]) and (getVehicleType(source) ~= "Helicopter") then
				if (isVehicleEngineOn(source)) then
					setVehicleEngineState(source, true)
					toggleControl(player, "accelerate", true)
					toggleControl(player, "brake_reverse", true)
				else
					setVehicleEngineState(source, false)
					toggleControl(player, "accelerate", false)
					toggleControl(player, "brake_reverse", false)
				end
			else
				toggleControl(player, "accelerate", true)
				toggleControl(player, "brake_reverse", true)
				setVehicleEngineState(source, true)
				setElementData(source, "roleplay:vehicles.engine", 1, false)
			end
		else
			if (not enginelessVehicle[getElementModel(source)]) then
				if (getVehicleEngineState(source)) then
					toggleControl(player, "accelerate", true)
					toggleControl(player, "brake_reverse", true)
				else
					toggleControl(player, "accelerate", false)
					toggleControl(player, "brake_reverse", false)
				end
			else
				toggleControl(player, "accelerate", true)
				toggleControl(player, "brake_reverse", true)
				setVehicleEngineState(source, true)
			end
		end
		
		if (bike[getElementModel(source)]) then
			toggleControl(player, "steer_forward", false)
		end
		
		setElementData(player, "roleplay:characters.invehicle", 1, true)
		
		if (exports['roleplay-accounts']:isClientTrialAdmin(player) and exports['roleplay-accounts']:getAdminState(player) == 1) then
			if (getVehicleFaction(source)) then
				outputChatBox("(( This " .. getVehicleName(source) .. " belongs to " .. (getVehicleFaction(source) == 666 and "Socialz's Secret Lounge" or exports['roleplay-factions']:getFactionByID(getVehicleFaction(source))["name"]) .. ". ))", player, 210, 160, 25, false)
			else
				if (getVehicleOwnerName(source)) and (getVehicleOwnerName(source) ~= "nil") then
					outputChatBox("(( This " .. getVehicleName(source) .. " belongs to " .. tostring(getVehicleOwnerName(source)) .. ". ))", player, 210, 160, 25, false)
				elseif (tonumber(getElementData(source, "roleplay:vehicles.job")) > 0) and (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= 3) then
					outputChatBox("(( This " .. getVehicleName(source) .. " belongs to Los Santos Transit. ))", player, 210, 160, 25, false)
				elseif (tonumber(getElementData(source, "roleplay:vehicles.job")) == 3) then
					outputChatBox("(( This " .. getVehicleName(source) .. " belongs to Department of Motor Vehicles. ))", player, 210, 160, 25, false)
				else
					outputChatBox("(( This " .. getVehicleName(source) .. " belongs to an unknown person. ))", player, 210, 160, 25, false)
				end
			end
		end
		
		outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] entered vehicle ID " .. getVehicleRealID(source) .. ".")
	end
)

addEventHandler("onVehicleExit", root,
	function(player, seat, jacked)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] exited vehicle ID " .. getVehicleRealID(source) .. ".")
		setElementData(player, "roleplay:characters.lastvehicle", getVehicleRealID(source), false)
		
		if (getElementData(player, "roleplay:characters.seatbelt")) then
			removeElementData(player, "roleplay:characters.seatbelt")
		end
		
		if (getVehicleRealID(source) > 0) and (tonumber(getElementData(source, "roleplay:vehicles.job")) <= 0) then
			saveVehicle(source)
		end
	end
)

addEventHandler("onVehicleStartEnter", root,
	function(player, seat, jacked, door)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then cancelEvent() return end
		if (getVehicleRealType(source) <= 0 and (not getElementData(source, "roleplay:vehicles.temp"))) then cancelEvent() return end
		if (isVehicleLocked(source)) then
			if (not locklessVehicle[getElementModel(source)]) then
				outputChatBox("The vehicle door is locked.", player, 245, 20, 20, false)
			else
				setVehicleLocked(source, false)
			end
		elseif (tonumber(getElementData(source, "roleplay:vehicles.job"))) and (tonumber(getElementData(source, "roleplay:vehicles.job")) > 0) then
			if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) or (exports['roleplay-accounts']:isClientTrialAdmin(player) and exports['roleplay-accounts']:getAdminState(player) == 0) then
				if (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= 3) then
					if (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= exports['roleplay-accounts']:getCharacterJob(player)) then
						cancelEvent()
						outputChatBox("You're not working for that city job at the moment.", player, 245, 20, 20, false)
					end
				else
					if (exports['roleplay-accounts']:hasDriversLicense(player)) then
						if (dmvTruckModels[getElementModel(source)]) then
							if (exports['roleplay-accounts']:hasTruckLicense(player)) then
								cancelEvent()
								outputChatBox("You already have a Heavy Duty driver's license.", player, 245, 20, 20, false)
							end
						else
							if (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == tonumber(getElementData(player, "roleplay:characters.dmv:manual"))) or (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == 0 and tonumber(getElementData(player, "roleplay:characters.dmv:manual")) == 1) then
								cancelEvent()
								outputChatBox("You already have a Standard driver's license for " .. (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == 0 and "Automatic" or "Manual") .. " transmission.", player, 245, 20, 20, false)
							end
						end
					end
				end
			end
		else
			outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] started entering vehicle ID " .. getVehicleRealID(source) .. ".")
		end
	end
)

addEventHandler("onVehicleStartExit", root,
	function(player, seat, jacked, door)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then cancelEvent() return end
		if (getElementData(player, "roleplay:characters.seatbelt")) then
			cancelEvent()
			outputChatBox("Unbuckle your seatbelt in order to step out of the vehicle.", player, 245, 20, 20, false)
			return
		end
		
		if (isVehicleLocked(source)) then
			cancelEvent()
			if (not locklessVehicle[getElementModel(source)]) then
				outputChatBox("The vehicle door is locked.", player, 245, 20, 20, false)
				return
			else
				setVehicleLocked(source, false)
			end
		else
			if (isPlayerInVehicle(player)) then
				removeElementData(player, "roleplay:characters.invehicle")
			end
			
			if (bike[getElementModel(source)]) then
				toggleControl(player, "steer_forward", true)
			end
			
			outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] started exiting vehicle ID " .. getVehicleRealID(source) .. ".")
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		bindKey(source, "j", "down", toggleEngine)
		bindKey(source, "k", "down", toggleLock)
		bindKey(source, "l", "down", toggleLights)
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

function toggleEngine(player, cmd)
	local _player
	if (not player) and (source) and (getElementType(source) == "player") then _player = source elseif (player) then _player = player end
	if (not exports['roleplay-accounts']:isClientPlaying(_player)) then return end
	if (not isPlayerInVehicle(_player)) then return end
	local vehicle = getPedOccupiedVehicle(_player)
	if (not vehicle) then return end
	if (getVehicleController(vehicle) == _player) then
		if (enginelessVehicle[getElementModel(vehicle)]) then
			outputChatBox("This type of vehicle doesn't have an engine.", _player, 245, 20, 20, false)
			return
		end
		
		if (not getElementData(vehicle, "roleplay:vehicles.temp")) then
			if (getVehicleFuel(vehicle) > 0) then
				if (not isVehicleEngineOn(vehicle)) then
					if (exports['roleplay-items']:hasItem(_player, 7, getVehicleRealID(vehicle))) then
						toggleControl(_player, "accelerate", true)
						toggleControl(_player, "brake_reverse", true)
						setVehicleEngineState(vehicle, true)
						setElementData(vehicle, "roleplay:vehicles.engine", 1, false)
						outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] turned their vehicle's engine on (vehicle ID " .. getVehicleRealID(vehicle) .. ").")
					elseif (exports['roleplay-accounts']:isClientTrialAdmin(_player) and exports['roleplay-accounts']:getAdminState(_player) == 1) then
						toggleControl(_player, "accelerate", true)
						toggleControl(_player, "brake_reverse", true)
						setVehicleEngineState(vehicle, true)
						setElementData(vehicle, "roleplay:vehicles.engine", 1, false)
						outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] turned their vehicle's engine on (vehicle ID " .. getVehicleRealID(vehicle) .. ").")
					elseif (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) > 0) and (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) == 3) then
						toggleControl(_player, "accelerate", true)
						toggleControl(_player, "brake_reverse", true)
						setVehicleEngineState(vehicle, true)
						setElementData(vehicle, "roleplay:vehicles.engine", 1, false)
						outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] turned their vehicle's engine on (vehicle ID " .. getVehicleRealID(vehicle) .. ").")
					elseif (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) > 0) and (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 3) then
						if (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) == exports['roleplay-accounts']:getCharacterJob(_player)) then
							toggleControl(_player, "accelerate", true)
							toggleControl(_player, "brake_reverse", true)
							setVehicleEngineState(vehicle, true)
							setElementData(vehicle, "roleplay:vehicles.engine", 1, false)
							outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] turned their vehicle's engine on (vehicle ID " .. getVehicleRealID(vehicle) .. ").")
						else
							outputChatBox("You need vehicle keys to this vehicle in order to ignite the engine (2).", _player, 245, 20, 20, false)
						end
					elseif (getVehicleFaction(vehicle)) then
						if (exports['roleplay-accounts']:getPlayerFaction(player)) and (getVehicleFaction(vehicle) == exports['roleplay-accounts']:getPlayerFaction(player)) then
							toggleControl(_player, "accelerate", true)
							toggleControl(_player, "brake_reverse", true)
							setVehicleEngineState(vehicle, true)
							setElementData(vehicle, "roleplay:vehicles.engine", 1, false)
							outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] turned their vehicle's engine on (vehicle ID " .. getVehicleRealID(vehicle) .. ").")
						else
							outputChatBox("You need vehicle keys to this vehicle in order to ignite the engine (3).", _player, 245, 20, 20, false)
						end
					else
						outputChatBox("You need vehicle keys to this vehicle in order to ignite the engine (1).", _player, 245, 20, 20, false)
					end
				else
					toggleControl(_player, "accelerate", false)
					toggleControl(_player, "brake_reverse", false)
					setVehicleEngineState(vehicle, false)
					setElementData(vehicle, "roleplay:vehicles.engine", 0, false)
					outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] turned their vehicle's engine off (vehicle ID " .. getVehicleRealID(vehicle) .. ").")
				end
			else
				outputChatBox("The vehicle doesn't have any fuel in the tank.", _player, 245, 20, 20, false)
			end
		else
			if (getVehicleEngineState(vehicle)) then
				toggleControl(_player, "accelerate", false)
				toggleControl(_player, "brake_reverse", false)
				setVehicleEngineState(vehicle, false)
			else
				toggleControl(_player, "accelerate", true)
				toggleControl(_player, "brake_reverse", true)
				setVehicleEngineState(vehicle, true)
			end
		end
	end
end
addCommandHandler({"togengine", "toggleengine", "engine"}, toggleEngine)

function toggleLock(player, cmd)
	local _player
	if (not player) and (source) and (getElementType(source) == "player") then _player = source elseif (player) then _player = player end
	if (not exports['roleplay-accounts']:isClientPlaying(_player)) then return end
	if (isPlayerInVehicle(_player)) then
		local vehicle = getPedOccupiedVehicle(_player)
		if (not vehicle) then return end
		if (getPedOccupiedVehicleSeat(_player) == 0) or (getPedOccupiedVehicleSeat(_player) == 1) then
			if (bike[getElementModel(vehicle)]) or (locklessVehicle[getElementModel(vehicle)]) then
				outputChatBox("This type of vehicle doesn't have a lock.", _player, 245, 20, 20, false)
				return
			end
			
			setVehicleLocked(vehicle, not isVehicleLocked(vehicle))
			exports['roleplay-chat']:outputLocalActionMe(_player, (isVehicleLocked(vehicle) and "locks" or "unlocks") .. " the vehicle doors.")
			outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] " .. (isVehicleLocked(vehicle) and "locked" or "unlocked") .. " their " .. getVehicleName(vehicle) .. " (ID: " .. getVehicleRealID(vehicle) .. ").")
		end
	else
		if (getElementData(_player, "roleplay:temp.stopvehlocking")) then return end
		local x, y, z = getElementPosition(_player)
		local shortestDistance = 20
		local shortestVehicle
		
		for _,vehicle in ipairs(getElementsByType("vehicle")) do
			if (getVehicleRealType(vehicle) > 0) and (getVehicleRealID(vehicle) > 0) then
				local vx, vy, vz = getElementPosition(vehicle)
				local distance = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
				if (distance <= 20) and (getElementInterior(_player) == getElementInterior(vehicle)) and (getElementDimension(_player) == getElementDimension(vehicle)) then
					if (not bike[getElementModel(vehicle)]) and (not locklessVehicle[getElementModel(vehicle)]) then
						if (exports['roleplay-items']:hasItem(_player, 7, getVehicleRealID(vehicle))) or (exports['roleplay-accounts']:isClientTrialAdmin(_player) and exports['roleplay-accounts']:getAdminState(_player) == 1) or ((getVehicleFaction(vehicle) and exports['roleplay-accounts']:getPlayerFaction(player)) and (getVehicleFaction(vehicle) == exports['roleplay-accounts']:getPlayerFaction(player))) then
							if (distance <= shortestDistance) then
								shortestDistance = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
								shortestVehicle = vehicle
							end
						end
					end
				end
			end
		end
		
		if (shortestVehicle) and (isElement(shortestVehicle)) then
			setVehicleLocked(shortestVehicle, not isVehicleLocked(shortestVehicle))
			setPedAnimation(_player, "GHANDS", "gsign3LH", -1, false, false, false, false)
			local name = getVehicleName(shortestVehicle)
			exports['roleplay-chat']:outputLocalActionMe(_player, (isVehicleLocked(shortestVehicle) and "locks" or "unlocks") .. " the " .. ((string.sub(name, string.len(name)-1) == "s") and name .. "'" or name .. "'s") .. " doors.")
			outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] " .. (isVehicleLocked(shortestVehicle) and "locked" or "unlocked") .. " " .. getVehicleName(shortestVehicle) .. " remotely (ID: " .. getVehicleRealID(shortestVehicle) .. ").")
		end
	end
end
addCommandHandler({"toglock", "toglocks", "togglelock", "togglelocks"}, toggleLock)

function toggleLights(player, cmd)
	local _player
	if (not player) and (source) and (getElementType(source) == "player") then _player = source elseif (player) then _player = player end
	if (not exports['roleplay-accounts']:isClientPlaying(_player)) then return end
	if (not isPlayerInVehicle(_player)) then return end
	local vehicle = getPedOccupiedVehicle(_player)
	if (not vehicle) then return end
	if (getPedOccupiedVehicleSeat(_player) == 0) then
		if (lightlessVehicle[getElementModel(vehicle)]) then
			outputChatBox("This type of vehicle doesn't have lights.", _player, 245, 20, 20, false)
			return
		end
		
		if (getVehicleOverrideLights(vehicle) ~= 2) then
			setVehicleOverrideLights(vehicle, 2)
			outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] set their " .. getVehicleName(vehicle) .. "'s lights on (ID: " .. getVehicleRealID(vehicle) .. ").")
		else
			setVehicleOverrideLights(vehicle, 1)
			outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] set their " .. getVehicleName(vehicle) .. "'s lights off (ID: " .. getVehicleRealID(vehicle) .. ").")
		end
	end
end
addCommandHandler({"toglight", "toglights", "togglelight", "togglelights"}, toggleLights)

function toggleHandbrake(player, cmd)
	local _player
	if (not player) and (source) and (getElementType(source) == "player") then _player = source elseif (player) then _player = player end
	if (not exports['roleplay-accounts']:isClientPlaying(_player)) then return end
	if (not isPedInVehicle(_player)) then return end
	local vehicle = getPedOccupiedVehicle(_player)
	if (getPedOccupiedVehicleSeat(_player) == 0) then
		setElementData(vehicle, "roleplay:vehicles.handbrake", (isVehicleHandbraked(vehicle) and 0 or 1), true)
		setElementFrozen(vehicle, isVehicleHandbraked(vehicle))
		outputChatBox("Handbrake is now " .. (isVehicleHandbraked(vehicle) and "applied" or "released") .. ".", _player, 20, 245, 20, false)
		outputServerLog("Vehicles: " .. getPlayerName(_player) .. " [" .. exports['roleplay-accounts']:getAccountName(_player) .. "] " .. (isVehicleHandbraked(vehicle) and "applied" or "released") .. " their handbrake on " .. getVehicleName(vehicle) .. "  (ID: " .. getVehicleRealID(vehicle) .. ").")
	end
end
addCommandHandler({"toghandbrake", "handbrake"}, toggleHandbrake)

addCommandHandler({"seatbelt", "togseatbelt"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not isPlayerInVehicle(player)) then return end
		if (not isPedInVehicle(player)) then return end
		local vehicle = getPedOccupiedVehicle(player)
		if (vehicle) then
			if (bike[getElementModel(vehicle)]) then
				outputChatBox("You cannot toggle the seatbelt on a vehicle like this.", player, 245, 20, 20, false)
				return
			end
			
			if (getElementData(player, "roleplay:characters.seatbelt")) then
				exports['roleplay-chat']:outputLocalActionMe(player, "unbuckles their seatbelt.")
				outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] unbuckles their seatbelt on vehicle ID " .. (getVehicleRealID(vehicle) and getVehicleRealID(vehicle) or "nil") .. ".")
				removeElementData(player, "roleplay:characters.seatbelt")
			else
				exports['roleplay-chat']:outputLocalActionMe(player, "buckles their seatbelt.")
				outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] buckles their seatbelt on vehicle ID " .. (getVehicleRealID(vehicle) and getVehicleRealID(vehicle) or "nil") .. ".")
				setElementData(player, "roleplay:characters.seatbelt", true, false)
			end
		end
	end
)

addCommandHandler({"togwin", "togwindows", "togwindow"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not isPlayerInVehicle(player)) then return end
		if (not isPedInVehicle(player)) then return end
		local vehicle = getPedOccupiedVehicle(player)
		if (vehicle) then
			if (windowless[getElementModel(vehicle)]) or (bike[getElementModel(vehicle)]) then
				outputChatBox("You cannot toggle the windows on a vehicle like this.", player, 245, 20, 20, false)
				return
			end
			
			local state = isVehicleWindowsDown(vehicle)
			setElementData(vehicle, "roleplay:vehicles.winstate", (state and 0 or 1), true)
			exports['roleplay-chat']:outputLocalActionMe(player, "rolls their window " .. (state and "up" or "down") .. ".")
		end
	end
)

addCommandHandler({"lastcar", "lastid", "lastveh", "oldcar", "oldveh", "oldid"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) or (not name) then
			if (getElementData(player, "roleplay:characters.lastvehicle")) then
				outputChatBox("Last vehicle ID was " .. getElementData(player, "roleplay:characters.lastvehicle") .. ".", player, 210, 160, 25, false)
				outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] checked for their last vehicle ID (" .. getElementData(player, "roleplay:characters.lastvehicle") .. ").")
			else
				outputChatBox("You haven't been in a vehicle yet.", player, 245, 20, 20, false)
			end
		else
			local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
			if (target) then
				if (getElementData(target, "roleplay:characters.lastvehicle")) then
					outputChatBox((target == player and "Last" or exports['roleplay-accounts']:getRealPlayerName2(target) .. " last") .. " vehicle ID was " .. getElementData(target, "roleplay:characters.lastvehicle") .. ".", player, 210, 160, 25, false)
					outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] checked for " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " last vehicle ID (" .. getElementData(target, "roleplay:characters.lastvehicle") .. ").")
				end
			else
				outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"thiscar", "thisid", "thisveh"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) or (not name) then
			if (not isPedInVehicle(player)) then
				outputChatBox("You have to be in a vehicle in order to check that.", player, 245, 20, 20, false)
			else
				local vehicle = getPedOccupiedVehicle(player)
				if (vehicle) then
					if (getVehicleRealID(vehicle)) then
						outputChatBox("This vehicle ID is " .. getVehicleRealID(vehicle) .. ".", player, 210, 160, 25, false)
						outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] checked for their vehicle ID (" .. getVehicleRealID(vehicle) .. ").")
					else
						outputChatBox("This is an invalid vehicle and therefore you cannot check its ID.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("You have to be in a vehicle in order to check that.", player, 245, 20, 20, false)
				end
			end
		else
			local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
			if (target) then
				if (isPedInVehicle(target)) then
					local vehicle = getPedOccupiedVehicle(player)
					if (vehicle) then
						if (getVehicleRealID(vehicle)) then
							outputChatBox((target == player and "This" or exports['roleplay-accounts']:getRealPlayerName2(target) .. " current") .. " vehicle ID is " .. getVehicleRealID(vehicle) .. ".", player, 210, 160, 25, false)
							outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] checked for " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " vehicle ID (" .. getVehicleRealID(vehicle) .. ").")
						else
							outputChatBox("The vehicle type is invalid and therefore doesn't own an ID.", player, 245, 20, 20, false)
						end
					else
						outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
					end
				else
					outputChatBox((target == player and "You are not in a vehicle." or "That player is not in a vehicle."), player, 245, 20, 20, false)
				end
			else
				outputChatBox("Cannot find a player with that name or too many results.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"sell", "sellveh"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not name) then
			outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
		else
			if (not isPedInVehicle(player)) then
				outputChatBox("Get in a vehicle in order to do that.", player, 245, 20, 20, false)
				return
			end
			
			local vehicle = getPedOccupiedVehicle(player)
			if (vehicle) then
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					if (target ~= player) then
						if (exports['roleplay-items']:hasItem(player, 7, getVehicleRealID(vehicle))) or (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
							if (getVehicleRealID(vehicle) > 0) then
								if (getElementHealth(vehicle) == 0) then
									outputChatBox("This vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
									return
								end
								
								setElementData(vehicle, "roleplay:vehicles.owner", exports['roleplay-accounts']:getCharacterID(target), true)
								setElementData(vehicle, "roleplay:vehicles.ownername", getPlayerName(target), true)
								
								outputChatBox("Vehicle sold to " .. getPlayerName(target):gsub("_", " ") .. ". Make sure to ask for a /pay.", player, 20, 245, 20, false)
								outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] sold their vehicle (" .. getVehicleRealID(vehicle) .. ") to " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
								
								exports['roleplay-items']:takeItem(player, 7, getVehicleRealID(vehicle))
								exports['roleplay-items']:giveItem(target, 7, getVehicleRealID(vehicle))
							else
								outputChatBox("Cannot sell this type of vehicle.", player, 245, 20, 20, false)
							end
						else
							outputChatBox("You need to have the keys to this vehicle in order to park it.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("You cannot sell the vehicle to yourself, you know.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("No such player found with that name or ID.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("Get in a vehicle in order to do that.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"park", "saveveh"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not isPedInVehicle(player)) then
			outputChatBox("Get in a vehicle in order to do that.", player, 245, 20, 20, false)
			return
		end
		
		local vehicle = getPedOccupiedVehicle(player)
		if (vehicle) then
			if (exports['roleplay-items']:hasItem(player, 7, getVehicleRealID(vehicle))) or (exports['roleplay-accounts']:isClientTrialAdmin(player) and exports['roleplay-accounts']:getAdminState(player) == 1) or ((getVehicleFaction(vehicle)) and ((exports['roleplay-accounts']:getPlayerFaction(player) == getVehicleFaction(vehicle)) and (exports['roleplay-accounts']:getFactionPrivileges(player) > 0))) then
				if (getElementData(player, "roleplay:temp.vehparkcd")) then
					outputChatBox("You have to wait for a bit before parking again.", player, 245, 20, 20, false)
					return
				end
				
				if (getElementHealth(vehicle) == 0) then
					outputChatBox("This vehicle is destroyed. You have to wait for it to respawn.", player, 245, 20, 20, false)
					return
				end
				
				local x, y, z = getElementPosition(vehicle)
				local rx, ry, rz = getElementRotation(vehicle)
				
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "vehicles", "posX", x, "posY", y, "posZ", z, "rotX", rx, "rotY", ry, "rotZ", rz, "interior", getElementInterior(player), "dimension", getElementDimension(player), "rPosX", x, "rPosY", y, "rPosZ", z, "rRotX", rx, "rRotY", ry, "rRotZ", rz, "respawnInterior", getElementInterior(player), "respawnDimension", getElementDimension(player), "id", getVehicleRealID(vehicle))
				setVehicleRespawnPosition(vehicle, x, y, z, rx, ry, rz)
				setElementData(vehicle, "roleplay:vehicles.respawn.int", getElementInterior(player))
				setElementData(vehicle, "roleplay:vehicles.respawn.dim", getElementDimension(player))
				
				outputChatBox("Vehicle respawn position is now saved.", player, 20, 245, 20, false)
				outputServerLog("Vehicles: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] parked their vehicle at '" .. (math.floor(x*100)/100) .. ", " .. (math.floor(y*100)/100) .. ", " .. (math.floor(z*100)/100) .. ", " .. getElementInterior(player) .. ", " .. getElementDimension(player) .. "' (" .. getVehicleRealID(vehicle) .. ").")
				
				setTimer(function(player)
					if (isElement(player)) then
						if (getElementData(player, "roleplay:temp.vehparkcd")) then
							removeElementData(player, "roleplay:temp.vehparkcd")
						end
					end
				end, 2850, 1, player)
			else
				outputChatBox("You need to have the keys to this vehicle in order to park it.", player, 245, 20, 20, false)
			end
		else
			outputChatBox("Get in a vehicle in order to do that.", player, 245, 20, 20, false)
		end
	end
)

-- Some utilities
letters = { "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z" }
numbers = { "0","1","2","3","4","5","6","7","8","9" }
 
function generateLetter ( upper )
    if upper then return letters[ math.random ( #letters ) ]:upper ( ) end
    return letters[ math.random ( #letters ) ]
end
 
function generateNumber ( ) return numbers[ math.random ( 1, #numbers ) ] end
 
function generateString ( length )
    if not length or type ( length ) ~= "number" or math.ceil ( length ) < 2 then return false end
    local result = ""
    for i = 1, math.ceil ( length ) do
        if math.random ( 2 ) == 1 then upper = true else upper = false end
 
        if math.random ( 2 ) == 1 then result = result .. generateLetter ( upper )
        else result = result .. generateNumber ( ) end
    end
    return tostring ( result )
end