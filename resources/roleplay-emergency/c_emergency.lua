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

-- Strobes
local strobeTimers = {}

function strobeRepeater(vehicle, mode)
	if (isTimer(strobeTimers[vehicle])) then killTimer(strobeTimers[vehicle]) end
	local mode = tonumber(mode)
	if (mode == 1) or (not mode) then
		setVehicleHeadLightColor(vehicle, 0, 0, 255)
		setVehicleLightState(vehicle, 0, 1)
		setVehicleLightState(vehicle, 2, 1)
		strobeTimers[vehicle] = setTimer(function(vehicle)
			if (not isElement(vehicle)) then
				killTimer(strobeTimers[vehicle])
				strobeTimers[vehicle] = nil
			end
			
			local r, g, b = getVehicleHeadLightColor(vehicle)
			if (r == 255) and (g == 0) and (b == 0) then
				setVehicleHeadLightColor(vehicle, 0, 0, 255)
				setVehicleLightState(vehicle, 0, 1)
				setVehicleLightState(vehicle, 2, 1)
				setVehicleLightState(vehicle, 1, 0)
				setVehicleLightState(vehicle, 3, 0)
			else
				setVehicleHeadLightColor(vehicle, 255, 0, 0)
				setVehicleLightState(vehicle, 0, 0)
				setVehicleLightState(vehicle, 2, 0)
				setVehicleLightState(vehicle, 1, 1)
				setVehicleLightState(vehicle, 3, 1)
			end
		end, 200, 0, vehicle)
	elseif (mode) and (mode == 2) then
		setVehicleHeadLightColor(vehicle, 255, 255, 255)
		setVehicleLightState(vehicle, 0, 1)
		setVehicleLightState(vehicle, 2, 1)
		strobeTimers[vehicle] = setTimer(function(vehicle)
			if (not isElement(vehicle)) then
				killTimer(strobeTimers[vehicle])
				strobeTimers[vehicle] = nil
			end
			
			local state = getVehicleLightState(vehicle, 0)
			if (state == 0) then
				setVehicleLightState(vehicle, 0, 1)
				setVehicleLightState(vehicle, 2, 1)
				setVehicleLightState(vehicle, 1, 0)
				setVehicleLightState(vehicle, 3, 0)
			else
				setVehicleLightState(vehicle, 0, 0)
				setVehicleLightState(vehicle, 2, 0)
				setVehicleLightState(vehicle, 1, 1)
				setVehicleLightState(vehicle, 3, 1)
			end
		end, 100, 0, vehicle)
	end
end

addEvent(":_toggleEmergencyStrobes_:", true)
addEventHandler(":_toggleEmergencyStrobes_:", root,
	function(vehicle)
		if (strobeTimers[vehicle]) then
			killTimer(strobeTimers[vehicle])
			strobeTimers[vehicle] = nil
		end
		
		if (getElementData(vehicle, "roleplay:vehicles.strobe")) then
			strobeRepeater(vehicle, 1)
		else
			setVehicleHeadLightColor(vehicle, 255, 255, 255)
			setVehicleLightState(vehicle, 0, 0)
			setVehicleLightState(vehicle, 2, 0)
			setVehicleLightState(vehicle, 1, 0)
			setVehicleLightState(vehicle, 3, 0)
		end
	end
)

-- Sirens
local sirens = {}
local sounds = {}

function soundRepeater(vehicle)
	if (isTimer(sirens[vehicle])) then killTimer(sirens[vehicle]) end
	if (isElement(sounds[vehicle])) then destroyElement(sounds[vehicle]) end
	
	local x, y, z = getElementPosition(vehicle)
	sounds[vehicle] = playSound3D("sounds/3.wav", x, y, z, false)
	setElementInterior(sounds[vehicle], getElementInterior(vehicle))
	setElementDimension(sounds[vehicle], getElementDimension(vehicle))
	attachElements(sounds[vehicle], vehicle)
	setSoundMinDistance(sounds[vehicle], 30)
	setSoundMaxDistance(sounds[vehicle], 200)
	
	sirens[vehicle] = setTimer(function(vehicle)
		if (not isElement(vehicle)) then
			killTimer(sirens[vehicle])
			sirens[vehicle] = nil
			
			if (sounds[vehicle]) then
				destroyElement(sounds[vehicle])
				sounds[vehicle] = nil
			end
		end
		
		destroyElement(sounds[vehicle])
		local x, y, z = getElementPosition(vehicle)
		sounds[vehicle] = playSound3D("sounds/4.wav", x, y, z, true)
		setElementInterior(sounds[vehicle], getElementInterior(vehicle))
		setElementDimension(sounds[vehicle], getElementDimension(vehicle))
		attachElements(sounds[vehicle], vehicle)
		setSoundMinDistance(sounds[vehicle], 30)
		setSoundMaxDistance(sounds[vehicle], 200)
		
		sirens[vehicle] = setTimer(function(vehicle)
			if (not isElement(vehicle)) then
				killTimer(sirens[vehicle])
				sirens[vehicle] = nil
				
				if (sounds[vehicle]) then
					destroyElement(sounds[vehicle])
					sounds[vehicle] = nil
				end
			end
			soundRepeater(vehicle)
		end, 3600, 1, vehicle)
	end, 3600, 1, vehicle)
end

addEvent(":_toggleEmergencySirens_:", true)
addEventHandler(":_toggleEmergencySirens_:", root,
	function(vehicle)
		if (sirens[vehicle]) then
			killTimer(sirens[vehicle])
			sirens[vehicle] = nil
		end
		
		if (sounds[vehicle]) then
			destroyElement(sounds[vehicle])
			sounds[vehicle] = nil
		end
		
		if (getElementData(vehicle, "roleplay:vehicles.siren")) then
			soundRepeater(vehicle)
		end
	end
)

addEventHandler("onClientElementStreamIn", root,
	function()
		if (getElementType(source) == "vehicle") and (getElementData(source, "roleplay:vehicles.siren")) and (not sounds[source]) then
			soundRepeater(source)
		end
	end
)

addEventHandler("onClientElementStreamOut", root,
	function()
		if (getElementType(source) == "vehicle") and (sounds[source]) then
			if (isTimer(sirens[source])) then
				killTimer(sirens[source])
				sirens[source] = nil
			end
			
			destroyElement(sounds[source])
			sounds[source] = nil
		end
	end
)