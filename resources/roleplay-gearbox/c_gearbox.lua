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

local sx, sy = guiGetScreenSize()
local gearboxViewOn = false
local vehicleCurrentGear = 0
local vehicleTypes = {["Plane"]=true, ["Helicopter"]=true, ["Boat"]=true, ["Trailer"]=true, ["Train"]=true, ["BMX"]=true}
local bike = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true}
local motorbike = {[581]=true, [462]=true, [521]=true, [463]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true}
local postGUI = false

local function updateGear(state)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) or (getVehicleController(vehicle) ~= localPlayer) or (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	local gearType = exports['roleplay-vehicles']:getVehicleGearType(vehicle)
	if (not gearType) then
		toggleControl("accelerate", true)
		toggleControl("brake_reverse", true)
		return
	end
	
	if (state == 1) then
		if (gearType == 1) then
			if (vehicleCurrentGear < 5) then
				vehicleCurrentGear = vehicleCurrentGear+1
				setElementData(vehicle, "roleplay:vehicles.currentGear", vehicleCurrentGear, true)
			else
				return
			end
		else
			if (vehicleCurrentGear < 1) then
				vehicleCurrentGear = vehicleCurrentGear+1
				setElementData(vehicle, "roleplay:vehicles.currentGear", vehicleCurrentGear, true)
			else
				return
			end
		end
	elseif (state == -1) then
		if (vehicleCurrentGear > -1) then
			if (vehicleCurrentGear == 0) then
				if (bike[getElementModel(vehicle)]) then
					return
				end
			end
			
			vehicleCurrentGear = vehicleCurrentGear-1
			setElementData(vehicle, "roleplay:vehicles.currentGear", vehicleCurrentGear, true)
		else
			return
		end
	elseif (state == -2) then
		if (vehicleCurrentGear ~= 0) then
			vehicleCurrentGear = 0
			setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
		else
			return
		end
	else
		if (state == "num_add") then
			updateGear(1)
		elseif (state == "num_sub") then
			updateGear(-1)
		end
		return
	end
	
	playSoundFrontEnd(4)
end

local function updateGearbox()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) or (getVehicleController(vehicle) ~= localPlayer) then return end
	local gearType = exports['roleplay-vehicles']:getVehicleGearType(vehicle)
	if (not gearType) then
		toggleControl("accelerate", true)
		toggleControl("brake_reverse", true)
		return
	end
	
	local vehicleGear = getVehicleCurrentGear(vehicle)
	local velX, velY, velZ = getElementVelocity(vehicle)
	local type = getVehicleType(vehicle)
	
	local velX2 = math.abs(velX)
	local velY2 = math.abs(velY)
	local velZ2 = math.abs(velZ)
	
	local visible
	local velocityActor
	
	if (vehicleCurrentGear == 1) then
		velocityActor = 1.055
	elseif (vehicleCurrentGear == 2) then
		velocityActor = 1.012
	elseif (vehicleCurrentGear == 3) then
		velocityActor = 1.005
	elseif (vehicleCurrentGear == 4) then
		velocityActor = 1.0025
	else
		velocityActor = 1.002
	end
	
	if (not vehicleTypes[type]) then
		if (vehicleCurrentGear > 0) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			
			if (bike[getElementModel(vehicle)]) then
				toggleControl("accelerate", true)
				toggleControl("brake_reverse", true)
			else
				toggleControl("accelerate", true)
				toggleControl("brake_reverse", false)
				
				if (exports['roleplay-vehicles']:getElementSpeed(vehicle) > 6) then
					toggleControl("brake_reverse", true)
				else
					toggleControl("brake_reverse", false)
					setControlState("brake_reverse", false)
				end
			end
			
			if (gearType == 1) then
				if (vehicleCurrentGear < vehicleGear) then
					if (math.max(velX2, velY2, velZ2) ~= velZ2) then
						local x, y = velX/velocityActor, velY/velocityActor
						setElementVelocity(vehicle, x, y, velZ)
						dxDrawLine((sx-102*2)-91, sy-221, sx-205, sy-221, tocolor(255, 25, 25, 255), 4, postGUI)
					end
				end
			end
		elseif (vehicleCurrentGear == 0) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			
			if (bike[getElementModel(vehicle)]) then
				if (motorbike[getElementModel(vehicle)]) then
					toggleControl("accelerate", false)
					toggleControl("brake_reverse", true)
				else
					toggleControl("accelerate", true)
					toggleControl("brake_reverse", true)
				end
			else
				toggleControl("accelerate", false)
				toggleControl("brake_reverse", false)
			end
		elseif (vehicleCurrentGear == -1) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			
			if (bike[getElementModel(vehicle)]) then
				toggleControl("accelerate", false)
				toggleControl("brake_reverse", true)
			else
				toggleControl("accelerate", true)
				toggleControl("brake_reverse", true)
			end
			
			if (exports['roleplay-vehicles']:getElementSpeed(vehicle) > 6) then
				toggleControl("accelerate", true)
			else
				toggleControl("accelerate", false)
				setControlState("accelerate", false)
			end
		end
		
		if (vehicleGear < vehicleCurrentGear) then
			if (math.max(velX2, velY2, velZ2) ~= velZ2) then
				local s = (((vehicleCurrentGear-vehicleGear)/100)+1)
				s = s*(((vehicleCurrentGear-vehicleGear)/120)+1)
				local x, y = velX/s, velY/s
				setElementVelocity(vehicle, x, y, velZ)
			end
		end
		
		local _vehicleCurrentGear = "F"
		if (vehicleCurrentGear == 0) then
			_vehicleCurrentGear = "N"
		elseif (vehicleCurrentGear == -1) then
			_vehicleCurrentGear = "R"
		else
			if (gearType == 1) then
				_vehicleCurrentGear = vehicleCurrentGear
			end
		end
		
		dxDrawRectangle((sx-102*2)-91, sy-289, 91, 71, tocolor(0, 0, 0, 0.6*255), postGUI)
		dxDrawText(_vehicleCurrentGear, (sx-102*2)-89, sy-282, (sx-102*2), (sy-289)+69, tocolor(0, 0, 0, 0.5*255), 2, "default-bold", "center", "center", true, false, postGUI, false, false)
		dxDrawText(_vehicleCurrentGear, (sx-102*2)-91, sy-284, (sx-102*2), (sy-289)+69, (vehicleCurrentGear == -1 and tocolor(200, 25, 25, 0.8*255) or tocolor(255, 255, 255, 0.8*255)), 2, "default-bold", "center", "center", true, false, postGUI, false, false)
		
		if (isChatBoxInputActive()) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			toggleControl("accelerate", false)
			toggleControl("brake_reverse", false)
		end
	else
		toggleControl("accelerate", true)
		toggleControl("brake_reverse", true)
	end
