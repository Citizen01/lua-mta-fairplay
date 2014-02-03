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
local currentFPS = 0
local lastFPS = 0
local calculateFPS = 0
local isShowing = false

local function renderFPS()
	if (getTickCount() < currentFPS) then
		calculateFPS = calculateFPS+1
	else
		lastFPS = calculateFPS
		calculateFPS = 0
		currentFPS = getTickCount()+1000
	end
	dxDrawText("FPS: " .. lastFPS, 26, 4, sx, sy)
end

addCommandHandler("showfps",
	function(cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		isShowing = not isShowing
		if (isShowing) then
			currentFPS = getTickCount()+1000
			addEventHandler("onClientRender", root, renderFPS)
		else
			removeEventHandler("onClientRender", root, renderFPS)
		end
	end, false, false
)