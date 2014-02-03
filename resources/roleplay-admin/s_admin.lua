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

setTimer(function()
	reloadBans()
	outputServerLog("Reloaded bans.")
end, 30000, 0)

addCommandHandler({"announce", "announcement", "ann"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local message = table.concat({...}, " ")
			if (not ...) or (not message) or (#message <= 1) then
				outputChatBox("SYNTAX: /" .. cmd .. " [message]", player, 210, 160, 25, false)
			else
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player) .. " sent a global broadcast to the server.")
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientPlaying(v)) then
						outputChatBox(" * GLOBAL BROADCAST: " .. message, v, 220, 205, 25, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"fulllock", "lockserver", "lockdown"},
	function(player, cmd)
		local account = getPlayerAccount(player)
		if (not account) or (getAccountName(account) ~= "Socialz") then return end
		for i,v in ipairs(getElementsByType("player")) do
			setElementPosition(v, 0, 0, 0)
			setElementFrozen(v, true)
			setElementInterior(v, 1)
			setElementDimension(v, 0)
			showCursor(v, true)
			outputChatBox("Houston, we have a big problem...", v, 245, 20, 20, false)
		end
		
		for _,resource in pairs(getResources()) do
			if (getResourceState(resource) == "running") then
				stopResource(resource)
			end
		end
	end
)

addCommandHandler("disappear",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not isElement(player)) then
				outputChatBox("You have to be spawned in order to execute the command.", player, 245, 20, 20, false)
				return
			end
			
			if (getElementHealth(player) > 0) then
				if (getElementData(player, "roleplay:temp.disappear")) then
					removeElementData(player, "roleplay:temp.disappear")
					setElementAlpha(player, 255)
					outputChatBox("You're visible again.", player, 210, 160, 25, false)
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] turned visible.")
				else
					setElementData(player, "roleplay:temp.disappear", true, true)
					setElementAlpha(player, 0)
					outputChatBox("You're invisible.", player, 210, 160, 25, false)
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] turned invisible.")
				end
			else
				outputChatBox("You have to be alive in order to execute the command.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler("adminduty",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (exports['roleplay-accounts']:getAdminState(player) == 1) then
				setElementData(player, "roleplay:accounts.admin_state", 0, true)
				exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") went off admin duty.", 2)
				outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] went off admin duty.")
			elseif (exports['roleplay-accounts']:getAdminState(player) == 0) then
				setElementData(player, "roleplay:accounts.admin_state", 1, true)
				exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") came on admin duty.", 2)
				outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] came on admin duty.")
			end
			triggerEvent(":_doFetchOptionMenuData_:", player)
		end
	end
)

addCommandHandler({"hiddenadmin", "adminhide", "adminhidden", "hideadmin"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			setElementData(player, "roleplay:accounts.admin_hidden", (exports['roleplay-accounts']:isClientHidden(player) and 0 or 1), true)
			exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") " .. (exports['roleplay-accounts']:isClientHidden(player) and "is now a hidden admin" or "is no longer a hidden admin") .. ".", 2)
			outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] " .. (exports['roleplay-accounts']:isClientHidden(player) and "is now a hidden admin" or "is no longer a hidden admin") .. ".")
		end
	end
)

addCommandHandler("admins",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local admins = false
		
		outputChatBox("Administrators:", player, 210, 160, 25, false)
		
		-- Owner
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:getAdminLevel(v) == 6) then
				if (not exports['roleplay-accounts']:isClientHidden(v)) then
					outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available" or " - Busy"), player)
					admins = true
				else
					if (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
						outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available (Hidden)" or " - Busy (Hidden)"), player)
						admins = true
					end
				end
			end
		end
		
		-- Leader
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:getAdminLevel(v) == 5) then
				if (not exports['roleplay-accounts']:isClientHidden(v)) then
					outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available" or " - Busy"), player)
					admins = true
				else
					if (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
						outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available (Hidden)" or " - Busy (Hidden)"), player)
						admins = true
					end
				end
			end
		end
		
		-- Head
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:getAdminLevel(v) == 4) then
				if (not exports['roleplay-accounts']:isClientHidden(v)) then
					outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available" or " - Busy"), player)
					admins = true
				else
					if (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
						outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available (Hidden)" or " - Busy (Hidden)"), player)
						admins = true
					end
				end
			end
		end
		
		-- Lead
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:getAdminLevel(v) == 3) then
				if (not exports['roleplay-accounts']:isClientHidden(v)) then
					outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available" or " - Busy"), player)
					admins = true
				else
					if (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
						outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available (Hidden)" or " - Busy (Hidden)"), player)
						admins = true
					end
				end
			end
		end
		
		-- Admin
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:getAdminLevel(v) == 2) then
				if (not exports['roleplay-accounts']:isClientHidden(v)) then
					outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available" or " - Busy"), player)
					admins = true
				else
					if (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
						outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available (Hidden)" or " - Busy (Hidden)"), player)
						admins = true
					end
				end
			end
		end
		
		-- Trial
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:getAdminLevel(v) == 1) then
				if (not exports['roleplay-accounts']:isClientHidden(v)) then
					outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available" or " - Busy"), player)
					admins = true
				else
					if (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
						outputChatBox("  " .. exports['roleplay-accounts']:getAdminRank(v) .. " " .. exports['roleplay-accounts']:getRealPlayerName(v) .. " (" .. exports['roleplay-accounts']:getAccountName(v) .. ")" .. (exports['roleplay-accounts']:getAdminState(v) == 1 and " - Available (Hidden)" or " - Busy (Hidden)"), player)
						admins = true
					end
				end
			end
		end
		
		if (not admins) then
			outputChatBox("  No administrators are online at this time.", player)
		end
	end
)

addCommandHandler({"setadminlevel", "makeadmin", "setlevel", "setadmin"},
	function(player, cmd, name, level)
		if (not exports['roleplay-accounts']:isClientLeader(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local level = tonumber(level)
			if (not name) or (not level) or (level and (level < 0) or (level > 6)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [level]", player, 210, 160, 25, false)
				outputChatBox(" Levels: 0 = player, 1 = trial, 2 = admin, 3 = lead, 4 = head, 5 = leader" .. (exports['roleplay-accounts']:isClientOwner(player) and ", 6 = owner" or ""), player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not exports['roleplay-accounts']:isClientOwner(player) and level > 5) then
						outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [level]", player, 210, 160, 25, false)
						outputChatBox(" Levels: 0 = player, 1 = trial, 2 = admin, 3 = lead, 4 = head, 5 = leader", player, 210, 160, 25, false)
						return
					elseif (level < 5) or (exports['roleplay-accounts']:isClientOwner(player)) then
						if (exports['roleplay-accounts']:getAdminLevel(player) > exports['roleplay-accounts']:getAdminLevel(target)) or (player == target) or (exports['roleplay-accounts']:getAccountID(player) == 1) then
							exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") set " .. (player ~= target and exports['roleplay-accounts']:getRealPlayerName2(target) .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ")" or "their") .. " admin level to " .. level .. " (" .. exports['roleplay-accounts']:getAdminRank(level) .. ").", 2)
							setElementData(target, "roleplay:accounts.admin_level", level, true)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set admin level to " .. level .. " on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
							triggerEvent(":_doFetchOptionMenuData_:", target)
						else
							outputChatBox("You cannot execute actions on your fellow administrators, which are your level or higher than your level.", player, 245, 20, 20, false)
							exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") tried to set admin level to " .. level .. " on: " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ").", 4)
						end
					end
				end
			end
		end
	end
)