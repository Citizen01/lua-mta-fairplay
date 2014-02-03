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

addEvent(":_doFetchOptionMenuData_:", true)
addEventHandler(":_doFetchOptionMenuData_:", root,
	function(vehicle)
		if (source ~= client) then return end
		if (not vehicle) or (not isElement(vehicle)) then return end
		if (exports['roleplay-items']:hasItem(client, 7, getVehicleID(vehicle))) or
		(getVehicleController(vehicle) == client) or
		(exports['roleplay-accounts']:isClientTrialAdmin(client) and exports['roleplay-accounts']:getAdminState(client) == 1) or
		(tonumber(getElementData(vehicle, "roleplay:vehicles.job")) and tonumber(getElementData(vehicle, "roleplay:vehicles.job")) > 0 and tonumber(getElementData(vehicle, "roleplay:vehicles.job")) == exports['roleplay-accounts']:getCharacterJob(client)) or
		((exports['roleplay-accounts']:getPlayerFaction(client)) and (getVehicleFaction(vehicle)) and (getVehicleFaction(vehicle) == exports['roleplay-accounts']:getPlayerFaction(client))) then
			triggerClientEvent(client, ":_doUpdateOptionMenu_:", client, true)
		end
	end
)

addEvent(":_doToggleVehicleLockOption_:", true)
addEventHandler(":_doToggleVehicleLockOption_:", root,
	function(vehicle)
		if (source ~= client) then return end
		if (exports['roleplay-items']:hasItem(client, 7, getVehicleID(vehicle))) or
		(getVehicleController(vehicle) == client) or
		(exports['roleplay-accounts']:isClientTrialAdmin(client) and exports['roleplay-accounts']:getAdminState(client) == 1) or
		(tonumber(getElementData(vehicle, "roleplay:vehicles.job")) and tonumber(getElementData(vehicle, "roleplay:vehicles.job")) > 0 and tonumber(getElementData(vehicle, "roleplay:vehicles.job")) == exports['roleplay-accounts']:getCharacterJob(client)) or
		((exports['roleplay-accounts']:getPlayerFaction(client)) and (getVehicleFaction(vehicle)) and (getVehicleFaction(vehicle) == exports['roleplay-accounts']:getPlayerFaction(client))) then
			local playerVehicle = getPedOccupiedVehicle(client)
			local locked = not isVehicleLocked(vehicle)
			local name = getVehicleName(vehicle)
			
			if (playerVehicle) then
				if (playerVehicle == vehicle) then
					exports['roleplay-chat']:outputLocalActionMe(client, (locked == true and "locks" or "unlocks") .. " the vehicle doors.")
					outputServerLog("Vehicles: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] " .. (locked == true and "locked" or "unlocked") .. " their " .. getVehicleName(vehicle) .. " (ID: " .. getVehicleID(vehicle) .. ").")
				else
					exports['roleplay-chat']:outputLocalActionMe(client, (locked == true and "locks" or "unlocks") .. " the " .. ((string.sub(name, string.len(name)-1) == "s") and name .. "'" or name .. "'s") .. " doors.")
					outputServerLog("Vehicles: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] " .. (locked == true and "locked" or "unlocked") .. " " .. getVehicleName(vehicle) .. " remotely (ID: " .. getVehicleID(vehicle) .. ").")
				end
			else
				exports['roleplay-chat']:outputLocalActionMe(client, (locked == true and "locks" or "unlocks") .. " the " .. ((string.sub(name, string.len(name)-1) == "s") and name .. "'" or name .. "'s") .. " doors.")
				outputServerLog("Vehicles: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] " .. (locked == true and "locked" or "unlocked") .. " " .. getVehicleName(vehicle) .. " remotely (ID: " .. getVehicleID(vehicle) .. ").")
			end
			
			setVehicleLocked(vehicle, locked)
		else
			outputChatBox("y u be so mean.", client, 245, 20, 20, false)
		end
	end
)

addEvent(":_syncVehicleDoorStates_:", true)
addEventHandler(":_syncVehicleDoorStates_:", root,
	function(vehicle, door, position)
		if (not vehicle) or (not isElement(vehicle)) then return end
		local ratio = (position/100)
		
		if (position == 0) then
			ratio = 0
		elseif (position == 100) then
			ratio = 1
		end
		
		setVehicleDoorOpenRatio(vehicle, door, ratio, 0.5)
	end
)

addEvent(":_doSetVehicleDescOption_:", true)
addEventHandler(":_doSetVehicleDescOption_:", root,
	function(vehicle, newDescription)
		if (source ~= client) then return end
		if (exports['roleplay-items']:hasItem(client, 7, getVehicleID(vehicle))) or (exports['roleplay-accounts']:getAdminState(client) == 1) then
			setElementData(vehicle, "roleplay:vehicles.description", newDescription, true)
			outputChatBox("Vehicle description is now updated.", client, 20, 245, 20, false)
			outputServerLog("Vehicles: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] set their " .. getVehicleName(vehicle) .. " vehicle description (ID: " .. getVehicleID(vehicle) .. ").")
		else
			outputChatBox("y u be so mean.", client, 245, 20, 20, false)
		end
	end
)