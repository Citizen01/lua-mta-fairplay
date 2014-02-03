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

local settingID = 0
local postSettingsTable = {}
local settingsTable = {
	{"Feature: Chatbubbles", "0"},
	{"Feature: Custom Radio Channels", "0"},
	{"Feature: Default GTA Radio", "0"},
	[16] = {"Feature: Motion Blur", "0"},
	{"Feature: Nametags", "0"},
	{"Feature: Walking Style", "0"},
	{"Shader:  Bloom Effect", "0"},
	{"Shader:  Contrast Effect", "0"},
	{"Shader:  Depth of Field & Bokeh", "0"},
	{"Shader:  Detailed Skybox", "0"},
	{"Shader:  Detailed Surfaces", "0"},
	{"Shader:  Detailed Water", "0"},
	{"Shader:  FXAA Filtering", "0"},
	{"Shader:  Ground Reflection", "0"},
	{"Shader:  Snowy Ground", "0"},
	{"Shader:  Vehicle Reflections", "0"}
}

local altSettingsTable = {
	[2] = {
		{"0", "None"},
		{"1", "Level 1 FXAA filtering"},
		{"2", "Level 2 FXAA filtering"},
		{"3", "Level 3 FXAA filtering"},
		{"4", "Level 4 FXAA filtering"}
	}
}

altSettings = {
    window = {},
    gridlist = {},
    button = {}
}

local function displayAlternateSettingsMenu()
	if (isElement(altSettings.window[1])) then
		destroyElement(altSettings.window[1])
		guiSetEnabled(settings.window[1], true)
		
		if (settingID == 0) then
			guiGridListClear(settings.gridlist[1])
			for i,v in ipairs(settingsTable) do
				local row = guiGridListAddRow(settings.gridlist[1])
				guiGridListSetItemText(settings.gridlist[1], row, 1, v[1], false, false)
				guiGridListSetItemText(settings.gridlist[1], row, 2, (tostring(v[2]) == "0" and "None" or tostring(v[2])), false, false)
				if (tostring(v[2]) == "0") then
					guiGridListSetItemColor(settings.gridlist[1], row, 2, 245, 20, 20, 255)
				else
					guiGridListSetItemColor(settings.gridlist[1], row, 2, 20, 245, 20, 255)
				end
			end
		end
		
		return
	end
	
	guiSetEnabled(settings.window[1], false)
	
	altSettings.window[1] = guiCreateWindow(629, 344, 438, 409, "Alternate Arguments", false)
	guiWindowSetSizable(altSettings.window[1], false)
	
	altSettings.gridlist[1] = guiCreateGridList(10, 26, 418, 271, false, altSettings.window[1])
	guiGridListAddColumn(altSettings.gridlist[1], "Value", 0.1)
	guiGridListAddColumn(altSettings.gridlist[1], "Description", 0.8)
	
	if (settingID ~= 1) then
		for i,v in ipairs(altSettingsTable[settingID]) do
			local row = guiGridListAddRow(altSettings.gridlist[1])
			guiGridListSetItemText(altSettings.gridlist[1], row, 1, v[1], false, false)
			guiGridListSetItemText(altSettings.gridlist[1], row, 2, v[2], false, false)
			
			if (settingID == 2) then
				if (v[1] == settingsTable[12][2]) then
					guiGridListSetSelectedItem(settings.gridlist[1], 12, 1)
				end
			end
		end
	end
	
	altSettings.button[1] = guiCreateButton(10, 303, 418, 44, "Select Setting", false, altSettings.window[1])
	guiSetFont(altSettings.button[1], "default-bold-small")
	altSettings.button[2] = guiCreateButton(10, 353, 418, 44, "Exit Window", false, altSettings.window[1])
	
	function tempSave()
		local row, col = guiGridListGetSelectedItem(altSettings.gridlist[1])
		if (row ~= -1) and (col ~= -1) then
			if (settingID == 2) then
				settingsTable[12][2] = guiGridListGetItemText(altSettings.gridlist[1], row, 1)
				settingID = 0
				displayAlternateSettingsMenu()
			end
		else
			outputChatBox("Select a setting from the list.", 245, 20, 20, false)
		end
	end
	
	addEventHandler("onClientGUIClick", altSettings.button[1], tempSave, false)
	addEventHandler("onClientGUIDoubleClick", altSettings.gridlist[1], tempSave, false)
	addEventHandler("onClientGUIClick", altSettings.button[2], displayAlternateSettingsMenu, false)
