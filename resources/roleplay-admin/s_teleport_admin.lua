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

local locations = {
	-- x, y, z, int, dim
	["sf"] = {-1985.1, 137.79, 27.68, 0, 0},
	["sanfierro"] = {-1985.1, 137.79, 27.68, 0, 0},
	["ls"] = {1520.98, -1675.53, 13.54, 0, 0},
	["lspd"] = {1520.98, -1675.53, 13.54, 0, 0},
	["lossantos"] = {1520.98, -1675.53, 13.54, 0, 0},
	["lv"] = {2032.95, 1342.81, 10.82, 0, 0},
	["lasventuras"] = {2032.95, 1342.81, 10.82, 0, 0},
	["dmv"] = {927.3, -1717.84, 13.54, 0, 0},
	["ash"] = {1183.98, -1323.77, 13.57, 0, 0},
	["cg"] = {2036.16, -1412.43, 16.99, 0, 0},
	["hospital"] = {2036.16, -1412.43, 16.99, 0, 0},
	["grove"] = {2493.22, -1667.31, 13.34, 0, 0},
	["cityhall"] = {1463.56, -1820.52, 1250.89, 4, 15},
	["igs"] = {1967.83, -1773.63, 13.54, 0, 0},
	["vgs"] = {1005.38, -949.39, 42.19, 0, 0},
	["airport"] = {1439.24, -2287.07, 13.54, 0, 0},
	["lsia"] = {1439.24, -2287.07, 13.54, 0, 0},
	["unity"] = {1743.04, -1861.05, 13.57, 0, 0},
	["mall"] = {1128.82, -1429.4, 15.79, 0, 0},
	["bank"] = {1426.02, -1553.65, 13.54, 0, 0},
	["adminlounge"] = {1779.33, -1301.96, 120.2, 0, 0},
	["admin"] = {1779.33, -1301.96, 120.2, 0, 0},
	["lounge"] = {1779.33, -1301.96, 120.2, 0, 0},
}

