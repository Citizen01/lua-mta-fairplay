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

function saveCharacter(element, manualOrAuto)
	local x, y, z = getElementPosition(element)
	local rx, ry, rz = getElementRotation(element)
	local query = dbExec(getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = NOW(), `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "characters", "characterName", getPlayerName(element), "posX", x, "posY", y, "posZ", z, "rotX", rx, "rotY", ry, "rotZ", rz, "interior", getElementInterior(element), "dimension", getElementDimension(element), "model", getElementModel(element), "health", (getElementHealth(element) < 5 and 10 or getElementHealth(element)), "armor", getPedArmor(element), "cash", getPlayerMoney(element), "bank", exports['roleplay-banking']:getBankValue(element), "factionID", getPlayerFaction(element), "factionPrivileges", getFactionPrivileges(element), "jobID", getCharacterJob(element), "lastOnline", "playedTime", getCharacterTime(element), "driversLicense", tonumber(getElementData(element, "roleplay:characters.dmv:license")), "transmissionLicense", tonumber(getElementData(element, "roleplay:characters.dmv:manual")), "id", getCharacterID(element))
	if (query) then
		if (manualOrAuto) then
			outputChatBox("Saved character information.", element, 20, 245, 20, false)
			outputServerLog("Character: " .. getPlayerName(element) .. " [" .. getAccountName(element) .. "] saved their character information.")
		else
			outputServerLog("Character: Character information for " .. getPlayerName(element) .. " [" .. getAccountName(element) .. "] was saved automatically.")
		end
	else
		outputServerLog("Error: MySQL query failed when trying to save character info to the database (" .. getPlayerName(element) .. " [" .. getAccountName(element) .. "]).")
	end
	
	local option1 = getAccountSetting(element, "1")
	local option2 = getElementData(element, "roleplay:accounts.option2")
	local option3 = getAccountSetting(element, "3")
	local option4 = getAccountSetting(element, "4")
	local option5 = getAccountSetting(element, "5")
	local option6 = getAccountSetting(element, "6")
	local option7 = getAccountSetting(element, "7")
	local option8 = getAccountSetting(element, "8")
	local query = dbExec(getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "accounts", "admin_level", getAdminLevel(element), "admin_state", getAdminState(element), "admin_hidden", (isClientHidden(element) and 1 or 0), "option_1", option1, "option_2", option2, "option_3", option3, "option_4", option4, "option_5", option5, "option_6", option6, "option_7", option7, "option_8", option8, "lastOnline", getRealTime().timestamp, "id", getAccountID(element))
	if (query) then
		if (manualOrAuto) then
			outputChatBox("Saved account information.", element, 20, 245, 20, false)
			outputServerLog("Account: " .. getPlayerName(element) .. " [" .. getAccountName(element) .. "] saved their account information.")
		else
			outputServerLog("Account: Account information for " .. getPlayerName(element) .. " [" .. getAccountName(element) .. "] was saved automatically.")
		end
	else
		outputServerLog("Error: MySQL query failed when trying to save account info the database (" .. getPlayerName(element) .. " [" .. getAccountName(element) .. "]).")
	end
	
	local lang1, skill1 = exports['roleplay-chat']:getPlayerLanguage(element, 1)
	local lang2, skill2 = exports['roleplay-chat']:getPlayerLanguage(element, 2)
	local lang3, skill3 = exports['roleplay-chat']:getPlayerLanguage(element, 3)
	local query = dbExec(getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??', `??` = '??' WHERE `??` = '??'", "languages", "lang1", lang1, "lang2", lang2, "lang3", lang3, "skill1", skill1, "skill2", skill2, "skill3", skill3, "id", getCharacterID(element))
	if (query) then
		if (manualOrAuto) then
			outputChatBox("Saved language data.", element, 20, 245, 20, false)
			outputServerLog("Languages: " .. getPlayerName(element) .. " [" .. getAccountName(element) .. "] saved their language data.")
		else
			outputServerLog("Languages: Language data for " .. getPlayerName(element) .. " [" .. getAccountName(element) .. "] was saved automatically.")
		end
	else
		outputServerLog("Error: MySQL query failed when trying to save account info the database (" .. getPlayerName(element) .. " [" .. getAccountName(element) .. "]).")
	end
end
addEvent(":_doSaveChar_:", true)
addEventHandler(":_doSaveChar_:", root, saveCharacter)

function getClientRealID(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:clients.id"))) then return false, 1 end
	return tonumber(getElementData(element, "roleplay:clients.id"))
end

function getCharacterSessionTime(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.stime"))) then return 0 end
	return tonumber(getElementData(element, "roleplay:characters.stime"))
end

function getCharacterTime(element)
	if (not element) or (getElementType(element) ~= "player") then return end
	if (not tonumber(getElementData(element, "roleplay:characters.time"))) then return 0 end
	return tonumber(getElementData(element, "roleplay:characters.time"))
end

function getCharacterHour(element)
	if (not getCharacterTime(element)) then return 0 end
	return getCharacterTime(element)/60
end