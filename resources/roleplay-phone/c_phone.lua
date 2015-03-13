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

local sx, sy = guiGetScreenSize()
local phoneNumber = 0
local phoneRingtone = 1
local phoneMessageTone = 1
local contacts = {}

local phoneMenu = {
	window = {},
	button = {}
}

local phoneContacts = {
    window = {},
    button = {},
	edit = {},
    label = {},
    gridlist = {}
}

local phoneCall = {
    window = {},
    button = {},
    edit = {}
}

local phoneSMS = {
    window = {},
    button = {},
    edit = {},
    memo = {}
}

local phoneSettings = {
    window = {},
    button = {},
    gridlist = {},
    label = {}
}

function displayPhoneMenu(number, contacts_, ringtoneID)
	if (isElement(phoneMenu.window[1])) then
		triggerEvent(":_exitPhoneWindows_:", localPlayer, phoneNumber)
		return
	end
	
	phoneNumber = number
	phoneRingtone = ringtoneID
	
	for result,row in pairs(contacts_) do
		table.insert(contacts, {
			["id"] = row["id"],
			["name"] = row["name"],
			["number"] = row["number"]
		})
	end
	
	local hour, minute = getTime()
	phoneMenu.window[1] = guiCreateWindow((sx-169)/2, (sy-179)/2, 169, 179, (string.len(hour) == 1 and "0" .. hour or hour) .. ":" .. (string.len(minute) == 1 and "0" .. minute or minute) .. " (" .. phoneNumber .. ")", false)
	guiWindowSetSizable(phoneMenu.window[1], false)
	guiSetAlpha(phoneMenu.window[1], 1.00)
	
	phoneMenu.button[1] = guiCreateButton(10, 24, 148, 25, "Browse Contacts", false, phoneMenu.window[1])
	guiSetFont(phoneMenu.button[1], "default-bold-small")
	
	phoneMenu.button[2] = guiCreateButton(10, 54, 148, 25, "Call a Number", false, phoneMenu.window[1])
	guiSetFont(phoneMenu.button[2], "default-bold-small")
	
	phoneMenu.button[3] = guiCreateButton(10, 85, 148, 25, "Send a Message", false, phoneMenu.window[1])
	guiSetFont(phoneMenu.button[3], "default-bold-small")
	
	phoneMenu.button[4] = guiCreateButton(10, 115, 148, 25, "Settings", false, phoneMenu.window[1])
	guiSetFont(phoneMenu.button[4], "default-bold-small")
	
	phoneMenu.button[5] = guiCreateButton(10, 146, 148, 25, "Exit", false, phoneMenu.window[1])
	guiSetFont(phoneMenu.button[5], "default-bold-small")
	
	addEventHandler("onClientGUIClick", phoneMenu.button[1], displayPhoneContacts, false)
	addEventHandler("onClientGUIClick", phoneMenu.button[2], displayPhoneCall, false)
	addEventHandler("onClientGUIClick", phoneMenu.button[3], displayPhoneSMS, false)
	addEventHandler("onClientGUIClick", phoneMenu.button[4], displayPhoneSettings, false)
	addEventHandler("onClientGUIClick", phoneMenu.button[5], displayPhoneMenu, false)
	
	checkTimeTimer = setTimer(function()
		if (not isElement(phoneMenu.window[1])) then killTimer(checkTimeTimer) return end
		guiSetText(phoneMenu.window[1], (string.len(hour) == 1 and "0" .. hour or hour) .. ":" .. (string.len(minute) == 1 and "0" .. minute or minute) .. " (" .. phoneNumber .. ")")
	end, 5000, 0)
end
addEvent(":_onDisplayPhoneMenu_:", true)
addEventHandler(":_onDisplayPhoneMenu_:", root, displayPhoneMenu)

