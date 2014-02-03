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
local marqueeX = sx
local isTooltip = false
local g_motd = nil
local g_area = false
local g_motdvis = true
local g_alphamul = 255
local soundplaying = false

local skins = {
	["whiteMale"] = {1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 268, 272, 290, 291, 292, 295, 299, 303, 305, 306, 307, 308, 309, 312},
	["blackMale"] = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262, 269, 270, 271, 293, 296, 297, 300, 301, 302, 310, 311},
	["asianMale"] = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294},
	["whiteFemale"] = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298},
	["blackFemale"] = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256, 304},
	["asianFemale"] = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
}

local texts = {
	["warnings"] = {
		["resolution"] = "WARNING: You are currently running on a resolution that we don't exclusively support. We suggest switching to 1024x768 resolution or higher for better support."
	},
	["notifications"] = {
		["motd"] = "MESSAGE OF THE DAY: "
	},
	["errors"] = {
		["error-submit"] = "ERROR: An error occured when trying to send the form. Please reconnect\nand retry.",
		["error-name"] = "ERROR: The name has to be at least 2 characters long\nand be less than 25 characters long.",
		["error-namespace"] = "ERROR: The lastname cannot end with a space character.",
		["error-namecapital"] = "ERROR: The names have to start with a capital letter.",
		["error-name-invchar"] = "ERROR: The character name has invalid characters in it. Make\nsure you only pass in regular letters. Also, firstname and lastname\nhave to be separated with a space character.",
		["error-name-restricted"] = "ERROR: The character name is restricted and cannot be used.",
		["error-name-inuse"] = "ERROR: The character name is already in use. Think of another\nname!",
		["error-desc"] = "ERROR: The description has to be at least 100 characters long\nand be less than 500 characters long."
	},
	["tips"] = {
		["username"] = "USERNAME\nA username has to be at least 3 characters long and be smaller than 20 characters. Some usernames are restricted. It cannot contain only numbers. It can only contain lowercase and uppercase letters as well as numbers and a few special characters such as _?!",
		["password"] = "PASSWORD\nA password has to be at least 6 characters long and be smaller than 30 characters. Simple passwords are restricted. It has to contain numbers and letters. It can only contain lowercase and uppercase letters, numbers and a few special characters such as _?!*",
		["username-illegal-characters"] = "SUBMIT FAILED\nApparently your username contains illegal characters. It cannot contain only numbers. It can only contain lowercase and uppercase letters as well as numbers and a few special characters such as _?!",
		["password-illegal-characters"] = "SUBMIT FAILED\nApparently your password contains illegal characters. It has to contain numbers and letters. It can only contain lowercase and uppercase letters, numbers and a few special characters such as _?!*",
		["username-restricted"] = "SUBMIT FAILED\nApparently your username is restricted and cannot be registered or logged in with.",
		["password-restricted"] = "SUBMIT FAILED\nApparently your password is restricted and cannot be registered or logged in with.",
		["username-length"] = "SUBMIT FAILED\nYour username is either too short or too long. Minimum amount of characters is 3, and maximum is 20.",
		["password-length"] = "SUBMIT FAILED\nYour password is either too short or too long. Minimum amount of characters is 6, and maximum is 30.",
		["empty"] = "SUBMIT FAILED\nApparently you haven't passed in enough information. Please fill in your login information to proceed.",
		["submit-invalid"] = "INVALID CREDIENTIALS\nThe username and/or password was wrong, or if you're registering, the username is already in use and you have to try to suit yourself a new username.",
		["register-success"] = "REGISTER SUCCESS\nA new account has been created with those details. Please log in in order to proceed in the process.",
		["already-logged-in"] = "LOGIN FAILED\nThis account is already logged in in-game. Log out from the account before logging in again."
	}
}

local illegalUsernames = {"fuck", "dick", "ass", "hole", "azz", "zz", "bitch", "root", "admin", "administrator", "mod", "moderator", "administration", "moderation", "fairplay", "fairplaygaming", "fpg", "fairplaygamingcommunity", "socialzgamingcommunity", "sgc", "mtateam", "mta", "mtasa", "multitheftauto", "justin bieber"}
local illegalPasswords = {"123asd", "123456", "987654", "asd123", "123987", "987123", "asdasd", "asdfgh", "lollol", "lol123", "123lol", "lolled", "lmfao1", "111111", "omglol", "social", "socialz"}
local illegalCharacters = {"'", "/", "\\", "&", "+", "$", "#", "@"}

function guiCenterElement(element, offsetX, offsetY)
	local wx, wy = guiGetSize(element, false)
	local x, y = (sx-wx)/2+(offsetX and offsetX or 0), (sy-wy)/2+(offsetY and offsetY or 0)
	guiSetPosition(element, x, y, false)
end

local function displayMenu()
	if (not isClientPlaying(localPlayer)) then return end
	if (isElement(g_menu_window)) then
		destroyElement(g_menu_window)
		showCursor(false, false)
		return
	end
	
	g_menu_window = guiCreateWindow(0, 0, 271, 165, "Game Menu", false)
	guiCenterElement(g_menu_window)
	guiWindowSetSizable(g_menu_window, false)
	guiSetProperty(g_menu_window, "AlwaysOnTop", "true")
	
	g_menu_btn1 = guiCreateButton(10, 29, 251, 35, "Return to Selection", false, g_menu_window)
	g_menu_btn2 = guiCreateButton(10, 74, 251, 35, "Game Settings", false, g_menu_window)
	g_menu_btn3 = guiCreateButton(10, 119, 251, 35, "Close Menu", false, g_menu_window)
	
	addEventHandler("onClientGUIClick", g_menu_btn1,
		function()
			triggerServerEvent(":_finishForceExit_:", localPlayer)
			displayMenu()
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_menu_btn2, displayConfigMenu, false)
	addEventHandler("onClientGUIClick", g_menu_btn3, displayMenu, false)
	
	showCursor(true)
end
addCommandHandler("menu", displayMenu)

