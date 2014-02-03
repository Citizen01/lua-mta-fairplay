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

local jobs = {
	{["name"] = "LST - Bus Driver"},
	{["name"] = "LST - Taxi Driver"}
}

addEvent(":_verifyJobAbility_:", true)
addEventHandler(":_verifyJobAbility_:", root,
	function(jobID)
		if (source ~= client) then return end
		local jobID = tonumber(jobID)
		if (jobID) then
			if (jobs[jobID]) then
				if (exports['roleplay-accounts']:getCharacterJob(client) == 0) then
					if (exports['roleplay-accounts']:hasDriversLicense(client)) and (exports['roleplay-accounts']:hasManualTransmission(client)) then
						outputChatBox("You've accepted the " .. jobs[jobID]["name"] .. " job.", client, 20, 245, 20, false)
						setElementData(client, "roleplay:characters.job", jobID, true)
						
						if (jobID == 1) then
							outputChatBox("In order to start your shift as a Bus Driver, view your map (F11) and locate a yellow blip near Unity Station.", client, 210, 160, 25, false)
							triggerClientEvent(client, ":_syncDutyBlip_:", client, jobID)
						end
					else
						outputChatBox("You need a valid driver's license in order to get this job.", client, 245, 20, 20, false)
					end
				else
					outputChatBox("You already have a job. Quit your job by typing /quitjob.", client, 245, 20, 20, false)
				end
			else
				outputChatBox("That job is no longer available, sorry!", client, 245, 20, 20, false)
			end
		end
	end
)

addEvent(":_getRealJobs_:", true)
addEventHandler(":_getRealJobs_:", root,
	function()
		triggerClientEvent(source, ":_putRealJobs_:", source, jobs)
	end
)

addEventHandler("onVehicleEnter", root,
	function(player, seat, jacked)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (seat == 0) and (tonumber(getElementData(source, "roleplay:vehicles.job"))) and (exports['roleplay-accounts']:getCharacterJob(player) == 1) then
			if (tonumber(getElementData(source, "roleplay:vehicles.job")) == 1) then
				triggerClientEvent(player, ":_beginRoute_:", player, math.random(1, 1))
			end
		end
	end
)

addEventHandler("onVehicleExit", root,
	function(player, seat, jacker)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) and (exports['roleplay-accounts']:getCharacterJob(player) ~= 1) then return end
		triggerClientEvent(player, ":_disableRoute_:", player)
	end
)

addEventHandler("onResourceStop", root,
	function(resource)
		if (getResourceName(resource) == "roleplay-vehicles") then
			restartResource(getThisResource())
		end
	end
)

-- Commands
addCommandHandler("quitjob",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (exports['roleplay-accounts']:getCharacterJob(player) > 0) then
			outputChatBox("You've quit your job as a " .. (exports['roleplay-accounts']:getCharacterJob(player) == 1 and "Bus Driver" or "Taxi Driver") .. ".", player, 20, 245, 20, false)
			setElementData(player, "roleplay:characters.job", 0, true)
		else
			outputChatBox("You're not working anywhere at the moment.", player, 245, 20, 20, false)
		end
	end
)