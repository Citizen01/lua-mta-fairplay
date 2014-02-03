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

local sPoints = 0
local sItems = {}
local sx, sy = guiGetScreenSize()

local menu = {
    window = {},
    button = {},
    gridlist = {},
    label = {}
}

local function displayDonationMenu()
	if (isElement(menu.window[1])) then
		destroyElement(menu.window[1])
		showCursor(false)
		return
	end
	
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	
	triggerServerEvent(":_fetchCurrentDonationStatus_:", localPlayer)
	
	menu.window[1] = guiCreateWindow((sx-601)/2, (sy-536)/2, 601, 536, "Donation Menu", false)
	guiWindowSetSizable(menu.window[1], false)
	guiSetAlpha(menu.window[1], 0.90)
	
	menu.label[1] = guiCreateLabel(16, 33, 568, 15, "Points available: " .. sPoints, false, menu.window[1])
	guiSetFont(menu.label[1], "default-bold-small")
	
	menu.label[2] = guiCreateLabel(16, 58, 568, 49, "If you've donated money to support the Community or perhaps won in a Community competition or event, you're able to activate in-game features for a few donation points. Donation points can only be issued by Community Leaders and they are only issued by the reasons explained above.", false, menu.window[1])
	guiSetFont(menu.label[2], "default-bold-small")
	guiLabelSetHorizontalAlign(menu.label[2], "center", true)
	
	menu.label[3] = guiCreateLabel(16, 117, 568, 15, "AVAILABLE PERKS", false, menu.window[1])
	guiSetFont(menu.label[3], "default-bold-small")
	
	menu.gridlist[1] = guiCreateGridList(16, 142, 568, 136, false, menu.window[1])
	guiGridListAddColumn(menu.gridlist[1], "Name", 0.5)
	guiGridListAddColumn(menu.gridlist[1], "Duration", 0.2)
	guiGridListAddColumn(menu.gridlist[1], "Cost", 0.2)
	
	for index,_ in ipairs(sItems) do
		local row = guiGridListAddRow(menu.gridlist[1])
		guiGridListSetItemText(menu.gridlist[1], row, 1, sItems[index][1], false, false)
		guiGridListSetItemText(menu.gridlist[1], row, 2, (sItems[index][2] == 0 and "one-time use" or (sItems[index][2] == 1 and sItems[index][2] .. " month" or sItems[index][2] .. " months")), false, false)
		guiGridListSetItemText(menu.gridlist[1], row, 3, sItems[index][3] .. " points", false, false)
	end
	
	menu.label[4] = guiCreateLabel(16, 325, 568, 15, "CURRENTLY ACTIVATED PERKS", false, menu.window[1])
	guiSetFont(menu.label[4], "default-bold-small")
	
	menu.button[1] = guiCreateButton(16, 284, 568, 31, "Activate Perk", false, menu.window[1])
	guiSetFont(menu.button[1], "default-bold-small")
	
	menu.gridlist[2] = guiCreateGridList(16, 350, 568, 136, false, menu.window[1])
	guiGridListAddColumn(menu.gridlist[2], "Name", 0.5)
	guiGridListAddColumn(menu.gridlist[2], "Duration", 0.2)
	guiGridListAddColumn(menu.gridlist[2], "Cost", 0.2)
	
	menu.button[2] = guiCreateButton(16, 492, 568, 31, "Close Window", false, menu.window[1])
	guiSetFont(menu.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", menu.button[1],
		function()
			local row, col = guiGridListGetSelectedItem(menu.gridlist[1])
			if (row ~= -1) and (col ~= -1) then
				if (row == 0) then
					displayCustomNumberMenu()
				else
					triggerServerEvent(":_activateDonationPerk_:", localPlayer, row)
				end
			else
				outputChatBox("Select a perk from the list in order to activate a perk.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", menu.button[2], displayDonationMenu, false)
end

local custom = {
    window = {},
    label = {},
    button = {},
    edit = {}
}

function displayCustomNumberMenu()
	guiSetEnabled(menu.window[1], false)
	
	custom.window[1] = guiCreateWindow((sx-228)/2, (sy-163)/2, 228, 163, "Custom Number", false)
	guiWindowSetSizable(custom.window[1], false)
	
	custom.edit[1] = guiCreateEdit(10, 53, 207, 30, "", false, custom.window[1])
	
	custom.label[1] = guiCreateLabel(10, 28, 207, 15, "Enter a custom number", false, custom.window[1])
	guiSetFont(custom.label[1], "default-bold-small")
	guiLabelSetHorizontalAlign(custom.label[1], "center", false)
	
	custom.button[1] = guiCreateButton(10, 89, 207, 30, "Attempt", false, custom.window[1])
	guiSetFont(custom.button[1], "default-bold-small")
	
	custom.button[2] = guiCreateButton(10, 124, 207, 30, "Cancel", false, custom.window[1])
	
	showCursor(true, true)
	
	addEventHandler("onClientGUIClick", custom.button[2],
		function()
			destroyElement(custom.window[1])
			guiSetEnabled(menu.window[1], true)
			showCursor(true, false)
		end, false
	)
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		triggerServerEvent(":_fetchCurrentDonationStatus_:", localPlayer)
		bindKey("F5", "down", displayDonationMenu)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		unbindKey("F5", "down", displayDonationMenu)
	end
)

addEvent(":_updateCurrentDonationStatus_:", true)
addEventHandler(":_updateCurrentDonationStatus_:", root,
	function(points, items)
		sItems = items
		sPoints = points
	end
)