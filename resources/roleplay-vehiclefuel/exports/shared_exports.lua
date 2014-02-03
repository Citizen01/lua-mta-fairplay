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

function getFuelPointByID(id)
	for i,v in ipairs(getElementsByType("ped")) do
		if (tonumber(getElementData(v, "roleplay:refuel.id"))) then
			if (tonumber(getElementData(v, "roleplay:refuel.id")) == id) then
				return v
			end
		end
	end
	return false
end

function getFuelPointByName(name)
	for i,v in ipairs(getElementsByType("ped")) do
		if (getFuelPointName(v)) and (tonumber(getElementData(v, "roleplay:refuel.id"))) then
			if (getFuelPointName(v) == name) then
				return v
			end
		end
	end
	return false
end

function getFuelPointID(fuelpoint)
	if (tonumber(getElementData(fuelpoint, "roleplay:refuel.id"))) then
		return tonumber(getElementData(fuelpoint, "roleplay:refuel.id"))
	end
	return false
end

function getFuelPointName(fuelpoint)
	if (getElementData(fuelpoint, "roleplay:peds.name")) then
		return getElementData(fuelpoint, "roleplay:peds.name")
	end
	return false
end