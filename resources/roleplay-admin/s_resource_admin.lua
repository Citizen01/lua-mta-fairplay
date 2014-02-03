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

local tempVehicles = {}

local addCommandHandler_ = addCommandHandler
	addCommandHandler = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					if (hasObjectPermissionTo(player, "command." .. commandName[1], not restricted)) then
						fn(player, ...)
					end
				end
			)
		end
	end
end

addCommandHandler("restartres",
	function(player, cmd, resource)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not resource) then
				outputChatBox("SYNTAX: /" .. cmd .. " [resource name]", player, 210, 160, 25, false)
				return
			else
				local res = getResourceFromName(resource)
				
				if (not res) then
					outputChatBox("Couldn't find a resource with that name.", player, 245, 20, 20, false)
					return
				end
				
				if (getResourceState(res) == "running") then
					restartResource(res)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player) .. " restarted resource '" .. resource .. "'.", 6)
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] restarted resource '" .. resource .. "'.")
				else
					outputChatBox("The resource has to be running in order to restart it.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler("stopres",
	function(player, cmd, resource)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not resource) then
				outputChatBox("SYNTAX: /" .. cmd .. " [resource name]", player, 210, 160, 25, false)
				return
			else
				local res = getResourceFromName(resource)
				
				if (not res) then
					outputChatBox("Couldn't find a resource with that name.", player, 245, 20, 20, false)
					return
				end
				
				if (getResourceState(res) == "running") then
					stopResource(res)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player) .. " stopped resource '" .. resource .. "'.", 6)
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] stopped resource '" .. resource .. "'.")
				else
					outputChatBox("The resource has to be running in order to stop it.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler("startres",
	function(player, cmd, resource)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not resource) then
				outputChatBox("SYNTAX: /" .. cmd .. " [resource name]", player, 210, 160, 25, false)
				return
			else
				local res = getResourceFromName(resource)
				
				if (not res) then
					outputChatBox("Couldn't find a resource with that name.", player, 245, 20, 20, false)
					return
				end
				
				if (getResourceState(res) == "loaded") then
					startResource(res)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player) .. " started resource '" .. resource .. "'.", 6)
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] started resource '" .. resource .. "'.")
				else
					outputChatBox("The resource has to be stopped and loaded in order to started it.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"reloadacl", "aclreload", "loadacl", "aclload"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientLeader(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			aclReload()
			outputChatBox("ACL reloaded successfully.", player, 20, 245, 20, false)
		end
	end
)