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

function getBankValue(element)
	if (not element) then return false, 1 end
	if (not tonumber(element)) and (getElementType(element) == "player") then
		if (not tonumber(getElementData(element, "roleplay:characters.bank"))) then return false, 3 end
		return tonumber(getElementData(element, "roleplay:characters.bank"))
	elseif (tonumber(element)) then
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "bank", "characters", "id", element)
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then return false end
			for result, row in pairs(result) do
				return row["bank"]
			end
		end
	end
	return false
end

function setBankValue(element, value)
	if (not tonumber(value)) or (not element) then return false, 1 end
	if (not tonumber(element)) and (getElementType(element) == "player") then
		if (not tonumber(getElementData(element, "roleplay:characters.bank"))) then return false, 3 end
		setElementData(element, "roleplay:characters.bank", tonumber(value), false)
		return tonumber(getElementData(element, "roleplay:characters.bank"))
	elseif (tonumber(element)) then
		local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "characters", "bank", tonumber(value), "id", tonumber(element))
		if (query) then
			return getBankValue(tonumber(element))
		end
	end
	return false
end

function takeBankValue(element, value)
	if (not tonumber(value)) or (not element) then return false, 1 end
	if (not tonumber(element)) and (getElementType(element) == "player") then
		if (not tonumber(getElementData(element, "roleplay:characters.bank"))) then return false, 3 end
		setElementData(element, "roleplay:characters.bank", tonumber(getElementData(element, "roleplay:characters.bank"))-tonumber(value), false)
		return tonumber(getElementData(element, "roleplay:characters.bank"))
	elseif (tonumber(element)) then
		local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = `??`-'??' WHERE `??` = '??'", "characters", "bank", "bank", tonumber(value), "id", tonumber(element))
		if (query) then
			return getBankValue(tonumber(element))
		end
	end
	return false
end

function giveBankValue(element, value)
	if (not tonumber(value)) or (not element) then return false, 1 end
	if (not tonumber(element)) and (getElementType(element) == "player") then
		if (not tonumber(getElementData(element, "roleplay:characters.bank"))) then return false, 3 end
		setElementData(element, "roleplay:characters.bank", tonumber(getElementData(element, "roleplay:characters.bank"))+tonumber(value), false)
		return tonumber(getElementData(element, "roleplay:characters.bank"))
	elseif (tonumber(element)) then
		local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = `??`+'??' WHERE `??` = '??'", "characters", "bank", "bank", tonumber(value), "id", tonumber(element))
		if (query) then
			return getBankValue(tonumber(element))
		end
	end
	return false
end

addEvent(":_doTheyEvenHaveAccessToThatMoney_:", true)
addEventHandler(":_doTheyEvenHaveAccessToThatMoney_:", root,
	function(amount)
		if (source ~= client) then return end
		if (getPlayerMoney(client) >= amount) then
			triggerClientEvent(client, ":_fetchTheyEvenHaveAccessToThatMoney_:", client, 1, getPlayerMoney(client))
		else
			triggerClientEvent(client, ":_fetchTheyEvenHaveAccessToThatMoney_:", client, 0, getPlayerMoney(client))
		end
	end
)