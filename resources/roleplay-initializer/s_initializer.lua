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

local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		local accResource = getResourceFromName("roleplay-accounts")
		if (accResource) then
			outputServerLog("Initializing account resource.")
			startResource(accResource)
			
			local waitTime = 3500+round(math.random(0, 5000), -2)
			
			outputServerLog("Full start coming up in " .. waitTime .. " ms.")
			setTimer(function()
				outputServerLog("Full start beginning now.")
				for i,v in pairs(getResources()) do
					if (getResourceName(v):find("roleplay-")) and (getResourceName(v) ~= "roleplay-accounts") then
						if (getResourceState(v) == "loaded") then
							if (not startResource(v)) then
								outputServerLog("Failed start up of " .. getResourceName(v) .. ". Please investigate.")
							end
						end
					end
				end
			end, waitTime, 1)
		else
			shutdown("Didn't find a required resource 'roleplay-accounts' from the server. Shutting down...")
		end
	end
)