function displayConfigMenu()
	if (isElement(g_config_window)) then
		destroyElement(g_config_window)
		guiSetProperty(g_menu_window, "AlwaysOnTop", "true")
		guiSetEnabled(g_menu_window, true)
		guiBringToFront(g_menu_window)
		return
	end
	
	guiSetEnabled(g_menu_window, false)
	guiSetProperty(g_menu_window, "AlwaysOnTop", "false")
	guiMoveToBack(g_menu_window)
	
	g_config_window = guiCreateWindow((sx-279)/2, (sy-193)/2, 279, 189, "Change Settings", false)
	guiWindowSetSizable(g_config_window, false)
	guiSetProperty(g_config_window, "AlwaysOnTop", "true")
	guiSetAlpha(g_config_window, 0.90)
	
	guiBringToFront(g_config_window)

	g_config_check_watershader = guiCreateCheckBox(10, 28, 165, 15, "Enable water shader", false, false, g_config_window)
	guiSetFont(g_config_check_watershader, "default-bold-small")
	guiCheckBoxSetSelected(g_config_check_watershader, (exports['roleplay-accounts']:getAccountSetting(localPlayer, "4") == 1 and true or false))
	
	g_config_check_nametags = guiCreateCheckBox(10, 48, 165, 15, "Enable nametags", false, false, g_config_window)
	guiSetFont(g_config_check_nametags, "default-bold-small")
	guiCheckBoxSetSelected(g_config_check_nametags, (exports['roleplay-accounts']:getAccountSetting(localPlayer, "5") == 1 and true or false))
	
	g_config_check_gtadefault = guiCreateCheckBox(10, 68, 165, 15, "Enable GTA default radio", false, false, g_config_window)
	guiSetFont(g_config_check_gtadefault, "default-bold-small")
	guiCheckBoxSetSelected(g_config_check_gtadefault, (exports['roleplay-accounts']:getAccountSetting(localPlayer, "6") == 1 and true or false))
	
	g_config_check_customs = guiCreateCheckBox(10, 88, 259, 15, "Enable listening to other custom radios", false, false, g_config_window)
	guiSetFont(g_config_check_customs, "default-bold-small")
	guiCheckBoxSetSelected(g_config_check_customs, (exports['roleplay-accounts']:getAccountSetting(localPlayer, "7") == 1 and true or false))
	
	g_config_check_bubbles = guiCreateCheckBox(10, 108, 259, 15, "Enable chatbubbles", false, false, g_config_window)
	guiSetFont(g_config_check_bubbles, "default-bold-small")
	guiCheckBoxSetSelected(g_config_check_bubbles, (exports['roleplay-accounts']:getAccountSetting(localPlayer, "8") == 1 and true or false))
	
	g_config_button_save = guiCreateButton(10, 145, 259, 31, "Save Configuration", false, g_config_window)
	
	addEventHandler("onClientGUIClick", g_config_button_save,
		function()
			triggerServerEvent(":_updateAccountSettingsF10_:", localPlayer, guiCheckBoxGetSelected(g_config_check_watershader), guiCheckBoxGetSelected(g_config_check_nametags), guiCheckBoxGetSelected(g_config_check_gtadefault), guiCheckBoxGetSelected(g_config_check_customs), guiCheckBoxGetSelected(g_config_check_bubbles))
			triggerEvent(":_updateAccountSettings_:", localPlayer)
			outputChatBox("Settings are now saved.", 20, 245, 20, false)
			displayConfigMenu()
		end, false
	)
end

local function guiSubmitLogin()
	local username = guiGetText(g_login_username)
	local password = guiGetText(g_login_password)
	if (username) and (password) then
		if (username == "" or password == "") then
			isTooltip = 9
			return
		end
		
		if (string.find(username, "[%a%d_!?]")) and (not string.find(username, "[%s]")) then
			for i,v in pairs(illegalUsernames) do
				if (string.lower(username) == v) then
					isTooltip = 7
					break
				end
			end
			if (string.find(password, "[%a%d_!?*]")) and (not string.find(password, "[%s]")) then
				for i,v in pairs(illegalPasswords) do
					if (string.lower(password) == v) then
						isTooltip = 8
						break
					end
				end
				
				if (not string.find(password, "[%a%d]")) then
					isTooltip = 4
					return
				end
				
				for i,v in pairs(illegalCharacters) do
					username = string.gsub(username, v, "")
					password = string.gsub(password, v, "")
				end
				
				if (string.len(username) >= 3) and (string.len(username) <= 20) then
					if (string.len(password) >= 6) and (string.len(password) <= 30) then
						guiSetEnabled(g_login_username, false)
						guiSetEnabled(g_login_password, false)
						guiSetEnabled(g_login_submit, false)
						triggerServerEvent(":_submitLogin_:", localPlayer, _base64encode(username), md5(password))
					else
						isTooltip = 6
					end
				else
					isTooltip = 5
				end
			else
				isTooltip = 4
			end
		else
			isTooltip = 3
		end
	end
end

local function dxDisplayTooltip()
	if (not isTooltip) then return end
	local gx, gy = guiGetPosition(g_login_username, false)
	local text = ""
	
	dxDrawRectangle(gx+250, gy, 351, 126, tocolor(0, 0, 0, 0.2*255))
	
	if (isTooltip == 1) then
		text = texts["tips"]["username"]
	elseif (isTooltip == 2) then
		text = texts["tips"]["password"]
	elseif (isTooltip == 3) then
		text = texts["tips"]["username-illegal-characters"]
	elseif (isTooltip == 4) then
		text = texts["tips"]["password-illegal-characters"]
	elseif (isTooltip == 5) then
		text = texts["tips"]["username-length"]
	elseif (isTooltip == 6) then
		text = texts["tips"]["password-length"]
	elseif (isTooltip == 7) then
		text = texts["tips"]["username-restricted"]
	elseif (isTooltip == 8) then
		text = texts["tips"]["password-restricted"]
	elseif (isTooltip == 9) then
		text = texts["tips"]["empty"]
	elseif (isTooltip == 10) then
		text = texts["tips"]["register-success"]
	elseif (isTooltip == 11) then
		text = texts["tips"]["submit-invalid"]
	elseif (isTooltip == 12) then
		text = texts["tips"]["already-logged-in"]
	end
	
	dxDrawText(text, gx+271, gy+21, gx+592, gy+111, tocolor(0, 0, 0, 0.2*255), 1.0, "default-bold", "left", "top", true, true, false, false, false)
	dxDrawText(text, gx+270, gy+20, gx+591, gy+110, (isTooltip ~= 10 and tocolor(250, 250, 250, 1.0*255) or tocolor(50, 250, 50, 1.0*255)), 1.0, "default-bold", "left", "top", true, true, false, false, false)
