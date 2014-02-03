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

addCommandHandler({"makegun", "givegun", "creategun", "makeweapon", "giveweapon", "givewep", "gw", "makewep", "createwep", "createweapon"},
	function(player, cmd, name, id, ammo)
		if (not exports['roleplay-accounts']:isClientSenior(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local ammo = tonumber(ammo)
			if (not id) or (ammo and ammo < 0) or (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [weapon id/name] [ammo]", player, 210, 160, 25, false)
				return
			else
				local _id
				
				if (not tonumber(id)) then
					local id = id:gsub("_", " ")
					if (not getWeaponIDFromName(id)) then
						outputChatBox("Invalid weapon name passed in.", player, 245, 20, 20, false)
						return
					else
						_id = getWeaponIDFromName(id)
					end
				else
					local id = tonumber(id)
					if (not getWeaponNameFromID(id)) then
						outputChatBox("Invalid weapon ID passed in.", player, 245, 20, 20, false)
						return
					else
						_id = id
					end
				end
				
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					giveWeapon(target, _id, ammo)
					exports['roleplay-items']:giveItem(target, 11, _id)
					exports['roleplay-items']:giveItem(target, 12, _id .. "#" .. ammo)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " gave " .. getPlayerName(target):gsub("_", " ") .. " a " .. getWeaponNameFromID(_id) .. " with " .. ammo .. " bullets.")
					outputServerLog("Weapons: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] gave " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] a " .. getWeaponNameFromID(_id) .. " with " .. ammo .. " bullets.")
				else
					outputChatBox("Player with that name or ID cannot be found.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"makeammo", "giveammo", "createammo"},
	function(player, cmd, name, id, ammo)
		if (not exports['roleplay-accounts']:isClientSenior(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local ammo = tonumber(ammo)
			if (not id) or (not ammo) or (ammo <= 0) or (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [weapon id/name] [ammo]", player, 210, 160, 25, false)
				return
			else
				local id = tonumber(id)
				local _id
				
				if (not id) then
					local id = id:gsub("_", " ")
					if (not getWeaponIDFromName(id)) then
						outputChatBox("Invalid weapon name passed in.", player, 245, 20, 20, false)
						return
					else
						_id = getWeaponIDFromName(id)
					end
				else
					if (not getWeaponNameFromID(id)) then
						outputChatBox("Invalid weapon ID passed in.", player, 245, 20, 20, false)
						return
					else
						_id = id
					end
				end
				
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					if (getPedWeapon(target, getSlotFromWeapon(_id))) then
						giveWeapon(target, _id, ammo)
					end
					
					exports['roleplay-items']:giveItem(target, 12, _id .. "#" .. ammo)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " gave " .. getPlayerName(target):gsub("_", " ") .. " " .. ammo .. " bullets to " .. getWeaponNameFromID(_id) .. ".")
					outputServerLog("Weapons: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] gave " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] " .. ammo .. " bullets to " .. getWeaponNameFromID(_id) .. ".")
				else
					outputChatBox("Player with that name or ID cannot be found.", player, 245, 20, 20, false)
				end
			end
		end
	end
)