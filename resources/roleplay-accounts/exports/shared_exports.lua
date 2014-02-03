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

local ipAddress = ""
local version = "1.0-GIT"
local poweruserID = 1

MTAoutputChatBox_ = outputChatBox
function outputLongChatBox(text, visibleTo, r, g, b, colorCoded)
	if (string.len(text) > 128) then
		MTAoutputChatBox_(string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded)
		outputChatBox(string.sub(text, 128), visibleTo, r, g, b, colorCoded)
	else
		MTAoutputChatBox_(text, visibleTo, r, g, b, colorCoded)
	end
end

function outputAdminLog(message, type)
	if (not message) then return false, 2 end
	for i,v in ipairs(getElementsByType("player")) do
		if (isClientTrialAdmin(v)) then
			if (not type) or (type == 1) then
				outputLongChatBox(" [AdminLog] " .. message:gsub("_", " "), v, 245, 20, 20, false)
			elseif (type == 2) then
				outputLongChatBox(" [AdminDuty] " .. message:gsub("_", " "), v, 245, 20, 20, false)
			elseif (type == 3) then
				outputLongChatBox(" [AdminWarn] " .. message:gsub("_", " "), v, 245, 20, 20, false)
			elseif (type == 4) then
				if (isClientLeader(v)) then
					outputLongChatBox(" [LeadWarn] " .. message:gsub("_", " "), v, 190, 60, 180, false)
				end
			elseif (type == 5) then
				outputLongChatBox(" [AdminFatal] " .. message:gsub("_", " "), v, 200, 10, 10, false)
			elseif (type == 6) then
				outputLongChatBox(" [AdminScript] " .. message:gsub("_", " "), v, 245, 20, 20, false)
			elseif (type == 7) then
				if (isClientLeader(v)) then
					outputLongChatBox(" [HeadWarn] " .. message:gsub("_", " "), v, 190, 60, 180, false)
				end
			elseif (type == 8) then
				outputLongChatBox(" [AdminAct] " .. message:gsub("_", " "), v, 245, 20, 20, false)
			else
				outputLongChatBox(" [AdminLog] " .. message:gsub("_", " "), v, 245, 20, 20, false)
			end
		elseif (type == -1) then
			outputLongChatBox(" [AdminAct] " .. message:gsub("_", " "), v, 245, 20, 20, false)
		end
	end
end

function getPlayerFromPartialName(string, player)
	if (not string) then return false, 2 end
	if (not tonumber(string)) and (string == "*") and (getElementType(player) == "player") then
		return player
	else
		if (tonumber(string)) and (tonumber(string) > 0) then
			return getPlayerByID(tonumber(string), player)
		end
		
		local matches = {}
		for i,v in ipairs(getElementsByType("player")) do
			if (getPlayerName(v) == string) and (isClientPlaying(v)) then
				return v
			end
			local playerName = getPlayerName(v):gsub("#%x%x%x%x%x%x", "")
			playerName = playerName:lower()
			if (playerName:find(string:lower(), 0)) and (isClientPlaying(v)) then
				table.insert(matches, v)
			end
		end
		if (#matches == 1) then
			return matches[1]
		end
		return false
	end
end

function getPlayerByID(id, player)
	if (not id) then return false, 2 end
	if (id == "*") and (getElementType(player) == "player") then
		return player
	else
		if (not tonumber(id)) then return false, 2 end
		for i,v in ipairs(getElementsByType("player")) do
			if (tonumber(getElementData(v, "roleplay:clients.id"))) and (isClientPlaying(v)) then
				if (tonumber(getElementData(v, "roleplay:clients.id")) == id) then
					return v
				end
			end
		end
		return false
	end
end

function getRealPlayerName(element)
	if (isElement(element)) then
		return getPlayerName(element):gsub("_", " ")
	else
		return element:gsub("_", " ")
	end
end

function getRealPlayerName2(element)
	return (string.sub(getRealPlayerName(element), #getRealPlayerName(element)-1) == "s" and getRealPlayerName(element) .. "'" or getRealPlayerName(element) .. "'s")
end

function getReturnData(integer)
	if (not tonumber(integer)) then return false, 2 end
	local integer = tonumber(integer)
	if (integer == 1) then
		return true, "No element data initialized the element"
	elseif (integer == 2) then
		return true, "No proper value entered to the parameters of a function"
	elseif (integer == 3) then
		return true, "Invalid element data found on an element"
	else
		return false, 2
	end
end

function isClientLoggedIn(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.loggedin"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.loggedin"))
	if (elementData == 0) then
		return false, true
	elseif (elementData == 1) then
		return true
	else
		return false, 3
	end
end

function isClientPlaying(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.state"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.state"))
	if (elementData == 2) then
		return true
	else
		return false, 3
	end
end

function isClientInTutorial(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.state"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.state"))
	if (elementData == 3) then
		return true
	else
		return false, 3
	end
