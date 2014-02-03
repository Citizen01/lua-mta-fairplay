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

addEvent(":_setWalkStyle_:", true)
addEventHandler(":_setWalkStyle_:", root,
	function(drugID)
		if (drugID == 1) then
			setPedWalkingStyle(source, 137)
		else
			setPedWalkingStyle(source, 0)
			local hour, minute = getTime()
			setTime(hour, minute)
		end
	end
)