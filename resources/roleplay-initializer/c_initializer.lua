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

local _dis = false
local _dir1 = false
local _x = 700
local _y = 130

local function showDownloadDX()
	if (_dir1 == false) then
		_x = _x-1
	else
		_x = _x+1
	end
	
	if (_x >= 700) then
		_dir1 = false
	elseif (_x <= 670) then
		_dir1 = true
	end
	
	if (_dir2 == false) then
		_y = _y-1
	else
		_y = _y+1
	end
	
	if (_y >= 130) then
		_dir2 = false
	elseif (_y <= 80) then
		_dir2 = true
	end
	
	dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 0.95*255), true)
	dxDrawText("Initializing the system...", sx-_x, sy-_y, sx, sy, tocolor(245, 245, 245, 0.9*255), 1.5, "bankgothic", "left", "top", true, false, true, false, false)
	
	if (not isTransferBoxActive()) then
		initStartup()
	end
end

function initStartup(resource)
	if (isTransferBoxActive()) then
		_dis = true
		addEventHandler("onClientRender", root, showDownloadDX)
	else
		if (_dis == true) then
			removeEventHandler("onClientRender", root, showDownloadDX)
		end
		
		if (getResourceName(resource) == "roleplay-accounts") then
			triggerEvent(":_initRealStartup_:", localPlayer)
		end
	end
end
addEventHandler("onClientResourceStart", root, initStartup)