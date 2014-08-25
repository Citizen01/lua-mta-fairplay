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

local playerNamePrefix = "Roleplay"

function getSafeNamePrefix()
	return playerNamePrefix
end

addEvent(":_returnCheat_:", true)
addEventHandler(":_returnCheat_:", root,
	function(ret, cheat, gameSpeed, isNormalGameSpeed, gravity)
		if (exports['roleplay-accounts']:isClientOwner(client)) or (not exports['roleplay-accounts']:isClientPlaying(client)) then return end
		if (ret == 0) then
			if (source == client) and (type(cheat) == "string") then
				exports['roleplay-accounts']:outputAdminLog("WARNING! GTA:SA related cheat '" .. tostring(cheat) .. "' in use by " .. getPlayerName(client) .. ". Please verify.", 5)
				outputServerLog("Anti-cheat: " .. getPlayerName(client) .. " is most likely cheating - GTA:SA cheat '" .. tostring(cheat) .. "' in use.")
			else
				exports['roleplay-accounts']:outputAdminLog("WARNING! GTA:SA related unknown cheat '" .. tostring(cheat) .. "' in use by " .. getPlayerName(client) .. ". Please verify.", 5)
				outputServerLog("Anti-cheat: We're being fooled by " .. getPlayerName(client) .. ". GTA:SA cheat is invalid '" .. tostring(cheat) .. "'.")
			end
		elseif (ret == 1) then
			if (source == client) and (type(gameSpeed) == "number") and (type(isNormalGameSpeed) == "boolean") and (type(gravity) == "number") then
				if (gameSpeed ~= getGameSpeed()) or ((getGameSpeed() == 1) ~= isNormalGameSpeed) then
					exports['roleplay-accounts']:outputAdminLog("WARNING! Game speed is affected! '" .. getGameSpeed() .. "' is expected, but returned '" .. gameSpeed .. "' by " .. getPlayerName(client) .. ". Please verify.", 5)
					outputServerLog("Anti-cheat: " .. getPlayerName(client) .. " is most likely cheating - game speed expected to be at " .. getGameSpeed() .. " but client returned '" .. gameSpeed .. "'.")
				end
				
				if (gravity * 100000 ~= getGravity() * 100000) then
					if (exports['roleplay-accounts']:isClientTrialAdmin(client)) then return end
					exports['roleplay-accounts']:outputAdminLog("WARNING! Game gravity is affected! '" .. getGravity() .. "' is expected, but returned '" .. gravity .. "' by " .. getPlayerName(client) .. ". Please verify.", 5)
					outputServerLog("Anti-cheat: " .. getPlayerName(client) .. " is most likely cheating - gravity expected to be at " .. getGravity() .. " but client returned '" .. gravity .. "'.")
				end
			else
				outputAdminLog("WARNING! Anti-cheat system is being fooled by " .. getPlayerName(client) .. "! AC returned '" .. tostring(gameSpeed) .. "', '" .. tostring(isNormalGameSpeed) .. "', '" .. tostring(gravity) .. "'. Please verify.", 5)
				outputServerLog("Anti-cheat: We're being fooled by " .. getPlayerName(client) .. ". Value is/values are invalid '" .. tostring(gameSpeed) .. "', '" .. tostring(isNormalGameSpeed) .. "', '" .. tostring(gravity) .. "'.")
			end
		elseif (ret == 2) then
			local cheat = tonumber(cheat)
			if (source == client) and (cheat) then
				if (math.floor(cheat) >= 1000) then
					exports['roleplay-accounts']:outputAdminLog("WARNING! Vehicle speed is affected! <1000 km/h is expected, but returned " .. math.floor(cheat) .. " km/h by " .. getPlayerName(client) .. ". Please verify.", 5)
					outputServerLog("Anti-cheat: " .. getPlayerName(client) .. " is most likely cheating - vehicle speed is equal to or more than 1000 km/h; speed = " .. math.floor(speed) .. ".")
				end
			else
				exports['roleplay-accounts']:outputAdminLog("WARNING! Anti-cheat system is being fooled by " .. getPlayerName(client) .. "! AC returned '" .. tostring(cheat) .. "'. Please verify.", 5)
				outputServerLog("Anti-cheat: We're being fooled by " .. getPlayerName(client) .. ". Vehicle speed value is invalid '" .. tostring(cheat) .. "'.")
			end
		else
			exports['roleplay-accounts']:outputAdminLog("WARNING! Anti-cheat system is being fooled by " .. getPlayerName(client) .. "! AC returned '" .. tostring(ret) .. "' instead of 0, 1 or 2. Please verify.", 5)
			outputServerLog("Anti-cheat: We're being fooled by " .. getPlayerName(client) .. ". Return value is invalid '" .. tostring(ret) .. "'.")
		end
	end
)