end

settings = {
    window = {},
    gridlist = {},
    button = {}
}

local function displaySettingsMenu()
	if (isElement(settings.window[1])) then
		destroyElement(settings.window[1])
		
		if (isElement(altSettings.window[1])) then
			destroyElement(altSettings.window[1])
		end
		
		showCursor(false)
		return
	end
	
	settings.window[1] = guiCreateWindow(629, 344, 438, 409, "Game Settings", false)
	guiWindowSetSizable(settings.window[1], false)
	
	settings.gridlist[1] = guiCreateGridList(10, 26, 418, 271, false, settings.window[1])
	guiGridListAddColumn(settings.gridlist[1], "Setting", 0.8)
	guiGridListAddColumn(settings.gridlist[1], "Enabled", 0.1)
	
	for i,v in ipairs(settingsTable) do
		local row = guiGridListAddRow(settings.gridlist[1])
		guiGridListSetItemText(settings.gridlist[1], row, 1, v[1], false, false)
		guiGridListSetItemText(settings.gridlist[1], row, 2, (tostring(v[2]) == "0" and "None" or tostring(v[2])), false, false)
		
		if (tostring(v[2]) == "0") then
			guiGridListSetItemColor(settings.gridlist[1], row, 2, 245, 20, 20, 255)
		else
			guiGridListSetItemColor(settings.gridlist[1], row, 2, 20, 245, 20, 255)
		end
	end
	
	settings.button[1] = guiCreateButton(10, 303, 418, 44, "Save Settings", false, settings.window[1])
	guiSetFont(settings.button[1], "default-bold-small")
	settings.button[2] = guiCreateButton(10, 353, 418, 44, "Exit Window", false, settings.window[1])
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", settings.button[1],
		function()
			for i,v in ipairs(settingsTable) do
				postSettingsTable[i] = v[2]
			end
			
			triggerEvent(":_placeTheRealSettings_:", localPlayer, postSettingsTable)
			
			for i,v in ipairs(postSettingsTable) do
				local state = (v == "0" and false or true)
				if (i == 1) then
					triggerEvent(":_setChatbubbles_:", localPlayer, state) --todo: the rest of the features here too
				elseif (i == 15) then
					setBlurLevel((state and 36 or 0))
				else
					local state = (v == "0" and false or true)
					triggerEvent(":_setShader_:", localPlayer, i, state, v)
				end
			end
			
			displaySettingsMenu()
			outputChatBox("Game settings have been saved for this session.", 20, 245, 20, false)
		end, false
	)
	
	addEventHandler("onClientGUIDoubleClick", settings.gridlist[1],
		function()
			local row, col = guiGridListGetSelectedItem(source)
			if (row ~= -1) and (col ~= -1) then
				local text = guiGridListGetItemText(source, row, 1)
				if (text == "Feature: Walking Style") then
					settingID = 1
					displayAlternateSettingsMenu()
				elseif (text == "Shader:  FXAA Filtering") then
					settingID = 2
					displayAlternateSettingsMenu()
				else
					if (guiGridListGetItemText(source, row, 2) == "None") then
						guiGridListSetItemText(source, row, 2, "1", false, false)
						guiGridListSetItemColor(source, row, 2, 20, 245, 20, 255)
						settingsTable[row+1][2] = "1"
					else
						guiGridListSetItemText(source, row, 2, "None", false, false)
						guiGridListSetItemColor(source, row, 2, 245, 20, 20, 255)
						settingsTable[row+1][2] = "0"
					end
				end
			else
				outputChatBox("Select a setting from the list.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", settings.button[2], displaySettingsMenu, false)
end

addEvent(":_displaySettingsMenu_:", true)
addEventHandler(":_displaySettingsMenu_:", root,
	function()
		displaySettingsMenu()
	end
)

-- Commands
addCommandHandler("settings",
	function(cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		displaySettingsMenu()
	end
)