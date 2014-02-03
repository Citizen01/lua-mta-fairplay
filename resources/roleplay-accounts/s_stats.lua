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

addCommandHandler("stats",
	function(player, cmd)
		if (not isClientPlaying(player)) then return end
		outputChatBox("Character stats for " .. getRealPlayerName(player) .. ":", player, 210, 160, 25, false)
		outputChatBox("   Cash in wallet: " .. exports['roleplay-banking']:getFormattedValue(getPlayerMoney(player)) .. " USD", player, 210, 160, 25, false)
		if (hasDriversLicense(player)) then
			outputChatBox("   Driver's license: " .. (tonumber(getElementData(player, "roleplay:characters.dmv:license")) == 1 and "Standard" or "Heavy Duty") .. " (" .. (tonumber(getElementData(player, "roleplay:characters.dmv:manual")) == 1 and "Manual & Automatic" or "Automatic") .. ")", player, 210, 160, 25, false)
		else
			outputChatBox("   Driver's license: None", player, 210, 160, 25, false)
		end
	end, false, false
)