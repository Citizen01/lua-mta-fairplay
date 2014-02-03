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

local pressTime = 0

bindKey("horn", "both",
	function(key, state)
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (getVehicleOccupant(vehicle) == localPlayer) and (tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) and (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) == 2) then
			if (state == "down") then
				pressTime = getTickCount()
			elseif (state == "up") and (pressTime ~= 0) then
				if ((getTickCount()-pressTime) < 170) then
					triggerServerEvent(":_syncTaxiLights_:", localPlayer, vehicle)
				end
				pressTime = 0
			end
		else
			pressTime = 0
		end
	end
)