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

function getElevator(id)
	if (not tonumber(id)) then return false, 1 end
	local id = tonumber(id)
	local matches = {}
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getElevatorID(v)) and (getElevatorID(v) == id) then
			table.insert(matches, v)
		end
	end
	if (#matches == 2) then
		return matches[1], matches[2]
	end
	return false
end

function getElevatorID(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:elevators.id"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:elevators.id"))
end

function getElevatorOpenType(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:elevators.opentype"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:elevators.opentype"))
end

function getInteriorID(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.id"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:interiors.id"))
end

function getInteriorType(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.type"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:interiors.type"))
end

function getInteriorInsideID(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.interiorid"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:interiors.interiorid"))
end

function getInteriorCost(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.cost"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:interiors.cost"))
end

function getInteriorPrice(element)
	return getInteriorCost(element)
end

function getInteriorName(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not getElementData(element, "roleplay:interiors.name")) then return false, 3 end
	return getElementData(element, "roleplay:interiors.name")
end

function getInteriorOwner(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.ownerid"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:interiors.ownerid"))
end

function getInteriorOwnerName(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not getElementData(element, "roleplay:interiors.ownername")) then return false, 3 end
	return getElementData(element, "roleplay:interiors.ownername"):gsub("_", " ")
end

function getInteriorLastUsed(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.lastused"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:interiors.lastused"))
end

function isInteriorForSale(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not getInteriorOwner(element)) or (not getInteriorType(element)) then return false, 3 end
	if (getInteriorType(element) > 0) then
		if (getInteriorOwner(element) == 0) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function isInteriorLocked(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.locked"))) then return false, 3 end
	if (tonumber(getElementData(element, "roleplay:interiors.locked")) == 1) then
		return true
	else
		return false
	end
end

function isInteriorDisabled(element)
	if (not element) or (getElementType(element) ~= "pickup") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:interiors.disabled"))) then return false, 3 end
	if (tonumber(getElementData(element, "roleplay:interiors.disabled")) == 1) then
		return true
	else
		return false
	end
end

function getInterior(id)
	if (not tonumber(id)) then return false, 1 end
	local id = tonumber(id)
	local matches = {}
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getInteriorID(v)) and (getInteriorID(v) == id) then
			table.insert(matches, v)
		end
	end
	if (#matches == 2) then
		return matches[1], matches[2]
	end
	return false
end