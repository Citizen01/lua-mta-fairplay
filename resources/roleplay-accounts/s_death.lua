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

addEventHandler("onPlayerWasted", root,
	function(ammo, killer, weapon, bodypart, stealth)
		local player
		
		if (not source) then
			player = killer
		else
			player = source
		end
		
		fadeCamera(player, false, 7.5)
		outputServerLog("Death: " .. getPlayerName(player) .. " [" .. getAccountName(player) .. "] died (" .. (player == killer and "Suicide)" or (killer and getPlayerName(killer) .. "[" .. getAccountName(killer) .. "])" or "Unknown") .. ". Death caused with " .. weapon) .. ".")
		outputAdminLog(getPlayerName(player) .. " died (" .. (player ~= killer and "Suicide)" or getPlayerName(killer) .. ". Death caused with " .. getWeaponNameFromID(weapon) .. "."))
		
		local model = getElementModel(player)
		local x, y, z = getElementPosition(player)
		local dist = getDistanceBetweenPoints3D(x, y, z, 2034.55, -1414.66, 17.99)
		local totalCharge = 30
		
		if (dist >= 500) then
			totalCharge = math.floor(((dist-(dist/2))/2)/4)
		end
		
		exports['roleplay-banking']:takeBankValue(player, totalCharge)
		setElementFrozen(player, true)
		
		setTimer(function(player, model, distance, totalCharge)
			if (isElement(player)) and (isClientPlaying(player)) then
				spawnPlayer(player, 2034.55, -1414.66, 17.99, 133.51, model, 0, 0, nil)
				fadeCamera(player, true, 2.5)
				setCameraTarget(player, player)
				setTimer(setElementFrozen, 500, 1, player, false)
				triggerClientEvent(player, ":_addNewMessage_:", player, "NOTIFICATION: You were playerkilled, which means you cannot remember anything what happened before you woke up at the hospital. Metagaming will result in a punishment. Additionally, the hospital charged $" .. totalCharge .. " for your stay.", 30000)
			end
		end, 7.5*1000, 1, player, model, dist, totalCharge)
	end
)