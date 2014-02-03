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
local factionData = {}
local factionMenu = { window = {}, tabpanel = {}, tab = {}, gridlist = {}, label = {}, button = {} }
local rankMenu = { window = {}, label = {}, button = {}, rank = { edit = {} }, wage = { edit = {} } }
local factionMotd = { window = {}, button = {}, memo = {} }
local factionSetRank = { window = {}, label = {}, radio = {}, button = {} }
local factionSetRights = { window = {}, label = {}, radio = {}, button = {} }
local inviteMenu = { window = {}, label = {}, edit = {}, button = {} }
local cooldown = { motd = false, rank = false, setrank = false, setrights = false }

addEvent(":_showFactionMenu_:", true)
addEventHandler(":_showFactionMenu_:", root,
	function(factionID, factionName, factionType, factionMOTD, factionRanks, factionWages, factionPlayers)
		factionData = {
			["id"] = factionID, ["name"] = factionName, ["type"] = factionType, ["motd"] = factionMOTD, ["ranks"] = fromJSON(factionRanks), ["wages"] = fromJSON(factionWages), ["players"] = factionPlayers
		}
		displayFactionMenu()
	end
)

addEvent(":_closeFactionMenu_:", true)
addEventHandler(":_closeFactionMenu_:", root,
	function()
		if (isElement(factionMenu.window[1])) then
			destroyElement(factionMenu.window[1])
			showCursor(false)
			guiSetInputEnabled(false)
		end
		
		if (isElement(rankMenu.window[1])) then
			destroyElement(rankMenu.window[1])
		end
		
		if (isElement(factionMotd.window[1])) then
			destroyElement(factionMotd.window[1])
		end
		
		if (isElement(factionSetRank.window[1])) then
			destroyElement(factionSetRank.window[1])
		end
		
		if (isElement(factionSetRights.window[1])) then
			destroyElement(factionSetRights.window[1])
		end
		
		if (isElement(inviteMenu.window[1])) then
			destroyElement(inviteMenu.window[1])
		end
	end
)

