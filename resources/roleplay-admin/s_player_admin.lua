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

local jailedTimer = {}
local decreaseTimer = {}

addEvent(":_initializeJailTimer_:", true)
addEventHandler(":_initializeJailTimer_:", root,
	function()
		local source = player
		local totalTime = tonumber(getElementData(player, "roleplay:accounts.jailed"))
		if (math.ceil(totalTime) > 1) then
			setElementPosition(player, 264.58, 77.58, 1001.03)
			setElementInterior(player, 6)
			setElementDimension(player, math.random(10000, 65535))
			if (isTimer(jailedTimer[player])) then killTimer(jailedTimer[player]) end
			jailedTimer[player] = setTimer(function(player)
				if (player) and (isElement(player)) then
					local totalTime = tonumber(getElementData(player, "roleplay:accounts.jailed"))
					setElementPosition(player, 1520.98, -1675.53, 13.54)
					setElementInterior(player, 0)
					setElementDimension(player, 0)
					setElementData(player, "roleplay:accounts.jailed", -1, true)
					setElementData(player, "roleplay:accounts.jailedReason", "", true)
					setElementData(player, "roleplay:accounts.jailedBy", 0, true)
					outputChatBox(" You've been released from admin jail. Behave from now on!", player, 210, 160, 25, false)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " was released from admin jail after " .. totalTime .. " " .. (totalTime == 1 and "minute" or "minutes") .. ".")
				end
				jailedTimer[player] = nil
			end, totalTime*60000, 1, player)
		else
			setElementPosition(player, 1520.98, -1675.53, 13.54)
			setElementInterior(player, 0)
			setElementDimension(player, 0)
			setElementData(player, "roleplay:accounts.jailed", -1, true)
			setElementData(player, "roleplay:accounts.jailedReason", "", true)
			setElementData(player, "roleplay:accounts.jailedBy", 0, true)
			outputChatBox(" You've been released from admin jail. Behave from now on!", player, 210, 160, 25, false)
			exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " was released from admin jail because the admin jail session was too short.")
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "accounts", "jailed", -1, "jailedReason", "", "jailedBy", 0, "id", exports['roleplay-accounts']:getAccountID(player))
		end
	end
)

addEvent(":_fuckJailTimer_:", true)
addEventHandler(":_fuckJailTimer_:", root,
	function(justLogout)
		local source = player
		if (isTimer(jailedTimer[player])) then killTimer(jailedTimer[player]) else return end
		
		local totalTime = tonumber(getElementData(player, "roleplay:accounts.jailed"))
		if (totalTime) then
			if (math.ceil(totalTime) > 1) then
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "accounts", "jailed", totalTime, "id", exports['roleplay-accounts']:getAccountID(player))
			else
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "accounts", "jailed", -1, "jailedReason", "", "jailedBy", 0, "id", exports['roleplay-accounts']:getAccountID(player))
			end
			
			if (not justLogout) then
				setElementData(player, "roleplay:accounts.jailed", -1, true)
				setElementData(player, "roleplay:accounts.jailedReason", "", true)
				setElementData(player, "roleplay:accounts.jailedBy", 0, true)
			end
		end
	end
)

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					if (hasObjectPermissionTo(player, "command." .. commandName[1], not restricted)) then
						fn(player, ...)
					end
				end
			)
		end
	end
end