local tostring_ = tostring
local tostring = function(data)
	if (type(data) == "table") then
		local function tabletostring(data)
			local t = {}
			for k, v in pairs(data) do
				if (type(v) == "table") then
					t[k] = tabletostring(v)
				elseif (isElement(v)) then
					if (getElementType(v) == "player") then
						t[k] = getPlayerName(v) .. " [" .. getElementType(v) .. "]"
					else
						t[k] = tostring_(v) .. " [" .. getElementType(v) .. "]"
					end
				else
					t[k] = v
				end
			end
			return t
		end
		return toJSON(tabletostring(data))
	elseif (isElement(data)) and (getElementType(data) == "player") then
		return getPlayerName(data)
	end
	return tostring_(data)
end

addEventHandler("onElementDataChange", root,
	function(name, old)
		if (client) then
			if (name == "superman:flying") then
				if (tostring(getElementData(source, name)) == "true") then
					if (not exports['roleplay-accounts']:isClientModerator(source)) then
						setElementData(source, name, false, true)
						exports['roleplay-accounts']:outputAdminLog("WARNING! " .. (getElementType(source) == "player" and getPlayerName(source) or getElementType(source)) .. " tried to switch element data manually (key: '" .. name .. "', value: '" .. tostring(getElementData(source, name)) .. "', old = '" .. tostring(old) .. "').", 5)
					end
				end
			elseif (name == "roleplay:weather.snowing") or (name == "roleplay:temp.stopvehlocking") or (name == "roleplay:vehicles.currentGear") or (name == "roleplay:vehicles.radio") or (name == "roleplay:temp.sx") or (name == "roleplay:temp.sy") or (name == "roleplay:accounts.option2") or (name == "roleplay:languages.1") or (name == "roleplay:languages.2") or (name == "roleplay:languages.3") or (name == "roleplay:languages.1skill") or (name == "roleplay:languages.2skill") or (name == "roleplay:languages.3skill") then
				return
			elseif (name == "freecam:state") then
				if (not exports['roleplay-accounts']:isClientModerator(source)) then
					removeElementData(source, name)
					exports['roleplay-accounts']:outputAdminLog("WARNING! " .. (getElementType(source) == "player" and getPlayerName(source) or getElementType(source)) .. " tried to switch element data manually (key: '" .. name .. "', value: '" .. tostring(getElementData(source, name)) .. "', old = '" .. tostring(old) .. "').", 5)
				end
			else
				exports['roleplay-accounts']:outputAdminLog("WARNING! " .. (getElementType(source) == "player" and getPlayerName(source) or getElementType(source)) .. " tried to switch element data manually (key: '" .. name .. "', value: '" .. tostring(getElementData(source, name)) .. "', old = '" .. tostring(old) .. "').", 5)
				if (isElement(source)) then
					if (old == nil) then
						removeElementData(source, name)
					else
						setElementData(source, name, old)
					end
				end
			end
		end
	end
)

addEventHandler("onVehicleStartEnter", root,
	function(player, seat, jacked, door)
		if (seat == 0) and (jacked) then
			if (exports['roleplay-vehicles']:getVehicleOwner(source) ~= exports['roleplay-accounts']:getCharacterID(player)) and (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
				cancelEvent()
				outputDebugString("AC: Prevented " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] from entering, possible ninjajack.")
			elseif (exports['roleplay-accounts']:isClientTrialAdmin(player)) and (exports['roleplay-accounts']:getAdminState(player) ~= 1) then
				cancelEvent()
				outputDebugString("AC: Prevented " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] from entering, possible ninjajack.")
			end
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		setPlayerName(source, playerNamePrefix .. "." .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9))
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			if (not exports['roleplay-accounts']:isClientLoggedIn(v)) then
				setPlayerName(source, playerNamePrefix .. "." .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9) .. math.random(0,9))
			end
		end
	end
)

local commandSpam = {}

addEventHandler("onPlayerCommand", root,
	function(cmd)
		if (cmd == "Animation") then return end
		if (not commandSpam[source]) then
			commandSpam[source] = 1
		elseif (commandSpam[source] >= 4) then
			cancelEvent()
			outputChatBox("Stop spamming the functions or you will be kicked from the server.", source, 255, 0, 0)
			commandSpam[source] = commandSpam[source]+1
		elseif (commandSpam[source] == 9) then
			cancelEvent()
			commandSpam[source] = nil
			kickPlayer(source, "Function spamming is not allowed.")
		else
			commandSpam[source] = commandSpam[source]+1
		end
	end
)
setTimer(function() commandSpam = {} end, 1000, 0)