end

function dxDisplayCommon()
	if (marqueeX > -dxGetTextWidth(texts["warnings"]["resolution"])) then
		marqueeX = marqueeX-1.3
	else
		marqueeX = sx
	end
	
	-- Full background
	if (g_alphamul > 0) then
		dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 0.4*255), postGUI)
		--dxDrawRectangle(0, 0, sx, sy, tocolor(80, 190, 220, g_alphamul)) --dat old fuckin bg
	end
	
	if (g_motdvis) then
		-- Logo
		if (sx >= 1024 and sx < 1680) then
			dxDrawImage((sx-350)/2, (sy-350)/2-210, 350, 350, "images/logo.png")
		elseif (sx >= 1680) then
			dxDrawImage((sx-350)/2, (sy-350)/2-250, 350, 350, "images/logo.png")
		end
		
		-- MOTD background
		dxDrawRectangle(0, 0, sx, 100, tocolor(0, 0, 0, 255), postGUI)
		--dxDrawRectangle(0, 0, sx, 50, tocolor(0, 0, 0, 0.20*255))
		dxDrawText(texts["notifications"]["motd"] .. (g_motd and g_motd or "Sadly, someone made a mistake and forgot to set a MOTD message - so, nothing to announce! :-("), marqueeX, 18, sx-17, 35, tocolor(0, 0, 0, 0.2*255), 1.0, "default-bold", "left", "top", true, false, false, false, true)
		dxDrawText(texts["notifications"]["motd"] .. (g_motd and g_motd or "Sadly, someone made a mistake and forgot to set a MOTD message - so, nothing to announce! :-("), marqueeX, 17, sx-17, 35, tocolor(250, 250, 250, 255), 1.0, "default-bold", "left", "top", true, false, false, false, true)
		--dxDrawRectangle(0, 0, 17, 50, tocolor(64, 152, 176, 255))
		dxDrawRectangle(0, 0, 17, 100, tocolor(0, 0, 0, 255), postGUI)
		
		-- Warning background
		if (sx < 1024) then
			dxDrawRectangle(0, 52, sx, 50, tocolor(190, 35, 35, 0.80*255))
			dxDrawText(texts["warnings"]["resolution"], marqueeX, 71, sx-17, 99, tocolor(0, 0, 0, 0.2*255), 1.0, "default-bold", "left", "top", true, false, false, false, true)
			dxDrawText(texts["warnings"]["resolution"], marqueeX, 70, sx-17, 100, tocolor(250, 250, 250, 255), 1.0, "default-bold", "left", "top", true, false, false, false, true)
			dxDrawRectangle(0, 52, 17, 50, tocolor(168, 66, 72, 255))
		end
		
		dxDrawRectangle(0, sy-100, sx, 100, tocolor(0, 0, 0, 255), postGUI)
	else
		if (g_alphamul > 0) then
			g_alphamul = g_alphamul-2
		end
	end
	
	if (not g_area) then
		-- Login background
		dxDrawRectangle(0, (sy-150)/2, sx, 175, tocolor(0, 0, 0, 0.4*255))
		dxDrawRectangle((sx-250)/2, (sy-150)/2, 250, 175, tocolor(0, 0, 0, 0.45*255))
	end
end

local function guiDisplayLogin()
	if (isElement(g_login_username)) then
		destroyElement(g_login_username)
		destroyElement(g_login_password)
		destroyElement(g_login_submit)
		showCursor(false, false)
		removeEventHandler("onClientRender", root, dxDisplayCommon)
		removeEventHandler("onClientRender", root, dxDisplayTooltip)
		return
	end
	
	g_login_username = guiCreateEdit(0, 0, 200, 35, "", false)
	guiCenterElement(g_login_username, 0, -33)
	guiEditSetMaxLength(g_login_username, 25)
	
	g_login_password = guiCreateEdit(0, 0, 200, 35, "", false)
	guiCenterElement(g_login_password, 0, 13)
	guiEditSetMasked(g_login_password, true)
	guiEditSetMaxLength(g_login_password, 30)
	
	g_login_submit = guiCreateButton(0, 0, 200, 35, "LOG IN or REGISTER", false)
	guiCenterElement(g_login_submit, 0, 58)
	
	addEventHandler("onClientGUIClick", g_login_username,
		function()
			isTooltip = 1
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_login_password,
		function()
			isTooltip = 2
		end, false
	)
	
	addEventHandler("onClientKey", root,
		function(button, pressOrRelease)
			if (isClientLoggedIn(localPlayer)) then return end
			if ((button == "tab") and (pressOrRelease)) then
				if (isTooltip == 1) then
					isTooltip = 2
				elseif (isTooltip == 2) then
					isTooltip = 1
				end
			end
		end
	)
	
	addEventHandler("onClientGUIAccepted", g_login_password,
		function(editBox)
			if (isClientLoggedIn(localPlayer)) then return end
			guiSubmitLogin()
		end
	)
	
	g_area = false
	addEventHandler("onClientRender", root, dxDisplayCommon)
	addEventHandler("onClientRender", root, dxDisplayTooltip)
	addEventHandler("onClientGUIClick", g_login_submit, guiSubmitLogin, false)
	
	showCursor(true, true)
end

addEvent(":_doRegisterSuccess_:", true)
addEventHandler(":_doRegisterSuccess_:", root,
	function()
		isTooltip = 10
		guiSetText(g_login_username, "")
		guiSetText(g_login_password, "")
		guiSetEnabled(g_login_username, true)
		guiSetEnabled(g_login_password, true)
		guiSetEnabled(g_login_submit, true)
	end
)

addEvent(":_itsackdchardammit_:", true)
addEventHandler(":_itsackdchardammit_:", root,
	function()
		guiSetEnabled(g_selection_select, false)
		guiSetEnabled(g_selection_create, false)
		guiSetEnabled(g_selection_delete, false)
		guiSetEnabled(g_selection_gridlist, false)
	end
)

function dxDisplayCKWarning()
	local wrnmsg = "That character has been character killed. Please select or create another one."
	dxDrawText(wrnmsg, (sx-dxGetTextWidth(wrnmsg))/2, (sy-dxGetFontHeight(wrnmsg))/2-115, sx, sy, tocolor(245, 245, 245, 240))
end