function displayFactionMenu()
	if (not exports['roleplay-accounts']:getPlayerFaction(localPlayer)) then
		outputChatBox("You're not in a faction.", 245, 20, 20, false)
		return
	end
	
	if (isElement(factionMenu.window[1])) then
		triggerServerEvent(":_closeFactionMenu_:", localPlayer)
		return
	end
	
	factionMenu.window[1] = guiCreateWindow((sx-761)/2, (sy-624)/2, 761, (exports['roleplay-accounts']:getFactionPrivileges(localPlayer) > 0 and 624 or 450), "Faction - " .. factionData.name, false)
	guiWindowSetSizable(factionMenu.window[1], false)
	
	factionMenu.tabpanel[1] = guiCreateTabPanel(10, 25, 741, 375, false, factionMenu.window[1])
	
	-- Members Tab
	factionMenu.tab[1] = guiCreateTab("Members", factionMenu.tabpanel[1])
	
	factionMenu.gridlist[1] = guiCreateGridList(10, 10, 721, 330, false, factionMenu.tab[1])
	guiGridListAddColumn(factionMenu.gridlist[1], "Character name", 0.2)
	guiGridListAddColumn(factionMenu.gridlist[1], "Rank & Wage ($)", 0.25)
	guiGridListAddColumn(factionMenu.gridlist[1], "Privileges", 0.1)
	guiGridListAddColumn(factionMenu.gridlist[1], "Last online", 0.15)
	guiGridListAddColumn(factionMenu.gridlist[1], "On Duty", 0.1)
	guiGridListAddColumn(factionMenu.gridlist[1], "Status", 0.1)
	
	for _,player in pairs(factionData.players) do
		local row = guiGridListAddRow(factionMenu.gridlist[1])
		guiGridListSetItemText(factionMenu.gridlist[1], row, 1, player.name:gsub("_", " "), false, false)
		guiGridListSetItemText(factionMenu.gridlist[1], row, 2, factionData["ranks"][player.rank] .. " (" .. exports['roleplay-banking']:getFormattedValue(factionData["wages"][player.rank]) .. ")", false, false)
		
		local privilegeName = "Member"
		if (player.privileges == 1) then
			privilegeName = "Leader"
		elseif (player.privileges == 2) then
			privilegeName = "Owner"
		end
		
		guiGridListSetItemText(factionMenu.gridlist[1], row, 3, privilegeName, false, false)
		guiGridListSetItemText(factionMenu.gridlist[1], row, 4, (player.lastOnline and (player.lastOnline > 1 and player.lastOnline .. " days ago" or (player.lastOnline ~= 0 and player.lastOnline .. " day ago" or "Today")) or "Never"), false, false)
		guiGridListSetItemText(factionMenu.gridlist[1], row, 5, "-", false, false)
		guiGridListSetItemText(factionMenu.gridlist[1], row, 6, (getPlayerFromName(player.name) and "Online" or "Offline"), false, false)
		guiGridListSetItemColor(factionMenu.gridlist[1], row, 6, 245, 20, 20, 225)
		
		if (getPlayerFromName(player.name)) then
			guiGridListSetItemColor(factionMenu.gridlist[1], row, 6, 20, 245, 20, 225)
		end
	end
	
	if (exports['roleplay-accounts']:getFactionPrivileges(localPlayer) > 0) then
		factionMenu.tab[2] = guiCreateTab("Vehicles", factionMenu.tabpanel[1])
		
		factionMenu.gridlist[2] = guiCreateGridList(10, 10, 721, 330, false, factionMenu.tab[2])
		guiGridListAddColumn(factionMenu.gridlist[2], "Vehicle ID", 0.2)
		guiGridListAddColumn(factionMenu.gridlist[2], "Vehicle Name", 0.25)
		guiGridListAddColumn(factionMenu.gridlist[2], "Vehicle Plate", 0.25)
		guiGridListAddColumn(factionMenu.gridlist[2], "Vehicle Location", 0.25)
		
		for _,vehicle in ipairs(getElementsByType("vehicle")) do
			if (exports['roleplay-vehicles']:getVehicleFaction(vehicle)) then
				if (exports['roleplay-vehicles']:getVehicleFaction(vehicle) == factionData.id) then
					local row = guiGridListAddRow(factionMenu.gridlist[2])
					guiGridListSetItemText(factionMenu.gridlist[2], row, 1, exports['roleplay-vehicles']:getVehicleID(vehicle), false, true)
					guiGridListSetItemText(factionMenu.gridlist[2], row, 2, getVehicleName(vehicle), false, false)
					guiGridListSetItemText(factionMenu.gridlist[2], row, 3, string.upper(getVehiclePlateText(vehicle)), false, false)
					
					local x, y, z = getElementPosition(vehicle)
					guiGridListSetItemText(factionMenu.gridlist[2], row, 4, getZoneName(x, y, z, false) .. ", " .. getZoneName(x, y, z, true), false, false)
				end
			end
		end
		
		-- Member Actions
		factionMenu.label[1] = guiCreateLabel(10, 416, 178, 14, "Member Actions", false, factionMenu.window[1])
		guiSetFont(factionMenu.label[1], "default-bold-small")
		guiLabelSetHorizontalAlign(factionMenu.label[1], "center", false)
		
		factionMenu.button[1] = guiCreateButton(10, 451, 179, 33, "Kick Member", false, factionMenu.window[1])
		factionMenu.button[2] = guiCreateButton(10, 494, 179, 33, "Set Member Rank", false, factionMenu.window[1])
		addEventHandler("onClientGUIClick", factionMenu.button[2],
			function()
				local row, col = guiGridListGetSelectedItem(factionMenu.gridlist[1])
				if (row ~= -1) and (col ~= -1) then
					displaySetRankMenu(row)
				else
					outputChatBox("Please select a faction member from the list.", 245, 20, 20, false)
				end
			end, false
		)
		
		factionMenu.button[3] = guiCreateButton(10, 537, 179, 33, "Set Member Rights", false, factionMenu.window[1])
		addEventHandler("onClientGUIClick", factionMenu.button[3],
			function()
				local row, col = guiGridListGetSelectedItem(factionMenu.gridlist[1])
				if (row ~= -1) and (col ~= -1) then
					displaySetRightsMenu(row)
				else
					outputChatBox("Please select a faction member from the list.", 245, 20, 20, false)
				end
			end, false
		)
		
		factionMenu.button[4] = guiCreateButton(10, 580, 179, 33, "Invite Player", false, factionMenu.window[1])
		addEventHandler("onClientGUIClick", factionMenu.button[4], displayInviteMenu, false)
		
		-- Vehicle Actions
		factionMenu.label[2] = guiCreateLabel(198, 416, 178, 14, "Vehicle Actions", false, factionMenu.window[1])
		guiSetFont(factionMenu.label[2], "default-bold-small")
		guiLabelSetHorizontalAlign(factionMenu.label[2], "center", false)
		
		factionMenu.button[5] = guiCreateButton(199, 451, 179, 33, "Respawn Vehicle", false, factionMenu.window[1])
		addEventHandler("onClientGUIClick", factionMenu.button[5],
			function()
				local row, col = guiGridListGetSelectedItem(factionMenu.gridlist[2])
				if (row ~= -1) and (col ~= -1) then
					triggerServerEvent(":_syncFactionChange_:", localPlayer, 6, tonumber(guiGridListGetItemText(factionMenu.gridlist[2], row, 1)))
				else
					outputChatBox("Please select a vehicle from the list.", 245, 20, 20, false)
				end
			end, false
		)
		
		factionMenu.button[6] = guiCreateButton(199, 494, 179, 33, "Respawn All Vehicles", false, factionMenu.window[1])
		addEventHandler("onClientGUIClick", factionMenu.button[6],
			function()
				triggerServerEvent(":_syncFactionChange_:", localPlayer, 5)
			end, false
		)
		
		-- Faction Actions
		factionMenu.label[3] = guiCreateLabel(390, 416, 178, 14, "Faction Actions", false, factionMenu.window[1])
		guiSetFont(factionMenu.label[3], "default-bold-small")
		guiLabelSetHorizontalAlign(factionMenu.label[3], "center", false)
		
		factionMenu.button[7] = guiCreateButton(388, 451, 179, 33, "Message of the Day", false, factionMenu.window[1])
		addEventHandler("onClientGUIClick", factionMenu.button[7], displayMotdMenu, false)
		
		if (exports['roleplay-accounts']:getFactionPrivileges(localPlayer) > 1) then
			factionMenu.button[9] = guiCreateButton(388, 494, 179, 33, "Edit Ranks & Wages", false, factionMenu.window[1])
			addEventHandler("onClientGUIClick", factionMenu.button[9], displayRankMenu, false)
		end
	end
	
	factionMenu.label[4] = guiCreateLabel((exports['roleplay-accounts']:getFactionPrivileges(localPlayer) > 0 and 155 or 90), 25, (exports['roleplay-accounts']:getFactionPrivileges(localPlayer) > 0 and 596 or 641), 15, "MOTD: " .. factionData.motd, false, factionMenu.window[1])
	guiSetFont(factionMenu.label[4], "default-bold-small")
	
	factionMenu.button[8] = guiCreateButton(572, (exports['roleplay-accounts']:getFactionPrivileges(localPlayer) > 0 and 581 or 407), 179, 33, "Exit Faction Menu", false, factionMenu.window[1])
	
	addEventHandler("onClientGUIClick", factionMenu.button[8], displayFactionMenu, false)
	
	showCursor(true)
	guiSetInputEnabled(true)