addCommandHandler({"issuedriverslicense", "issuedriverlicense", "givedriverslicense", "givedriverlicense"},
	function(player, cmd, name, type)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
				outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
				return
			else
				local type = tonumber(type)
				if (not name) or (not type) or (type and type < 0 or type > 4) then
					outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [type]", player, 210, 160, 25, false)
					outputChatBox("Types:", player, 210, 160, 25, false)
					outputChatBox("  0 = Remove", player, 210, 160, 25, false)
					outputChatBox("  1 = Standard 	& Manual", player, 210, 160, 25, false)
					outputChatBox("  2 = Standard 	& Automatic", player, 210, 160, 25, false)
					outputChatBox("  3 = Heavy 		& Manual", player, 210, 160, 25, false)
					outputChatBox("  4 = Heavy 		& Automatic", player, 210, 160, 25, false)
				else
					local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
					if (not target) then
						outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
					else
						if (not isElement(target)) then
							outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
							return
						end
						
						if (getElementHealth(target) > 0) then
							if (type == 0) then
								setElementData(target, "roleplay:characters.dmv:license", 0, true)
								setElementData(target, "roleplay:characters.dmv:manual", -1, true)
								outputChatBox("You removed " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " driver's license.", player, 210, 160, 25, false)
								outputChatBox(exports['roleplay-accounts']:getRealPlayerName(player) .. " removed your driver's license.", target, 210, 160, 25, false)
							elseif (type == 1) then
								setElementData(target, "roleplay:characters.dmv:license", 1, true)
								setElementData(target, "roleplay:characters.dmv:manual", 1, true)
								outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " driver's license to Standard & Manual.", player, 210, 160, 25, false)
								outputChatBox(exports['roleplay-accounts']:getRealPlayerName(player) .. " set your driver's license to Standard & Manual.", target, 210, 160, 25, false)
							elseif (type == 2) then
								setElementData(target, "roleplay:characters.dmv:license", 1, true)
								setElementData(target, "roleplay:characters.dmv:manual", 0, true)
								outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " driver's license to Standard & Automatic.", player, 210, 160, 25, false)
								outputChatBox(exports['roleplay-accounts']:getRealPlayerName(player) .. " set your driver's license to Standard & Automatic.", target, 210, 160, 25, false)
							elseif (type == 3) then
								setElementData(target, "roleplay:characters.dmv:license", 2, true)
								setElementData(target, "roleplay:characters.dmv:manual", 1, true)
								outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " driver's license to Heavy & Manual.", player, 210, 160, 25, false)
								outputChatBox(exports['roleplay-accounts']:getRealPlayerName(player) .. " set your driver's license to Heavy & Manual.", target, 210, 160, 25, false)
							elseif (type == 4) then
								setElementData(target, "roleplay:characters.dmv:license", 2, true)
								setElementData(target, "roleplay:characters.dmv:manual", 0, true)
								outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " driver's license to Heavy & Automatic.", player, 210, 160, 25, false)
								outputChatBox(exports['roleplay-accounts']:getRealPlayerName(player) .. " set your driver's license to Heavy & Automatic.", target, 210, 160, 25, false)
							end
							
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " [" .. type .. "] command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
						else
							outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
						end
					end
				end
			end
		end
	end
)

addCommandHandler({"freeze", "unfreeze"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local frozen = isElementFrozen(target)
						setElementFrozen(target, not frozen)
						
						outputChatBox("You " .. (frozen and "unfroze" or "froze") .. " " .. exports['roleplay-accounts']:getRealPlayerName(target) .. ".", player, 210, 160, 25, false)
						outputChatBox("Administrator " .. (frozen and "unfroze" or "froze") .. " you." .. (frozen and "" or " Please wait for their instructions."), target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"setname", "changename"},
	function(player, cmd, name, newName)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) or (not newName) or (not string.find(newName, "_")) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [new character name]", player, 210, 160, 25, false)
			else
				local newName = string.gsub(newName, " ", "_")
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "characterName", "characters", "characterName", newName)
						if (not query) then return end
						local result, num_affected_rows = dbPoll(query, -1)
						if (num_affected_rows > 0) then
							outputChatBox("A character with that name already exists.", player, 245, 20, 20, false)
						else
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "characters", "characterName", newName, "id", exports['roleplay-accounts']:getCharacterID(target))
							setPlayerName(target, newName)
							outputChatBox("You changed " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " name to " .. newName:gsub("_", " ") .. ".", player, 210, 160, 25, false)
							outputChatBox("Administrator changed your name to " .. newName:gsub("_", " ") .. ".", target, 210, 160, 25, false)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " [" .. newName .. "] command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
						end
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"sethealth", "sethp"},
	function(player, cmd, name, amount)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) or (not tonumber(amount)) or (amount and tonumber(amount) < 0 or tonumber(amount) > 100) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [amount]", player, 210, 160, 25, false)
				return
			else
				local amount = tonumber(amount)
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						setElementHealth(target, amount)
						
						outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " health to " .. amount .. ".", player, 210, 160, 25, false)
						outputChatBox("Administrator set your health to " .. amount .. ".", target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] health to " .. amount .. ".")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"pkick", "kick", "kickplayer"},
	function(player, cmd, name, ...)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) or (not (...)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [reason]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (player == target) then
						outputChatBox("You cannot kick yourself out from the server.", player, 245, 20, 20, false)
						return
					end
					
					if (exports['roleplay-accounts']:getAdminLevel(player) > exports['roleplay-accounts']:getAdminLevel(target)) then
						local reason = table.concat({...}, " ")
						if (reason and #reason > 1) then
							for _,public in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientPlaying(public)) then
									if (exports['roleplay-accounts']:isClientHidden(player)) and (not exports['roleplay-accounts']:isClientTrialAdmin(public)) then
										outputChatBox(" [AdminAct] Hidden Admin kicked " .. getPlayerName(target):gsub("_", " ") .. " from the server.", public, 245, 20, 20, false)
									else
										outputChatBox(" [AdminAct] " .. getPlayerName(player):gsub("_", " ") .. " kicked " .. getPlayerName(target):gsub("_", " ") .. " from the server.", public, 245, 20, 20, false)
									end
									
									outputChatBox(" [AdminAct] Reason: " .. reason, public, 245, 20, 20, false)
								end
							end
							
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] kicked " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] from the server for '" .. reason .. "'.")
							kickPlayer(target, player, reason)
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [reason]", player, 210, 160, 25, false)
						end
					else
						outputChatBox("You cannot execute actions on your fellow administrators, which are your level or lower than your level.", player, 245, 20, 20, false)
						exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") tried to kick an admin: " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ").", 4)
					end
				end
			end
		end
	end
)

