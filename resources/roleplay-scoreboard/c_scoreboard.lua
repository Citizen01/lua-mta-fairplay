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

local tPlayers = {}

local bPostGUI = true
local iMaxBoxes = 15
local iMinBoxes = 1
local iScrollAmount = 3
local bForceDisappear = false
local isShowing = false

local fBoardWidth = 536
local fBoardHeight = 572
local cBoardColor = tocolor(0, 0, 0, 0.9*255)

local sTextServerName = "Playerlist"
local cTextColor = tocolor(245, 245, 245, 0.93*255)
local fTextScale = 2.0
local sTextFont = "sans"
local fTextMargin = 30
local sTextAlignX = "center"
local sTextAlignY = "top"
local bTextClip = true
local bTextWordBreak = false
local bTextColorCoded = false
local bTextSubPixelPos = false

local fBoxWidth = 532
local fBoxHeight = 30
local fBoxMargin = 0
local fBoxTopOffset = 32
local iMultiplier = 30
local cBoxColor = tocolor(130, 130, 130, 0.07*255)

local sBoxText = ""
local sBoxText2 = ""
local cBoxTextColor_PLAY = tocolor(245, 245, 245, 255)
local cBoxTextColor_MENU = tocolor(145, 145, 145, 205)
local cBoxTextColor_ADMIN = tocolor(245, 215, 25, 255)
local cBoxTextColor_DONATOR = tocolor(150, 100, 65, 255)
local fBoxTextScale = 1.0
local sBoxTextFont = "default-bold"
local fBoxTextMargin = 30
local sBoxTextAlignX = "left"
local sBoxTextAlignY = "top"
local bBoxTextClip = true
local bBoxTextWordBreak = false
local bBoxTextColorCoded = false
local bBoxTextSubPixelPos = false

