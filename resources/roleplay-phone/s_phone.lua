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
addEventHandler("onResourceStop", root,
	function(resource)
		if (getResourceName(resource) == "roleplay-inventory") then
			for i,v in ipairs(getElementsByType("player")) do
				triggerClientEvent(v, ":_exitPhoneWindows_:", v, true)
			end
		end
		
		if (resource == getThisResource()) then
			for i,v in ipairs(getElementsByType("player")) do
				if (isPlayerOnPhone(v)) then
					outputChatBox("The phone call got interrupted and lost connection.", v, 245, 20, 20, false)
					removeElementData(v, "roleplay:temp.onphone")
					setPedAnimation(v, "ped", "phone_out", -1, false, false, false, false)
				end
				
				if (isPlayerBeingCalled(v)) then
					outputChatBox("The phone call got interrupted and lost connection.", v, 245, 20, 20, false)
					removeElementData(v, "roleplay:temp.beingcalled")
					setPedAnimation(v, "ped", "phone_out", -1, false, false, false, false)
				end
				
				if (isPlayerCalling(v)) then
					outputChatBox("The phone call got interrupted and lost connection.", v, 245, 20, 20, false)
					removeElementData(v, "roleplay:temp.calling")
					setPedAnimation(v, "ped", "phone_out", -1, false, false, false, false)
				end
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if (isPlayerOnPhone(source)) then
			local target = isPlayerOnPhone(source)
			outputChatBox("The phone call got interrupted and lost connection.", target, 245, 20, 20, false)
			removeElementData(target, "roleplay:temp.onphone")
			setPedAnimation(target, "ped", "phone_out", -1, false, false, false, false)
		end
		
		if (isPlayerBeingCalled(source)) then
			triggerClientEvent(root, ":_stopPlayingRingOnElement_:", root, source)
			local target = isPlayerBeingCalled(source)
			outputChatBox("The phone call got interrupted and lost connection.", target, 245, 20, 20, false)
			removeElementData(target, "roleplay:temp.calling")
			setPedAnimation(target, "ped", "phone_out", -1, false, false, false, false)
		end
		
		if (isPlayerCalling(source)) then
			local target = isPlayerCalling(source)
			outputChatBox("The phone call got interrupted and lost connection.", target, 245, 20, 20, false)
			removeElementData(target, "roleplay:temp.beingcalled")
			setPedAnimation(target, "ped", "phone_out", -1, false, false, false, false)
		end
	end
)

local function displayPhone(number)
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??' AND `??` = '??' AND `??` = '??' LIMIT 1", "inventory", "charID", exports['roleplay-accounts']:getCharacterID(source), "itemID", "10", "value", number)
	if (query) then
		local result, num_affected_rows = dbPoll(query, -1)
		if (num_affected_rows > 0) then
			local query2 = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??'", "contacts", "ownerNumber", number)
			if (query2) then
				local result2, num_affected_rows2 = dbPoll(query2, -1)
				for i,v in pairs(result) do
					triggerClientEvent(source, ":_onDisplayPhoneMenu_:", source, tonumber(number), result2, v["ringtoneID"])
					break
				end
			end
		end
	end
end
addEvent(":_displayPhone_:", true)
addEventHandler(":_displayPhone_:", root, displayPhone)

addEvent(":_updateContactList_:", true)
addEventHandler(":_updateContactList_:", root,
	function(dbEntryID)
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "contacts", "id", tonumber(dbEntryID))
	end
)

addEvent(":_updateRingtone_:", true)
addEventHandler(":_updateRingtone_:", root,
	function(ringtoneID, phoneNumber)
		if (source ~= client) then return end
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??' AND `??` = '??' AND `??` = '??'", "inventory", "ringtoneID", tonumber(ringtoneID), "charID", exports['roleplay-accounts']:getCharacterID(client), "itemID", "10", "value", phoneNumber)
	end
)