addCommandHandler({"silentkick", "spkick", "skick"},
	function(player, cmd, name, ...)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) or (not (...)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [reason]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (player == target) then
						outputChatBox("You cannot kick yourself out from the server.", player, 245, 20, 20, false)
						return
					end
					
					if (exports['roleplay-accounts']:getAdminLevel(player) > exports['roleplay-accounts']:getAdminLevel(target)) then
						local reason = table.concat({...}, " ")
						if (reason and #reason > 1) then
							for _,public in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientTrialAdmin(public)) then
									outputChatBox(" [AdminAct] " .. getPlayerName(player):gsub("_", " ") .. " silently kicked " .. getPlayerName(target):gsub("_", " ") .. " from the server.", public, 245, 20, 20, false)
									outputChatBox(" [AdminAct] Reason: " .. reason, public, 245, 20, 20, false)
								end
							end
							
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] silently kicked " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] from the server for '" .. reason .. "'.")
							kickPlayer(target, player, reason)
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [reason]", player, 210, 160, 25, false)
						end
					else
						outputChatBox("You cannot execute actions on your fellow administrators, which are your level or lower than your level.", player, 245, 20, 20, false)
						exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") tried to silently kick an admin: " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ").", 4)
					end
				end
			end
		end
	end
)

addCommandHandler({"jail", "pjail", "jailplayer"},
	function(player, cmd, name, len, ...)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local len = tonumber(len)
			if (not name) or (not len) or (len and len < 0) or (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [length in minutes: 0 = permanent] [reason]", player, 210, 160, 25, false)
			else
				local len = math.ceil(tonumber(len))
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					--if (player == target) then
					--	outputChatBox("You cannot jail yourself.", player, 245, 20, 20, false)
					--	return
					--end
					
					--if (exports['roleplay-accounts']:getAdminLevel(player) > exports['roleplay-accounts']:getAdminLevel(target)) or (exports['roleplay-accounts']:getAdminLevel(player) == 5 and not exports['roleplay-accounts']:isClientOwner(target)) then
						local reason = table.concat({...}, " ")
						if (reason and #reason > 1) then
							for _,public in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientPlaying(public)) then
									if (exports['roleplay-accounts']:isClientHidden(player)) and (not exports['roleplay-accounts']:isClientTrialAdmin(public)) then
										outputChatBox(" [AdminAct] Hidden Admin jailed " .. getPlayerName(target):gsub("_", " ") .. " " .. (len == 0 and "permanently" or (len == 1 and "for 1 minute" or "for " .. len .. " minutes")) .. ".", public, 245, 20, 20, false)
									else
										outputChatBox(" [AdminAct] " .. getPlayerName(player):gsub("_", " ") .. " jailed " .. getPlayerName(target):gsub("_", " ") .. " " .. (len == 0 and "permanently" or (hour == 1 and "for 1 minute" or "for " .. len .. " minutes")) .. ".", public, 245, 20, 20, false)
									end
									
									outputChatBox(" [AdminAct] Reason: " .. reason, public, 245, 20, 20, false)
								end
							end
							
							if (isPedInVehicle(target)) then removePedFromVehicle(target) end
							setElementPosition(target, 264.58, 77.58, 1001.03)
							setElementInterior(target, 6)
							setElementDimension(target, math.random(10000, 65535))
							setElementData(target, "roleplay:accounts.jailed", len, false)
							setElementData(target, "roleplay:accounts.jailedBy", exports['roleplay-accounts']:getAccountID(player), false)
							setElementData(target, "roleplay:accounts.jailedReason", reason, false)
							
							if (isTimer(decreaseTimer[target])) then killTimer(decreaseTimer[target]) end
							decreaseTimer[target] = setTimer(function(player)
								if (player) and (isElement(player)) then
									local totalTime = tonumber(getElementData(player, "roleplay:accounts.jailed"))
									setElementData(target, "roleplay:accounts.jailed", totalTime-1, false)
								else
									killTimer(decreaseTimer[target])
									decreaseTimer[target] = nil
								end
							end, 60000, 0, target)
							
							if (isTimer(jailedTimer[target])) then killTimer(jailedTimer[target]) end
							jailedTimer[target] = setTimer(function(player)
								if (player) and (isElement(player)) then
									local totalTime = tonumber(getElementData(player, "roleplay:accounts.jailed"))
									setElementPosition(player, 1520.98, -1675.53, 13.54)
									setElementInterior(player, 0)
									setElementDimension(player, 0)
									triggerEvent(":_fuckJailTimer_:", player)
									outputChatBox(" You've been released from admin jail. Behave from now on!", player, 210, 160, 25, false)
									exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " was released from admin jail after " .. totalTime .. " " .. (totalTime == 1 and "minute" or "minutes") .. ".")
								end
								jailedTimer[player] = nil
							end, len*60000, 1, target)
							
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] jailed " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] for '" .. reason .. "' (" .. (len == 0 and "permanent" or (len == 1 and "1 minute" or len .. " minutes")) .. ").")
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [length in minutes: 0 = permanent] [reason]", player, 210, 160, 25, false)
						end
					--else
					--	outputChatBox("You cannot execute actions on your fellow administrators, which are your level or higher than your level.", player, 245, 20, 20, false)
					--	exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") tried to jail an admin: " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ") " .. (len == 0 and "permanently" or (len == 1 and "for 1 minute" or "for " .. len .. " minutes.")) .. ".", 4)
					--end
				end
			end
		end
	end
)

