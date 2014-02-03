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
local messages = {}
local messageTimer = {}
local xPos = sx
local yPos = -50

function forceCloseMessages()
	if (#messages > 0) then
		messages = {}
		for i,v in pairs(messageTimer) do
			if (isTimer(v)) then killTimer(v) end
		end
		xPos = sx
		yPos = -50
	end
end

function addNewMessage(message, customTime)
	if (not message) then return false end
	local count = #messages+1
	messages[count] = message
	messageTimer[count] = setTimer(function()
		messages[1] = nil
		table.condense(messages)
		if (#messages == 0) then
			xPos = sx
		end
	end, (customTime and customTime or 50000), 1)
end
addEvent(":_addNewMessage_:", true)
addEventHandler(":_addNewMessage_:", root, addNewMessage)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		addEventHandler("onClientRender", root,
			function()
				dxDrawRectangle(0, yPos, sx, 50, tocolor(0, 0, 0, 0.85*255), true)
				if (#messages > 0) then
					local text = table.concat(messages, " | ")
					if (yPos ~= 0) then
						yPos = yPos+1
					end
					
					if (xPos > -dxGetTextWidth(text)) then
						xPos = xPos-1.3
					else
						xPos = sx
					end
					
					dxDrawText(text, xPos, yPos+17, sx, 45, tocolor(250, 250, 250, 1.0*255), 1.0, "default-bold", "left", "top", true, false, true, false, true)
				else
					if (yPos ~= -50) then
						yPos = yPos-0.5
					end
				end
			end
		)
	end
)