addEvent(":_updateMessageTone_:", true)
addEventHandler(":_updateMessageTone_:", root,
	function(messagetoneID, phoneNumber)
		if (source ~= client) then return end
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??' AND `??` = '??' AND `??` = '??'", "inventory", "messagetoneID", tonumber(messagetoneID), "charID", exports['roleplay-accounts']:getCharacterID(client), "itemID", "10", "value", phoneNumber)
	end
)

addEvent(":_addContactList_:", true)
addEventHandler(":_addContactList_:", root,
	function(name, number, phoneNumber)
		if (source ~= client) then return end
		dbExec(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (name, number, ownerNumber) VALUES ('??', '??', '??')", "contacts", tostring(name), tonumber(number), tonumber(phoneNumber))
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??'", "contacts", "ownerNumber", phoneNumber)
		if (query) then
			local result, num_affected_rows = dbPoll(query, -1)
			triggerClientEvent(client, ":_updatePhoneContacts_:", client, tonumber(phoneNumber), result)
		end
	end
)

addEvent(":_cutPhoneCall_:", true)
addEventHandler(":_cutPhoneCall_:", root,
	function(number)
		if (source ~= client) then return end
		local foundItem = false
		
		for i,v in ipairs(getElementsByType("object")) do
			if (getElementModel(v) == 330) and (getElementData(v, "roleplay:worlditems.itemID")) then
				if (tonumber(getElementData(v, "roleplay:worlditems.itemID")) == 10) then
					if (tonumber(getElementData(v, "roleplay:worlditems.value")) == number) then
						foundItem = true
						triggerClientEvent(root, ":_stopPlayingRingOnElement_:", root, item)
						outputChatBox("The phone call has been ended.", client, 210, 160, 25, false)
						setPedAnimation(client, "ped", "phone_out", -1, false, false, false, false)
					
						if (getElementData(client, "roleplay:temp.onphone")) then
							removeElementData(client, "roleplay:temp.onphone")
						end
						
						if (getElementData(client, "roleplay:temp.beingcalled")) then
							removeElementData(client, "roleplay:temp.beingcalled")
						end
						
						if (getElementData(client, "roleplay:temp.calling")) then
							removeElementData(client, "roleplay:temp.calling")
						end
						
						break
					end
				end
			end
		end
		
		if (not foundItem) then
			for i,v in ipairs(getElementsByType("player")) do
				if (exports['roleplay-items']:hasItem(v, 10, tostring(number))) then
					foundItem = true
					triggerClientEvent(root, ":_stopPlayingRingOnElement_:", root, v)
					outputChatBox("The phone call has been ended.", client, 210, 160, 25, false)
					outputChatBox("The phone call has been ended.", v, 210, 160, 25, false)
					setPedAnimation(client, "ped", "phone_out", -1, false, false, false, false)
					setPedAnimation(v, "ped", "phone_out", -1, false, false, false, false)
					
					if (getElementData(v, "roleplay:temp.onphone")) then
						removeElementData(v, "roleplay:temp.onphone")
					end
					
					if (getElementData(v, "roleplay:temp.beingcalled")) then
						removeElementData(v, "roleplay:temp.beingcalled")
					end
					
					if (getElementData(v, "roleplay:temp.calling")) then
						removeElementData(v, "roleplay:temp.calling")
					end
					
					if (getElementData(client, "roleplay:temp.onphone")) then
						removeElementData(client, "roleplay:temp.onphone")
					end
					
					if (getElementData(client, "roleplay:temp.beingcalled")) then
						removeElementData(client, "roleplay:temp.beingcalled")
					end
					
					if (getElementData(client, "roleplay:temp.calling")) then
						removeElementData(client, "roleplay:temp.calling")
					end
					
					break
				end
			end
		end
		
		if (isTimer(notPickedUpTimer[client])) then
			killTimer(notPickedUpTimer[client])
		end
		
		if (isTimer(callingTimer[client])) then
			killTimer(callingTimer[client])
		end
		
		if (not foundItem) then
			outputChatBox("Wat.", client, 245, 20, 20, false)
		end
	end
)

addEvent(":_cutPhoneSMS_:", true)
addEventHandler(":_cutPhoneSMS_:", root,
	function(number)
		if (source ~= client) then return end
		local foundItem = false
		
		if (not foundItem) then
			for i,v in ipairs(getElementsByType("player")) do
				if (exports['roleplay-items']:hasItem(v, 10, tostring(number))) then
					foundItem = true
					outputChatBox("The text message deliver has now been cancelled.", client, 210, 160, 25, false)
					break
				end
			end
		end
		
		if (isTimer(sendingTimer[client])) then
			killTimer(sendingTimer[client])
		end
		
		if (not foundItem) then
			outputChatBox("Wat.", client, 245, 20, 20, false)
		end
	end
)

notPickedUpTimer = {}
callingTimer = {}

addEvent(":_usePhoneToCall_:", true)
addEventHandler(":_usePhoneToCall_:", root,
	function(number, callerNumber)
		if (source ~= client) then return end
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??' AND `??` = '??' LIMIT 1", "inventory", "itemID", "10", "value", number)
		if (query) then
			local result, num_affected_rows = dbPoll(query, -1)
			setPedAnimation(client, "ped", "phone_in", -1, false, false, false, true)
			if (num_affected_rows > 0) then
				triggerClientEvent(client, ":_setPhoneWindowText_:", client, 1)
				
				local foundItem = false
				
				for i,v in ipairs(getElementsByType("object")) do
					if (getElementModel(v) == 330) and (getElementData(v, "roleplay:worlditems.itemID")) then
						if (tonumber(getElementData(v, "roleplay:worlditems.itemID")) == 10) then
							if (getElementData(v, "roleplay:worlditems.value") == number) then
								foundItem = true
								for _,row in pairs(result) do
									callingTimer[client] = setTimer(function(item, caller, ringtone)
										if (not isElement(player)) or (not isElement(caller)) then return end
										triggerClientEvent(root, ":_startPlayingRingOnElement_:", root, item, ringtone)
										setElementData(caller, "roleplay:temp.calling", item, false)
									end, 3000, 1, v, client, row["ringtoneID"])
									break
								end
								break
							end
						end
					end
				end
				
				if (not foundItem) then
					for i,v in ipairs(getElementsByType("player")) do
						if (exports['roleplay-items']:hasItem(v, 10, number)) then
							if (not isPlayerOnPhone(v)) or (not isPlayerBeingCalled(v)) or (not isPlayerCalling(v)) then
								foundItem = true
								for _,row in pairs(result) do
									callingTimer[client] = setTimer(function(player, caller, ringtone, callerNumber)
										if (not isElement(player)) or (not isElement(caller)) then return end
										triggerClientEvent(root, ":_startPlayingRingOnElement_:", root, player, ringtone)
										outputChatBox(" " .. callerNumber .. " is calling your phone " .. number .. ". Pick up the call by typing /answer.", player, 210, 160, 25, false)
										setElementData(player, "roleplay:temp.beingcalled", caller, false)
										setElementData(player, "roleplay:temp.mynumber", number, false)
										setElementData(caller, "roleplay:temp.calling", player, false)
										setElementData(caller, "roleplay:temp.mynumber", callerNumber, false)
									end, 3000, 1, v, client, row["ringtoneID"], callerNumber)
								end
							else
								outputChatBox("The number you have dialed is currently unavailable.", client, 245, 20, 20, false)
								triggerClientEvent(client, ":_setPhoneWindowText_:", client, 2)
								setPedAnimation(client, "ped", "phone_out", -1, false, false, false, false)
							end
							break
						end
					end
				end
				
				notPickedUpTimer[client] = setTimer(function(caller)
					if (not isElement(caller)) then return end
					if (not isPlayerOnPhone(caller)) then
						triggerClientEvent(caller, ":_setPhoneWindowText_:", caller, 2)
						outputChatBox("The number you have dialed is not picking up.", client, 245, 20, 20, false)
						setPedAnimation(caller, "ped", "phone_out", -1, false, false, false, false)
						removeElementData(isPlayerCalling(caller), "roleplay:temp.beingcalled")
						removeElementData(caller, "roleplay:temp.calling")
						removeElementData(caller, "roleplay:temp.mynumber")
					end
				end, 28000, 1, client)
			else
				triggerClientEvent(client, ":_setPhoneWindowText_:", client, 1)
				if (number == "911") then
					callingTimer[client] = setTimer(function(player)
						outputChatBox("cool, 911 is responding jajajajajaja.", player, 20, 245, 20, false)
						triggerClientEvent(player, ":_setPhoneWindowText_:", player, 2)
					end, 2000, 1, client)
				else
					exports['roleplay-chat']:outputLocalActionMe(client, "taps some buttons on " .. exports['roleplay-accounts']:getCharacterRealGender(client, 1) .. " phone and takes the phone over to " .. exports['roleplay-accounts']:getCharacterRealGender(client, 1) .. " ear.")
					callingTimer[client] = setTimer(function(player)
						if (not isElement(player)) then return end
						outputChatBox("The number you have dialed is not in use.", player, 245, 20, 20, false)
						triggerClientEvent(player, ":_setPhoneWindowText_:", player, 2)
						setPedAnimation(player, "ped", "phone_out", -1, false, false, false, false)
					end, 3000, 1, client)
				end
			end
		end
	end
)

messageTimers = {}
sendingTimer = {}

addEvent(":_usePhoneToText_:", true)
addEventHandler(":_usePhoneToText_:", root,
	function(number, message, callerNumber)
		if (source ~= client) then return end
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??` WHERE `??` = '??' AND `??` = '??' LIMIT 1", "inventory", "itemID", "10", "value", number)
		if (query) then
			local result, num_affected_rows = dbPoll(query, -1)
			exports['roleplay-chat']:outputLocalActionMe(client, "taps some buttons on " .. exports['roleplay-accounts']:getCharacterRealGender(client, 1) .. " phone.")
			triggerClientEvent(client, ":_setPhoneSMSWindowText_:", client, 1)
			
			if (num_affected_rows > 0) then
				local foundItem = false
				
				if (not foundItem) then
					local query2 = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `name` FROM `??` WHERE `??` = '??' AND `??` = '??' LIMIT 1", "contacts", "number", callerNumber, "ownerNumber", number)
					local result2, num_affected_rows2 = dbPoll(query2, -1)
					for i,v in ipairs(getElementsByType("player")) do
						if (exports['roleplay-items']:hasItem(v, 10, number)) then
							foundItem = true
							if (num_affected_rows2 > 0) then
								for _,row1 in pairs(result) do
									for _,row in pairs(result2) do
										sendingTimer[client] = setTimer(function(player, caller, message, callerNumber, contactName, messageToneID)
											if (not isElement(player)) or (not isElement(caller)) then return end
											local hour, minute = getTime()
											outputChatBox(" [" .. (string.len(hour) == 1 and "0" .. hour or hour) .. ":" .. (string.len(minute) == 1 and "0" .. minute or minute) .. "] Text message from " .. contactName .. " (" .. callerNumber .. ")" .. ": " .. message, player, 210, 160, 25, false)
											outputChatBox("Text message delivered to the number successfully.", caller, 20, 245, 20, false)
											triggerClientEvent(caller, ":_setPhoneSMSWindowText_:", caller, 2)
											triggerClientEvent(root, ":_startPlayingMsgOnElement_:", root, player, messageToneID)
										end, 3000, 1, v, client, message, callerNumber, row["name"], row1["messagetoneID"])
									end
								end
							else
								for _,row in pairs(result) do
									sendingTimer[client] = setTimer(function(player, caller, message, callerNumber, messageToneID)
										if (not isElement(player)) or (not isElement(caller)) then return end
										local hour, minute = getTime()
										outputChatBox(" [" .. (string.len(hour) == 1 and "0" .. hour or hour) .. ":" .. (string.len(minute) == 1 and "0" .. minute or minute) .. "] Text message from " .. callerNumber .. ": " .. message, player, 210, 160, 25, false)
										outputChatBox("Text message delivered to the number successfully.", caller, 20, 245, 20, false)
										triggerClientEvent(root, ":_startPlayingMsgOnElement_:", root, player, messageToneID)
										triggerClientEvent(caller, ":_setPhoneSMSWindowText_:", caller, 2)
									end, 3000, 1, v, client, message, callerNumber, row["messagetoneID"])
								end
							end
							break
						end
					end
				end
				
				if (not foundItem) then
					messageTimers[client] = setTimer(function(player)
						if (not isElement(player)) then return end
						triggerClientEvent(player, ":_setPhoneSMSWindowText_:", player, 2)
						outputChatBox("It seems the message could not be sent to the number.", player, 245, 20, 20, false)
					end, 3000, 1, client)
				end
			else
				if (number == "911") then
					sendingTimer[client] = setTimer(function(player)
						outputChatBox("cool, 911 is responding jajajajajaja.", player, 20, 245, 20, false)
						triggerClientEvent(player, ":_setPhoneSMSWindowText_:", player, 2)
					end, 2000, 1, client)
				else
					sendingTimer[client] = setTimer(function(player)
						if (not isElement(player)) then return end
						outputChatBox("The number you tried to text to is not in use.", player, 245, 20, 20, false)
						triggerClientEvent(player, ":_setPhoneSMSWindowText_:", player, 2)
					end, 3000, 1, client)
				end
			end
		end
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

addCommandHandler({"answer", "ap", "pickup"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (isPlayerOnPhone(player)) then
			outputChatBox("You're already on phone.", player, 245, 20, 20, false)
		else
			if (isPlayerBeingCalled(player)) then
				setElementData(player, "roleplay:temp.onphone", isPlayerBeingCalled(player), false)
				setElementData(isPlayerBeingCalled(player), "roleplay:temp.onphone", player, false)
				outputChatBox("You picked up the call.", player, 210, 160, 25, false)
				outputChatBox("They picked up the call.", isPlayerBeingCalled(player), 210, 160, 25, false)
				triggerClientEvent(root, ":_stopPlayingRingOnElement_:", root, player)
				triggerClientEvent(isPlayerBeingCalled(player), ":_setPhoneWindowText_:", isPlayerBeingCalled(player), 3)
				setPedAnimation(isPlayerOnPhone(player), "ped", "phone_talk", -1, false, false, false, true)
				setPedAnimation(player, "ped", "phone_in", -1, false, false, false, true)
				if (isTimer(notPickedUpTimer[isPlayerBeingCalled(player)])) then
					killTimer(notPickedUpTimer[isPlayerBeingCalled(player)])
				end
				removeElementData(player, "roleplay:temp.beingcalled")
			else
				outputChatBox("You're not being called by anyone.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"hangup", "endcall", "ec"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (not isPlayerOnPhone(player)) then
			outputChatBox("You're not on the phone.", player, 245, 20, 20, false)
		else
			outputChatBox("You hung up the call.", player, 210, 160, 25, false)
			outputChatBox("They hung up the call.", isPlayerOnPhone(player), 210, 160, 25, false)
			triggerClientEvent(isPlayerOnPhone(player), ":_setPhoneWindowText_:", isPlayerOnPhone(player), 2)
			triggerClientEvent(player, ":_setPhoneWindowText_:", player, 2)
			setPedAnimation(isPlayerOnPhone(player), "ped", "phone_out", -1, false, false, false, false)
			setPedAnimation(player, "ped", "phone_out", -1, false, false, false, false)
			removeElementData(isPlayerOnPhone(player), "roleplay:temp.onphone")
			removeElementData(player, "roleplay:temp.onphone")
		end
	end
)