function guiDisplayCharacterScreen(fromLogin)
	if (isElement(g_selection_select)) then
		destroyElement(g_selection_select)
		destroyElement(g_selection_create)
		destroyElement(g_selection_delete)
		destroyElement(g_selection_gridlist)
		if (isElement(g_delete_window)) then destroyElement(g_delete_window) end
		showCursor(false, false)
		g_area = false
		removeEventHandler("onClientRender", root, dxDisplayCommon)
		return
	end
	
	forceCloseMessages()
	
	g_selection_select = guiCreateButton(0, 0, 203, 45, "Choose Character", false)
	guiCenterElement(g_selection_select, 240, -51)
	guiSetAlpha(g_selection_select, 0.80)
	
	g_selection_create = guiCreateButton(0, 0, 203, 45, "Create Character", false)
	guiCenterElement(g_selection_create, 240, 0)
	guiSetAlpha(g_selection_create, 0.80)
	
	g_selection_delete = guiCreateButton(0, 0, 203, 45, "Delete Character", false)
	guiCenterElement(g_selection_delete, 240, 51)
	guiSetAlpha(g_selection_delete, 0.80)
	
	g_selection_gridlist = guiCreateGridList(0, 0, 540, 200, false)
	guiCenterElement(g_selection_gridlist, -137, 27)
	guiSetAlpha(g_selection_gridlist, 0.80)
	
	guiGridListAddColumn(g_selection_gridlist, "character name", 0.3)
	guiGridListAddColumn(g_selection_gridlist, "gender", 0.12)
	guiGridListAddColumn(g_selection_gridlist, "race", 0.12)
	guiGridListAddColumn(g_selection_gridlist, "last login", 0.4)
	
	triggerServerEvent(":_fetchUserCharacters_:", localPlayer)
	
	local function setCurrentCharacter()
		local row = guiGridListGetSelectedItem(g_selection_gridlist)
		if (row ~= -1) then
			local _, isCK = guiGridListGetItemColor(g_selection_gridlist, row, 1)
			if (isCK == 255) then
				if (isTimer(dxckwrn)) then
					killTimer(dxckwrn)
					removeEventHandler("onClientRender", root, dxDisplayCKWarning)
				end
				
				guiSetEnabled(g_selection_select, false)
				guiSetEnabled(g_selection_create, false)
				guiSetEnabled(g_selection_delete, false)
				guiSetEnabled(g_selection_gridlist, false)
				triggerServerEvent(":_setCurrentCharacter_:", localPlayer, guiGridListGetItemText(g_selection_gridlist, row, 1):gsub(" ", "_"))
			else
				outputChatBox("That character has been character killed. Please select or create another one.", 245, 20, 20, false)
				if (not isTimer(dxckwrn)) then
					addEventHandler("onClientRender", root, dxDisplayCKWarning)
					dxckwrn = setTimer(function()
						removeEventHandler("onClientRender", root, dxDisplayCKWarning)
					end, 7000, 1)
				else
					resetTimer(dxckwrn)
				end
			end
		end
	end
	addEventHandler("onClientGUIDoubleClick", g_selection_gridlist, setCurrentCharacter, false)
	addEventHandler("onClientGUIClick", g_selection_select, setCurrentCharacter, false)
	
	addEventHandler("onClientGUIClick", g_selection_create, guiDisplayCharacterCreation, false)
	
	addEventHandler("onClientGUIClick", g_selection_delete,
		function()
			local row = guiGridListGetSelectedItem(g_selection_gridlist)
			if (row ~= -1) then
				guiSetEnabled(g_selection_select, false)
				guiSetEnabled(g_selection_create, false)
				guiSetEnabled(g_selection_delete, false)
				guiSetEnabled(g_selection_gridlist, false)
				
				g_delete_window = guiCreateWindow(715, 472, 274, 136, "ARE YOU SURE?", false)
				guiCenterElement(g_delete_window)
				guiWindowSetSizable(g_delete_window, false)
				guiWindowSetMovable(g_delete_window, false)
				guiBringToFront(g_delete_window)
				
				g_delete_label = guiCreateLabel(8, 28, 256, 49, "Deleting this character will cause it to be permanently deleted. Are you sure of this action?", false, g_delete_window)
				guiSetFont(g_delete_label, "default-bold-small")
				guiLabelSetHorizontalAlign(g_delete_label, "center", true)
				
				g_delete_deletebtn = guiCreateButton(18, 87, 112, 36, "DELETE", false, g_delete_window)
				guiSetFont(g_delete_deletebtn, "default-bold-small")
				
				g_delete_cancelbtn = guiCreateButton(140, 87, 114, 36, "CANCEL", false, g_delete_window)
				guiSetFont(g_delete_cancelbtn, "default-bold-small")
				
				addEventHandler("onClientGUIClick", g_delete_deletebtn,
					function()
						triggerServerEvent(":_doDeleteCharacter_:", localPlayer, guiGridListGetItemText(g_selection_gridlist, row, 1):gsub(" ", "_"))
						guiSetEnabled(g_selection_select, true)
						guiSetEnabled(g_selection_create, true)
						guiSetEnabled(g_selection_delete, true)
						guiSetEnabled(g_selection_gridlist, true)
						destroyElement(g_delete_window)
					end, false
				)
				
				addEventHandler("onClientGUIClick", g_delete_cancelbtn,
					function()
						guiSetEnabled(g_selection_select, true)
						guiSetEnabled(g_selection_create, true)
						guiSetEnabled(g_selection_delete, true)
						guiSetEnabled(g_selection_gridlist, true)
						destroyElement(g_delete_window)
					end, false
				)
			end
		end, false
	)
	
	
	g_area = true
	addEventHandler("onClientRender", root, dxDisplayCommon)
	fadeCamera(true, 1.5)
	
	if (not fromLogin) then
		startView()
	end
	
	if (not soundplaying) then
		--
		--  Mitis - Life of Sin
		--  Find Mitis and his music on Facebook at http://www.facebook.com/mitismusic and on SoundCloud at https://soundcloud.com/mitis
		--  This music is not owned or created by FairPlay Gaming, we're using it as he agreed on it
		--
		mitis = playSound("http://fairplaymta.net/files/LICENSED_mitis_life_of_sin.mp3", true)
		setSoundVolume(mitis, 0.05)
		soundplaying = true
	end
	
	showCursor(true, true)
end

