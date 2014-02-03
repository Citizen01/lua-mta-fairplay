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

local localLanguages = {}
local sx, sy = guiGetScreenSize()

local function displayLanguageSelection()
	if (isElement(g_lang_window)) then
		destroyElement(g_lang_window)
		showCursor(false)
		return
	end
	
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	local lang1, skill1 = getPlayerLanguage(localPlayer, 1)
	local lang2, skill2 = getPlayerLanguage(localPlayer, 2)
	local lang3, skill3 = getPlayerLanguage(localPlayer, 3)
	
	g_lang_window = guiCreateWindow(721, 391, 194, 212, "Select Language", false)
	guiWindowSetSizable(g_lang_window, false)
	
	g_lang_radio1 = guiCreateRadioButton(14, 32, 118, 19, getLanguageName(lang1) .. " (" .. skill1 .. "%)", false, g_lang_window)
	guiRadioButtonSetSelected(g_lang_radio1, true)
	
	if (not lang2) or (lang2 ~= 0) then
		g_lang_radio2 = guiCreateRadioButton(14, 61, 118, 19, getLanguageName(lang2) .. " (" .. skill2 .. "%)", false, g_lang_window)
	else
		g_lang_radio2 = guiCreateRadioButton(14, 61, 118, 19, "No language", false, g_lang_window)
		guiSetEnabled(g_lang_radio2, false)
	end
	
	if (not lang3) or (lang3 ~= 0) then
		g_lang_radio3 = guiCreateRadioButton(14, 90, 118, 19, getLanguageName(lang3) .. " (" .. skill3 .. "%)", false, g_lang_window)
	else
		g_lang_radio3 = guiCreateRadioButton(14, 90, 118, 19, "No language", false, g_lang_window)
		guiSetEnabled(g_lang_radio3, false)
	end
	
	g_lang_set = guiCreateButton(14, 123, 165, 35, "Set as Main Language", false, g_lang_window)
	guiSetFont(g_lang_set, "default-bold-small")
	
	g_lang_exit = guiCreateButton(14, 164, 165, 35, "Exit Menu", false, g_lang_window)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", g_lang_exit, displayLanguageSelection, false)
	addEventHandler("onClientGUIClick", g_lang_set,
		function()
			if (guiRadioButtonGetSelected(g_lang_radio1)) then
				displayLanguageSelection()
				return
			else
				if (guiRadioButtonGetSelected(g_lang_radio2)) then
					setElementData(localPlayer, "roleplay:languages.1", lang2, true)
					setElementData(localPlayer, "roleplay:languages.1skill", skill2, true)
					setElementData(localPlayer, "roleplay:languages.2", lang1, true)
					setElementData(localPlayer, "roleplay:languages.2skill", skill1, true)
				elseif (guiRadioButtonGetSelected(g_lang_radio3)) then
					setElementData(localPlayer, "roleplay:languages.1", lang3, true)
					setElementData(localPlayer, "roleplay:languages.1skill", skill3, true)
					setElementData(localPlayer, "roleplay:languages.3", lang2, true)
					setElementData(localPlayer, "roleplay:languages.3skill", skill2, true)
					setElementData(localPlayer, "roleplay:languages.2", lang1, true)
					setElementData(localPlayer, "roleplay:languages.2skill", skill1, true)
				end
				displayLanguageSelection()
				triggerServerEvent(":_doSaveChar_:", localPlayer, localPlayer, false)
			end
		end, false
	)
end

addEvent(":_closeLanguageMenu_:", true)
addEventHandler(":_closeLanguageMenu_:", root,
	function(bRedo)
		if (isElement(g_lang_window)) then
			destroyElement(g_lang_window)
			showCursor(false)
			if (bRedo) then
				displayLanguageSelection()
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("F3", "down", displayLanguageSelection)
	end
)