addCommandHandler({"unjail", "unjailplayer", "punjail"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					local totalTime = tonumber(getElementData(target, "roleplay:accounts.jailed"))
					if (totalTime) then
						if (isTimer(decreaseTimer[target])) then killTimer(decreaseTimer[target]) end
						if (isTimer(jailedTimer[target])) then killTimer(jailedTimer[target]) end
						setElementPosition(target, 1520.98, -1675.53, 13.54)
						setElementInterior(target, 0)
						setElementDimension(target, 0)
						triggerEvent(":_fuckJailTimer_:", target)
						outputChatBox(" You've been released from admin jail. Behave from now on!", target, 210, 160, 25, false)
						exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " was released from admin jail by " .. getPlayerName(player):gsub("_", " ") .. ".")
					else
						outputChatBox("That player isn't in jail.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"ban", "pban", "banplayer"},
	function(player, cmd, name, hour, ...)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local hour = tonumber(hour)
			if (not name) or (not hour) or (hour and hour < 0) or (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [hour: 0 = permanent] [reason]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (player == target) then
						outputChatBox("You cannot kick yourself out from the server.", player, 245, 20, 20, false)
						return
					end
					
					if (exports['roleplay-accounts']:getAdminLevel(player) > exports['roleplay-accounts']:getAdminLevel(target)) then
						local reason = table.concat({...}, " ")
						if (reason and #reason > 1) then
							local hour = (hour == 0 and 0 or hour*3600)
							for _,public in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientPlaying(public)) then
									if (exports['roleplay-accounts']:isClientHidden(player)) and (not exports['roleplay-accounts']:isClientTrialAdmin(public)) then
										outputChatBox(" [AdminAct] Hidden Admin banned " .. getPlayerName(target):gsub("_", " ") .. " from the server " .. (hour == 0 and "permanently" or (hour == 1 and "for 1 hour" or "for " .. hour .. " hours")) .. ".", public, 245, 20, 20, false)
									else
										outputChatBox(" [AdminAct] " .. getPlayerName(player):gsub("_", " ") .. " banned " .. getPlayerName(target):gsub("_", " ") .. " from the server " .. (hour == 0 and "permanently" or (hour == 1 and "for 1 hour" or "for " .. hour .. " hours")) .. ".", public, 245, 20, 20, false)
									end
									
									outputChatBox(" [AdminAct] Reason: " .. reason, public, 245, 20, 20, false)
								end
							end
							
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] banned " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] from the server for '" .. reason .. "' (" .. (hour == 0 and "permanent" or (hour == 1 and "1 hour" or hour .. " hours")) .. ").")
							banPlayer(target, true, true, true, player, reason, hour)
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [hour: 0 = permanent] [reason]", player, 210, 160, 25, false)
						end
					else
						outputChatBox("You cannot execute actions on your fellow administrators, which are your level or lower than your level.", player, 245, 20, 20, false)
						exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") tried to ban an admin: " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ") " .. (hour == 0 and "permanently" or (hour == 1 and "for 1 hour" or "for " .. hour .. " hours.")) .. ".", 4)
					end
				end
			end
		end
	end
)

