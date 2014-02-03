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

local function enterElevator()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (getPedOccupiedVehicle(localPlayer)) then return end
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getElevatorID(v)) then
			local x, y, z = getElementPosition(localPlayer)
			local px, py, pz = getElementPosition(v)
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 1) then
				if (getElementInterior(localPlayer) == getElementInterior(v)) and (getElementDimension(localPlayer) == getElementDimension(v)) then
					if (getElevatorOpenType(v) == 1) then
						triggerServerEvent(":_doEnterElevator_:", localPlayer, v)
						break
					elseif (getElevatorOpenType(v) == 2) then
						outputChatBox("The elevator is disabled.", 245, 20, 20, false)
					elseif (getElevatorOpenType(v) == 0) then
						outputChatBox("The elevator is locked.", 245, 20, 20, false)
					end
				end
			end
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("f", "down", enterElevator)
		bindKey("enter", "down", enterElevator)
	end
)