end

function isOOCMuted(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.option1"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.option1"))
	if (elementData == 0) then
		return false
	elseif (elementData == 1) then
		return true
	else
		return false
	end
end

function isClientTrialAdmin(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_level"))
	if (elementData >= 1) or (getAccountID(element) == poweruserID) then
		return true
	else
		return false, 3
	end
end
function isClientModerator(element) return isClientTrialAdmin(element) end

function isClientAdmin(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_level"))
	if (elementData >= 2) or (getAccountID(element) == poweruserID) then
		return true
	else
		return false, 3
	end
end

function isClientLeadAdmin(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_level"))
	if (elementData >= 3) or (getAccountID(element) == poweruserID) then
		return true
	else
		return false, 3
	end
end
function isClientSenior(element) return isClientLeadAdmin(element) end
function isClientSeniorAdmin(element) return isClientLeadAdmin(element) end

function isClientHeadAdmin(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_level"))
	if (elementData >= 4) or (getAccountID(element) == poweruserID) then
		return true
	else
		return false, 3
	end
end

function isClientLeader(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_level"))
	if (elementData >= 5) or (getAccountID(element) == poweruserID) then
		return true
	else
		return false, 3
	end
end

function isClientOwner(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_level"))
	if (elementData >= 6) or (getAccountID(element) == poweruserID) then
		return true
	else
		return false, 3
	end
end

function isClientHidden(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_hidden"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_hidden"))
	if (elementData == 0) then
		return false
	elseif (elementData == 1) then
		return true
	else
		return false
	end
end

function getAccountSetting(element, name)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.option" .. name))) then return 1 end
	return tonumber(getElementData(element, "roleplay:accounts.option" .. name))
end

function getPlayerLanguage(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not getElementData(element, "roleplay:characters.language")) then return false, 1 end
	return getElementData(element, "roleplay:characters.language")
end

function getPlayerLanguages(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not getElementData(element, "roleplay:characters.languages")) then return false, 1 end
	return getElementData(element, "roleplay:characters.languages")
end

function getPlayerFaction(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:characters.faction"))) or (tonumber(getElementData(element, "roleplay:characters.faction")) <= 0) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:characters.faction"))
end

function getFactionPrivileges(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:characters.faction:privileges"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:characters.faction:privileges"))
end

function getFactionRank(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not isClientPlaying(element)) then return end
	if (not tonumber(getElementData(element, "roleplay:characters.faction:rank"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:characters.faction:rank"))
end

function getAccountName(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not getElementData(element, "roleplay:accounts.username")) then return false, 1 end
	local elementData = getElementData(element, "roleplay:accounts.username")
	return _base64decode(elementData)
end

function getAccountID(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.id"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:accounts.id"))
	if (elementData > 0) then
		return elementData
	else
		return false, 3
	end
end

function getCharacterID(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.id"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:characters.id"))
end

function getCharacterGender(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.gender"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:characters.gender"))
end

function getCharacterRealGender(element, style)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (getCharacterGender(element) == 0) then
		if (style == 1) then
			return "he"
		elseif (style == 2) then
			return "his"
		elseif (style == 3) then
			return "him"
		end
	elseif (getCharacterGender(element) == 1) then
		if (style == 1) then
			return "she"
		elseif (style == 2) then
			return "her"
		elseif (style == 3) then
			return "her"
		end
	end
end

function getCharacterJob(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.job"))) then return 0 end
	return tonumber(getElementData(element, "roleplay:characters.job"))
end

function hasDriversLicense(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.dmv:license"))) then return 0 end
	return (tonumber(getElementData(element, "roleplay:characters.dmv:license")) > 0 and true or false)
end

function hasTruckLicense(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.dmv:license"))) then return 0 end
	return (tonumber(getElementData(element, "roleplay:characters.dmv:license")) == 2 and true or false)
end

function hasManualTransmission(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.dmv:manual"))) then return 0 end
	return (tonumber(getElementData(element, "roleplay:characters.dmv:manual")) == 1 and true or false)
end

function hasAutomaticTransmission(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.dmv:manual"))) then return 0 end
	return (tonumber(getElementData(element, "roleplay:characters.dmv:manual")) >= 0 and true or false)
end

function getClientID(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:clients.id_ghost"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:clients.id_ghost"))
end

function getAdminLevel(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:accounts.admin_level"))
end

function getAdminRank(element)
	if (not tonumber(element)) then
		if (not element) or (getElementType(element) ~= "player") then return end
		if (not tonumber(getElementData(element, "roleplay:accounts.admin_level"))) then return false, 1 end
		local elementData = tonumber(getElementData(element, "roleplay:accounts.admin_level"))
		if (elementData == 0) then
			return "Player"
		elseif (elementData == 1) then
			return "Trial Admin"
		elseif (elementData == 2) then
			return "Administrator", "Admin"
		elseif (elementData == 3) then
			return "Lead Administrator", "Lead Admin"
		elseif (elementData == 4) then
			return "Head Administrator", "Head Admin"
		elseif (elementData == 5) then
			return "Community Leader", "Leader"
		elseif (elementData == 6) then
			return "Community Owner", "Owner"
		else
			return false, "Unknown"
		end
	else
		local element = tonumber(element)
		if (element == 0) then
			return "Player"
		elseif (element == 1) then
			return "Trial Administrator", "Trial Admin"
		elseif (element == 2) then
			return "Administrator", "Admin"
		elseif (element == 3) then
			return "Lead Administrator", "Lead Admin"
		elseif (element == 4) then
			return "Head Administrator", "Head Admin"
		elseif (element == 5) then
			return "Community Leader", "Leader"
		elseif (element == 6) then
			return "Community Owner", "Owner"
		else
			return false, "Unknown"
		end
	end
end

function getAdminState(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.admin_state"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:accounts.admin_state"))
end

function getClientState(element) -- 0: Login, 1: Selection, 2: In-game, 3: Tutorial
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:accounts.state"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:accounts.state"))
end

local gWeekDays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
function getFormattedDate(format, escaper, timestamp)
	Check("getFormattedDate", "string", format, "format", {"nil", "string"}, escaper, "escaper", {"nil", "string"}, timestamp, "timestamp")
 
	escaper = (escaper or "'"):sub(1, 1)
	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false
 
	time.year = time.year + 1900
	time.month = time.month + 1
 
	local datetime = {d = ("%02d"):format(time.monthday), h = ("%02d"):format(time.hour), i = ("%02d"):format(time.minute), m = ("%02d"):format(time.month), s = ("%02d"):format(time.second), w = gWeekDays[time.weekday+1]:sub(1, 2), W = gWeekDays[time.weekday+1], y = tostring(time.year):sub(-2), Y = time.year}
 
	for char in format:gmatch(".") do
		if (char == escaper) then escaped = not escaped
		else formattedDate = formattedDate..(not escaped and datetime[char] or char) end
	end
 
	return formattedDate
end

function getServerIP()
	return ipAddress
end

function getScriptVersion()
	return version
end