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
local image = false

local function drawPhoto()
	if (image) then
		dxDrawImage(0, 0, sx, sy, image, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("F2", "down", "report")
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		unbindKey("F2", "down", "report")
	end
)

addEvent(":_displayReportShot_:",true)
addEventHandler(":_displayReportShot_:", root,
	function(pixels)
		if (image) then
			destroyElement(image)
		end
		
		if (isElement(g_exit_btn)) then
			destroyElement(g_exit_btn)
			showCursor(false)
		end
		
        image = dxCreateTexture(pixels)
		addEventHandler("onClientRender", root, drawPhoto)
		
		g_exit_btn = guiCreateButton(0.92, 0.05, 0.05, 0.07, "CLOSE", true)
		guiSetAlpha(g_exit_btn, 0.85)
		guiSetProperty(g_exit_btn, "AlwaysOnTop", "true")
		
		showCursor(true)
		showChat(false)
		
		addEventHandler("onClientGUIClick", g_exit_btn,
			function()
				removeEventHandler("onClientRender", root, drawPhoto)
				
				if (image) then
					destroyElement(image)
				end
				
				destroyElement(g_exit_btn)
				showCursor(false)
				showChat(true)
			end
		)
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		setElementData(localPlayer, "roleplay:temp.sx", sx, true)
		setElementData(localPlayer, "roleplay:temp.sy", sy, true)
	end
)

local function displayReportMenu()
	if (isElement(g_report_window)) then
		destroyElement(g_report_window)
		showCursor(false)
		guiSetInputEnabled(false)
		return
	end
	
	-- Window
	g_report_window = guiCreateWindow(599, 359, 468, 340, "Report to Administrators", false)
	guiWindowSetSizable(g_report_window, false)
	
	-- Character
	g_character_label = guiCreateLabel(17, 31, 216, 16, "Character name or ID (you)", false, g_report_window)
	guiLabelSetColor(g_character_label, 0, 237, 0)
	
	g_character_edit = guiCreateEdit(17, 53, 216, 31, "*", false, g_report_window)
	
	g_character_shot = guiCreateCheckBox(257, 53, 197, 31, "Provide report with screenshot", true, false, g_report_window)
	guiCheckBoxSetSelected(g_character_shot, false)
	
	-- Description
	g_description_label = guiCreateLabel(17, 103, 96, 18, "Issue description", false, g_report_window)
	g_description_memo = guiCreateMemo(17, 127, 434, 118, "", false, g_report_window)
	
	g_description_len = guiCreateLabel(123, 103, 96, 18, "(0/300)", false, g_report_window)
	guiLabelSetColor(g_description_len, 237, 0, 0)
	
	addEventHandler("onClientGUIChanged", g_character_edit,
		function()
			local name = guiGetText(g_character_edit)
			if (#name > 2) or (name == "*") then
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name:gsub(" ", "_"), localPlayer)
				if (target) then
					guiLabelSetColor(g_character_label, 0, 237, 0)
					guiSetText(g_character_label, "Character name or ID " .. (target == localPlayer and "(you)" or "(found)"))
				else
					guiSetText(g_character_label, "Character name or ID")
					guiLabelSetColor(g_character_label, 237, 0, 0)
				end
			else
				guiSetText(g_character_label, "Character name or ID")
				guiLabelSetColor(g_character_label, 237, 0, 0)
			end
		end
	)
	
	addEventHandler("onClientGUIChanged", g_description_memo,
		function()
			guiSetText(g_description_len, "(" .. string.len(tostring(guiGetText(g_description_memo)))-1 .. "/300)")
			if (string.len(tostring(guiGetText(g_description_memo)))-1 >= 300) then
				guiLabelSetColor(g_description_len, 237, 0, 0)
			elseif (string.len(tostring(guiGetText(g_description_memo)))-1 >= 250) then
				guiLabelSetColor(g_description_len, 250, 167, 22)
			elseif (string.len(tostring(guiGetText(g_description_memo)))-1 >= 10) then
				guiLabelSetColor(g_description_len, 0, 237, 0)
			else
				guiLabelSetColor(g_description_len, 237, 0, 0)
			end
		end
	)
	
	-- Buttons
	g_report_submit = guiCreateButton(17, 255, 434, 33, "Submit Report", false, g_report_window)
	guiSetFont(g_report_submit, "default-bold-small")
	
	g_report_cancel = guiCreateButton(17, 294, 434, 33, "Cancel", false, g_report_window)
	
	showCursor(true)
	guiSetInputEnabled(true)
	
	addEventHandler("onClientGUIClick", g_report_cancel, displayReportMenu, false)
	addEventHandler("onClientGUIClick", g_report_submit,
		function()
			local name = guiGetText(g_character_edit)
			if (string.len(tostring(name)) > 2) or (name == "*") then
				local description = guiGetText(g_description_memo)
				if (string.len(tostring(description))-1 >= 10) and (string.len(tostring(description))-1 <= 300) then
					local target = exports['roleplay-accounts']:getPlayerFromPartialName(name:gsub(" ", "_"), localPlayer)
					if (target) then
						triggerServerEvent(":_submitReport_:", localPlayer, target, description, guiCheckBoxGetSelected(g_character_shot))
						displayReportMenu()
					else
						outputChatBox("Couldn't find a player with that name.", 245, 20, 20, false)
					end
				else
					outputChatBox("The description you entered is either too short or too long.", 245, 20, 20, false)
				end
			else
				outputChatBox("The character name you entered is too short.", 245, 20, 20, false)
			end
		end, false
	)
end

addEvent(":_reportStart_:", true)
addEventHandler(":_reportStart_:", root,
	function()
		displayReportMenu()
	end
)

addEvent(":_closeReportMenu_:", true)
addEventHandler(":_closeReportMenu_:", root,
	function()
		if (isElement(g_exit_btn)) then
			destroyElement(g_exit_btn)
			showCursor(false)
			guiSetInputEnabled(false)
		end
		
		if (isElement(g_report_window)) then
			destroyElement(g_report_window)
			showCursor(false)
			guiSetInputEnabled(false)
		end
	end
)