function displayPhoneContacts()
	if (isElement(phoneContacts.window[1])) then
		destroyElement(phoneContacts.window[1])
		guiSetEnabled(phoneMenu.window[1], true)
		showCursor(false, false)
		return
	end
	
	guiSetEnabled(phoneMenu.window[1], false)
	
	phoneContacts.window[1] = guiCreateWindow((sx-336)/2, (sy-382)/2, 336, 382, "Browse Contacts", false)
	guiWindowSetSizable(phoneContacts.window[1], false)
	guiSetAlpha(phoneContacts.window[1], 1.00)
	
	-- Contact gridlist
	phoneContacts.gridlist[1] = guiCreateGridList(9, 24, 318, 167, false, phoneContacts.window[1])
	local g_name = guiGridListAddColumn(phoneContacts.gridlist[1], "Name", 0.4)
	guiGridListSetColumnWidth(phoneContacts.gridlist[1], g_name, 0.6, true)
	
	local g_number = guiGridListAddColumn(phoneContacts.gridlist[1], "Number", 0.4)
	guiGridListSetColumnWidth(phoneContacts.gridlist[1], g_number, 0.3, true)
	
	for i,v in ipairs(contacts) do
		local row = guiGridListAddRow(phoneContacts.gridlist[1])
		guiGridListSetItemText(phoneContacts.gridlist[1], row, g_name, contacts[i]["name"], false, false)
		guiGridListSetItemText(phoneContacts.gridlist[1], row, g_number, contacts[i]["number"], false, true)
	end
	
	-- Call button
	phoneContacts.button[1] = guiCreateButton(9, 196, 154, 28, "Call", false, phoneContacts.window[1])
	guiSetFont(phoneContacts.button[1], "default-bold-small")
	
	-- Send button
	phoneContacts.button[2] = guiCreateButton(176, 196, 151, 28, "Send SMS", false, phoneContacts.window[1])
	guiSetFont(phoneContacts.button[2], "default-bold-small")
	
	-- Remove button
	phoneContacts.button[3] = guiCreateButton(9, 229, 318, 28, "Remove from Contacts", false, phoneContacts.window[1])
	guiSetFont(phoneContacts.button[3], "default-bold-small")
	
	-- Name
	phoneContacts.label[1] = guiCreateLabel(9, 265, 154, 17, "Name:", false, phoneContacts.window[1])
	guiSetFont(phoneContacts.label[1], "default-bold-small")
	phoneContacts.edit[1] = guiCreateEdit(9, 282, 154, 25, "", false, phoneContacts.window[1])
	
	-- Number
	phoneContacts.label[2] = guiCreateLabel(173, 265, 154, 17, "Number:", false, phoneContacts.window[1])
	guiSetFont(phoneContacts.label[2], "default-bold-small")
	phoneContacts.edit[2] = guiCreateEdit(173, 282, 154, 25, "", false, phoneContacts.window[1])
	
	-- Add button
	phoneContacts.button[4] = guiCreateButton(9, 313, 318, 28, "Add to Contacts", false, phoneContacts.window[1])
	guiSetFont(phoneContacts.button[4], "default-bold-small")
	
	-- Exit button
	phoneContacts.button[5] = guiCreateButton(9, 345, 318, 28, "Exit Window", false, phoneContacts.window[1])
	guiSetFont(phoneContacts.button[5], "default-bold-small")
	
	addEventHandler("onClientGUIClick", phoneContacts.button[1],
		function()
			local row, column = guiGridListGetSelectedItem(phoneContacts.gridlist[1])
			if (row ~= -1) and (column ~= -1) then
				local number = guiGridListGetItemText(phoneContacts.gridlist[1], row, 2)
				displayPhoneContacts()
				displayPhoneCall(number)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneContacts.button[2],
		function()
			local row, column = guiGridListGetSelectedItem(phoneContacts.gridlist[1])
			if (row ~= -1) and (column ~= -1) then
				local number = guiGridListGetItemText(phoneContacts.gridlist[1], row, 2)
				displayPhoneContacts()
				displayPhoneSMS(number)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneContacts.button[3],
		function()
			local row, column = guiGridListGetSelectedItem(phoneContacts.gridlist[1])
			if (row ~= -1) and (column ~= -1) then
				local number = guiGridListGetItemText(phoneContacts.gridlist[1], row, 2)
				guiGridListRemoveRow(phoneContacts.gridlist[1], row)
				for i,v in ipairs(contacts) do
					if (contacts[i]["number"] == number) then
						triggerServerEvent(":_updateContactList_:", localPlayer, contacts[i]["id"])
						contacts[i] = nil
						break
					end
				end
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneContacts.button[4],
		function()
			local name = guiGetText(phoneContacts.edit[1])
			local number = guiGetText(phoneContacts.edit[2])
			if (string.len(name) >= 3) and (string.len(name) <= 30) then
				if (string.len(number) >= 3) and (string.len(number) <= 8) then
					if (tonumber(number)) then
						triggerServerEvent(":_addContactList_:", localPlayer, name, number, phoneNumber)
						local newRow = guiGridListAddRow(phoneContacts.gridlist[1])
						guiGridListSetItemText(phoneContacts.gridlist[1], newRow, 1, tostring(name), false, false)
						guiGridListSetItemText(phoneContacts.gridlist[1], newRow, 2, phoneNumber, false, true)
						guiSetText(phoneContacts.edit[1], "")
						guiSetText(phoneContacts.edit[2], "")
					else
						outputChatBox("That's not a phone number, you know?", 245, 20, 20, false)
					end
				else
					outputChatBox("The number you entered is too short or too long. Minimum of 3 and maximum or 8 numbers allowed.", 245, 20, 20, false)
				end
			else
				outputChatBox("The name you entered is too short or too long. Minimum of 3 and maximum or 30 characters allowed.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneContacts.button[5], displayPhoneContacts, false)
	
	showCursor(true, true)
end

function displayPhoneCall(customNumber)
	if (isElement(phoneCall.window[1])) then
		destroyElement(phoneCall.window[1])
		guiSetEnabled(phoneMenu.window[1], true)
		showCursor(false, false)
		return
	end
	
	guiSetEnabled(phoneMenu.window[1], false)
	
	phoneCall.window[1] = guiCreateWindow((sx-223)/2, (sy-99)/2, 223, 99, "Call a Number", false)
	guiWindowSetSizable(phoneCall.window[1], false)
	guiSetAlpha(phoneCall.window[1], 1.00)
	
	-- Number
	phoneCall.edit[1] = guiCreateEdit(10, 27, 203, 29, (tonumber(customNumber) and tostring(customNumber) or ""), false, phoneCall.window[1])
	
	-- Call button
	phoneCall.button[1] = guiCreateButton(10, 62, 95, 27, "Call", false, phoneCall.window[1])
	guiSetFont(phoneCall.button[1], "default-bold-small")
	
	-- Exit button
	phoneCall.button[2] = guiCreateButton(118, 62, 95, 27, "Exit", false, phoneCall.window[1])
	guiSetFont(phoneCall.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", phoneCall.button[1],
		function()
			local number = guiGetText(phoneCall.edit[1])
			
			if (number) and (string.find(number, "[0-9]")) then
				if (number ~= phoneNumber) then
					if (string.len(number) >= 3) then
						triggerServerEvent(":_usePhoneToCall_:", localPlayer, number, phoneNumber)
					else
						outputChatBox("The number is too short. A minimum number count of 3 is required.", 245, 20, 20, false)
					end
				else
					outputChatBox("You can't call yourself, you know.", 245, 20, 20, false)
				end
			else
				outputChatBox("You can only call to a number.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneCall.button[2],
		function()
			local number = guiGetText(phoneCall.edit[1])
			if (number) and (string.find(number, "[0-9]")) and (guiGetText(phoneCall.button[2]) ~= "Exit") then
				triggerServerEvent(":_cutPhoneCall_:", localPlayer, number)
				triggerEvent(":_setPhoneWindowText_:", localPlayer, 2)
			elseif (guiGetText(phoneCall.button[2]) == "Exit") then
				displayPhoneCall()
			else
				outputChatBox("You can only cut the phone call if the phone number is a valid number.", 245, 20, 20, false)
			end
		end, false
	)
	
	showCursor(true, true)
end

function displayPhoneSMS(customNumber, customText)
	if (isElement(phoneSMS.window[1])) then
		destroyElement(phoneSMS.window[1])
		guiSetEnabled(phoneMenu.window[1], true)
		showCursor(false, false)
		return
	end
	
	guiSetEnabled(phoneMenu.window[1], false)
	
	phoneSMS.window[1] = guiCreateWindow((sx-192)/2, (sy-262)/2, 192, 262, "Send a Message", false)
	guiWindowSetSizable(phoneSMS.window[1], false)
	guiSetAlpha(phoneSMS.window[1], 1.00)
	
	-- Number
	phoneSMS.edit[1] = guiCreateEdit(10, 27, 172, 34, (tonumber(customNumber) and tostring(customNumber) or ""), false, phoneSMS.window[1])
	
	-- Text
	phoneSMS.memo[1] = guiCreateMemo(10, 67, 173, 115, ((customText and (customText ~= "up" and customText ~= "down")) and tostring(customText) or ""), false, phoneSMS.window[1])
	
	-- Submit button
	phoneSMS.button[1] = guiCreateButton(9, 187, 174, 29, "Submit Message", false, phoneSMS.window[1])
	guiSetFont(phoneSMS.button[1], "default-bold-small")
	
	-- Exit button
	phoneSMS.button[2] = guiCreateButton(9, 222, 174, 29, "Exit Window", false, phoneSMS.window[1])
	guiSetFont(phoneSMS.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", phoneSMS.button[1],
		function()
			local number = guiGetText(phoneSMS.edit[1])
			local message = guiGetText(phoneSMS.memo[1])
			
			if (number) and (string.find(number, "[0-9]")) then
				if (number ~= tonumber(phoneNumber)) then
					if (string.len(number) >= 3) then
						if (message) and (string.len(message) > 0) then
							triggerServerEvent(":_usePhoneToText_:", localPlayer, number, message, phoneNumber)
						else
							outputChatBox("The message is too short.", 245, 20, 20, false)
						end
					else
						outputChatBox("The number is too short. A minimum number count of 3 is required.", 245, 20, 20, false)
					end
				else
					outputChatBox("You can't text yourself.", 245, 20, 20, false)
				end
			else
				outputChatBox("You can only text to a number.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneSMS.button[2],
		function()
			local number = guiGetText(phoneSMS.edit[1])
			if (number) and (string.find(number, "[0-9]")) and (guiGetText(phoneSMS.button[2]) ~= "Exit Window") then
				triggerServerEvent(":_cutPhoneSMS_:", localPlayer, number)
				triggerEvent(":_setPhoneSMSWindowText_:", localPlayer, 2)
			elseif (guiGetText(phoneSMS.button[2]) == "Exit Window") then
				displayPhoneSMS()
			else
				outputChatBox("You can only cancel the text message if the phone number is a valid number.", 245, 20, 20, false)
			end
		end, false
	)
	
	showCursor(true, true)
end

ringtonePreview = nil
messagetonePreview = nil
ringtoneNames = {"Default", "Silent", "Vibrate", "Water Drops", "Hip Hop", "Old Phone", "Tickling", "Fading", "Bells", "Ping Pong", "Whistle", "Starbells", "Bells 2.0", "Coffee Break", "Get Lucky Remix", "Default 2.0", "Nokia Dub", "Housy", "Hot Whistle", "Dying Battery"}
messageNames = {"Default", "Silent", "Vibrate", "Bright Bell", "Idea", "Car Lock", "Echoing Bell", "Bright Funny Bell", "Whistle", "Quick Message", "Trancy"}

function displayPhoneSettings()
	if (isElement(phoneSettings.window[1])) then
		destroyElement(phoneSettings.window[1])
		guiSetEnabled(phoneMenu.window[1], true)
		return
	end
	
	guiSetEnabled(phoneMenu.window[1], false)
	
	phoneSettings.window[1] = guiCreateWindow((sx-403)/2, (sy-275)/2, 403, 275, "Settings", false)
	guiWindowSetSizable(phoneSettings.window[1], false)
	guiSetAlpha(phoneSettings.window[1], 1.00)
	
	-- Ringtone label
	phoneSettings.label[1] = guiCreateLabel(16, 28, 182, 16, "Ringtone", false, phoneSettings.window[1])
	guiSetFont(phoneSettings.label[1], "default-bold-small")
	
	-- Ringtone gridlist
	phoneSettings.gridlist[1] = guiCreateGridList(11, 55, 187, 108, false, phoneSettings.window[1])
	local g_ring = guiGridListAddColumn(phoneSettings.gridlist[1], "Ringtone", 0.8)
	
	for i=1,#ringtoneNames do
		local row = guiGridListAddRow(phoneSettings.gridlist[1])
		guiGridListSetItemText(phoneSettings.gridlist[1], row, g_ring, i .. " - " .. ringtoneNames[i], false, false)
		if (i == #ringtoneNames) then
			guiGridListSetSelectedItem(phoneSettings.gridlist[1], phoneRingtone-1, 1)
		end
	end
	
	-- Message gridlist
	phoneSettings.gridlist[2] = guiCreateGridList(205, 55, 187, 108, false, phoneSettings.window[1])
	local g_ring = guiGridListAddColumn(phoneSettings.gridlist[2], "Message Tone", 0.8)
	
	for i=1,#messageNames do
		local row = guiGridListAddRow(phoneSettings.gridlist[2])
		guiGridListSetItemText(phoneSettings.gridlist[2], row, g_ring, i .. " - " .. messageNames[i], false, false)
		guiGridListSetSelectedItem(phoneSettings.gridlist[2], 1, 1)
		if (i == #messageNames) then
			guiGridListSetSelectedItem(phoneSettings.gridlist[2], phoneMessageTone-1, 1)
		end
	end
	
	-- Save button
	phoneSettings.button[1] = guiCreateButton(11, 170, 187, 28, "Save Ringtone", false, phoneSettings.window[1])
	guiSetFont(phoneSettings.button[1], "default-bold-small")
	
	-- Preview button
	phoneSettings.button[2] = guiCreateButton(11, 202, 187, 28, "Preview Ringtone", false, phoneSettings.window[1])
	guiSetFont(phoneSettings.button[2], "default-bold-small")
	
	-- Save2 button
	phoneSettings.button[4] = guiCreateButton(205, 170, 187, 28, "Save Message Tone", false, phoneSettings.window[1])
	guiSetFont(phoneSettings.button[4], "default-bold-small")
	
	-- Preview2 button
	phoneSettings.button[5] = guiCreateButton(205, 202, 187, 28, "Preview Message Tone", false, phoneSettings.window[1])
	guiSetFont(phoneSettings.button[5], "default-bold-small")
	
	-- Exit button
	phoneSettings.button[3] = guiCreateButton(11, 234, 381, 28, "Exit Menu", false, phoneSettings.window[1])
	guiSetFont(phoneSettings.button[3], "default-bold-small")
	
	addEventHandler("onClientGUIClick", phoneSettings.button[1],
		function()
			local row, col = guiGridListGetSelectedItem(phoneSettings.gridlist[1])
			if (row ~= -1) and (col ~= -1) then
				local ringtone = row+1
				if (ringtone ~= phoneRingtone) then
					phoneRingtone = ringtone
					triggerServerEvent(":_updateRingtone_:", localPlayer, ringtone, phoneNumber)
					outputChatBox("Selected ringtone saved and chosen.", 20, 245, 20, false)
				else
					outputChatBox("Choose a new ringtone from the list in order to save it.", 245, 20, 20, false)
				end
			else
				outputChatBox("Choose a ringtone from the list in order to set one.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneSettings.button[4],
		function()
			local row, col = guiGridListGetSelectedItem(phoneSettings.gridlist[2])
			if (row ~= -1) and (col ~= -1) then
				local messagetone = row+1
				if (messagetone ~= phoneMessageTone) then
					phoneMessageTone = messagetone
					triggerServerEvent(":_updateMessageTone_:", localPlayer, messagetone, phoneNumber)
					outputChatBox("Selected message tone saved and chosen.", 20, 245, 20, false)
				else
					outputChatBox("Choose a new message tone from the list in order to save it.", 245, 20, 20, false)
				end
			else
				outputChatBox("Choose a message tone from the list in order to set one.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneSettings.button[2],
		function()
			local row, col = guiGridListGetSelectedItem(phoneSettings.gridlist[1])
			if (row ~= -1) and (col ~= -1) then
				if (ringtonePreview) then
					destroyElement(ringtonePreview)
					ringtonePreview = nil
					guiSetText(phoneSettings.button[2], "Preview Ringtone")
					return
				end
				
				if (messagetonePreview) then
					destroyElement(messagetonePreview)
					messagetonePreview = nil
					guiSetText(phoneSettings.button[5], "Preview Message Tone")
				end
				
				if (row+1 ~= 2) then
					ringtonePreview = playSound("ringtones/" .. row+1 .. ".mp3", true)
					setSoundVolume(ringtonePreview, 0.6)
					guiSetText(phoneSettings.button[2], "Stop Preview")
				end
			else
				outputChatBox("Choose a ringtone from the list in order to set one.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneSettings.button[5],
		function()
			local row, col = guiGridListGetSelectedItem(phoneSettings.gridlist[2])
			if (row ~= -1) and (col ~= -1) then
				if (messagetonePreview) then
					destroyElement(messagetonePreview)
					messagetonePreview = nil
					guiSetText(phoneSettings.button[5], "Preview Message Tone")
					return
				end
				
				if (ringtonePreview) then
					destroyElement(ringtonePreview)
					ringtonePreview = nil
					guiSetText(phoneSettings.button[2], "Preview Ringtone")
				end
				
				if (row+1 ~= 2) then
					messagetonePreview = playSound("messagetones/" .. row+1 .. ".mp3", true)
					setSoundVolume(messagetonePreview, 0.6)
					guiSetText(phoneSettings.button[5], "Stop Preview")
				end
			else
				outputChatBox("Choose a message tone from the list in order to set one.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", phoneSettings.button[3],
		function()
			if (isElement(ringtonePreview)) then
				destroyElement(ringtonePreview)
				ringtonePreview = nil
			end
			
			if (isElement(messagetonePreview)) then
				destroyElement(messagetonePreview)
				messagetonePreview = nil
			end
			
			guiSetText(phoneSettings.button[2], "Preview Sound")
			displayPhoneSettings()
		end, false
	)
end

addEvent(":_setPhoneWindowText_:", true)
addEventHandler(":_setPhoneWindowText_:", root,
	function(state)
		if (not isElement(phoneCall.window[1])) then return end
		if (state == 1) then
			guiSetText(phoneCall.window[1], "Now dialing...")
			guiSetEnabled(phoneCall.edit[1], false)
			guiSetEnabled(phoneCall.button[1], false)
			guiSetText(phoneCall.button[2], "Cancel")
		elseif (state == 2) then
			guiSetText(phoneCall.window[1], "Call a Number")
			guiSetEnabled(phoneCall.edit[1], true)
			guiSetEnabled(phoneCall.button[1], true)
			guiSetText(phoneCall.button[2], "Exit")
		elseif (state == 3) then
			guiSetText(phoneCall.window[1], "Connected!")
			guiSetText(phoneCall.button[2], "Hang up")
		end
	end
)

addEvent(":_setPhoneSMSWindowText_:", true)
addEventHandler(":_setPhoneSMSWindowText_:", root,
	function(state)
		if (not isElement(phoneSMS.window[1])) then return end
		if (state == 1) then
			guiSetText(phoneSMS.window[1], "Now sending...")
			guiSetEnabled(phoneSMS.edit[1], false)
			guiSetEnabled(phoneSMS.memo[1], false)
			guiMemoSetReadOnly(phoneSMS.memo[1], true)
			guiSetEnabled(phoneSMS.button[1], false)
			guiSetText(phoneSMS.button[2], "Cancel")
		elseif (state == 2) then
			guiSetText(phoneSMS.window[1], "Send a Message")
			guiSetEnabled(phoneSMS.edit[1], true)
			guiSetEnabled(phoneSMS.memo[1], true)
			guiMemoSetReadOnly(phoneSMS.memo[1], false)
			guiSetEnabled(phoneSMS.button[1], true)
			guiSetText(phoneSMS.edit[1], "")
			guiSetText(phoneSMS.memo[1], "")
			guiSetText(phoneSMS.button[2], "Exit Window")
		end
	end
)

addEvent(":_exitPhoneWindows_:", true)
addEventHandler(":_exitPhoneWindows_:", root,
	function(number)
		if (phoneNumber == number) or (number == true) then
			if (isElement(phoneMenu.window[1])) then
				destroyElement(phoneMenu.window[1])
			end
			
			if (isElement(phoneContacts.window[1])) then
				destroyElement(phoneContacts.window[1])
			end
			
			if (isElement(phoneCall.window[1])) then
				destroyElement(phoneCall.window[1])
			end
			
			if (isElement(phoneSMS.window[1])) then
				destroyElement(phoneSMS.window[1])
			end
			
			if (isElement(phoneSettings.window[1])) then
				destroyElement(phoneSettings.window[1])
			end
			
			if (isTimer(checkTimeTimer)) then
				killTimer(checkTimeTimer)
			end
			
			phoneNumber = 0
			phoneRingtone = 1
			contacts = {}
			
			showCursor(false, false)
			
			triggerEvent(":_updateLockVar_:", localPlayer)
		end
	end
)

local messageSounds = {}
local sounds = {}
local soundDestroyTimers = {}

addEvent(":_startPlayingRingOnElement_:", true)
addEventHandler(":_startPlayingRingOnElement_:", root,
	function(element, ringID)
		local x, y, z = getElementPosition(element)
		sounds[element] = playSound3D("ringtones/" .. (ringID and ringID or 10) .. ".mp3", x, y, z, true)
		setSoundMaxDistance(sounds[element], 13)
		setSoundVolume(sounds[element], 0.5)
		attachElements(sounds[element], element)
		soundDestroyTimers[element] = setTimer(function(element)
			destroyElement(sounds[element])
		end, 25000, 1, element)
	end
)

addEvent(":_startPlayingMsgOnElement_:", true)
addEventHandler(":_startPlayingMsgOnElement_:", root,
	function(element, ringID)
		local x, y, z = getElementPosition(element)
		messageSounds[element] = playSound3D("messagetones/" .. (ringID and ringID or 10) .. ".mp3", x, y, z, false)
		setSoundMaxDistance(messageSounds[element], 13)
		setSoundVolume(messageSounds[element], 0.5)
		attachElements(messageSounds[element], element)
	end
)

addEvent(":_stopPlayingRingOnElement_:", true)
addEventHandler(":_stopPlayingRingOnElement_:", root,
	function(element)
		if (sounds[element]) then
			destroyElement(sounds[element])
			sounds[element] = nil
		end
		
		if (isTimer(soundDestroyTimers[element])) then
			killTimer(soundDestroyTimers[element])
		end
	end
)

addEvent(":_updatePhoneContacts_:", true)
addEventHandler(":_updatePhoneContacts_:", root,
	function(number, tContacts)
		if (isElement(phoneMenu.window[1])) then
			triggerEvent(":_exitPhoneWindows_:", localPlayer, number)
		end
		
		displayPhoneMenu(number, tContacts)
		displayPhoneContacts()
	end
)