addEvent(":_spawnPlayerSuccess_:", true)
addEventHandler(":_spawnPlayerSuccess_:", root,
	function(x, y, z, newOrNot)
		if (isElement(g_selection_select)) then
			guiDisplayCharacterScreen()
		end
		
		if (isElement(g_creation_label_name)) then
			guiDisplayCharacterCreation()
		end
		
		g_area = true
		g_motdvis = false
		g_alphamul = 255
		addEventHandler("onClientRender", root, dxDisplayCommon)
		
		timingalpha = setTimer(function()
			if (g_alphamul <= 0) then
				stopView()
				killTimer(timingalpha)
				setElementPosition(localPlayer, x, y, z)
				fadeCamera(true, 2.5)
				
				if (newOrNot == true) then
					triggerEvent(":_displayTutorial_:", localPlayer, x, y, z)
				else
					setCameraTarget(localPlayer)
					
					setTimer(function()
						showChat(true)
					end, 1000, 1)
					
					triggerEvent(":_stopMitis_:", localPlayer)
					triggerEvent(":_runRealPlayTimer_:", localPlayer)
				end
				
				removeEventHandler("onClientRender", root, dxDisplayCommon)
				g_motdvis = true
				g_alphamul = 255
			end
		end, 50, 0)
	end
)

-- Just some cool things
local _KSisTimer = isTimer
local _KSresetTimer = resetTimer
local _SsetTimer = setTimer
local _SBtriggerServerEvent = triggerServerEvent
addEvent(":_runRealPlayTimer_:", true)
addEventHandler(":_runRealPlayTimer_:", root,
	function()
		if (_KSisTimer(_XamazingTimer)) then _KSresetTimer(_XamazingTimer) return end
		_XamazingTimer = _SsetTimer(function()
			if (isClientPlaying(localPlayer)) then
				_SBtriggerServerEvent(":_raiseGameHour_:", localPlayer)
			end
		end, 60000, 0)
	end
)

-- Stop playing the MitiS song ok
addEvent(":_stopMitis_:", true)
addEventHandler(":_stopMitis_:", root,
	function()
		killit = setTimer(function()
			if (getSoundVolume(mitis) > 0) then
				setSoundVolume(mitis, getSoundVolume(mitis)-0.01)
			else
				killTimer(killit)
				stopSound(mitis)
				soundplaying = false
			end
		end, 225, 0)
	end
)

addEvent(":_addUserCharacters_:", true)
addEventHandler(":_addUserCharacters_:", root,
	function(result, rows)
		if (not isElement(g_selection_gridlist)) then return end
		if (rows > 0) then
			for result,row in pairs(result) do
				local rowid = guiGridListAddRow(g_selection_gridlist)
				guiGridListSetItemText(g_selection_gridlist, rowid, 1, row["characterName"]:gsub("_", " "), false, false)
				guiGridListSetItemText(g_selection_gridlist, rowid, 2, (row["gender"] == 0 and "Male" or "Female"), false, false)
				
				if (row["race"] == 0) then
					guiGridListSetItemText(g_selection_gridlist, rowid, 3, "White", false, false)
				elseif (row["race"] == 1) then
					guiGridListSetItemText(g_selection_gridlist, rowid, 3, "Black", false, false)
				elseif (row["race"] == 2) then
					guiGridListSetItemText(g_selection_gridlist, rowid, 3, "Asian", false, false)
				else
					guiGridListSetItemText(g_selection_gridlist, rowid, 3, "Unknown", false, false)
				end
				
				if (row["loginDate"] == "0") then
					guiGridListSetItemText(g_selection_gridlist, rowid, 4, "Never", false, false)
				else
					guiGridListSetItemText(g_selection_gridlist, rowid, 4, row["loginDate"], false, false)
				end
				
				if (row["cked"] == 1) then
					guiGridListSetItemColor(g_selection_gridlist, rowid, 1, 245, 20, 20, 230)
					guiGridListSetItemColor(g_selection_gridlist, rowid, 2, 245, 20, 20, 230)
					guiGridListSetItemColor(g_selection_gridlist, rowid, 3, 245, 20, 20, 230)
					guiGridListSetItemColor(g_selection_gridlist, rowid, 4, 245, 20, 20, 230)
				end
			end
		else
			guiSetEnabled(g_selection_select, false)
			guiSetEnabled(g_selection_delete, false)
		end
	end
)

addEvent(":_deleteCharacterSuccess_:", true)
addEventHandler(":_deleteCharacterSuccess_:", root,
	function()
		if (isElement(g_creation_label_name)) then guiDisplayCharacterCreation() end
		if (isElement(g_selection_select)) then guiDisplayCharacterScreen() end
		guiDisplayCharacterScreen()
		g_area = false
		removeEventHandler("onClientRender", root, dxDisplayCommon)
	end
)

local cweight = 0
local cheight = 0
local cage = 0
local gender_id = 0
local selected_model = 1
local g_creation = {
	window = {},
	edit = {},
	label = {},
	button = {},
	radiobutton = {},
	gridlist = {},
	memo = {},
	scrollbar = {},
	combobox = {}
}

