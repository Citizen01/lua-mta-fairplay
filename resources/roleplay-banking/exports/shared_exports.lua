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

function getATMID(element)
	if (not element) or (getElementType(element) ~= "object") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:atms.id"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:atms.id"))
end

function getATMDeposit(element)
	if (not element) or (getElementType(element) ~= "object") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:atms.deposit"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:atms.deposit"))
end

function getATMWithdraw(element)
	if (not element) or (getElementType(element) ~= "object") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:atms.withdraw"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:atms.withdraw"))
end

function getATMLimit(element)
	if (not element) or (getElementType(element) ~= "object") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:atms.limit"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:atms.limit"))
end

function getATM(id)
	if (not tonumber(id)) then return false, 1 end
	local id = tonumber(id)
	local matches = {}
	for i,v in ipairs(getElementsByType("object")) do
		if (getElementModel(v) == 2942) then
			if (getATMID(v)) and (getATMID(v) == id) then
				table.insert(matches, v)
			end
		end
	end
	if (#matches == 1) then
		return matches[1]
	end
	return false
end

function getFormattedValue(number)
	if (not tonumber(number)) then return false, 1 end
	local formatted = tonumber(number)
	while true do
		formatted,k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
			break
		end
	end
	return formatted
end