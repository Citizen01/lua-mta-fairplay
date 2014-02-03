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

local function tablelength(table)
	local count = 0
	for _ in pairs(table) do count = count+1 end
	return count
end

function getFactionByID(id)
	for i,v in ipairs(getElementsByType("team")) do
		if (getFactionID(v)) and (getFactionID(v) == id) then
			return v
		end
	end
	return false
end

function getFactionByName(name)
	return getTeamFromName(name)
end

function getFactionID(faction)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not tonumber(getElementData(faction, "roleplay:factions.id"))) then return end
	return tonumber(getElementData(faction, "roleplay:factions.id"))
end

function getFactionName(faction)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not getElementData(faction, "roleplay:factions.name")) then return end
	return getElementData(faction, "roleplay:factions.name")
end

function getFactionMOTD(faction)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not getElementData(faction, "roleplay:factions.motd")) then return end
	return getElementData(faction, "roleplay:factions.motd")
end

function getFactionDescription(faction)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not getElementData(faction, "roleplay:factions.description")) then return end
	return getElementData(faction, "roleplay:factions.description")
end

function getFactionRanks(faction, nonRaw)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not getElementData(faction, "roleplay:factions.ranks")) then return end
	if (not nonRaw) then
		return getElementData(faction, "roleplay:factions.ranks")
	else
		return fromJSON(getElementData(faction, "roleplay:factions.ranks"))
	end
end

function getFactionWages(faction, nonRaw)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not getElementData(faction, "roleplay:factions.wages")) then return end
	if (not nonRaw) then
		return getElementData(faction, "roleplay:factions.wages")
	else
		return fromJSON(getElementData(faction, "roleplay:factions.wages"))
	end
end

function getFactionType(faction)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not tonumber(getElementData(faction, "roleplay:factions.type"))) then return end
	return tonumber(getElementData(faction, "roleplay:factions.type"))
end

function getFactionBank(faction)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	if (not tonumber(getElementData(faction, "roleplay:factions.bank"))) then return end
	return tonumber(getElementData(faction, "roleplay:factions.bank"))
end

function setFactionBank(faction, amount)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	local id = getFactionID(faction)
	if (id) then
		setElementData(faction, "roleplay:factions.bank", amount, true)
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "factions", "bankValue", amount, "id", id)
		return true
	end
	return false
end

function takeFactionBank(faction, amount)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	local id = getFactionID(faction)
	if (id) then
		setElementData(faction, "roleplay:factions.bank", getFactionBank(faction)-amount, true)
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = `??`-'??' WHERE `??` = '??'", "factions", "bankValue", "bankValue", amount, "id", id)
		return true
	end
	return false
end

function giveFactionBank(faction, amount)
	if (not faction) or (not isElement(faction)) or (getElementType(faction) ~= "team") then return end
	local id = getFactionID(faction)
	if (id) then
		setElementData(faction, "roleplay:factions.bank", getFactionBank(faction)+amount, true)
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = `??`+'??' WHERE `??` = '??'", "factions", "bankValue", "bankValue", amount, "id", id)
		return true
	end
	return false
end