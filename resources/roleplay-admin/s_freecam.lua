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

local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
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

function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamEnabled", root, x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", root, dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", root, theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecam:state")
end

addCommandHandler({"togfreecam", "freemove", "freecam"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then return end
		if (isPlayerFreecamEnabled(player)) then
			setPlayerFreecamDisabled(player)
			setCameraTarget(player, player)
			setElementAlpha(player, 255)
			setElementFrozen(player, false)
		else
			setPlayerFreecamEnabled(player)
			setElementAlpha(player, 0)
			setElementFrozen(player, true)
		end
	end
)

addCommandHandler({"dropdown", "dropme"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then return end
		if (isPlayerFreecamEnabled(player)) then
			local cx, cy, cz, px, py, pz = getCameraMatrix(player)
			setElementPosition(player, cx, cy, cz)
			setPlayerFreecamDisabled(player)
			setCameraTarget(player, player)
			setElementAlpha(player, 255)
			setElementFrozen(player, false)
		else
			outputChatBox("You have to activate freecam mode first.", player, 245, 20, 20, false)
		end
	end
)