end

addEventHandler("onClientVehicleEnter", root,
	function(player, seat)
		if (player ~= localPlayer) or (seat ~= 0) or (not exports['roleplay-accounts']:isClientPlaying(player)) or (not exports['roleplay-vehicles']:getVehicleGearType(source)) then return end
		addEventHandler("onClientRender", root, updateGearbox)
		gearboxViewOn = true
		vehicleCurrentGear = tonumber(getElementData(source, "roleplay:vehicles.currentGear"))
	end
)

addEventHandler("onClientVehicleExit", root,
	function(player, seat)
		if (player ~= localPlayer) or (seat ~= 0) or (not exports['roleplay-accounts']:isClientPlaying(player)) or (not exports['roleplay-vehicles']:getVehicleGearType(source)) then return end
		removeEventHandler("onClientRender", root, updateGearbox)
		gearboxViewOn = true
		setElementData(source, "roleplay:vehicles.currentGear", vehicleCurrentGear, true)
		vehicleCurrentGear = 0
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local vehicle = getPedOccupiedVehicle(localPlayer)
		
		if (vehicle) and (exports['roleplay-accounts']:isClientPlaying(localPlayer)) and (getVehicleController(vehicle) == localPlayer) and (exports['roleplay-vehicles']:getVehicleGearType(vehicle)) then
			addEventHandler("onClientRender", root, updateGearbox)
			gearboxViewOn = true
			vehicleCurrentGear = tonumber(getElementData(vehicle, "roleplay:vehicles.currentGear"))
		end
		
		bindKey("num_mul", "down", "gear_neutralize")
		bindKey("num_sub", "down", updateGear, -1)
		bindKey("num_add", "down", updateGear, 1)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if (gearboxViewOn) then
			toggleControl("accelerate", true)
			toggleControl("brake_reverse", true)
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			setElementData(getPedOccupiedVehicle(localPlayer), "roleplay:vehicles.currentGear", vehicleCurrentGear, true)
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
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end
			)
		end
	end
end

addCommandHandler({"gear_up", "gear_down", "gear_n", "gear_neutral", "gear_neutralize"},
	function(cmd)
		if (cmd == "gear_n") or (cmd == "gear_neutral") or (cmd == "gear_neutralize") then
			updateGear(-2)
		else
			updateGear((cmd == "gear_up" and 1 or -1))
		end
	end
)