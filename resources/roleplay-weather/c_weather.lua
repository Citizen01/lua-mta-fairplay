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

local realRainLevel = 0
local allowChanges
local wasToggled
local isToggled

addEvent(":_updateRainLevel_:", true)
addEventHandler(":_updateRainLevel_:", root,
	function(rainLevel)
		if (isToggled) then setRainLevel(0) return end
		realRainLevel = rainLevel
		setRainLevel(realRainLevel)
	end
)

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, false)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end, false, false
			)
		end
	end
end

addCommandHandler({"tograin", "togglerain", "rain"},
	function(cmd)
		allowChanges = not allowChanges
		if (allowChanges) then
			outputChatBox("Rain rendering is now enabled.", 20, 245, 20, false)
			setRainLevel(realRainLevel)
		else
			outputChatBox("Rain rendering is now disabled.", 245, 20, 20, false)
			setRainLevel(0)
		end
	end
)