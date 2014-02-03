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

local playerLanguages = {}
local languages = {
	{"gb", "English"},
	{"fi", "Finnish"},
	{"ee", "Estonian"},
	{"se", "Swedish"},
	{"no", "Norwegian"},
	{"dk", "Danish"},
	{"nl", "Dutch"},
	{"es", "Spanish"},
	{"it", "Italian"},
	{"ru", "Russian"},
	{"de", "German"},
	{"fr", "French"},
	{"ja", "Japanese"},
	{"cn", "Chinese"},
	{"lt", "Lithuanian"},
	{"sc", "Gaelic"},
	{"il", "Hebrew"},
	{"ro", "Romanian"},
	{"pl", "Polish"},
	{"pr", "Portuguese"},
	{"al", "Albanian"},
	{"af", "Arabic"},
	{"gb", "Welsh"},
	{"hu", "Hungarian"},
	{"bo", "Bosnian"},
	{"eu", "Greek"},
	{"sb", "Serbian"},
	{"ct", "Croatian"},
	{"sl", "Slovak"},
	{"af", "Persian"},
	{"so", "Somalian"},
	{"gy", "Georgian"},
	{"eu", "Turkish"},
	{"kr", "Korean"},
	{"vn", "Vietnamese"},
	[101] = {"cp", "MD5"},
	[666] = {"tr", "Trollish"} -- In case language not found :')
}

function getLanguages()
	return languages
end

function getLanguage(language)
	local language = tonumber(language)
	if (language and languages[language]) then
		return languages[language][1], languages[language][2]
	else
		return false
	end
end

function getLanguageFlag(language)
	local language = tonumber(language)
	if (language and languages[language]) then
		return languages[language][1]
	else
		return false
	end
end

function getLanguageName(language)
	local language = tonumber(language)
	if (language and languages[language]) then
		return languages[language][2]
	else
		return false
	end
end

function hasLanguage(player, language, slot, skill)
	if (player) and (language) then
		if (not skill) then
			if (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "1"))) == tonumber(language)) then
				return true, 1
			elseif (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "2"))) == tonumber(language)) then
				return true, 2
			elseif (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "3"))) == tonumber(language)) then
				return true, 3
			else
				return false
			end
		else
			if (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "1"))) == tonumber(language)) and (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "1") .. "skill")) == tonumber(skill)) then
				return true, 1
			elseif (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "2"))) == tonumber(language)) and (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "2") .. "skill")) == tonumber(skill)) then
				return true, 2
			elseif (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "3"))) == tonumber(language)) and (tonumber(getElementData(player, "roleplay:languages." .. (tonumber(slot) and tonumber(slot) or "3") .. "skill")) == tonumber(skill)) then
				return true, 3
			else
				return false
			end
		end
	else
		return false
	end
end

function getFreeSlot(player)
	local lang1 = tonumber(getElementData(player, "roleplay:languages.1"))
	local lang2 = tonumber(getElementData(player, "roleplay:languages.2"))
	local lang3 = tonumber(getElementData(player, "roleplay:languages.3"))
	
	if (not lang1) or (lang1 == 0) then
		return 1
	elseif (not lang2) or (lang2 == 0) then
		return 2
	elseif (not lang3) or (lang3 == 0) then
		return 3
	else
		return 0
	end
end

function giveLanguage(player, language, free, skill)
	if (player) and (language) then
		local has, slot = hasLanguage(player, language)
		if (not has) then
			local slot = getFreeSlot(player)
			if (slot > 0) then
				setElementData(player, "roleplay:languages." .. (free and free or slot), (tonumber(language) and tonumber(language) or 0), true)
				setElementData(player, "roleplay:languages." .. (free and free or slot) .. "skill", (tonumber(skill) and tonumber(skill) or 100), true)
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function takeLanguage(player, language)
	if (player) and (language) then
		local has, slot = hasLanguage(player, language)
		if (has) then
			setElementData(player, "roleplay:languages." .. slot, 0, true)
			setElementData(player, "roleplay:languages." .. slot .. "skill", 0, true)
			return true
		else
			return false
		end
	else
		return false
	end
end

function increaseLanguageSkill(player, language)
	local has, slot = hasLanguage(player, language)
	if (has) then
		local skill = tonumber(getElementData(player, "roleplay:languages." .. slot .. "skill"))
		if (skill < 100) then
			local lucky = math.random(1, math.max(math.ceil(skill/3), 8))
			if (lucky == 1) then
				local skill = skill+1
				setElementData(player, "roleplay:languages." .. slot .. "skill", skill, true)
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "languages", "skill" .. slot, skill, "charID", exports['roleplay-accounts']:getCharacterID(player))
				return true, skill
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function getPlayerLanguage(player, slot)
	if (slot) then
		return tonumber(getElementData(player, "roleplay:languages." .. slot)), tonumber(getElementData(player, "roleplay:languages." .. slot .. "skill"))
	else
		return tonumber(getElementData(player, "roleplay:languages.1")), tonumber(getElementData(player, "roleplay:languages.1skill"))
	end
end

function getPlayerLanguages(player)
	if (player) then
		return tonumber(getElementData(player, "roleplay:languages.1")), tonumber(getElementData(player, "roleplay:languages.2")), tonumber(getElementData(player, "roleplay:languages.3"))
	else
		return false
	end
end

function getPlayerLanguageSkill(player, language)
	local has, slot = hasLanguage(player, language)
	if (has) then
		return tonumber(getElementData(player, "roleplay:languages." .. slot .. "skill"))
	else
		return 0
	end
end