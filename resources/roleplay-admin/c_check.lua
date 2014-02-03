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
local check = {
    button = {},
    window = {},
    label = {}
}

local function displayCheckWindow(player, serial, ip)
	if (isElement(check.window[1])) then
		destroyElement(check.window[1])
		return
	end
	
	local info_name = getPlayerName(player)
	local info_account = exports['roleplay-accounts']:getAccountName(player)
	local info_id = exports['roleplay-accounts']:getClientID(player)
	local info_gender = exports['roleplay-accounts']:getCharacterGender(player)
	
	check.window[1] = guiCreateWindow((sx-300), (sy-305)/2, 283, 305, "Check Player", false)
	guiWindowSetSizable(check.window[1], false)
	
	check.label[1] = guiCreateLabel(10, 27, 263, 15, "Character name: " .. info_name, false, check.window[1])
	guiSetFont(check.label[1], "default-bold-small")
	
	check.label[2] = guiCreateLabel(10, 46, 263, 15, "Account name: " .. info_account, false, check.window[1])
	guiSetFont(check.label[2], "default-bold-small")
	
	check.label[3] = guiCreateLabel(10, 65, 263, 15, "Client serial: " .. serial, false, check.window[1])
	guiSetFont(check.label[3], "default-bold-small")
	
	check.label[4] = guiCreateLabel(10, 84, 263, 15, "Client IP-address: " .. ip, false, check.window[1])
	guiSetFont(check.label[4], "default-bold-small")
	
	check.label[5] = guiCreateLabel(10, 103, 263, 15, "Client ID: " .. info_id, false, check.window[1])
	guiSetFont(check.label[5], "default-bold-small")
	
	check.label[6] = guiCreateLabel(10, 122, 263, 15, "Character gender: " .. (info_gender == 0 and "Male" or "Female"), false, check.window[1])
	guiSetFont(check.label[6], "default-bold-small")
	
	check.label[7] = guiCreateLabel(10, 141, 263, 15, "Character race: -", false, check.window[1])
	guiSetFont(check.label[7], "default-bold-small")
	
	check.label[8] = guiCreateLabel(10, 160, 263, 15, "Character height: 0 cm", false, check.window[1])
	guiSetFont(check.label[8], "default-bold-small")
	
	check.label[9] = guiCreateLabel(10, 179, 263, 15, "Character weight: 0 kg", false, check.window[1])
	guiSetFont(check.label[9], "default-bold-small")
	
	check.label[10] = guiCreateLabel(10, 198, 263, 15, "Character skin: " .. getElementModel(player), false, check.window[1])
	guiSetFont(check.label[10], "default-bold-small")
	
	check.label[11] = guiCreateLabel(10, 217, 263, 15, "Account warnings: 0/0", false, check.window[1])
	guiSetFont(check.label[11], "default-bold-small")
	
	check.button[1] = guiCreateButton(10, 242, 130, 54, "-", false, check.window[1])
	guiSetFont(check.button[1], "default-bold-small")
	
	check.button[2] = guiCreateButton(143, 242, 130, 54, "Close Window", false, check.window[1])
	guiSetFont(check.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", check.button[2], displayCheckWindow, false)
end

addEvent(":_doCheckPlayer_:", true)
addEventHandler(":_doCheckPlayer_:", root,
	function(player, serial, ip)
		displayCheckWindow(player, serial, ip)
    end
)