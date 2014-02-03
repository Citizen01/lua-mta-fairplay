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

function isSettingRealEnabled(element, settingID)
	if (not element) or (not isElement(element)) or (getElementType(element) ~= "player") or (not tonumber(settingID)) or (tonumber(settingID) <= 0) then return false end
	if (not exports['roleplay-accounts']:isClientPlaying(element)) then return false end
	local settingID = tonumber(settingID)
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "settings", "accounts", "id", exports['roleplay-accounts']:getAccountID(element))
	if (query) then
		local result, num_affected_rows = dbPoll(query, -1)
		if (num_affected_rows > 0) then
			for result, row in pairs(result) do
				if (row[tostring(settingID)]) then
					local theRow = row[tostring(settingID)]
					if (theRow > 0) then
						return true
					end
				end
			end
		end
	end
	return false
end