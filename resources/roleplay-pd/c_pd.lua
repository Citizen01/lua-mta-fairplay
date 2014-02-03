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

local copGuards = {
	[1] = {"Randy_Garrison", 280, 1543.82, -1631.96, 13.38, 90, 0, 0},
	[2] = {"Jack_Falcon", 281, 1580.52, -1634.13, 13.56, 0, 0, 0},
	[3] = {"Ralph_Ferrigan", 283, 1566.15, -1689.98, 6.21, 180, 0, 0}
}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for i,v in ipairs(copGuards) do
			local ped = createPed(v[2], v[3], v[4], v[5], v[6], false)
			setElementInterior(ped, v[7])
			setElementDimension(ped, v[8])
			setElementData(ped, "roleplay:peds.name", v[1], true)
			setTimer(setPedAnimation, 500, 1, ped, "COP_AMBIENT", "Coplook_loop", -1, false, true, false, true)
			setTimer(function(ped)
				if (not isElement(ped)) then return end
				setPedAnimation(ped, "COP_AMBIENT", "Coplook_loop", -1, false, true, false, true)
				setElementPosition(ped, copGuards[i][3], copGuards[i][4], copGuards[i][5])
				setElementRotation(ped, 0, 0, copGuards[i][6])
			end, 5000, 0, ped, i)
		end
	end
)