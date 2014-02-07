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

local ckCharacters = {}

function loadKilledCharacters()
	if (#ckCharacters > 0) then
		for i,v in pairs(ckCharacters) do
			destroyElement(v)
		end
		ckCharacters = {}
	end
	
	local query = dbQuery(getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??'", "characters", "cked", 1)
	if (query) then
		local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
		if (num_affected_rows > 0) then
			if (num_affected_rows == 1) then
				outputDebugString("1 character killed pedestrian is about to be loaded.")
			else
				outputDebugString(num_affected_rows .. " character killed pedestrians are about to be loaded.")
			end
			
			for result,row in pairs(result) do
				ckCharacters[row["id"]] = createPed(row["model"], row["posX"], row["posY"], row["posZ"], row["rotZ"])
				setElementInterior(ckCharacters[row["id"]], row["interior"])
				setElementDimension(ckCharacters[row["id"]], row["dimension"])
				setElementData(ckCharacters[row["id"]], "roleplay:ck.id", row["id"], false)
				setElementData(ckCharacters[row["id"]], "roleplay:ck.name", row["characterName"], false)
				setElementData(ckCharacters[row["id"]], "roleplay:ck.cod", row["CoD"], false)
				killPed(ckCharacters[row["id"]])
			end
		else
			outputDebugString("0 character killed pedestrians loaded.")
		end
	end
end

function findCharacterKill(arg)
	if (not arg) then return false end
	local ped, id = nil, 0
	
	if (tonumber(arg)) then
		local arg = tonumber(arg)
		
		for i,v in pairs(ckCharacters) do
			if (isElement(v)) then
				if (i == arg) then
					ped, id = v, arg
					break
				end
			end
		end
	else
		for i,v in pairs(ckCharacters) do
			if (isElement(v)) then
				local name = getElementData(v, "roleplay:ck.name")
				if (name) and (name == tostring(arg)) then
					ped, id = v, tonumber(getElementData(v, "roleplay:ck.id"))
					break
				end
			end
		end
	end
	
	if (ped) and (tonumber(id) and tonumber(id) > 0) then
		return ped, id
	else
		return false
	end
end

function deleteCharacterKill(arg)
	if (not arg) then return false end
	local ped, id = findCharacterKill(arg)
	if (ped) and (id) then
		local query = dbExec(getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "characters", "cked", 0, "id", id)
		if (query) then
			if (isElement(ped)) then
				destroyElement(ped)
			end
			return true
		else
			return false, 9
		end
	else
		return false, 10
	end
end

function createCharacterKill(player, causeOfDeath)
	if (not player) or (getElementType(player) ~= "player") or (not causeOfDeath) then return false end
	if (not isClientPlaying(player)) then return false end
	local id = getCharacterID(player)
	local query = dbExec(getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??' WHERE `??` = '??'", "characters", "cked", 1, "CoD", causeOfDeath, "id", id)
	if (query) then
		if (ckCharacters[id]) and (isElement(ckCharacters[id])) then
			destroyElement(ckCharacters[id])
			ckCharacters[id] = nil
		end
		
		local x, y, z = getElementPosition(player)
		local _, _, rot = getElementRotation(player)
		ckCharacters[id] = createPed(getElementModel(player), x, y, z, rot)
		setElementInterior(ckCharacters[id], getElementInterior(player))
		setElementDimension(ckCharacters[id], getElementDimension(player))
		setElementData(ckCharacters[id], "roleplay:ck.id", id, false)
		setElementData(ckCharacters[id], "roleplay:ck.name", getPlayerName(player), false)
		setElementData(ckCharacters[id], "roleplay:ck.cod", causeOfDeath, false)
		killPed(ckCharacters[id])
		exitGameMode(player)
		
		return true
	else
		return false, 9
	end
end

--Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
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

addCommandHandler({"unck", "deleteck", "unckplayer"},
	function(player, cmd, name)
		if (not isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) then
				outputChatBox("SYNTAX: /" .. cmd .. " [full character name]", player, 210, 160, 25, false)
			else
				if (deleteCharacterKill(name)) then
					outputAdminLog(getRealPlayerName(player) .. " removed character kill on " .. getRealPlayerName(target) .. ".")
				else
					outputChatBox("Character kill on that player name not found.", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"ck", "makeck", "ckplayer"},
	function(player, cmd, name, ...)
		if (not isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			if (not name) or (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [cause of death]", player, 210, 160, 25, false)
			else
				local causeOfDeath = table.concat({...}, " ")
				if (causeOfDeath) and (#causeOfDeath > 1) then
					local target = getPlayerFromPartialName(name, player)
					if (target) then
						createCharacterKill(target, causeOfDeath)
						outputAdminLog(getRealPlayerName(player) .. " character killed " .. getRealPlayerName(target) .. ".")
					else
						outputChatBox("Player with that name or ID not found.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [cause of death]", player, 210, 160, 25, false)
				end
			end
		end
	end
)