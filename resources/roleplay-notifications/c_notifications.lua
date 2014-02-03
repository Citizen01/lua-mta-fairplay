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

-- Configuration
local scaleX, scaleY = 250, 50 -- Width and height of the notification box (defauLt: 250x50px)
local waitTime = 10000 -- Milliseconds till automatic delete of a notification (default: 10000)
local colors = {
	-- red, green, blue, alpha
	red 	= {175, 	50, 	50, 	220}, 	-- Red color (default: 175, 50, 50, 220)
	green 	= {50, 		175, 	50, 	220}, 	-- Green color (default: 50, 175, 50, 220)
	blue	= {50, 		70, 	165, 	220}, 	-- Blue color (default: 50, 50, 175, 220)
	black	= {5, 		5, 		5, 		220} 	-- Black color (default: 5, 5, 5, 220)
}

-- Script
local sx, sy = guiGetScreenSize()
local notifications = {}
local postGUI = true

addEventHandler("onClientRender", root,
	function()
		for i,v in pairs(notifications) do
			local textHeight = dxGetFontHeight(1.2, "default-bold")
			local textWidth = dxGetTextWidth(v.text, 1.2, "default-bold")
			dxDrawRectangle(v.posX, v.posY, scaleX, scaleY, tocolor(colors[v.color][1], colors[v.color][2], colors[v.color][3], colors[v.color][4]))
			dxDrawText(v.text, v.posX, v.posY, v.posX+scaleX, v.posY+scaleY, tocolor(230, 230, 230, colors[v.color][4]), 1.2, "default-bold", "center", "center")
			
			if (v.delete == true) then
				v.posX = v.posX+2
				if (v.posX >= sx) then
					notifications[i] = nil
				end
			else
				if (v.posY ~= scaleY*(i)) and (v.finish == false) then
					v.posY = v.posY+5
				else
					if (v.finish == false) then
						v.finish = true
					end
				end
			end
		end
	end
)

function addNotification(string, color)
	if (not string) then return end
	local string = tostring(string)
	table.insert(notifications, {
		text 	= string,
		posX 	= (sx-10)-(scaleX),
		posY 	= 0,
		color 	= color,
		finish	= false,
		delete	= false,
		timer	= nil
	})
	
	notifications[#notifications].timer = setTimer(function(id)
		deleteNotification(id)
	end, waitTime+(#notifications*1000), 1, #notifications)
end
addEvent(":_addNotification_:", true)
addEventHandler(":_addNotification_:", root, addNotification)
--addNotification("You've received a new item.", "black")

function deleteNotification(id)
	if (not tonumber(id)) then return end
	local id = tonumber(id)
	if (not notifications[id]) then return end
	if (notifications[#notifications].timer) and (isElement(notifications[#notifications].timer)) and (isTimer(notifications[#notifications].timer)) then
		killTimer(notifications[#notifications].timer)
	end
	notifications[id].delete = true
end
addEvent(":_deleteNotification_:", true)
addEventHandler(":_deleteNotification_:", root, deleteNotification)