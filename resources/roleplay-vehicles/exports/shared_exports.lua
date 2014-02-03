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

function getElementSpeed(element, unit)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x, y, z = getElementVelocity(element)
		if (unit == "mph") or (unit == 1) or (unit == "1") then
			return (x^2 + y^2 + z^2)^0.5*100
		else
			return (x^2 + y^2 + z^2)^0.5*1.8*100
		end
	else
		return false
	end
end

function isVehicleEmpty(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	local passengers = getVehicleMaxPassengers(element)
	if (type(passengers) == "number") then
		for seat=0,passengers do
			if getVehicleOccupant(element, seat) then
				return false
			end
		end
	end
	return true
end

function getVehicleDescription(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not getElementData(element, "roleplay:vehicles.description")) then return false, 3 end
	return tostring(getElementData(element, "roleplay:vehicles.description"))
end

function getVehicleID(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.id"))) then return -1 end
	return tonumber(getElementData(element, "roleplay:vehicles.id"))
end

function getVehicleRealID(element)
	return getVehicleID(element)
end

function getVehicleRealType(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.type"))) then return -1 end
	return tonumber(getElementData(element, "roleplay:vehicles.type"))
end

function getVehicleOwner(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.owner"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:vehicles.owner"))
end

function getVehicleGearType(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.geartype"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:vehicles.geartype"))
end

function getVehicleOwnerName(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not getElementData(element, "roleplay:vehicles.ownername")) then return false, 3 end
	return getElementData(element, "roleplay:vehicles.ownername"):gsub("_", " ")
end

function getVehicleLastUsed(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.lastused"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:vehicles.lastused"))
end

function getVehicleFuel(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.fuel;"))) then return false, 3 end
	return math.floor(tonumber(getElementData(element, "roleplay:vehicles.fuel;")))
end

function getVehicleFaction(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not getVehicleOwner(element)) then return false, 3 end
	local owner = getVehicleOwner(element)
	if (tostring(owner):find("-")) then
		return math.abs(owner)
	else
		return false
	end
end

function isVehicleTinted(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.tinted"))) then return false, 3 end
	local elementData = tonumber(getElementData(element, "roleplay:vehicles.tinted"))
	if (elementData == 0) then
		return false
	elseif (elementData == 1) then
		return true
	else
		return false
	end
end

function isVehicleWindowsDown(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.winstate"))) then return false, 3 end
	local elementData = tonumber(getElementData(element, "roleplay:vehicles.winstate"))
	if (elementData == 0) then
		return false
	elseif (elementData == 1) then
		return true
	else
		return false
	end
end

function isVehicleHandbraked(element)
	if (not element) or (getElementType(element) ~= "vehicle") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.handbrake"))) then return false, 3 end
	local elementData = tonumber(getElementData(element, "roleplay:vehicles.handbrake"))
	if (elementData == 0) then
		return false
	elseif (elementData == 1) then
		return true
	else
		return false
	end
end

function isPlayerInVehicle(element)
	if (not element) or (getElementType(element) ~= "player") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:characters.invehicle"))) then return false, 3 end
	local elementData = tonumber(getElementData(element, "roleplay:characters.invehicle"))
	if (elementData == 0) then
		return false
	elseif (elementData == 1) then
		return true
	else
		return false
	end
end

function getVehicle(id)
	if (not tonumber(id)) then return false, 1 end
	local id = tonumber(id)
	local matches = {}
	for i,v in ipairs(getElementsByType("vehicle")) do
		if (getVehicleID(v)) and (getVehicleID(v) == id) then
			table.insert(matches, v)
		end
	end
	if (#matches == 1) then
		return matches[1]
	end
	return false
end