end

function displayInvitationWindow(by, faction, factionID)
	if (isElement(g_invite_window)) then
		destroyElement(g_invite_window)
		showCursor(false)
		if (isTimer(remainer)) then
			killTimer(remainer)
		end
		return
	end
	
	local remaining = 30
	
	g_invite_window = guiCreateWindow((sx-472)/2, (sy-154)/2, 472, 154, "Faction Invitation", false)
	guiWindowSetSizable(g_invite_window, false)
	guiSetProperty(g_invite_window, "AlwaysOnTop", "true")

	g_invite_label = guiCreateLabel(14, 30, 443, 48, "You have been invited to the " .. faction .. " by " .. by .. " on behalf of the faction. Would you like to accept or decline this invite?", false, g_invite_window)
	guiLabelSetHorizontalAlign(g_invite_label, "left", true)
	
	g_invite_deny = guiCreateButton(15, 86, 218, 28, "Decline", false, g_invite_window)
	guiSetFont(g_invite_deny, "default-bold-small")
	guiSetProperty(g_invite_deny, "NormalTextColour", "FFFF0000")
	
	g_invite_accept = guiCreateButton(239, 86, 218, 28, "Accept", false, g_invite_window)
	guiSetFont(g_invite_accept, "default-bold-small")
	guiSetProperty(g_invite_accept, "NormalTextColour", "FF0BFF00")
	
	g_invite_seconds = guiCreateLabel(15, 124, 442, 18, "Invite will be automatically declined in " .. remaining .. " seconds...", false, g_invite_window)
	guiLabelSetHorizontalAlign(g_invite_seconds, "center", false)
	
	remainer = setTimer(function(by, factionID)
		if (not isElement(g_invite_window)) then killTimer(remainer) end
		remaining = remaining-1
		guiSetText(g_invite_seconds, "Invite will be automatically declined in " .. remaining .. " seconds...")
		if (remaining == 0) then
			displayInvitationWindow()
			triggerServerEvent(":_factionInviteResult_:", localPlayer, 0, by, factionID)
			outputChatBox("Invitation request has been automatically declined.", 20, 245, 20, false)
		end
	end, 1000, remaining, by, factionID)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", g_invite_deny,
		function()
			displayInvitationWindow()
			triggerServerEvent(":_factionInviteResult_:", localPlayer, 0, by, factionID)
			outputChatBox("Invitation request has been declined.", 20, 245, 20, false)
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_invite_accept,
		function()
			displayInvitationWindow()
			triggerServerEvent(":_factionInviteResult_:", localPlayer, 1, by, factionID)
			outputChatBox("Invitation request has been accepted.", 20, 245, 20, false)
		end, false
	)