addCommandHandler("gotoplace",
	function(player, cmd, place)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not place) then
				outputChatBox("SYNTAX: /" .. cmd .. " [ls/sf/lv/dmv/cityhall/hospital/ash/grove/igs/vgs/lsia/unity/mall/bank]", player, 210, 160, 25, false)
				return
			else
				if (not locations[place]) then
					outputChatBox("Couldn't find a place with that name.", player, 245, 20, 20, false)
				else
					if (not isElement(player)) then
						outputChatBox("You have to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(player) > 0) then
						setElementPosition(player, locations[place][1], locations[place][2], locations[place][3])
						setElementInterior(player, locations[place][4])
						setElementDimension(player, locations[place][5])
						outputChatBox("Teleported to '" .. place .. "'.", player, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " [" .. place .. "] command.")
					else
						outputChatBox("You have to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler("adminlounge",
	function(player, cmd, place)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			executeCommandHandler("gotoplace", player, "adminlounge")
		end
	end
)

addCommandHandler({"getpos", "pos", "mypos", "getposition", "position", "getxyz"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) then
				if (not isElement(player)) then
					outputChatBox("You have to be spawned in order to execute the command.", player, 245, 20, 20, false)
					return
				end
				
				if (getElementHealth(player) > 0) then
					local x, y, z = getElementPosition(player)
					local rx, ry, rz = getElementRotation(player)
					outputChatBox("Position: " .. (math.floor(x*100)/100) .. ", " .. (math.floor(y*100)/100) .. ", " .. (math.floor(z*100)/100), player, 210, 160, 25, false)
					outputChatBox("Rotation: " .. (math.floor(rz*100)/100), player, 210, 160, 25, false)
					outputChatBox("Interior: " .. getElementInterior(player) .. ", Dimension: " .. getElementDimension(player), player, 210, 160, 25, false)
					outputChatBox(" - Copied " .. (math.floor(x*100)/100) .. " " .. (math.floor(y*100)/100) .. " " .. (math.floor(z*100)/100) .. " " .. getElementInterior(player) .. " " .. getElementDimension(player) .. " to your clipboard.", player)
					triggerClientEvent(player, ":_setClipBoard_:", player, (math.floor(x*100)/100) .. " " .. (math.floor(y*100)/100) .. " " .. (math.floor(z*100)/100) .. " " .. getElementInterior(player) .. " " .. getElementDimension(player))
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command.")
				else
					outputChatBox("You have to be alive in order to execute the command.", player, 245, 20, 20, false)
				end
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local x, y, z = getElementPosition(target)
						outputChatBox("Position: " .. (math.floor(x*100)/100) .. ", " .. (math.floor(y*100)/100) .. ", " .. (math.floor(z*100)/100), player, 210, 160, 25, false)
						outputChatBox("Rotation: " .. (math.floor(getPedRotation(target)*100)/100), player, 210, 160, 25, false)
						outputChatBox("Interior: " .. getElementInterior(target) .. ", Dimension: " .. getElementDimension(target), player, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"x", "y", "z"},
	function(player, cmd, value)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local value = tonumber(value)
			if (not value) then
				outputChatBox("SYNTAX: /" .. cmd .. " [amount]", player, 210, 160, 25, false)
				return
			else
				if (not isElement(player)) then
					outputChatBox("You have to be spawned in order to execute the command.", player, 245, 20, 20, false)
					return
				end
				
				if (getElementHealth(player) > 0) then
					local vehicle = getPedOccupiedVehicle(player)
					if (not vehicle) then
						local x, y, z = getElementPosition(player)
						if (cmd == "x") then
							setElementPosition(player, x+value, y, z)
						elseif (cmd == "y") then
							setElementPosition(player, x, y+value, z)
						elseif (cmd == "z") then
							setElementPosition(player, x, y, z+value)
						end
					else
						local x, y, z = getElementPosition(vehicle)
						if (cmd == "x") then
							setElementPosition(vehicle, x+value, y, z)
						elseif (cmd == "y") then
							setElementPosition(vehicle, x, y+value, z)
						elseif (cmd == "z") then
							setElementPosition(vehicle, x, y, z+value)
						end
					end
					outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command.")
				else
					outputChatBox("You have to be alive in order to execute the command.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"setxyz", "xyz", "setpos"},
	function(player, cmd, name, x, y, z)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local x = tonumber(x)
			local y = tonumber(y)
			local z = tonumber(z)
			if (not name) or (not x) or (not y) or (not z) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [x] [y] [z]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local vehicle = getPedOccupiedVehicle(player)
						
						if (not vehicle) then
							setElementPosition(target, x, y, z)
						else
							setElementPosition(vehicle, x, y, z)
						end
						
						outputChatBox("Teleported " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " to '" .. x .. ", " .. y .. ", " .. z .. "'.", player, 210, 160, 25, false)
						outputChatBox("Administrator teleported you to a position.", target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " [" .. x .. ", " .. y .. ", " .. z .. "] command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"setint", "setinterior"},
	function(player, cmd, name, intid)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local intid = tonumber(intid)
			if (not name) or (not intid) or (intid and intid < 0 or intid > 255) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [interior world: 0-255]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local vehicle = getPedOccupiedVehicle(player)
						
						if (not vehicle) then
							setElementInterior(target, intid)
						else
							setElementInterior(vehicle, intid)
						end
						
						outputChatBox("Teleported " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " to interior world " .. intid .. ".", player, 210, 160, 25, false)
						outputChatBox("Administrator teleported you to interior world " .. intid .. ".", target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " [" .. intid .. "] command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"setdim", "setdimension"},
	function(player, cmd, name, dimid)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local dimid = tonumber(dimid)
			if (not name) or (not dimid) or (dimid and dimid < 0 or dimid > 65535) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [dimension world: 0-65535]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local vehicle = getPedOccupiedVehicle(player)
						
						if (not vehicle) then
							setElementDimension(target, dimid)
						else
							setElementDimension(vehicle, dimid)
						end
						
						outputChatBox("Teleported " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " to dimension world " .. dimid .. ".", player, 210, 160, 25, false)
						outputChatBox("Administrator teleported you to dimension world " .. dimid .. ".", target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " [" .. dimid .. "] command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"gethere", "tphere"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local x, y, z = getElementPosition(player)
						local interior = getElementInterior(player)
						local dimension = getElementDimension(player)
						local rotation = getPedRotation(player)
						setCameraInterior(target, interior)
						
						local x = x+((math.cos(math.rad(rotation)))*2)
						local y = y+((math.sin(math.rad(rotation)))*2)
						
						if (isPedInVehicle(target)) then
							local vehicle = getPedOccupiedVehicle(target)
							setVehicleTurnVelocity(vehicle, 0, 0, 0)
							setElementPosition(vehicle, x, y, z + 1)
							setTimer(setVehicleTurnVelocity, 50, 20, vehicle, 0, 0, 0)
							setElementInterior(vehicle, interior)
							setElementDimension(vehicle, dimension)
						end
						
						setElementPosition(target, x, y, z)
						setElementInterior(target, interior)
						setElementDimension(target, dimension)
						
						outputChatBox("Teleported " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " to you.", player, 210, 160, 25, false)
						outputChatBox("Administrator teleported you to them.", target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler({"goto", "tpto"},
	function(player, cmd, name)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						local x, y, z = getElementPosition(target)
						local interior = getElementInterior(target)
						local dimension = getElementDimension(target)
						local rotation = getPedRotation(target)
						setCameraInterior(player, interior)
						
						local x = x+((math.cos(math.rad(rotation)))*2)
						local y = y+((math.sin(math.rad(rotation)))*2)
						
						if (isPedInVehicle(player)) then
							local vehicle = getPedOccupiedVehicle(player)
							setVehicleTurnVelocity(vehicle, 0, 0, 0)
							setElementPosition(vehicle, x, y, z + 1)
							setTimer(setVehicleTurnVelocity, 50, 20, vehicle, 0, 0, 0)
							setElementInterior(vehicle, interior)
							setElementDimension(vehicle, dimension)
						end
						
						setElementPosition(player, x, y, z)
						setElementInterior(player, interior)
						setElementDimension(player, dimension)
						
						outputChatBox("Teleported to " .. exports['roleplay-accounts']:getRealPlayerName(target) .. ".", player, 210, 160, 25, false)
						outputChatBox("Administrator teleported to you.", target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler("sendto",
	function(player, cmd, name, name2)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) or (not name2) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [destination: partial player name]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				local target2 = exports['roleplay-accounts']:getPlayerFromPartialName(name2, player)
				
				if (not target) or (not target2) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) or (not isElement(target2)) then
						outputChatBox("The players have to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) and (getElementHealth(target2) > 0) then
						local x, y, z = getElementPosition(target2)
						local interior = getElementInterior(target2)
						local dimension = getElementDimension(target2)
						local rotation = getPedRotation(target2)
						setCameraInterior(target, interior)
						
						local x = x+((math.cos(math.rad(rotation)))*2)
						local y = y+((math.sin(math.rad(rotation)))*2)
						
						if (isPedInVehicle(target)) then
							local vehicle = getPedOccupiedVehicle(target)
							setVehicleTurnVelocity(vehicle, 0, 0, 0)
							setElementPosition(vehicle, x, y, z + 1)
							setTimer(setVehicleTurnVelocity, 50, 20, vehicle, 0, 0, 0)
							setElementInterior(vehicle, interior)
							setElementDimension(vehicle, dimension)
						end
						
						setElementPosition(target, x, y, z)
						setElementInterior(target, interior)
						setElementDimension(target, dimension)
						
						outputChatBox("Teleported " .. exports['roleplay-accounts']:getRealPlayerName(target) .. " to " .. exports['roleplay-accounts']:getRealPlayerName(target2) .. ".", player, 210, 160, 25, false)
						outputChatBox("Administrator teleported you to " .. exports['roleplay-accounts']:getRealPlayerName(target2) .. ".", target, 210, 160, 25, false)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "] and " .. getPlayerName(target2) .. " [" .. exports['roleplay-accounts']:getAccountName(target2) .. "].")
					else
						outputChatBox("The players have to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)