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

function getPlayerStreet(element)
	if (not element) or (getElementType(element) ~= "player") then return false, 1 end
	if (not getElementData(element, "roleplay:vehicles.street")) then return false, 3 end
	return getElementData(element, "roleplay:vehicles.street")
end

function getPlayerSpeedLimit(element)
	if (not element) or (getElementType(element) ~= "player") then return false, 1 end
	if (not tonumber(getElementData(element, "roleplay:vehicles.speedlimit"))) then return false, 3 end
	return tonumber(getElementData(element, "roleplay:vehicles.speedlimit"))
end