function dxDisplayScoreboard()
	if (bForceDisappear) then return end
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	local localID = exports['roleplay-accounts']:getClientID(localPlayer)
	
	dxDrawRectangle((sx-fBoardWidth)/2, (sy-fBoardHeight)/2, fBoardWidth, fBoardHeight, cBoardColor, bPostGUI)
	
	-- Headers
	dxDrawText(#getElementsByType("player") .. "/100", ((sx-fBoxWidth+fBoxTextMargin)/2)+10, (sy-fBoxWidth+fBoxTextMargin)/2-25, (sx-fBoxWidth-dxGetTextWidth(#getElementsByType("player") .. "/100", fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(#getElementsByType("player") .. "/100", fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin-30, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale*50, tocolor(245, 245, 245, 0.65*255), fBoxTextScale, sBoxTextFont, "left", "top", bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	dxDrawText("FairPlay: MTA Roleplay - Public Beta", (sx-fBoxWidth+fBoxTextMargin)/2, (sy-fBoxWidth+fBoxTextMargin)/2-25, (sx-fBoxWidth-dxGetTextWidth("FairPlay: MTA Roleplay - Public Beta", fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth("FairPlay: MTA Roleplay - Public Beta", fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin-37, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale*50, tocolor(245, 245, 245, 0.65*255), fBoxTextScale, sBoxTextFont, "right", "top", bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	dxDrawText("ID", (sx-fBoxWidth+fBoxTextMargin)/2+10, (sy-fBoxWidth+fBoxTextMargin)/2, (sx-fBoxWidth-dxGetTextWidth("ID", fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth("ID", fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale*50, tocolor(245, 245, 245, 0.65*255), fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	dxDrawText("Name", (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2, (sx-fBoxWidth-dxGetTextWidth("Name", fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth("Name", fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale*50, tocolor(245, 245, 245, 0.65*255), fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	dxDrawText("Ping", (sx+fBoxWidth+fBoxTextMargin)/2-fBoxTextMargin-35, (sy-fBoxWidth+fBoxTextMargin)/2, sx, sy, tocolor(245, 245, 245, 0.65*255), fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	
	local pos = 2
	
	local sBoxText1 = localID
	local sBoxText2 = getPlayerName(localPlayer):gsub("_", " ") .. (not exports['roleplay-accounts']:isClientPlaying(localPlayer) and (exports['roleplay-accounts']:isClientLoggedIn(localPlayer) and " (Selection)" or " (Login)") or "")
	local sBoxText3 = getPlayerPing(localPlayer)
	dxDrawRectangle((sx-fBoxWidth)/2, ((sy-fBoardHeight)/2+fBoxTopOffset)+(pos-1)*fBoxTopOffset-fBoxMargin-5, fBoxWidth, fBoxHeight, cBoxColor, bPostGUI)
	dxDrawText(sBoxText1, (sx-fBoxWidth+fBoxTextMargin)/2+10, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier, (sx-fBoxWidth-dxGetTextWidth(sBoxText1, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText1, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, (exports['roleplay-accounts']:isClientPlaying(localPlayer) and cBoxTextColor_PLAY or cBoxTextColor_MENU), fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	
	if (exports['roleplay-accounts']:isClientTrialAdmin(localPlayer) and (exports['roleplay-accounts']:getAdminState(localPlayer) == 1)) then
		dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier, (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_ADMIN, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	--elseif (exports['roleplay-accounts']:isClientTrialAdmin(localPlayer) and (exports['roleplay-accounts']:getAdminState(localPlayer) == 1)) then
		--dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier, (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_DONATOR, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	else
		if (exports['roleplay-accounts']:isClientPlaying(localPlayer)) then
			dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier, (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_PLAY, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
		else
			dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier, (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_MENU, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
		end
	end
	
	dxDrawText(sBoxText3, (sx+fBoxWidth+fBoxTextMargin)/2-fBoxTextMargin-35, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier, sx, sy, (exports['roleplay-accounts']:isClientPlaying(localPlayer) and cBoxTextColor_PLAY or cBoxTextColor_MENU), fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
	
	local counterID = 0
	if (tPlayers) then
		for id,data in pairs(tPlayers) do
			if (isElement(data[1])) then
				if (data[1] ~= localPlayer) then
					counterID = counterID+1
					if (counterID >= iMinBoxes) and (counterID <= iMaxBoxes) then
						pos = pos+1
						
						local sBoxText1 = id
						local sBoxText2 = data[2]:gsub("_", " ") .. (not exports['roleplay-accounts']:isClientPlaying(data[1]) and (exports['roleplay-accounts']:isClientLoggedIn(data[1]) and " (Selection)" or " (Login)") or "")
						local sBoxText3 = data[3]
						dxDrawRectangle((sx-fBoxWidth)/2, ((sy-fBoardHeight)/2+fBoxTopOffset)+(pos-1)*fBoxTopOffset-fBoxMargin-5, fBoxWidth, fBoxHeight, cBoxColor, bPostGUI)
						dxDrawText(sBoxText1, (sx-fBoxWidth+fBoxTextMargin)/2+10, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier+(1*pos-1), (sx-fBoxWidth-dxGetTextWidth(sBoxText1, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText1, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, (exports['roleplay-accounts']:isClientPlaying(data[1]) and cBoxTextColor_PLAY or cBoxTextColor_MENU), fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
						
						if (exports['roleplay-accounts']:isClientTrialAdmin(data[1]) and (exports['roleplay-accounts']:getAdminState(data[1]) == 1)) then
							dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier+(1*pos-1), (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_ADMIN, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
						--elseif (exports['roleplay-accounts']:isClientTrialAdmin(data[1]) and (exports['roleplay-accounts']:getAdminState(data[1]) == 1)) then
							--dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*50, (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_DONATOR, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
						else
							if (exports['roleplay-accounts']:isClientPlaying(data[1])) then
								dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier+(1*pos-1), (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_PLAY, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
							else
								dxDrawText(sBoxText2, (sx-fBoxWidth+fBoxTextMargin)/2+40, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier+(1*pos-1), (sx-fBoxWidth-dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText2, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_MENU, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
							end
						end
						
						dxDrawText(sBoxText3, (sx+fBoxWidth+fBoxTextMargin)/2-fBoxTextMargin-35, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*iMultiplier+(1*pos-1), sx, sy, (exports['roleplay-accounts']:isClientPlaying(data[1]) and cBoxTextColor_PLAY or cBoxTextColor_MENU), fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
					end
				end
			end
		end
	end
	
	--[[for i,v in ipairs(getElementsByType("vehicle")) do
		local id = i
		if (id >= iMinBoxes) and (id <= iMaxBoxes) then
			pos = pos+1
			local ping = 100
			dxDrawRectangle((sx-fBoxWidth)/2, ((sy-fBoardHeight)/2+fBoxTopOffset)+pos*fBoxTopOffset-fBoxMargin-5, fBoxWidth, fBoxHeight, cBoxColor, bPostGUI)
			dxDrawText(id, (sx-fBoxWidth+fBoxTextMargin)/2, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*50, (sx-fBoxWidth-dxGetTextWidth(sBoxText, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_PLAY, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
			dxDrawText(getVehicleName(v), (sx-fBoxWidth+fBoxTextMargin)/2+20, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*50, (sx-fBoxWidth-dxGetTextWidth(sBoxText, fBoxTextScale, sBoxTextFont)*fBoxTextScale-fBoxTextMargin*4)/2+dxGetTextWidth(sBoxText, fBoxTextScale, sBoxTextFont)*fBoxTextScale+fBoardWidth-fBoxTextMargin, (sy-fBoxWidth+fBoxTextMargin)/2+dxGetFontHeight(fBoxTextScale, sBoxTextFont)*fBoxTextScale+(pos-1)*50, cBoxTextColor_PLAY, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
			dxDrawText(ping, (sx+fBoxWidth+fBoxTextMargin)/2-fBoxTextMargin-5-string.len(ping)*5, (sy-fBoxWidth+fBoxTextMargin)/2+(pos-1)*50, sx, sy, cBoxTextColor_PLAY, fBoxTextScale, sBoxTextFont, sBoxTextAlignX, sBoxTextAlignY, bBoxTextClip, bBoxTextWordBreak, bPostGUI, bBoxTextColorCoded, bBoxTextSubPixelPos)
		end
	end]]
end

local function toggleScoreboard(_, state)
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (state == "down") and (isShowing ~= true) then
		isShowing = true
		addEventHandler("onClientRender", root, dxDisplayScoreboard)
	else
		removeEventHandler("onClientRender", root, dxDisplayScoreboard)
		isShowing = false
	end
end

local function updateCache()
	tPlayers = {}
	for i,v in ipairs(getElementsByType("player")) do
		if (v ~= localPlayer) then
			tPlayers[exports['roleplay-accounts']:getClientID(v)] = {v, getPlayerName(v), getPlayerPing(v)}
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("mouse_wheel_up", "down", scrollScoreboardUp)
		bindKey("mouse_wheel_down", "down", scrollScoreboardDown)
		bindKey("tab", "both", toggleScoreboard)
		triggerServerEvent(":_doGetServerName_:", localPlayer)
		updateCache()
		setTimer(updateCache, 3500, 0)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		unbindKey("mouse_wheel_up", "down", scrollScoreboardUp)
		unbindKey("mouse_wheel_down", "down", scrollScoreboardDown)
		unbindKey("tab", "both", toggleScoreboard)
	end
)

addEvent(":_updateScoreboardBind_:", true)
addEventHandler(":_updateScoreboardBind_:", root,
	function(unbindOrNot)
		if (unbindOrNot) then
			unbindKey("mouse_wheel_up", "down", scrollScoreboardUp)
			unbindKey("mouse_wheel_down", "down", scrollScoreboardDown)
			unbindKey("tab", "both", toggleScoreboard)
		else
			bindKey("mouse_wheel_up", "down", scrollScoreboardUp)
			bindKey("mouse_wheel_down", "down", scrollScoreboardDown)
			bindKey("tab", "both", toggleScoreboard)
		end
	end
)

function scrollScoreboardDown()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (not isVisible) then return end
	if (iMaxBoxes+iScrollAmount <= #getElementsByType("player")) then
		iMinBoxes = iMinBoxes+iScrollAmount
		iMaxBoxes = iMaxBoxes+iScrollAmount
	else
		iMaxBoxes = #getElementsByType("player")
		iMinBoxes = iMaxBoxes-10
	end
end

function scrollScoreboardUp()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (not isVisible) then return end
	if (iMinBoxes-iScrollAmount >= 1) then
		iMinBoxes = iMinBoxes-iScrollAmount
		iMaxBoxes = iMaxBoxes-iScrollAmount
	else
		iMinBoxes = 1
		iMaxBoxes = 10
	end
end

addEvent(":_doThrowServerName_:", true)
addEventHandler(":_doThrowServerName_:", root,
	function(name)
		sTextServerName = "Playerlist" --name
	end
)