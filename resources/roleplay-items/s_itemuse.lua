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

addEvent(":_doItemAction_:", true)
addEventHandler(":_doItemAction_:", root,
	function(dbEntryID, itemID, value)
		if (source ~= client) then return end
		if (itemID == 1) then
			setElementHealth(client, math.min(100, getElementHealth(client)+getItemValue(itemID)))
			exports['roleplay-chat']:outputLocalActionMe(client, "moves " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " hand up to " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " mouth, taking a bite of " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " donut.")
			takeItem(client, itemID, value, dbEntryID)
		elseif (itemID == 2) then
			exports['roleplay-chat']:outputLocalActionMe(client, "throws " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " dice and the dice rolls number " .. math.random(1, 6) .. ".")
		elseif (itemID == 3) then
			setElementHealth(client, math.min(100, getElementHealth(client)+getItemValue(itemID)))
			exports['roleplay-chat']:outputLocalActionMe(client, "moves " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " hand up to " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " mouth, taking a sip of " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " water bottle.")
			takeItem(client, itemID, value, dbEntryID)
		elseif (itemID == 4) then
			setElementHealth(client, math.min(100, getElementHealth(client)+getItemValue(itemID)))
			exports['roleplay-chat']:outputLocalActionMe(client, "moves " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " hand up to " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " mouth, taking a sip of " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " coffee cup.")
			takeItem(client, itemID, value, dbEntryID)
		elseif (itemID == 10) then
			triggerEvent(":_displayPhone_:", client, value)
			exports['roleplay-chat']:outputLocalActionMe(client, "takes out " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " cellphone and slides the unlock on it.")
		elseif (itemID == 13) then
			outputChatBox("You can use this radio by typing /r <message>", client, 210, 160, 25, false)
		elseif (itemID == 14) then
			outputChatBox("You can use this megaphone by typing /m <message>", client, 210, 160, 25, false)
		else
			exports['roleplay-chat']:outputLocalActionMe(client, "shows " .. exports['roleplay-accounts']:getCharacterRealGender(client, 2) .. " " .. getItemName(itemID) .. " to people around " .. exports['roleplay-accounts']:getCharacterRealGender(client, 3) .. ".")
		end
	end
)

addEvent(":_deleteItem_:", true)
addEventHandler(":_deleteItem_:", root,
	function(dbEntryID, itemID, value)
		if (source ~= client) then return end
		exports['roleplay-chat']:outputLocalActionMe(client, "destroyed " .. exports['roleplay-accounts']:getCharacterRealGender(client, 3) .. " " .. getItemName(itemID) .. ".")
		takeItem(client, itemID, value, dbEntryID)
		
		if (itemID == 10) then
			triggerClientEvent(client, ":_exitPhoneWindows_:", client, value)
		end
	end
)