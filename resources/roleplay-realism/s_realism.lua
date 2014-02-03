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

local weaponClips = {
	[16] = 1, -- Grenade
	[17] = 1, -- Tear Gas
	[18] = 1, -- Molotov
	[22] = 17, -- Colt 45
	[23] = 17, -- Silenced
	[24] = 7, -- Deagle
	[25] = 1, -- Shotgun
	[26] = 2, -- Sawn-Off
	[27] = 7, -- SPAZ-12
	[28] = 50, -- Uzi
	[29] = 30, -- MP5
	[30] = 30, -- AK-47
	[31] = 50, -- M4
	[32] = 50, -- TEC-9
	[33] = 1, -- Rifle
	[34] = 1, -- Sniper
	[35] = 1, -- RPG
	[36] = 1, -- HS RPG
	[37] = 50, -- Flamethrower
	[38] = 500, -- Minigun
	[39] = 1, -- Satchel Charge
	[41] = 500, -- Spraycan
	[42] = 500, -- Fire Extinguisher
	[43] = 36 -- Camera
}

-- Commands
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

addCommandHandler("reload",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local player_
		
		if (player) then
			player_ = player
		else
			player_ = source
		end
		
		if (getPedAmmoInClip(player_) <= 1) then
			reloadPedWeapon(player_)
			outputServerLog("Realism: " .. getPlayerName(player_) .. " [" .. exports['roleplay-accounts']:getAccountName(player_) .. "] reloaded their weapon.")
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		bindKey(source, "r", "down", "reload")
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			bindKey(v, "r", "down", "reload")
		end
	end
)

addEvent(":_doMurderPlayer_:", true)
addEventHandler(":_doMurderPlayer_:", root,
	function(player)
		if (source ~= client) then return end
		killPed(client)
		outputServerLog("Kill: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] died from a headshot.")
	end
)