addCommandHandler({"sban", "spban", "sbanplayer", "silentban"},
	function(player, cmd, name, hour, ...)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local hour = tonumber(hour)
			if (not name) or (not hour) or (hour and hour < 0) or (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [hour: 0 = permanent] [reason]", player, 210, 160, 25, false)
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (player == target) then
						outputChatBox("You cannot kick yourself out from the server.", player, 245, 20, 20, false)
						return
					end
					
					if (exports['roleplay-accounts']:getAdminLevel(player) > exports['roleplay-accounts']:getAdminLevel(target)) then
						local reason = table.concat({...}, " ")
						if (reason and #reason > 1) then
							local hour = (hour == 0 and 0 or hour*3600)
							for _,public in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientTrialAdmin(public)) then
									outputChatBox(" [AdminAct] " .. getPlayerName(player):gsub("_", " ") .. " silently banned " .. getPlayerName(target):gsub("_", " ") .. " from the server " .. (hour == 0 and "permanently" or (hour == 1 and "for 1 hour" or "for " .. hour .. " hours")) .. ".", public, 245, 20, 20, false)
									outputChatBox(" [AdminAct] Reason: " .. reason, public, 245, 20, 20, false)
								end
							end
							
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] silently banned " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] from the server for '" .. reason .. "' (" .. (hour == 0 and "permanent" or (hour == 1 and "1 hour" or hour .. " hours")) .. ").")
							banPlayer(target, true, true, true, player, reason, hour)
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [hour: 0 = permanent] [reason]", player, 210, 160, 25, false)
						end
					else
						outputChatBox("You cannot execute actions on your fellow administrators, which are your level or lower than your level.", player, 245, 20, 20, false)
						exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") tried to silently ban an admin: " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ") " .. (hour == 0 and "permanently" or (hour == 1 and "for 1 hour" or "for " .. hour .. " hours.")) .. ".", 4)
					end
				end
			end
		end
	end
)