end
addEvent(":_doInviteWindow_:", true)
addEventHandler(":_doInviteWindow_:", root, displayInvitationWindow)

function displayInviteMenu()
	if (isElement(inviteMenu.window[1])) then
		destroyElement(inviteMenu.window[1])
		guiSetVisible(factionMenu.window[1], true)
		return
	end
	
	guiSetVisible(factionMenu.window[1], false)
	
	inviteMenu.window[1] = guiCreateWindow((sx-231)/2, (sy-136)/2, 231, 136, "Invite Player", false)
	guiWindowSetSizable(inviteMenu.window[1], false)
	guiSetProperty(inviteMenu.window[1], "AlwaysOnTop", "true")
	
	inviteMenu.edit[1] = guiCreateEdit(10, 28, 210, 30, "", false, inviteMenu.window[1])
	
	inviteMenu.button[1] = guiCreateButton(9, 66, 211, 26, "Cancel", false, inviteMenu.window[1])
	inviteMenu.button[2] = guiCreateButton(9, 98, 211, 26, "Invite", false, inviteMenu.window[1])
	guiSetFont(inviteMenu.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", inviteMenu.button[1], displayInviteMenu, false)
	addEventHandler("onClientGUIClick", inviteMenu.button[2],
		function()
			if (factionData["invites"] == 2) then
				outputChatBox("Your faction has used the maximum amount of invites today. Try again later.", 245, 20, 20, false)
				return
			end
			
			local name = guiGetText(inviteMenu.edit[1])
			local target = exports['roleplay-accounts']:getPlayerFromPartialName(name:gsub(" ", "_"), localPlayer)
			if (target) then
				if (not exports['roleplay-accounts']:getPlayerFaction(target)) then
					triggerServerEvent(":_invitePlayerToFaction_:", localPlayer, target)
					destroyElement(inviteMenu.window[1])
					showCursor(true, false)
					guiSetVisible(factionMenu.window[1], true)
				else
					outputChatBox("That player is already in a faction.", 245, 20, 20, false)
				end
			else
				outputChatBox("Cannot find such player or too many results.", 245, 20, 20, false)
			end
		end, false
	)
end

function displaySetRightsMenu(row)
	if (isElement(factionSetRights.window[1])) then
		destroyElement(factionSetRights.window[1])
		guiSetVisible(factionMenu.window[1], true)
		return
	end
	
	guiSetVisible(factionMenu.window[1], false)
	
	local rightMenu = guiGridListGetItemText(factionMenu.gridlist[1], row, 3)
	
	factionSetRights.window[1] = guiCreateWindow((sx-300)/2, (sy-345)/2, 300, 215, "Set Member Rights", false)
	guiWindowSetSizable(factionSetRights.window[1], false)
	guiSetProperty(factionSetRights.window[1], "AlwaysOnTop", "true")
	
	factionSetRights.label[1] = guiCreateLabel(0.05*300, 0.05*540, 0.4*300, 20, "Select rights...", false, factionSetRights.window[1])
	guiSetFont(factionSetRights.label[1], "default-bold-small")
	
	factionSetRights.radio[1] = guiCreateRadioButton(0.03*400, 26*2, 0.687*400, 22, "Member", false, factionSetRights.window[1])
	factionSetRights.radio[2] = guiCreateRadioButton(0.03*400, 26*3, 0.687*400, 22, "Leader", false, factionSetRights.window[1])
	factionSetRights.radio[3] = guiCreateRadioButton(0.03*400, 26*4, 0.687*400, 22, "Owner", false, factionSetRights.window[1])
	guiRadioButtonSetSelected(factionSetRights.radio[1], true)
	
	if (rightMenu == "Owner") then
		guiRadioButtonSetSelected(factionSetRights.radio[3], true)
	elseif (rightMenu == "Leader") then
		guiRadioButtonSetSelected(factionSetRights.radio[2], true)
	end
	
	factionSetRights.button[1] = guiCreateButton(0.03*400, 28*5, 0.687*400, 30, "Update", false, factionSetRights.window[1])
	guiSetFont(factionSetRights.button[1], "default-bold-small")
	
	factionSetRights.button[2] = guiCreateButton(0.03*400, 29*6, 0.687*400, 30, "Cancel", false, factionSetRights.window[1])
	
	addEventHandler("onClientGUIClick", factionSetRights.button[2], displaySetRightsMenu, false)
	addEventHandler("onClientGUIClick", factionSetRights.button[1],
		function()
			local newRights = rightMenu
			local name = guiGridListGetItemText(factionMenu.gridlist[1], row, 1)
			
			if (cooldown.setrights) then
				outputChatBox("Please wait a little before changing a member's rights again.", 245, 20, 20, false)
				return
			end
			
			for key=1,3 do
				local rank_ = guiRadioButtonGetSelected(factionSetRights.radio[key])
				if (rank_) then
					newRights = key
				end
			end
			
			triggerServerEvent(":_syncFactionChange_:", localPlayer, 4, name, newRights)
			cooldown.setrights = true
			
			setTimer(function()
				if (isElement(localPlayer)) then
					cooldown.setrights = false
				end
			end, 5000, 1)
		end, false
	)
end

function displaySetRankMenu(row)
	if (isElement(factionSetRank.window[1])) then
		destroyElement(factionSetRank.window[1])
		guiSetVisible(factionMenu.window[1], true)
		return
	end
	
	guiSetVisible(factionMenu.window[1], false)
	
	local rankMenu = guiGridListGetItemText(factionMenu.gridlist[1], row, 2)
	local y = 23
	
	factionSetRank.window[1] = guiCreateWindow((sx-300)/2, (sy-645)/2, 300, 645, "Set Member Rank", false)
	guiWindowSetSizable(factionSetRank.window[1], false)
	guiSetProperty(factionSetRank.window[1], "AlwaysOnTop", "true")
	
	factionSetRank.label[1] = guiCreateLabel(0.05*300, 0.05*540, 0.4*300, 20, "Select rank...", false, factionSetRank.window[1])
	guiSetFont(factionSetRank.label[1], "default-bold-small")
	
	for i=1,20 do
		y = (y or 0)+26
		factionSetRank.radio[i] = guiCreateRadioButton(0.03*400, y, 0.687*400, 22, factionData.ranks[i], false, factionSetRank.window[1])
		if (factionData["ranks"][i] == rankMenu) then
			guiRadioButtonSetSelected(factionSetRank.radio[i], true)
		end
	end
	
	factionSetRank.button[1] = guiCreateButton(0.03, 0.937, 0.93, 0.045, "Cancel", true, factionSetRank.window[1])
	factionSetRank.button[2] = guiCreateButton(0.03, 0.884, 0.93, 0.045, "Update", true, factionSetRank.window[1])
	guiSetFont(factionSetRank.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", factionSetRank.button[1], displaySetRankMenu, false)
	addEventHandler("onClientGUIClick", factionSetRank.button[2],
		function()
			local newRank = rankMenu
			local name = guiGridListGetItemText(factionMenu.gridlist[1], row, 1)
			
			if (cooldown.setrank) then
				outputChatBox("Please wait a little before changing a member's rank again.", 245, 20, 20, false)
				return
			end
			
			for key=1,20 do
				local rank_ = guiRadioButtonGetSelected(factionSetRank.radio[key])
				if (rank_) then
					newRank = key
				end
			end
			
			triggerServerEvent(":_syncFactionChange_:", localPlayer, 3, name, newRank)
			cooldown.setrank = true
			
			setTimer(function()
				if (isElement(localPlayer)) then
					cooldown.setrank = false
				end
			end, 5000, 1)
		end, false
	)
end

function displayMotdMenu()
	if (isElement(factionMotd.window[1])) then
		destroyElement(factionMotd.window[1])
		guiSetVisible(factionMenu.window[1], true)
		return
	end
	
	guiSetVisible(factionMenu.window[1], false)
	
	factionMotd.window[1] = guiCreateWindow((sx-492)/2, (sy-173)/2, 492, 173, "Message of the Day", false)
	guiWindowSetSizable(factionMotd.window[1], false)
	guiSetProperty(factionMotd.window[1], "AlwaysOnTop", "true")
	
	factionMotd.memo[1] = guiCreateMemo(10, 27, 472, 90, factionData.motd, false, factionMotd.window[1])
	
	factionMotd.button[1] = guiCreateButton(10, 123, 229, 37, "Cancel", false, factionMotd.window[1])
	factionMotd.button[2] = guiCreateButton(253, 123, 229, 37, "Update", false, factionMotd.window[1])
	guiSetFont(factionMotd.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", factionMotd.button[1], displayMotdMenu, false)
	addEventHandler("onClientGUIClick", factionMotd.button[2],
		function()
			if (cooldown.motd) then
				outputChatBox("Please wait a little before changing the faction MOTD again.", 245, 20, 20, false)
				return
			end
			
			local motd = guiGetText(factionMotd.memo[1])
			
			if (#motd <= 300) then
				for i=1,#motd do
					local char = string.sub(motd, i, i)
					if (char == "'") or (char == "\\") or (char == "/") then
						motd = motd:gsub(char, "")
					end
				end
				
				triggerServerEvent(":_syncFactionChange_:", localPlayer, 1, motd)
				cooldown.motd = true
				
				setTimer(function()
					if (isElement(localPlayer)) then
						cooldown.motd = false
					end
				end, 5000, 1)
			else
				outputChatBox("The Message of the Day has to be equal to or less than 300 characters long.", 245, 20, 20, false)
			end
		end, false
	)
end

function displayRankMenu()
	if (isElement(rankMenu.window[1])) then
		destroyElement(rankMenu.window[1])
		guiSetVisible(factionMenu.window[1], true)
		return
	end
	
	guiSetVisible(factionMenu.window[1], false)
	
	local legalTypes = (factionData.type >= 1 and factionData.type <= 3)
	local y = 23
	
	rankMenu.window[1] = guiCreateWindow((sx-300)/2, (sy-645)/2, 300, 645, "Edit Ranks & Wages", false)
	guiWindowSetSizable(rankMenu.window[1], false)
	guiSetProperty(rankMenu.window[1], "AlwaysOnTop", "true")
	
	rankMenu.label[1] = guiCreateLabel((legalTypes and 0.23*300 or 0.396*300), 0.05*540, 0.4*300, 20, "Rank Name", false, rankMenu.window[1])
	guiSetFont(rankMenu.label[1], "default-bold-small")
	
	if (legalTypes) then
		rankMenu.label[2] = guiCreateLabel(0.74*300, 0.05*540, 0.4*300, 20, "Wage", false, rankMenu.window[1])
		guiSetFont(rankMenu.label[2], "default-bold-small")
	end
	
	for i=1,20 do
		y = (y or 0)+26
		
		rankMenu.rank.edit[i] = guiCreateEdit(0.03*400, y, (legalTypes and 0.43 or 0.687)*400, 22, factionData["ranks"][i], false, rankMenu.window[1])
		
		if (legalTypes) then
			rankMenu.wage.edit[i] = guiCreateEdit(0.47*400, y, 0.25*400, 22, factionData["wages"][i], false, rankMenu.window[1])
		end
	end
	
	rankMenu.button[1] = guiCreateButton(0.03, 0.937, 0.93, 0.045, "Cancel", true, rankMenu.window[1])
	rankMenu.button[2] = guiCreateButton(0.03, 0.884, 0.93, 0.045, "Update", true, rankMenu.window[1])
	guiSetFont(rankMenu.button[2], "default-bold-small")
	
	addEventHandler("onClientGUIClick", rankMenu.button[1], displayRankMenu, false)
	addEventHandler("onClientGUIClick", rankMenu.button[2],
		function()
			if (cooldown.rank) then
				outputChatBox("Please wait a little before changing the faction ranks and wages again.", 245, 20, 20, false)
				return
			end
			
			local newRanks = {}
			local newWages = {}
			local illegalRank = false
			local illegalWage = false
			
			for key=1,20 do
				local rank_ = guiGetText(rankMenu.rank.edit[key])
				for i=1,#rank_ do
					local char = string.sub(rank_, i, i)
					if (not (((char >= "A") and (char <= "Z")) or ((char >= "a") and (char <= "z")) or ((char >= "0") and (char <= "9")) or (char == " "))) then
						illegalRank = key
						break
					end
				end
				
				if (#rank_ > 25) then
					illegalRank = key
				end
				
				newRanks[key] = rank_
				
				if (legalTypes) then
					local wage = guiGetText(rankMenu.wage.edit[key])
					for i=1,#wage do
						local char = string.sub(wage, i, i)
						if (not tonumber(char)) then
							illegalWage = key
							break
						end
					end
					
					if (tonumber(wage) < 0) then
						newWages[key] = 0
					else
						newWages[key] = math.min(wage, 3500)
					end
				else
					newWages[key] = 0
				end
			end
			
			if (illegalRank) then
				outputChatBox("Rank name ID " .. illegalRank .. " contains illegal characters or is too long. Please only use letters and numbers.", 245, 20, 20, false)
				return
			end
			
			if (illegalWage) then
				outputChatBox("Rank wage ID " .. illegalWage .. " contains illegal characters or is too small/high. Please only use letters and numbers.", 245, 20, 20, false)
				return
			end
			
			triggerServerEvent(":_syncFactionChange_:", localPlayer, 2, newRanks, newWages)
			cooldown.rank = true
			
			setTimer(function()
				if (isElement(localPlayer)) then
					cooldown.rank = false
				end
			end, 5000, 1)
		end, false
	)
end