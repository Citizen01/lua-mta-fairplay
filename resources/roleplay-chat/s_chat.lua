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

local bike = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true, [536]=true, [575]=true, [567]=true, [480]=true, [555]=true}
local windowless = {[568]=true, [601]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [528]=true, [530]=true, [531]=true, [532]=true, [571]=true, [572]=true}
local roofless = {[568]=true, [500]=true, [439]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [530]=true, [531]=true, [533]=true, [536]=true, [555]=true, [571]=true, [572]=true, [575]=true}

MTAoutputChatBox = outputChatBox
function outputChatBox(text, visibleTo, r, g, b, colorCoded)
	if (string.len(text) > 120) then
		MTAoutputChatBox(string.sub(text, 1, 119), visibleTo, r, g, b, colorCoded)
		outputChatBox(" " .. string.sub(text, 120), visibleTo, r, g, b, colorCoded)
	else
		MTAoutputChatBox(text, visibleTo, r, g, b, colorCoded)
	end
end

function outputLongChatBox(text, visibleTo, r, g, b, colorCoded)
	return outputChatBox(text, visibleTo, r, g, b, colorCoded)
end

function outputLocalChat(player, message, fdistance)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local x, y, z = getElementPosition(player)
	local affected = ""
	local senderLang, senderSkill = getPlayerLanguage(player, 1)
	local theDistance = (tonumber(fdistance) and 20 or 10000)
	local l1, l2 = "", ""
	
	if (tonumber(fdistance)) then
		theDistance = fdistance
	end
	
	for i,v in ipairs(getElementsByType("player")) do
		local px, py, pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
		if (theDistance == 10000) or (distance < theDistance and getElementInterior(v) == getElementInterior(player) and getElementDimension(v) == getElementDimension(player)) then
			local r, g, b = 240, 240, 240
			local senderLang, senderSkill = getPlayerLanguage(player, 1)
			
			if (distance > 8) then
				r, g, b = r-distance*2, g-distance*2, b-distance*2
			end
			
			-- ok i admit vg, sry, was bored
			local has, slot = hasLanguage(v, getPlayerLanguage(player, 1))
			if (not has) then
				if (player ~= v) then
					local length = string.len(message)
					local percent = 100-math.min(getPlayerLanguageSkill(v, senderLang), senderSkill)
					local replace = (percent/100)*length
					
					if (senderLang == 101) then
						message = md5(message)
					else
						local i = 1
						while(i < replace) do
							local char = string.sub(message, i, i)
							if (char ~= "") and (char ~= " ") then
								local replacechar
								
								if (string.byte(char) >= 65 and string.byte(char) <= 90) then
									replacechar = string.char(math.random(65, 90))
								elseif (string.byte(char) >= 97 and string.byte(char) <= 122) then
									replacechar = string.char(math.random(97, 122))
								end
								
								if (string.byte(char) >= 65 and string.byte(char) <= 90) or (string.byte(char) >= 97 and string.byte(char) <= 122) then
									message = string.gsub(message, tostring(char), replacechar, 1)
								end
							end
							i = i+1
						end
					end
				end
			else
				if (senderSkill < 100) then
					if (senderSkill > getPlayerLanguageSkill(v, senderLang)) or (getPlayerLanguageSkill(v, senderLang) < 85) then
						increaseLanguageSkill(player, senderLang)
					end
				end
			end
			
			local prefix = ""
			
			if (theDistance == 0.9) then
				prefix = "(Close Whisper) "
			elseif (theDistance == 3) then
				prefix = "(Whisper) "
			elseif (theDistance == 40) then
				prefix = "(Shout) "
			elseif (theDistance == 60) then
				prefix = "(Megaphone) "
			end
			
			local vehicle = getPedOccupiedVehicle(player)
			local firstLetter = string.upper(message:sub(1, 1))
			local restMessage = string.gsub(message:sub(2), "  ", " ")
			
			if (theDistance < 60) then
				if (exports['roleplay-vehicles']:isPlayerRealInVehicle(player)) then
					if (exports['roleplay-accounts']:isClientTrialAdmin(v)) and (exports['roleplay-accounts']:getAdminState(v) == 1) then
						triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
						outputLongChatBox(" " .. prefix .. (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle))) .. ") [" .. getLanguageName(senderLang) .. "] " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
						if (affected == "") then
							affected = getPlayerName(v)
						else
							affected = affected .. ";" .. getPlayerName(v)
						end
					else
						if (exports['roleplay-vehicles']:isVehicleWindowsDown(vehicle)) or (bike[getElementModel(vehicle)]) or (windowless[getElementModel(vehicle)]) or (roofless[getElementModel(vehicle)]) then
							triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
							outputLongChatBox(" " .. prefix .. (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle))) .. ") " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
							if (affected == "") then
								affected = getPlayerName(v)
							else
								affected = affected .. ";" .. getPlayerName(v)
							end
						else
							if (getPedOccupiedVehicle(v) and getPedOccupiedVehicle(v) == vehicle) then
								triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
								outputLongChatBox(" " .. prefix .. (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle))) .. ") " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
								if (affected == "") then
									affected = getPlayerName(v)
								else
									affected = affected .. ";" .. getPlayerName(v)
								end
							end
						end
					end
				else
					if (exports['roleplay-vehicles']:isPlayerRealInVehicle(v)) then
						local vehicle = getPedOccupiedVehicle(v)
						if (exports['roleplay-accounts']:isClientTrialAdmin(v)) and (exports['roleplay-accounts']:getAdminState(v) == 1) then
							triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
							outputLongChatBox(" " .. prefix .. (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle))) .. ") [" .. getLanguageName(senderLang) .. "] " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
							if (affected == "") then
								affected = getPlayerName(v)
							else
								affected = affected .. ";" .. getPlayerName(v)
							end
						else
							if (exports['roleplay-vehicles']:isVehicleWindowsDown(vehicle)) or (bike[getElementModel(vehicle)]) or (windowless[getElementModel(vehicle)]) or (roofless[getElementModel(vehicle)]) then
								if (getPedOccupiedVehicle(player) and getPedOccupiedVehicle(player) == vehicle) then
									triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
									outputLongChatBox(" " .. prefix .. (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle))) .. ") " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
									if (affected == "") then
										affected = getPlayerName(v)
									else
										affected = affected .. ";" .. getPlayerName(v)
									end
								else
									triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
									outputLongChatBox(" " .. prefix .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
									if (affected == "") then
										affected = getPlayerName(v)
									else
										affected = affected .. ";" .. getPlayerName(v)
									end
								end
							end
						end
					else
						if (exports['roleplay-accounts']:isClientTrialAdmin(v)) and (exports['roleplay-accounts']:getAdminState(v) == 1) then
							triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
							outputLongChatBox(" " .. prefix .. "[" .. getLanguageName(senderLang) .. "] " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
							if (affected == "") then
								affected = getPlayerName(v)
							else
								affected = affected .. ";" .. getPlayerName(v)
							end
						else
							triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
							outputLongChatBox(" " .. prefix .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, r, g, b, false)
							if (affected == "") then
								affected = getPlayerName(v)
							else
								affected = affected .. ";" .. getPlayerName(v)
							end
						end
					end
				end
			elseif (theDistance == 60) then
				if (exports['roleplay-accounts']:isClientTrialAdmin(v)) and (exports['roleplay-accounts']:getAdminState(v) == 1) then
					triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
					outputLongChatBox(" " .. prefix .. "[" .. getLanguageName(senderLang) .. "] " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, 245, 210, 25, false)
					if (affected == "") then
						affected = getPlayerName(v)
					else
						affected = affected .. ";" .. getPlayerName(v)
					end
				else
					triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
					outputLongChatBox(" " .. prefix .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, 245, 210, 25, false)
					if (affected == "") then
						affected = getPlayerName(v)
					else
						affected = affected .. ";" .. getPlayerName(v)
					end
				end
			else
				if (string.find(fdistance, "r")) then
					local frequency = string.gsub(fdistance, "r", "")
					if (exports['roleplay-items']:hasItem(v, 13, frequency)) or (getDistanceBetweenPoints3D(px, py, pz, x, y, z) <= 20) then
						if (exports['roleplay-accounts']:isClientTrialAdmin(v)) and (exports['roleplay-accounts']:getAdminState(v) == 1) then
							triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
							outputLongChatBox(" [#" .. frequency .. "] [" .. getLanguageName(senderLang) .. "] " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, 75, 75, 200, false)
							if (affected == "") then
								affected = frequency .. ";" .. getPlayerName(v)
							else
								affected = affected .. ";" .. getPlayerName(v)
							end
						else
							triggerClientEvent(v, ":_displayChatBubble_:", v, firstLetter .. restMessage, player)
							outputLongChatBox(" [#" .. frequency .. "] " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " says: " .. firstLetter .. restMessage, v, 75, 75, 200, false)
							if (affected == "") then
								affected = frequency .. ";" .. getPlayerName(v)
							else
								affected = affected .. ";" .. getPlayerName(v)
							end
						end
					end
				end
			end
			
			l1, l2 = firstLetter, restMessage
		end
	end
	
	local vehicle = getPedOccupiedVehicle(player)
	if (theDistance == 20) then
		outputServerLog("Chat (local chat): " .. (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. l1 .. l2 .. "'.")
		exports['roleplay-logging']:insertLog(player, 14, affected, (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. "[" .. getLanguageName(senderLang) .. ":" .. senderSkill .. "] " .. l1 .. l2)
	elseif (theDistance == 3) then
		outputServerLog("Chat (local whisper): " .. (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. l1 .. l2 .. "'.")
		exports['roleplay-logging']:insertLog(player, 26, affected, (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. "[" .. getLanguageName(senderLang) .. ":" .. senderSkill .. "] " .. l1 .. l2)
	elseif (theDistance == 60) then
		outputServerLog("Chat (megaphone): " .. (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. l1 .. l2 .. "'.")
		exports['roleplay-logging']:insertLog(player, 20, affected, (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. "[" .. getLanguageName(senderLang) .. ":" .. senderSkill .. "] " .. l1 .. l2)
	elseif (theDistance == 40) then
		outputServerLog("Chat (local shout): " .. (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. l1 .. l2 .. "'.")
		exports['roleplay-logging']:insertLog(player, 28, affected, (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. "[" .. getLanguageName(senderLang) .. ":" .. senderSkill .. "] " .. l1 .. l2)
	elseif (theDistance == 0.9) then
		outputServerLog("Chat (player whisper): " .. (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. l1 .. l2 .. "'.")
		exports['roleplay-logging']:insertLog(player, 27, affected, (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. "[" .. getLanguageName(senderLang) .. ":" .. senderSkill .. "] " .. l1 .. l2)
	else
		if (string.find(fdistance, "r")) then
			outputServerLog("Chat (radio@" .. string.gsub(fdistance, "r", "") .. "): " .. (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. l1 .. l2 .. "'.")
			exports['roleplay-logging']:insertLog(player, 21, affected, (vehicle and (bike[getElementModel(vehicle)] and "(On Bike" or "(In " .. (getVehicleType(vehicle) == "Automobile" and "Car" or getVehicleType(vehicle)) .. ") ") or "") .. "[" .. getLanguageName(senderLang) .. ":" .. senderSkill .. "] " .. l1 .. l2)
		end
	end
end

local veryIllegalWords = {
	["re-united"] = true,
	["reunited"] = true,
	["ug:rp"] = true,
	["ugrp"] = true,
}

function outputLocalOOCChat(player, message)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local words = split(message, " ")
	if (words) then
		for i,v in pairs(words) do
			if (veryIllegalWords[v:lower()]) then
				outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to local OOC a potential advertisement/threat message! Message skipped.", 3)
				exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
				exports['roleplay-logging']:insertLog(player, 15, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
				return
			end
		end
	end
	
	local x, y, z = getElementPosition(player)
	local affected = ""
	
	for i,v in ipairs(getElementsByType("player")) do
		local px, py, pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
		if (distance < 30 and getElementInterior(v) == getElementInterior(player) and getElementDimension(v) == getElementDimension(player)) then
			outputLongChatBox(" [OOC] (" .. exports['roleplay-accounts']:getClientID(player) .. ") " .. exports['roleplay-accounts']:getRealPlayerName(player) .. ": " .. message:gsub("  ", " "), v, 100, 150, 210, false)
			if (affected == "") then
				affected = getPlayerName(v)
			else
				affected = affected .. ";" .. getPlayerName(v)
			end
		end
	end
	
	outputServerLog("Chat (local ooc chat): " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. message:gsub("  ", " ") .. "'.")
	exports['roleplay-logging']:insertLog(player, 15, affected, message:gsub("  ", " "))
end

function outputLocalWhisper(player, message)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local words = split(message, " ")
	if (words) then
		for i,v in pairs(words) do
			if (veryIllegalWords[v:lower()]) then
				outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to local whisper a potential advertisement/threat message! Message skipped.", 3)
				exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
				exports['roleplay-logging']:insertLog(player, 26, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
				return
			end
		end
	end
	
	outputLocalChat(player, message, 3)
end

function outputPlayerWhisper(player, message)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local words = split(message, " ")
	if (words) then
		for i,v in pairs(words) do
			if (veryIllegalWords[v:lower()]) then
				outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to player whisper a potential advertisement/threat message! Message skipped.", 3)
				exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
				exports['roleplay-logging']:insertLog(player, 27, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
				return
			end
		end
	end
	
	outputLocalChat(player, message, 0.9)
end

function outputLocalShout(player, message)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local words = split(message, " ")
	if (words) then
		for i,v in pairs(words) do
			if (veryIllegalWords[v:lower()]) then
				outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to local shout a potential advertisement/threat message! Message skipped.", 3)
				exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
				exports['roleplay-logging']:insertLog(player, 28, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
				return
			end
		end
	end
	
	outputLocalChat(player, message .. "!", 40)
end

function outputMegaphone(player, message)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	if (exports['roleplay-items']:hasItem(player, 14)) then
		local words = split(message, " ")
		if (words) then
			for i,v in pairs(words) do
				if (veryIllegalWords[v:lower()]) then
					outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to local megaphone a potential advertisement/threat message! Message skipped.", 3)
					exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
					exports['roleplay-logging']:insertLog(player, 20, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
					return
				end
			end
		end
		
		outputLocalChat(player, message, 60)
	end
end

function outputRadio(player, message)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	if (exports['roleplay-items']:hasItem(player, 13)) then
		local words = split(message, " ")
		if (words) then
			for i,v in pairs(words) do
				if (veryIllegalWords[v:lower()]) then
					outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to radio a potential advertisement/threat message! Message skipped.", 3)
					exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
					exports['roleplay-logging']:insertLog(player, 21, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
					return
				end
			end
		end
		
		local frequency = exports['roleplay-items']:getPlayerItemValue(player, 13)
		outputLocalChat(player, message, "r" .. frequency)
	end
end

function outputGlobalOOCChat(player, message, hidden)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local affected = ""
	
	for i,v in ipairs(getElementsByType("player")) do
		if (not exports['roleplay-accounts']:isOOCMuted(v)) then
			local words = split(message, " ")
			if (words) then
				for i,v in pairs(words) do
					if (veryIllegalWords[v:lower()]) then
						outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
						exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to global OOC a potential advertisement/threat message! Message skipped.", 3)
						exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
						exports['roleplay-logging']:insertLog(player, 16, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
						return
					end
				end
			end
			
			if (not hidden) or (hidden and exports['roleplay-accounts']:isClientTrialAdmin(v)) then
				outputLongChatBox(" [GOOC] (" .. exports['roleplay-accounts']:getClientID(player) .. ") " .. exports['roleplay-accounts']:getRealPlayerName(player) .. "" .. (hidden and " (Hidden)" or "") .. ": " .. message:gsub("  ", " "), v, 227, 174, 30, false)
			elseif (hidden) then
				outputLongChatBox(" [GOOC] Hidden Admin: " .. message:gsub("  ", " "), v, 227, 174, 30, false)
			end
			
			if (affected == "") then
				affected = getPlayerName(v)
			else
				affected = affected .. ";" .. getPlayerName(v)
			end
		end
	end
	
	outputServerLog("Chat (global ooc chat): " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. message:gsub("  ", " ") .. "'.")
	exports['roleplay-logging']:insertLog(player, 16, affected, message:gsub("  ", " "))
end

function outputLocalActionMe(player, action)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local words = split(action, " ")
	if (words) then
		for i,v in pairs(words) do
			if (veryIllegalWords[v:lower()]) then
				outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to local /me a potential advertisement/threat message! Message skipped.", 3)
				exports['roleplay-accounts']:outputAdminLog("Message: " .. action, 3)
				exports['roleplay-logging']:insertLog(player, 17, getPlayerName(player), "SKIPPED!: " .. action:gsub("  ", " "))
				return
			end
		end
	end
	
	local x, y, z = getElementPosition(player)
	local affected = ""
	
	for i,v in ipairs(getElementsByType("player")) do
		local px, py, pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
		if (distance < 30 and getElementInterior(player) == getElementInterior(v) and getElementDimension(player) == getElementDimension(v)) then
			outputLongChatBox(" *" .. exports['roleplay-accounts']:getRealPlayerName(player) .. " " .. action:gsub("  ", " "), v, 237, 116, 136, false)
			if (affected == "") then
				affected = getPlayerName(v)
			else
				affected = affected .. ";" .. getPlayerName(v)
			end
		end
	end
	
	outputServerLog("Chat (local me): " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. action:gsub("  ", " ") .. "'.")
	exports['roleplay-logging']:insertLog(player, 17, affected, action:gsub("  ", " "))
end

function outputLocalActionDo(player, action)
	if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
	local words = split(action, " ")
	if (words) then
		for i,v in pairs(words) do
			if (veryIllegalWords[v:lower()]) then
				outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to local /do a potential advertisement/threat message! Message skipped.", 3)
				exports['roleplay-accounts']:outputAdminLog("Message: " .. action, 3)
				exports['roleplay-logging']:insertLog(player, 18, getPlayerName(player), "SKIPPED!: " .. action:gsub("  ", " "))
				return
			end
		end
	end
	
	local x, y, z = getElementPosition(player)
	local affected = ""
	
	for i,v in ipairs(getElementsByType("player")) do
		local px, py, pz = getElementPosition(v)
		local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
		if (distance < 30 and getElementInterior(player) == getElementInterior(v) and getElementDimension(player) == getElementDimension(v)) then
			outputLongChatBox(" * " .. action:gsub("  ", " ") .. " *  (( " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " ))", v, 237, 116, 136, false)
			if (affected == "") then
				affected = getPlayerName(v)
			else
				affected = affected .. ";" .. getPlayerName(v)
			end
		end
	end
	
	outputServerLog("Chat (local do): " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. action:gsub("  ", " ") .. "'.")
	exports['roleplay-logging']:insertLog(player, 18, affected, action:gsub("  ", " "))
end

addEventHandler("onPlayerChat", root,
	function(message, type)
		cancelEvent()
		if (not exports['roleplay-accounts']:isClientPlaying(source)) then return end
		if (not isPedDead(source)) then
			if (type == 0) then
				outputLocalChat(source, message, 20)
			elseif (type == 1) then
				outputLocalActionMe(source, message)
			end
		end
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		for _,player in ipairs(getElementsByType("player")) do
			bindKey(player, "b", "down", "chatbox", "LocalOOC")
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for _,player in ipairs(getElementsByType("player")) do
			unbindKey(player, "b", "down", "chatbox", "LocalOOC")
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		bindKey(source, "b", "down", "chatbox", "LocalOOC")
	end
)

-- Commands
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

addCommandHandler({"p", "ptalk", "talkphone", "phonetalk", "phone"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not exports['roleplay-phone']:isPlayerOnPhone(player)) then
			outputChatBox("You're not on the phone.", player, 245, 20, 20, false)
		else
			if (not ...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [message]", player, 210, 160, 25, false)
			else
				local message_ = table.concat({...}, " ")
				local message = table.concat({...}, " ")
				if (#message > 0) then
					local target = exports['roleplay-phone']:isPlayerOnPhone(player)
					local senderLang, senderSkill = getPlayerLanguage(player, 1)
					local px, py, pz = getElementPosition(target)
					local distance = getDistanceBetweenPoints3D(px, py, pz, getElementPosition(player))
					
					local has, slot = hasLanguage(target, getPlayerLanguage(player, 1))
					if (not has) then
						if (player ~= target) then
							local length = string.len(message)
							local percent = 100-math.min(getPlayerLanguageSkill(target, senderLang), senderSkill)
							local replace = (percent/100)*length
							
							if (senderLang == 101) then
								message = md5(message)
							else
								local i = 1
								while(i < replace) do
									local char = string.sub(message, i, i)
									if (char ~= "") and (char ~= " ") then
										local replacechar
										
										if (string.byte(char) >= 65 and string.byte(char) <= 90) then
											replacechar = string.char(math.random(65, 90))
										elseif (string.byte(char) >= 97 and string.byte(char) <= 122) then
											replacechar = string.char(math.random(97, 122))
										end
										
										if (string.byte(char) >= 65 and string.byte(char) <= 90) or (string.byte(char) >= 97 and string.byte(char) <= 122) then
											message = string.gsub(message, tostring(char), replacechar, 1)
										end
									end
									i = i+1
								end
							end
						end
					else
						if (senderSkill < 100) then
							if (senderSkill > getPlayerLanguageSkill(target, senderLang)) or (getPlayerLanguageSkill(target, senderLang) < 85) then
								increaseLanguageSkill(player, senderLang)
							end
						end
					end
					
					if (exports['roleplay-accounts']:isClientTrialAdmin(target) and exports['roleplay-accounts']:getAdminState(target) == 1) then
						outputChatBox(" [Cellphone] [" .. getLanguageName(senderLang) .. "] " .. getElementData(player, "roleplay:temp.mynumber") .. " ((" .. getPlayerName(player):gsub("_", " ") .. ")) says: " .. message_, exports['roleplay-phone']:isPlayerOnPhone(player))
						outputChatBox(" [Cellphone] [" .. getLanguageName(senderLang) .. "] You: " .. message_, player)
					else
						outputChatBox(" [Cellphone] " .. getElementData(player, "roleplay:temp.mynumber") .. " ((" .. getPlayerName(player):gsub("_", " ") .. ")) says: " .. message, exports['roleplay-phone']:isPlayerOnPhone(player))
						outputChatBox(" [Cellphone] You: " .. message_, player)
					end
					
					outputLocalChat(player, message_, 20)
				else
					outputChatBox("SYNTAX: /" .. cmd .. " [message]", player, 210, 160, 25, false)
				end
			end
		end
	end
)

addCommandHandler({"clear", "clearchat"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		for i=1,50 do
			outputChatBox(" ", player)
		end
	end
)

addCommandHandler({"me", "do"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local action = table.concat({...}, " ")
		if (#action > 0) then
			if (cmd == "me") then
				outputLocalActionMe(player, action)
			elseif (cmd == "do") then
				outputLocalActionDo(player, action)
			end
		end
	end
)

addCommandHandler({"f", "fc", "faction"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local message = table.concat({...}, " ")
		if (#message > 0) then
			if (not isPlayerMuted(player)) then
				if (not exports['roleplay-accounts']:getPlayerFaction(player)) then
					outputChatBox("You're not in a faction.", player, 245, 20, 20, false)
				else
					local affected = ""
					local words = split(message, " ")
					if (words) then
						for i,v in pairs(words) do
							if (veryIllegalWords[v:lower()]) then
								outputChatBox("Your message was skipped because it contained illegal characters.", player, 245, 20, 20, false)
								exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " tried to faction msg a potential advertisement/threat message! Message skipped.", 3)
								exports['roleplay-accounts']:outputAdminLog("Message: " .. message, 3)
								exports['roleplay-logging']:insertLog(player, 23, getPlayerName(player), "SKIPPED!: " .. message:gsub("  ", " "))
								return
							end
						end
					end
					
					for i,v in ipairs(getElementsByType("player")) do
						if (exports['roleplay-accounts']:getPlayerFaction(v)) and (exports['roleplay-accounts']:getPlayerFaction(v) == exports['roleplay-accounts']:getPlayerFaction(player)) then
							outputChatBox(" [Faction] " .. getPlayerName(player):gsub("_", " ") .. ": " .. message, v, 50, 210, 220, false)
							if (affected == "") then
								affected = getPlayerName(v)
							else
								affected = affected .. ";" .. getPlayerName(v)
							end
						end
					end
					
					outputServerLog("Chat (faction chat): " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] '" .. message:gsub("  ", " ") .. "'.")
					exports['roleplay-logging']:insertLog(player, 23, affected, message:gsub("  ", " "))
				end
			else
				outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"b", "looc", "ooc", "LocalOOC"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local message = table.concat({...}, " ")
		if (#message > 0) then
			if (not isPlayerMuted(player)) then
				outputLocalOOCChat(player, message)
			else
				outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"c", "whisper", "cw", "w"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local message = table.concat({...}, " ")
		if (#message > 0) then
			if (not isPlayerMuted(player)) then
				if (cmd == "w") then
					outputPlayerWhisper(player, message)
				else
					outputLocalWhisper(player, message)
				end
			else
				outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"s", "shout"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local message = table.concat({...}, " ")
		if (#message > 0) then
			if (not isPlayerMuted(player)) then
				outputLocalShout(player, message)
			else
				outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"r", "radio", "Radio"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local message = table.concat({...}, " ")
		if (not ...) or (not message) or (#message > 0) then
			if (exports['roleplay-items']:hasItem(player, 13)) then
				if (not isPlayerMuted(player)) then
					outputRadio(player, message)
				else
					outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("You kind of need a radio to use one, right?", player, 245, 20, 20, false)
			end
		else
			outputChatBox("SYNTAX: /" .. cmd .. " <message>", player, 210, 160, 25, false)
		end
	end
)

addCommandHandler({"m", "mega", "megaphone", "mphone"},
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local message = table.concat({...}, " ")
		if (not ...) or (not message) or (#message > 0) then
			if (exports['roleplay-items']:hasItem(player, 14)) then
				if (not isPlayerMuted(player)) then
					outputMegaphone(player, message)
				else
					outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("You kind of need a megaphone to use one, right?", player, 245, 20, 20, false)
			end
		else
			outputChatBox("SYNTAX: /" .. cmd .. " <message>", player, 210, 160, 25, false)
		end
	end
)

addCommandHandler("gooc",
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local message = table.concat({...}, " ")
		if (#message > 0) then
			if (not isPlayerMuted(player)) then
				if (not exports['roleplay-accounts']:isOOCMuted(player)) then
					local isAllowed = tonumber(getElementData(root, "roleplay:global.ooc"))
					if ((isAllowed) and (isAllowed == 1)) or (exports['roleplay-accounts']:isClientTrialAdmin(player)) then
						outputGlobalOOCChat(player, message)
					else
						outputChatBox("The global OOC chat is currently disabled by an Administrator.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("The global OOC chat is currently muted for you, unmute it with /togooc to use it.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler("hgooc",
	function(player, cmd, ...)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then return end
		local message = table.concat({...}, " ")
		if (#message > 0) then
			if (not isPlayerMuted(player)) then
				if (not exports['roleplay-accounts']:isOOCMuted(player)) then
					outputGlobalOOCChat(player, message, true)
				else
					outputChatBox("The global OOC chat is currently muted for you, unmute it with /togooc to use it.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("You are currently muted. Please wait for instructions from an Administrator.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"toggooc", "togooc", "toggleooc", "togglegooc"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		setElementData(player, "roleplay:accounts.option1", (exports['roleplay-accounts']:isOOCMuted(player) and 0 or 1), true)
		outputChatBox("You are now " .. (exports['roleplay-accounts']:isOOCMuted(player) and "muted" or "unmuted") .. " from the global OOC chat.", player, 20, 245, 20, false)
	end
)

addCommandHandler({"atoggooc", "atogooc", "atoggleooc", "atogglegooc"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then return end
		local isAllowed = tonumber(getElementData(root, "roleplay:global.ooc"))
		setElementData(root, "roleplay:global.ooc", ((isAllowed and isAllowed == 1) and 0 or 1))
		exports['roleplay-accounts']:outputAdminLog(getPlayerName(player) .. " " .. (tonumber(getElementData(root, "roleplay:global.ooc")) == 1 and "enabled" or "disabled") .. " the global OOC chat.")
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:isClientPlaying(v)) then
				outputChatBox("An Administrator " .. ((isAllowed and isAllowed == 1) and "disabled" or "enabled") .. " the global OOC chat.", v, 20, 245, 20, false)
			end
		end
	end
)

addCommandHandler({"stoggooc", "stogooc", "stoggleooc", "stogglegooc"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then return end
		local isAllowed = tonumber(getElementData(root, "roleplay:global.ooc"))
		setElementData(root, "roleplay:global.ooc", ((isAllowed and isAllowed == 1) and 0 or 1))
		exports['roleplay-accounts']:outputAdminLog(getPlayerName(player) .. " silently " .. (tonumber(getElementData(root, "roleplay:global.ooc")) == 1 and "enabled" or "disabled") .. " the global OOC chat.")
	end
)

addCommandHandler({"a", "ac", "l", "lc", "h", "hc"},
	function(player, cmd, ...)
		if (cmd == "a" or cmd == "ac") then
			if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then return end
			local message = table.concat({...}, " ")
			if (#message > 0) then
				local affected = ""
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientTrialAdmin(v)) then
						outputChatBox(" [AdminChat] " .. exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. "): " .. message, v, 90, 230, 90, false)
						if (affected == "") then
							affected = getPlayerName(v)
						else
							affected = affected .. ";" .. getPlayerName(v)
						end
					end
				end
				exports['roleplay-logging']:insertLog(player, 13, affected, message:gsub("  ", " "))
			end
		elseif (cmd == "l" or cmd == "lc") then
			if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then return end
			local message = table.concat({...}, " ")
			if (#message > 0) then
				local affected = ""
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientLeadAdmin(v)) then
						outputChatBox(" [LeadChat] " .. exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. "): " .. message, v, 190, 60, 180, false)
						if (affected == "") then
							affected = getPlayerName(v)
						else
							affected = affected .. ";" .. getPlayerName(v)
						end
					end
				end
				exports['roleplay-logging']:insertLog(player, 12, affected, message:gsub("  ", " "))
			end
		elseif (cmd == "h" or cmd == "hc") then
			if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then return end
			local message = table.concat({...}, " ")
			if (#message > 0) then
				local affected = ""
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientHeadAdmin(v)) then
						outputChatBox(" [HeadChat] " .. exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. "): " .. message, v, 209, 214, 69, false)
						if (affected == "") then
							affected = getPlayerName(v)
						else
							affected = affected .. ";" .. getPlayerName(v)
						end
					end
				end
				exports['roleplay-logging']:insertLog(player, 11, affected, message:gsub("  ", " "))
			end
		elseif (cmd == "cl" or cmd == "clc") then
			if (not exports['roleplay-accounts']:isClientLeader(player)) then return end
			local message = table.concat({...}, " ")
			if (#message > 0) then
				local affected = ""
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientLeader(v)) then
						outputChatBox(" [Leader] " .. exports['roleplay-accounts']:getAdminRank(player) .. " " .. exports['roleplay-accounts']:getRealPlayerName(player) .. " (" .. exports['roleplay-accounts']:getAccountName(player) .. "): " .. message, v, 209, 214, 69, false)
						if (affected == "") then
							affected = getPlayerName(v)
						else
							affected = affected .. ";" .. getPlayerName(v)
						end
					end
				end
				exports['roleplay-logging']:insertLog(player, 11, affected, message:gsub("  ", " "))
			end
		end
	end
)
