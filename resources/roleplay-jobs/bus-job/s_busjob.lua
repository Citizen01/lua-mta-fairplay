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

addEvent(":_payBusJob_:", true)
addEventHandler(":_payBusJob_:", root,
	function(totalGather)
		if (getElementData(source, "roleplay:jobs.marker")) then
			removeElementData(source, "roleplay:jobs.marker")
		end
		
		if (getElementData(source, "roleplay:jobs.route")) then
			removeElementData(source, "roleplay:jobs.route")
		end
		
		if (getElementData(source, "roleplay:jobs.gather")) then
			removeElementData(source, "roleplay:jobs.gather")
		end
		
		exports['roleplay-banking']:giveBankValue(source, totalGather)
	end
)

addEvent(":_takeShitFromBus_:", true)
addEventHandler(":_takeShitFromBus_:", root,
	function(totalGather)
		if (getElementData(source, "roleplay:jobs.marker")) then
			removeElementData(source, "roleplay:jobs.marker")
		end
		
		if (getElementData(source, "roleplay:jobs.route")) then
			removeElementData(source, "roleplay:jobs.route")
		end
		
		if (getElementData(source, "roleplay:jobs.gather")) then
			removeElementData(source, "roleplay:jobs.gather")
		end
	end
)

addEvent(":_updateBusData_:", true)
addEventHandler(":_updateBusData_:", root,
	function(currentMarker, currentRoute, totalGather)
		if (not exports['roleplay-accounts']:isClientPlaying(source)) then return end
		if (exports['roleplay-accounts']:getCharacterJob(source) ~= 1) then return end
		local vehicle = getPedOccupiedVehicle(source)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= source) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 1) then return end
		setElementData(source, "roleplay:jobs.marker", currentMarker, true)
		setElementData(source, "roleplay:jobs.route", currentRoute, true)
		setElementData(source, "roleplay:jobs.gather", totalGather, true)
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if (not exports['roleplay-accounts']:isClientPlaying(source)) then return end
		if (exports['roleplay-accounts']:getCharacterJob(source) ~= 1) then return end
		local vehicle = getPedOccupiedVehicle(source)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= source) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 1) then return end
		if (not tonumber(getElementData(source, "roleplay:jobs.route"))) or (not tonumber(getElementData(source, "roleplay:jobs.marker"))) or (not tonumber(getElementData(source, "roleplay:jobs.gather"))) then return end
		exports['roleplay-banking']:giveBankValue(source, tonumber(getElementData(source, "roleplay:jobs.gather")))
	end
)

--[[addEventHandler("onMarkerHit", root,
	function(vehicle, matchingDimension)
		if (getElementType(vehicle) ~= "vehicle") or (not matchingDimension) then return end
		local player = getVehicleController(vehicle)
		if (not player) or (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 1) then return end
		triggerClientEvent(player, ":_onClientMarkerHit_:", player, source, vehicle)
	end
)]]