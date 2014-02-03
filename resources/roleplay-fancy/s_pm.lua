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

local illegalWords = {
	["rp"] = true,
	["gaming"] = true,
	["community"] = true,
	[".net"] = true,
	[".org"] = true,
	[".mta"] = true,
	[".com"] = true,
	[".fi"] = true,
	[".co.uk"] = true,
	["ddos"] = true,
	["dd0s"] = true,
	["attack"] = true
}

local veryIllegalWords = {
	["yomommaooo"] = true,
}

MTAoutputChatBox_ = outputChatBox
function outputLongChatBox(text, visibleTo, r, g, b, colorCoded)
	if (string.len(text) > 128) then
		MTAoutputChatBox_(string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded)
		outputChatBox(string.sub(text, 128), visibleTo, r, g, b, colorCoded)
	else
		MTAoutputChatBox_(text, visibleTo, r, g, b, colorCoded)
	end
end

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

addCommandHandler("pm",
	function(player, cmd, name, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not name) or (not ...) then
			outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [message]", player, 210, 160, 25, false)
		else
			local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
			if (target) then
				local message = table.concat({...}, " ")
				if (#message > 0) then
					local words = split(message, " ")
					local hasWarn = false
					
					if (words) then
						for i,v in pairs(words) do
							if (veryIllegalWords[v:lower()]) then
								outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
								exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " sent " .. getPlayerName(target):gsub("_", " ") .. " a potential advertisement/threat message! Message skipped.", 3)
								exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
								hasWarn = true
								exports['roleplay-logging']:insertLog(player, 24, getPlayerName(player) .. ";" .. getPlayerName(target), "SKIPPED!: " .. message)
								return
							end
						end
						
						for i,v in pairs(words) do
							if (illegalWords[v:lower()]) then
								exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " sent " .. getPlayerName(target):gsub("_", " ") .. " a potential advertisement/threat message!", 3)
								exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
								hasWarn = true
								break
							end
						end
					end
					
					if (not hasWarn) then
						for i,v in pairs(illegalWords) do
							if (string.find(i, message)) then
								exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " sent " .. getPlayerName(target):gsub("_", " ") .. " a potential advertisement/threat message!", 3)
								exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
								hasWarn = true
								break
							end
						end
					end
					
					outputLongChatBox(" [PM] > (" .. exports['roleplay-accounts']:getClientRealID(target) .. ") " .. getPlayerName(target):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. "): " .. message, player, 240, 230, 25, false)
					outputLongChatBox(" [PM] < (" .. exports['roleplay-accounts']:getClientRealID(player) .. ") " .. getPlayerName(player):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. "): " .. message, target, 240, 230, 25, false)
					exports['roleplay-logging']:insertLog(player, 24, getPlayerName(player) .. ";" .. getPlayerName(target), message)
				else
					outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [message]", player, 210, 160, 25, false)
				end
			else
				outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
			end
		end
	end
)