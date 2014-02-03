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

addEventHandler("onResourceStart", resourceRoot,
	function()
		for _,vehicle in ipairs(getElementsByType("vehicle")) do
			if (getElementData(vehicle, "roleplay:vehicles.siren")) then
				removeElementData(vehicle, "roleplay:vehicles.siren")
			end
			
			if (getElementData(vehicle, "roleplay:vehicles.strobe")) then
				removeElementData(vehicle, "roleplay:vehicles.strobe")
				setVehicleHeadLightColor(vehicle, 255, 255, 255)
				setVehicleLightState(vehicle, 0, 0)
				setVehicleLightState(vehicle, 2, 0)
				setVehicleLightState(vehicle, 1, 0)
				setVehicleLightState(vehicle, 3, 0)
			end
		end
		
		for _,player in ipairs(getElementsByType("player")) do
			bindKey(player, "p", "down", "togemlights")
			bindKey(player, "n", "down", "togsiren")
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for _,vehicle in ipairs(getElementsByType("vehicle")) do
			if (getElementData(vehicle, "roleplay:vehicles.siren")) then
				removeElementData(vehicle, "roleplay:vehicles.siren")
			end
			
			if (getElementData(vehicle, "roleplay:vehicles.strobe")) then
				removeElementData(vehicle, "roleplay:vehicles.strobe")
				setVehicleHeadLightColor(vehicle, 255, 255, 255)
				setVehicleLightState(vehicle, 0, 0)
				setVehicleLightState(vehicle, 2, 0)
				setVehicleLightState(vehicle, 1, 0)
				setVehicleLightState(vehicle, 3, 0)
			end
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		bindKey(source, "p", "down", "togemlights")
		bindKey(source, "n", "down", "togsiren")
	end
)

-- Commands
addCommandHandler("togsiren",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not exports['roleplay-vehicles']:isPlayerInVehicle(player)) then return end
		local vehicle = getPedOccupiedVehicle(player)
		if (vehicle) and (getVehicleController(vehicle) == player) then
			if (getElementData(vehicle, "roleplay:vehicles.siren")) then
				removeElementData(vehicle, "roleplay:vehicles.siren")
			else
				setElementData(vehicle, "roleplay:vehicles.siren", true, true)
			end
			triggerClientEvent(root, ":_toggleEmergencySirens_:", root, vehicle)
		end
	end
)

addCommandHandler("togemlights",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not exports['roleplay-vehicles']:isPlayerInVehicle(player)) then return end
		local vehicle = getPedOccupiedVehicle(player)
		if (vehicle) and (getVehicleController(vehicle) == player) then
			if (getElementData(vehicle, "roleplay:vehicles.strobe")) then
				removeElementData(vehicle, "roleplay:vehicles.strobe")
			else
				setElementData(vehicle, "roleplay:vehicles.strobe", true, true)
			end
			triggerClientEvent(root, ":_toggleEmergencyStrobes_:", root, vehicle)
		end
	end
)