addCommandHandler({"unban", "unbanplayer", "delban", "unbanserial", "unbanip"},
	function(player, cmd, value)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not value) then
				outputChatBox("SYNTAX: /" .. cmd .. " [full character name/serial/ip]", player, 210, 160, 25, false)
			else
				local result = false
				
				if (string.find(value, ".")) or (cmd == "unbanip") then
					for i,ban in ipairs(getBans()) do
						if (getBanIP(ban) == value) then
							exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") unbanned IP " .. tostring(getBanIP(ban)) .. "/" .. (getBanNick(ban) and tostring(getBanNick(ban)) or tostring(getBanSerial(ban))) .. " (ban #" .. i .. ").", 2)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] unbanned IP " .. getBanIP(ban) .. "/" .. getBanNick(ban) .. " (ban #" .. i .. ").")
							removeBan(ban, player)
							result = true
						end
					end
				elseif (string.len(value) > 30) or (cmd == "unbanserial") then
					for i,ban in ipairs(getBans()) do
						if (getBanSerial(ban) == value) then
							exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") unbanned serial " .. tostring(getBanSerial(ban)) .. "/" .. (getBanNick(ban) and tostring(getBanNick(ban)) or tostring(getBanIP(ban))) .. " (ban #" .. i .. ").", 2)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] unbanned serial " .. getBanSerial(ban) .. "/" .. getBanNick(ban) .. " (ban #" .. i .. ").")
							removeBan(ban, player)
							result = true
						end
					end
				elseif (cmd == "unban") then
					for i,ban in ipairs(getBans()) do
						if (getBanNick(ban) == value) then
							exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. ") unbanned serial " .. tostring(getBanSerial(ban)) .. "/" .. (getBanNick(ban) and tostring(getBanNick(ban)) or tostring(getBanIP(ban))) .. " (ban #" .. i .. ").", 2)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] unbanned serial " .. getBanSerial(ban) .. "/" .. getBanNick(ban) .. " (ban #" .. i .. ").")
							removeBan(ban, player)
							result = true
						end
					end
				end
				
				if (not result) then
					outputChatBox("Couldn't find such ban on that username/serial/ip.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)

addCommandHandler({"givelanguage", "setlanguage", "givelang", "setlang", "learn", "learnlang"},
	function(player, cmd, name, language, level)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local level = tonumber(level)
			if (not name) or (level and (level < 0 or level > 100)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [language id] <[level: 0-100]>", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					local free = exports['roleplay-chat']:getFreeSlot(target)
					if (level) then
						local has, slot = exports['roleplay-chat']:hasLanguage(target, language, false, level)
						local has2, slot2 = exports['roleplay-chat']:hasLanguage(target, language)
						if (has) then
							outputChatBox("The player already has that language at " .. level .. "%.", player, 245, 20, 20, false)
							return
						else
							if (free == 0) and (not has2) then
								outputChatBox("The player's language skills are full. One language has to be removed in order to add one.", player, 245, 20, 20, false)
								return
							elseif (has2) then
								setElementData(player, "roleplay:languages." .. slot2 .. "skill", level, true)
								outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill to " .. level .. "%.", player, 20, 245, 20, false)
								outputChatBox("Administrator set your " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill to " .. level .. "%.", target, 20, 245, 20, false)
								triggerClientEvent(target, ":_closeLanguageMenu_:", target, true)
								outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill to " .. (level and level or 100) .. "%.")
								return
							end
							exports['roleplay-chat']:giveLanguage(target, language, free, level)
							outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill to " .. level .. "%.", player, 20, 245, 20, false)
							outputChatBox("Administrator set your " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill to " .. level .. "%.", target, 20, 245, 20, false)
							triggerClientEvent(target, ":_closeLanguageMenu_:", target, true)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill to " .. (level and level or 100) .. "%.")
						end
					else
						local has, slot = exports['roleplay-chat']:hasLanguage(target, language)
						if (has) then
							outputChatBox("The player already possesses " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill.", player, 245, 20, 20, false)
							return
						else
							if (free == 0) then
								outputChatBox("The player's language skills are full. One language has to be removed in order to add one.", player, 245, 20, 20, false)
								return
							end
							exports['roleplay-chat']:giveLanguage(target, language, free)
							outputChatBox(exports['roleplay-accounts']:getRealPlayerName(target) .. " learned " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill.", player, 20, 245, 20, false)
							outputChatBox("Administrator taught you " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill.", target, 20, 245, 20, false)
							triggerClientEvent(target, ":_closeLanguageMenu_:", target, true)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill to " .. (level and level or 100) .. "%.")
						end
					end
				end
			end
		end
	end
)

addCommandHandler({"takelanguage", "setlanguage", "takelang", "unlearn", "unlearnlang"},
	function(player, cmd, name, language)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local language = tonumber(language)
			if (not name) or (language and (language <= 0 or language > #exports['roleplay-chat']:getLanguages())) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [language id]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					local has, slot = exports['roleplay-chat']:hasLanguage(target, language)
					if (not has) then
						outputChatBox("The player doesn't know " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill.", player, 245, 20, 20, false)
						return
					else
						exports['roleplay-chat']:takeLanguage(target, language)
						outputChatBox("You removed " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill from " .. exports['roleplay-accounts']:getRealPlayerName(target) .. ".", player, 20, 245, 20, false)
						outputChatBox("Administrator removed your " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill.", target, 20, 245, 20, false)
					end
					
					triggerClientEvent(target, ":_closeLanguageMenu_:", target, true)
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] removed " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] " .. exports['roleplay-chat']:getLanguageName(language) .. " language skill.")
				end
			end
		end
	end
)