function guiDisplayCharacterCreation()
	if (isElement(g_creation.window[1])) then
		destroyElement(g_creation.window[1])
		destroyElement(g_creation_error)
		showCursor(false, false)
		cage = 0
		cheight = 0
		cweight = 0
		gender_id = 0
		selected_model = 1
		rowie = -1
		g_area = false
		removeEventHandler("onClientRender", root, dxDisplayCommon)
		return
	end
	
	guiDisplayCharacterScreen()
	
	if (isTimer(dxckwrn)) then
		killTimer(dxckwrn)
		removeEventHandler("onClientRender", root, dxDisplayCKWarning)
	end
	
	g_creation_error = guiCreateLabel(0, 0, 385, 60, "", false)
	guiCenterElement(g_creation_error, 10, -90)
	guiSetFont(g_creation_error, "default-bold-small")
	guiSetVisible(g_creation_error, false)
	
	g_creation.window[1] = guiCreateWindow(0, 0, 571, 454, "Create Character", false)
	guiWindowSetSizable(g_creation.window[1], false)
	guiCenterElement(g_creation.window[1], 0, 170)
	guiSetProperty(g_creation.window[1], "AlwaysOnTop", "true")

	g_creation.label[1] = guiCreateLabel(15, 31, 198, 15, "name", false, g_creation.window[1])
	guiSetFont(g_creation.label[1], "default-bold-small")
	g_creation.edit[1] = guiCreateEdit(15, 51, 198, 28, "", false, g_creation.window[1])
	
	g_creation.label[2] = guiCreateLabel(15, 89, 198, 15, "gender", false, g_creation.window[1])
	guiSetFont(g_creation.label[2], "default-bold-small")
	
	g_creation.radiobutton[6] = guiCreateRadioButton(15, 108, 57, 16, "male", false, g_creation.window[1])
	guiSetFont(g_creation.radiobutton[6], "default-bold-small")
	guiRadioButtonSetSelected(g_creation.radiobutton[6], true)
	gender_id = 0
	
	g_creation.radiobutton[7] = guiCreateRadioButton(89, 108, 57, 16, "female", false, g_creation.window[1])
	guiSetFont(g_creation.radiobutton[7], "default-bold-small")
	
	g_creation.label[3] = guiCreateLabel(15, 130, 198, 15, "race", false, g_creation.window[1])
	guiSetFont(g_creation.label[3], "default-bold-small")
	
	g_creation.combobox[1] = guiCreateComboBox(13, 150, 204, 25*3, "select race...", false, g_creation.window[1])
	guiComboBoxAddItem(g_creation.combobox[1], "white")
	guiComboBoxAddItem(g_creation.combobox[1], "black")
	guiComboBoxAddItem(g_creation.combobox[1], "asian")
	guiComboBoxSetSelected(g_creation.combobox[1], 0)
	
	g_creation.label[4] = guiCreateLabel(15, 179, 198, 15, "age (16 yo)", false, g_creation.window[1])
	guiSetFont(g_creation.label[4], "default-bold-small")
	g_creation.scrollbar[1] = guiCreateScrollBar(10, 200, 209, 20, true, false, g_creation.window[1])
	
	g_creation.label[5] = guiCreateLabel(15, 230, 198, 15, "height (145 cm)", false, g_creation.window[1])
	guiSetFont(g_creation.label[5], "default-bold-small")
	g_creation.scrollbar[2] = guiCreateScrollBar(10, 250, 209, 20, true, false, g_creation.window[1])
	
	g_creation.label[6] = guiCreateLabel(15, 280, 198, 15, "weight (40 kg)", false, g_creation.window[1])
	guiSetFont(g_creation.label[6], "default-bold-small")
	g_creation.scrollbar[3] = guiCreateScrollBar(10, 301, 209, 20, true, false, g_creation.window[1])
	
	g_creation.label[7] = guiCreateLabel(15, 331, 198, 15, "language", false, g_creation.window[1])
	guiSetFont(g_creation.label[7], "default-bold-small")
	g_creation.gridlist[1] = guiCreateGridList(14, 352, 203, 92, false, g_creation.window[1])
	guiGridListAddColumn(g_creation.gridlist[1], "name", 0.8)
	
	for i,v in ipairs(exports['roleplay-chat']:getLanguages()) do
		if (i ~= 101) and (i ~= 666) then
			local row = guiGridListAddRow(g_creation.gridlist[1])
			guiGridListSetItemText(g_creation.gridlist[1], row, 1, exports['roleplay-chat']:getLanguages()[i][2], false, false)
		end
	end
	
	guiGridListSetSelectedItem(g_creation.gridlist[1], 0, 1)
	
	g_creation.label[8] = guiCreateLabel(235, 31, 198, 15, "look", false, g_creation.window[1])
	guiSetFont(g_creation.label[8], "default-bold-small")
	g_creation.gridlist[2] = guiCreateGridList(235, 52, 95, 168, false, g_creation.window[1])
	guiGridListAddColumn(g_creation.gridlist[2], "model", 0.6)
	guiGridListSetSortingEnabled(g_creation.gridlist[2], false)
	
	for i,v in ipairs(skins["whiteMale"]) do
		local row = guiGridListAddRow(g_creation.gridlist[2])
		guiGridListSetItemText(g_creation.gridlist[2], row, 1, v, false, false)
	end
	
	guiGridListSetSelectedItem(g_creation.gridlist[2], 0, 1)
	
	g_creation.label[9] = guiCreateLabel(235, 230, 198, 15, "bio", false, g_creation.window[1])
	guiSetFont(g_creation.label[9], "default-bold-small")
	g_creation.memo[1] = guiCreateMemo(234, 250, 327, 194, "", false, g_creation.window[1])
	
	g_creation.button[1] = guiCreateButton(440, 52, 121, 80, "Create", false, g_creation.window[1])
	g_creation.button[2] = guiCreateButton(440, 140, 121, 80, "Cancel", false, g_creation.window[1])
	
	-- Character Model
	selected_model = 1
	g_creation_model_image = guiCreateStaticImage(340, 53, 90, 90, "images/models/" .. selected_model .. ".png", false, g_creation.window[1])
	
	-- Events
	addEventHandler("onClientGUIClick", g_creation.radiobutton[6],
		function()
			if (gender_id == 0) then return end
			gender_id = 0
			guiGridListClear(g_creation.gridlist[2])
			
			local text = guiComboBoxGetItemText(g_creation.combobox[1], guiComboBoxGetSelected(g_creation.combobox[1]))
			
			for i,v in ipairs(skins[text .. (gender_id == 0 and "Male" or "Female")]) do
				local row = guiGridListAddRow(g_creation.gridlist[2])
				guiGridListSetItemText(g_creation.gridlist[2], row, 1, v, false, false)
			end
			
			selected_model = skins[text .. (gender_id == 0 and "Male" or "Female")][1]
			guiGridListSetSelectedItem(g_creation.gridlist[2], 0, 1)
			guiStaticImageLoadImage(g_creation_model_image, "images/models/" .. selected_model .. ".png")
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_creation.radiobutton[7],
		function()
			if (gender_id == 1) then return end
			gender_id = 1
			guiGridListClear(g_creation.gridlist[2])
			
			local text = guiComboBoxGetItemText(g_creation.combobox[1], guiComboBoxGetSelected(g_creation.combobox[1]))
			
			for i,v in ipairs(skins[text .. (gender_id == 0 and "Male" or "Female")]) do
				local row = guiGridListAddRow(g_creation.gridlist[2])
				guiGridListSetItemText(g_creation.gridlist[2], row, 1, v, false, false)
			end
			
			selected_model = skins[text .. (gender_id == 0 and "Male" or "Female")][1]
			guiGridListSetSelectedItem(g_creation.gridlist[2], 0, 1)
			guiStaticImageLoadImage(g_creation_model_image, "images/models/" .. selected_model .. ".png")
		end, false
	)
	
	addEventHandler("onClientGUIComboBoxAccepted", g_creation.combobox[1],
		function(comboBox)
			local text = guiComboBoxGetItemText(comboBox, guiComboBoxGetSelected(comboBox))
			guiGridListClear(g_creation.gridlist[2])
			
			for i,v in ipairs(skins[text .. (gender_id == 0 and "Male" or "Female")]) do
				local row = guiGridListAddRow(g_creation.gridlist[2])
				guiGridListSetItemText(g_creation.gridlist[2], row, 1, v, false, false)
			end
			
			selected_model = skins[text .. (gender_id == 0 and "Male" or "Female")][1]
			guiStaticImageLoadImage(g_creation_model_image, "images/models/" .. selected_model .. ".png")
			guiGridListSetSelectedItem(g_creation.gridlist[2], 0, 1)
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_creation.gridlist[2],
		function()
			local row, col = guiGridListGetSelectedItem(source)
			if (row == -1) or (col == -1) then return end
			selected_model = guiGridListGetItemText(source, row, col)
			guiStaticImageLoadImage(g_creation_model_image, "images/models/" .. selected_model .. ".png")
		end, false
	)
	
	addEventHandler("onClientKey", root,
		function(button, pressOrRelease)
			if (getClientState(localPlayer) == 1) or (not isElement(g_creation.window[1])) then return end
			if (pressOrRelease == false) then
				rowie = -1
				
				if (button == "arrow_d") then
					rowie = guiGridListGetSelectedItem(g_creation.gridlist[2])
					local maxRow = guiGridListGetRowCount(g_creation.gridlist[2])
					if (rowie < (maxRow-1)) then
						rowie = rowie+1
						guiGridListSetSelectedItem(g_creation.gridlist[2], rowie, 1)
					else
						rowie = maxRow-1
					end
				elseif (button == "arrow_u") then
					rowie = guiGridListGetSelectedItem(g_creation.gridlist[2])
					if (rowie ~= 0) then
						rowie = rowie-1
						guiGridListSetSelectedItem(g_creation.gridlist[2], rowie, 1)
					end
				else
					return
				end
				
				selected_model = guiGridListGetItemText(g_creation.gridlist[2], rowie, 1)
				guiStaticImageLoadImage(g_creation_model_image, "images/models/" .. selected_model .. ".png")
			end
		end
	)
	
	function isValidCharacterName(string)
		local foundSpace, valid = false, true
		local lastChar, current = ' ', ''
		for i=1,#string do
			local char = string.sub(string, i, i)
			if (char == ' ') then
				if (i == #string) then
					valid = false
					return false, texts["errors"]["error-namespace"]
				else
					foundSpace = true
				end
				
				if (#current < 2) then
					valid = false
					return false, texts["errors"]["error-name"]
				end
				current = ''
			elseif (lastChar == ' ') then
				if (char < 'A') or (char > 'Z') then
					valid = false
					return false, texts["errors"]["error-namecapital"]
				end
				current = current .. char
			elseif (char >= 'a' and char <= 'z') or (char >= 'A' and char <= 'Z') then
				current = current .. char
			else
				valid = false
				return false, texts["errors"]["error-name-invchar"]
			end
			lastChar = char
		end
		
		if (valid) and (foundSpace) and (#string < 25) and (#current >= 2) then
			return true
		else
			return false, texts["errors"]["error-name"]
		end
	end
	
	addEventHandler("onClientGUIClick", g_creation.button[1],
		function()
			local name = guiGetText(g_creation.edit[1]) -- Name
			local desc = guiGetText(g_creation.memo[1]) -- Description
			local gend = (guiRadioButtonGetSelected(g_creation.radiobutton[6]) and 0 or 1) -- Gender (0 = male, 1 = female)
			local race = tonumber(guiComboBoxGetSelected(g_creation.combobox[1])) -- Race (0 = white, 1 = black, 2 = asian)
			local row, col = guiGridListGetSelectedItem(g_creation.gridlist[1])
			local language = tonumber(row)+1
			local skin = tonumber(selected_model) -- Skin
			
			if (name) and (desc) and (gend) and (race) and (skin) and (language) then
				local boolean, message = isValidCharacterName(name)
				if (boolean) then
					for i,v in pairs(illegalUsernames) do
						if (string.find(name:lower(), v)) then
							if (not isElement(g_creation_error)) then return end
							guiSetText(g_creation_error, texts["errors"]["error-name-restricted"])
							guiSetVisible(g_creation_error, true)
							if (isTimer(errorTimer)) then resetTimer(errorTimer) end
							errorTimer = setTimer(function()
								if (not isElement(g_creation_error)) then return end
								guiSetVisible(g_creation_error, false)
							end, 10000, 1)
							triggerServerEvent(":_printCharacterError_:", localPlayer, name, v)
							break
						end
					end
					
					if (string.len(desc) >= 100) and (string.len(desc) <= 500) then
						if ((gend == 0) or (gend == 1)) and ((race == 0) or (race == 1) or (race == 2)) and (skin > 0) then
							triggerServerEvent(":_doCharacterCreate_:", localPlayer, name, desc, gend, race, skin, cage, cheight, cweight, language)
						else
							if (not isElement(g_creation_error)) then return end
							guiSetText(g_creation_error, texts["errors"]["error-submit"])
							guiSetVisible(g_creation_error, true)
							if (isTimer(errorTimer)) then resetTimer(errorTimer) return end
							errorTimer = setTimer(function()
								if (not isElement(g_creation_error)) then return end
								guiSetText(g_creation_error, "")
								guiSetVisible(g_creation_error, false)
							end, 10000, 1)
						end
					else
						if (not isElement(g_creation_error)) then return end
						guiSetText(g_creation_error, texts["errors"]["error-desc"])
						guiSetVisible(g_creation_error, true)
						if (isTimer(errorTimer)) then resetTimer(errorTimer) end
						errorTimer = setTimer(function()
							if (not isElement(g_creation_error)) then return end
							guiSetVisible(g_creation_error, false)
						end, 10000, 1)
					end
				else
					if (not isElement(g_creation_error)) then return end
					guiSetText(g_creation_error, message)
					guiSetVisible(g_creation_error, true)
					if (isTimer(errorTimer)) then resetTimer(errorTimer) end
					errorTimer = setTimer(function()
						if (not isElement(g_creation_error)) then return end
						guiSetVisible(g_creation_error, false)
					end, 10000, 1)
				end
			else
				if (not isElement(g_creation_error)) then return end
				guiSetText(g_creation_error, texts["errors"]["error-submit"])
				guiSetVisible(g_creation_error, true)
				if (isTimer(errorTimer)) then resetTimer(errorTimer) return end
				errorTimer = setTimer(function()
					if (not isElement(g_creation_error)) then return end
					guiSetText(g_creation_error, "")
					guiSetVisible(g_creation_error, false)
				end, 10000, 1)
			end
		end, false
	)
	
	addEventHandler("onClientGUIScroll", g_creation.scrollbar[1],
		function(scrolled)
			local scrollpos = math.floor(((tonumber(guiGetProperty(g_creation.scrollbar[1], "ScrollPosition"))*100)*0.8)+16)
			guiSetText(g_creation.label[4], "age (" .. scrollpos .. " yo)")
			cage = scrollpos
		end
	)
	
	addEventHandler("onClientGUIScroll", g_creation.scrollbar[2],
		function(scrolled)
			local scrollpos = math.floor(((tonumber(guiGetProperty(g_creation.scrollbar[2], "ScrollPosition"))*100)/2)+145)
			guiSetText(g_creation.label[5], "height (" .. scrollpos .. " cm)")
			cheight = scrollpos
		end
	)
	
	addEventHandler("onClientGUIScroll", g_creation.scrollbar[3],
		function(scrolled)
			local scrollpos = math.floor((tonumber(guiGetProperty(g_creation.scrollbar[3], "ScrollPosition"))*100)+40)
			guiSetText(g_creation.label[6], "weight (" .. scrollpos .. " kg)")
			cweight = scrollpos
		end
	)
	
	addEventHandler("onClientGUIClick", g_creation.button[2],
		function()
			guiDisplayCharacterCreation()
			guiDisplayCharacterScreen()
		end, false
	)
	
	g_area = true
	addEventHandler("onClientRender", root, dxDisplayCommon)
	
	showCursor(true, true)
end

function initRealStartup()
	if (getClientState(localPlayer) ~= 2) then
		setTimer(function()
			if (not soundplaying) then
				--
				--  Mitis - Life of Sin
				--  Find Mitis and his music on Facebook at http://www.facebook.com/mitismusic and on SoundCloud at https://soundcloud.com/mitis
				--  This music is not owned or created by FairPlay Gaming, we're using it as he agreed on it
				--
				local lowvol = 0
				local norvol = 0.05
				mitis = playSound("http://fairplaymta.net/files/LICENSED_mitis_life_of_sin.mp3", true)
				setSoundVolume(mitis, (getClientState(localPlayer) == 2 and lowvol or norvol))
				soundplaying = true
			end
		end, 100, 1)
	else
		triggerEvent(":_runRealPlayTimer_:", localPlayer)
	end
	
	bindKey("m", "down", "togcursor")
	bindKey("f10", "down", "menu")
	bindKey("pause", "down", "menu")
	
	if (getClientState(localPlayer) == 0) or (getClientState(localPlayer) == false) then
		triggerServerEvent(":_doPatchBrokenData_:", localPlayer)
		showChat(false)
		showPlayerHudComponent("all", false)
		guiDisplayLogin()
	elseif (getClientState(localPlayer) == 1) then
		guiDisplayCharacterScreen()
	end
	
	if (getClientState(localPlayer) == 0) or (getClientState(localPlayer) == 1) or (getClientState(localPlayer) == false) then
		fadeCamera(true, 1.5)
		startView()
	end
	
	triggerServerEvent(":_fetchFreshMOTD_:", localPlayer)
	
	setTimer(function()
		triggerServerEvent(":_fetchFreshMOTD_:", localPlayer)
	end, 1*1000*3600, 0) -- Fetch news every hour
end
addEvent(":_initRealStartup_:", true)
addEventHandler(":_initRealStartup_:", root, initRealStartup)

addEvent(":_updateFreshMOTD_:", true)
addEventHandler(":_updateFreshMOTD_:", root,
	function(motd)
		g_motd = motd
	end
)

addEvent(":_closeAllMenus_:", true)
addEventHandler(":_closeAllMenus_:", root,
	function()
		for i,v in ipairs(getElementsByType("gui-window")) do
			destroyElement(v)
			showCursor(false, false)
		end
		
		for i,v in ipairs(getElementsByType("gui-tabpanel")) do
			destroyElement(v)
			showCursor(false, false)
		end
		
		for i,v in ipairs(getElementsByType("gui-button")) do
			destroyElement(v)
			showCursor(false, false)
		end
	end
)

addEvent(":_doLoginSuccess_:", true)
addEventHandler(":_doLoginSuccess_:", root,
	function()
		guiDisplayLogin()
		guiDisplayCharacterScreen(1)
	end
)

addEvent(":_onFailedLogin_:", true)
addEventHandler(":_onFailedLogin_:", root,
	function(errid)
		guiSetEnabled(g_login_username, true)
		guiSetEnabled(g_login_password, true)
		guiSetEnabled(g_login_submit, true)
		if (not errid) then
			isTooltip = 11
		else
			isTooltip = 12
		end
	end
)

addEvent(":_characterCreationResponse_:", true)
addEventHandler(":_characterCreationResponse_:", root,
	function(integer)
		if (integer == 2) then
			guiDisplayCharacterScreen()
		elseif (integer == 1) then
			guiDisplayCharacterCreation()
			guiDisplayCharacterScreen()
		elseif (integer == 0) then
			if (not isElement(g_creation_error)) then return end
			guiSetText(g_creation_error, texts["errors"]["error-name-inuse"])
			guiSetVisible(g_creation_error, true)
			if (isTimer(errorTimer)) then resetTimer(errorTimer) return end
			errorTimer = setTimer(function()
				if (not isElement(g_creation_error)) then return end
				guiSetText(g_creation_error, "")
				guiSetVisible(g_creation_error, false)
			end, 10000, 1)
		end
	end
)