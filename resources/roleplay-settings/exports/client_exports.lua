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

local settings = {}

addEvent(":_placeTheRealSettings_:", true)
addEventHandler(":_placeTheRealSettings_:", root,
	function(settingsTable)
		settings = settingsTable
		if (#settings < 12) then
			for i=1,30 do
				settings[i] = false
			end
		end
	end
)

function isSettingEnabled(element, settingID)
	if (not element) or (not isElement(element)) or (getElementType(element) ~= "player") or (not tonumber(settingID)) or (tonumber(settingID) <= 0) then return false end
	if (not exports['roleplay-accounts']:isClientPlaying(element)) then return false end
	local settingID = tonumber(settingID)
	if (settings[settingID]) then
		if (tonumber(settings[settingID]) > 0) then
			return true
		end
	end
	return false
end