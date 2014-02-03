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
	
	ps. worst inventory system ever, no need to tell me about it
]]

-- General Stuff
local sx, sy = guiGetScreenSize()
local isVisible = false
local postGUI = true
local illegalDrop = {[9]=true}
local cases = {"backpack", "keys", "weapons"}
local items = {
	["backpack"] = {},
	["keys"] = {},
	["weapons"] = {}
}

-- Inventory Settings
local GLOBAL_max = 6
local GLOBAL_cooldown = false
local GLOBAL_debug = false

local CATEGORY_hovering
local CATEGORY_open

local BG_currentIndex = 0
local BG_currentRow = 1

local ROW_width = 282.0
local ROW_offset = 100.0

local ITEM_scale = 90
local ITEM_margin = 3
local ITEM_currentIndex = 0
local ITEM_currentRow = 1

local HOVER_currentIndex = 0
local HOVER_currentRow = 1

local CLICK_currentIndex = 0
local CLICK_currentRow = 1

local dist
local col, x, y, z, element
local _cx, _cy = 0, 0
local maxDistance = 6
local DRAG_item
local DRAG_currentIndex = 0
local DRAG_currentRow = 1
local DELETING = false
local draggingWorldItem = false

local DRAGEND_currentIndex = 0
local DRAGEND_currentRow = 1
local LOCKINVENTORY = false

-- Script
local function doesContainData(case)
	if (not items[cases[case]]) or (#items[cases[case]] == 0) then
		return false
	else
		return true
	end
end

local function isHoveringWorldItem()
	local cx, cy, wx, wy, wz = getCursorPosition()
	local cx, cy = cx*sx, cy*sy
	local camX, camY, camZ = getWorldFromScreenPosition(cx, cy, 0.1)
	local _col, _x, _y, _z, _element = processLineOfSight(camX, camY, camZ, wx, wy, wz)
	if (_element) and (exports['roleplay-items']:isWorldItem(_element)) then
		return _element
	elseif (_x) and (_y) and (_z) then
		local maxdist = 0.34
		
		for _,object in ipairs(getElementsByType("object")) do
			if (isElementStreamedIn(object)) and (isElementOnScreen(object)) and (exports['roleplay-items']:isWorldItem(object)) then
				local px, py, pz = getElementPosition(object)
				local dist = getDistanceBetweenPoints3D(px, py, pz, _x, _y, _z)
				
				if (dist < maxdist) then
					_element = object
					maxdist = dist
				end
			end
		end
		
		if (_element) then
			local px, py, pz = getElementPosition(localPlayer)
			local ox, oy, oz = getElementPosition(_element)
			return (getDistanceBetweenPoints3D(px, py, pz, ox, oy, oz) < maxDistance) and (_element)
		end
	end
end

addEventHandler("onClientRender", root,
	function()
		if (isCursorShowing()) then
			local element = isHoveringWorldItem()
			if (element) and (getElementType(element) == "object") then
				local cx, cy, wx, wy, wz = getCursorPosition()
				local cx, cy = cx*sx, cy*sy
				local itemData = exports['roleplay-items']:isWorldItem(element)
				if (itemData) then
					local name = exports['roleplay-items']:getItems()[itemData[2]][1]
					local value = exports['roleplay-items']:getItems()[itemData[2]][2]
					local name_ = false
					
					if (exports['roleplay-items']:getItems()[itemData[2]][13] == 2) then
						name = name .. " (" .. itemData[3] .. ")"
					elseif (exports['roleplay-items']:getItems()[itemData[2]][13] == 3) then
						name = name .. " (" .. itemData[3] .. ")"
					elseif (itemData[2] == 10) then
						name = name .. " (#" .. itemData[3] .. ")"
					else
						if (itemData[3]) and (itemData[3] ~= "") then
							value = itemData[3]
						end
					end
					
					local name_length = math.max(200, dxGetTextWidth(name)*1.5)
					local value_length = math.max(200, dxGetTextWidth(value)*1.5)
					
					if (string.len(name) > string.len(value)) then
						name_ = true
					end
					
					dxDrawRectangle(cx, cy, (name_ == true and name_length or value_length), 57, tocolor(0, 0, 0, 0.5*255), postGUI)
					dxDrawText(name .. "\n" .. value, cx+17, cy+15, (name_ == true and name_length or value_length), 50, tocolor(245, 245, 245, 255), 1.0, "clear", "left", "top", false, false, postGUI, false, true)
				end
			end
		end
		
		if (not isVisible) then return end
		
		-- Background
		dxDrawRectangle((sx-ROW_width)/2, (CATEGORY_open ~= nil and sy-ROW_offset+4 or sy-ROW_offset), ROW_width, sy, tocolor(0, 0, 0, 0.65*255), postGUI)
		dxDrawRectangle((sx-ROW_width)/2, sy-2, ROW_width, sy, tocolor(245, 245, 245, 0.9*255), postGUI)
		
		-- Backpack
		dxDrawRectangle((sx-ROW_width+7)/2, sy-(ROW_offset-4), ITEM_scale, ITEM_scale, tocolor(0, 0, 0, (CATEGORY_hovering == 1 and 0.6*255 or 0.5*255)), postGUI)
		dxDrawImage((sx-ROW_width+9)/2+8, sy-(ROW_offset-9)-2, ITEM_scale-20, ITEM_scale-10, "images/backpack.png", 0, 0, 0, tocolor(255, 255, 255, (CATEGORY_hovering == 1 and 0.95*255 or 0.8*255)), postGUI)
		
		-- Keys
		dxDrawRectangle((sx-ROW_width+ITEM_scale*2+12)/2, sy-(ROW_offset-4), ITEM_scale, ITEM_scale, tocolor(0, 0, 0, (CATEGORY_hovering == 2 and 0.6*255 or 0.5*255)), postGUI)
		dxDrawImage((sx-ROW_width+ITEM_scale*2+26)/2+2, sy-(ROW_offset-12), ITEM_scale-20, ITEM_scale-15, "images/keys.png", 0, 0, 0, tocolor(255, 255, 255, (CATEGORY_hovering == 2 and 0.95*255 or 0.8*255)), postGUI)
		
		-- Weapons
		dxDrawRectangle((sx-ROW_width+ITEM_scale*4+17)/2, sy-(ROW_offset-4), ITEM_scale, ITEM_scale, tocolor(0, 0, 0, (CATEGORY_hovering == 3 and 0.6*255 or 0.5*255)), postGUI)
		dxDrawImage((sx-ROW_width+ITEM_scale*4+25)/2+2, sy-(ROW_offset-14)+5, ITEM_scale-13, ITEM_scale-35, "images/weapons.png", 0, 0, 0, tocolor(255, 255, 255, (CATEGORY_hovering == 3 and 0.95*255 or 0.8*255)), postGUI)
		
		local cx, cy, wx, wy, wz = getCursorPosition()
		local cx, cy = cx*sx, cy*sy
		
		if (CATEGORY_open) then
			-- Background
			for i,v in pairs(items[cases[CATEGORY_open]]) do
				if (BG_currentIndex == GLOBAL_max) then
					BG_currentIndex = 0
					BG_currentRow = BG_currentRow+1
				end
				
				if (i == #items[cases[CATEGORY_open]]) then
					BG_currentIndex = 0
					BG_currentRow = 1
				end
				
				BG_currentIndex = BG_currentIndex+1
				
				if (BG_currentIndex == 1) then
					dxDrawRectangle((sx-ROW_width*2)/2, ((sy-(ROW_offset*2))-((ITEM_scale+ITEM_margin)*(BG_currentRow-1)))+((ITEM_margin*3)-1), (ROW_width*2)-ITEM_margin, ITEM_scale+(ITEM_margin), tocolor(0, 0, 0, 0.65*255), postGUI)
				end
			end
			
			-- Grid bottom fix
			dxDrawRectangle((sx-ROW_width*2)/2, sy-(ROW_offset-1), (ROW_width*2)-ITEM_margin, ITEM_margin, tocolor(0, 0, 0, 0.65*255), postGUI)
			
			-- Item Grid
			for i,v in pairs(items[cases[CATEGORY_open]]) do
				local hovering = false
				
				if (ITEM_currentIndex == GLOBAL_max) then
					ITEM_currentIndex = 0
					ITEM_currentRow = ITEM_currentRow+1
				end
				
				if (i == #items[cases[CATEGORY_open]]) then
					ITEM_currentIndex = 0
					ITEM_currentRow = 1
				end
				
				ITEM_currentIndex = ITEM_currentIndex+1
				
				if (cx >= ((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(ITEM_currentIndex-2)))+(ITEM_margin/2))) and (cx <= (((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(ITEM_currentIndex-2)))+(ITEM_margin/2))+ITEM_scale)) and (cy >= ((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(ITEM_currentRow-1)))) and (cy <= (((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(ITEM_currentRow-1)))+ITEM_scale)) and (not DRAG_item) then
					hovering = true
				end
				
				if (DRAG_item ~= i) then
					dxDrawRectangle((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(ITEM_currentIndex-2)))+(ITEM_margin/2), (sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(ITEM_currentRow-1)), ITEM_scale, ITEM_scale, tocolor(0, 0, 0, (hovering and 0.6*255 or 0.5*255)), postGUI)
					dxDrawImage((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(ITEM_currentIndex-2)))+(ITEM_scale/8), ((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(ITEM_currentRow-1)))+(((ITEM_scale/8)/2)+3), ITEM_scale-18, ITEM_scale-18, "images/" .. items[cases[CATEGORY_open]][i][2] .. ".png", 0, 0, 0, tocolor(255, 255, 255, (hovering and 0.95*255 or 0.8*255)), postGUI)
				else
					local px, py, pz = getElementPosition(localPlayer)
					local camX, camY, camZ = getWorldFromScreenPosition(cx, cy, 0.1)
					col, x, y, z, element = processLineOfSight(camX, camY, camZ, wx, wy, wz)
					dist = maxDistance
					
					if (x) and (y) and (z) then
						dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
					end
					
					local color = tocolor(0, 0, 0, 0.6*255)
					
					if (not col) or (dist >= maxDistance) then
						color = tocolor(155, 25, 25, 0.7*255)
					elseif (element) and (getElementType(element) == "player") then
						color = tocolor(25, 155, 25, 0.7*255)
					elseif (DELETING) then
						color = tocolor(105, 20, 20, 0.75*255)
					end
					
					dxDrawRectangle(cx, cy, ITEM_scale, ITEM_scale, color, postGUI)
					dxDrawImage(cx+(ITEM_scale/8)-1, cy+(ITEM_scale/8)-4, ITEM_scale-18, ITEM_scale-18, "images/" .. items[cases[CATEGORY_open]][i][2] .. ".png", 0, 0, 0, tocolor(255, 255, 255, 0.95*255), postGUI)
				end
			end
			
			-- Hovering
			if (not DRAG_item) then
				for i,v in pairs(items[cases[CATEGORY_open]]) do
					if (HOVER_currentIndex == GLOBAL_max) then
						HOVER_currentIndex = 0
						HOVER_currentRow = HOVER_currentRow+1
					end
					
					if (i == #items[cases[CATEGORY_open]]) then
						HOVER_currentIndex = 0
						HOVER_currentRow = 1
					end
					
					HOVER_currentIndex = HOVER_currentIndex+1
					
					if (cx >= ((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(HOVER_currentIndex-2)))+(ITEM_margin/2))) and (cx <= (((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(HOVER_currentIndex-2)))+(ITEM_margin/2))+ITEM_scale)) and (cy >= ((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(HOVER_currentRow-1)))) and (cy <= (((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(HOVER_currentRow-1)))+ITEM_scale)) then
						local name
						local value = items[cases[CATEGORY_open]][i][3]
						
						local name_ = false
						local value_ = value
						
						if (CATEGORY_open == 2) then
							name = exports['roleplay-items']:getItems()[items[cases[CATEGORY_open]][i][2]][1] .. " (" .. items[cases[CATEGORY_open]][i][3] .. ")"
							value_ = exports['roleplay-items']:getItems()[items[cases[CATEGORY_open]][i][2]][2]
						else
							name = exports['roleplay-items']:getItems()[items[cases[CATEGORY_open]][i][2]][1]
						end
						
						if (not value or value == "") or (items[cases[CATEGORY_open]][i][2] == 10) then
							value_ = exports['roleplay-items']:getItems()[items[cases[CATEGORY_open]][i][2]][2]
						end
						
						if (items[cases[CATEGORY_open]][i][2] == 10) then
							name = exports['roleplay-items']:getItems()[items[cases[CATEGORY_open]][i][2]][1] .. " (#" .. items[cases[CATEGORY_open]][i][3] .. ")"
						end
						
						local name_length = math.max(200, dxGetTextWidth(name)*1.5)
						local value_length = math.max(200, dxGetTextWidth(value_)*1.5)
						
						if (string.len(name) > string.len(value_)) then
							name_ = true
						end
						
						dxDrawRectangle(cx, cy, (name_ == true and name_length or value_length), 57, tocolor(0, 0, 0, 0.5*255), postGUI)
						dxDrawText(name .. "\n" .. value_, cx+17, cy+15, (name_ == true and name_length or value_length), 50, tocolor(245, 245, 245, 255), 1.0, "clear", "left", "top", false, false, postGUI, false, true)
					end
				end
			end
		end
	end
)

addEventHandler("onClientCursorMove", root,
	function(cursorX, cursorY, cx, cy, worldX, worldY, worldZ)
		if (not draggingWorldItem) or (not isElement(draggingWorldItem)) then
			-- Inventory
			if (cx >= (sx-ROW_width+7)/2) and (cx <= ((sx-ROW_width+7)/2)+ITEM_scale) and (cy >= (sy-(ROW_offset-4))) and (cy <= (sy-(ROW_offset-4))+ITEM_scale) then
				-- Backpack
				if (CATEGORY_hovering == 1) then return end
				CATEGORY_hovering = 1
			elseif (cx >= (sx-ROW_width+ITEM_scale*2+12)/2) and (cx <= ((sx-ROW_width+ITEM_scale*2+12)/2)+ITEM_scale) and (cy >= (sy-(ROW_offset-4))) and (cy <= (sy-(ROW_offset-4))+ITEM_scale) then
				-- Keys
				if (CATEGORY_hovering == 2) then return end
				CATEGORY_hovering = 2
			elseif (cx >= (sx-ROW_width+ITEM_scale*4+17)/2) and (cx <= ((sx-ROW_width+ITEM_scale*4+16)/2)+ITEM_scale) and (cy >= (sy-(ROW_offset-4))) and (cy <= (sy-(ROW_offset-4))+ITEM_scale) then
				-- Weapons
				if (CATEGORY_hovering == 3) then return end
				CATEGORY_hovering = 3
			else
				if (CATEGORY_hovering == nil) then return end
				CATEGORY_hovering = nil
			end
		else
			if (not draggingWorldItem) or (not isElement(draggingWorldItem)) then return end
			local px, py, pz = getElementPosition(localPlayer)
			local camX, camY, camZ = getWorldFromScreenPosition(cx, cy, 0.1)
			local col, x, y, z, element = processLineOfSight(camX, camY, camZ, worldX, worldY, worldZ)
			if (not col) then return end
			local dist2 = maxDistance
			setElementPosition(draggingWorldItem, x, y, z)
		end
	end
)

local messageSent1 = false
local messageSent2 = false
local messageSent3 = false

addEventHandler("onClientKey", root,
	function(button, pressOrRelease)
		if (not DRAG_item) and (DELETING) then
			DELETING = false
		end
		
		if (button == "delete") then
			if (DRAG_item) then
				if (pressOrRelease == true) then
					if (DELETING) then return end
					DELETING = true
				else
					if (not DELETING) then return end
					DELETING = false
					triggerServerEvent(":_deleteItem_:", localPlayer, items[cases[CATEGORY_open]][DRAG_item][1], items[cases[CATEGORY_open]][DRAG_item][2], items[cases[CATEGORY_open]][DRAG_item][3])
					DRAG_item = false
				end
			end
		elseif (button == "backspace") or (button == "escape") then
			if (DELETING) then
				DELETING = false
			end
		end
	end
)

addEventHandler("onClientClick", root,
	function(button, state, cx, cy, worldX, worldY, worldZ, clickedWorld)
		if (button ~= "left") then return end
		if (not DRAG_item) and (DELETING) then
			DELETING = false
		end
		
		if (state == "down") then
			if (isVisible) then
				_cx, _cy = cx, cy
				setTimer(function()
					if (getKeyState("mouse1") == true) then
						if (items) then
							if (not CATEGORY_open) then return end
							for i,v in pairs(items[cases[CATEGORY_open]]) do
								if (DRAG_currentIndex == GLOBAL_max) then
									DRAG_currentIndex = 0
									DRAG_currentRow = DRAG_currentRow+1
								end
								
								if (i == #items[cases[CATEGORY_open]]) then
									DRAG_currentIndex = 0
									DRAG_currentRow = 1
								end
								
								DRAG_currentIndex = DRAG_currentIndex+1
								
								if (_cx >= ((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(DRAG_currentIndex-2)))+(ITEM_margin/2))) and (_cx <= (((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(DRAG_currentIndex-2)))+(ITEM_margin/2))+ITEM_scale)) and (_cy >= ((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(DRAG_currentRow-1)))) and (_cy <= (((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(DRAG_currentRow-1)))+ITEM_scale)) then
									if (illegalDrop[items[cases[CATEGORY_open]][i][2]]) and (not exports['roleplay-accounts']:isClientLeader(localPlayer)) then
										outputChatBox("You are unable to drop this item.", 245, 20, 20, false)
									else
										DRAG_item = i
									end
								end
							end
						end
					end
				end, 200, 1)
			else
				if (not draggingWorldItem) then
					local element = isHoveringWorldItem()
					if (element) and (getElementType(element) == "object") then
						if (not isPedInVehicle(localPlayer)) then
							local itemData = exports['roleplay-items']:isWorldItem(element)
							if (itemData) then
								setTimer(function()
									if (draggingWorldItem) then return end
									if (getKeyState("mouse1") == true) then
										local element = isHoveringWorldItem()
										if (element) then
											local itemData = exports['roleplay-items']:isWorldItem(element)
											if (itemData) then
												local x, y, z = getElementPosition(element)
												local _, _, rot = getElementRotation(element)
												setElementData(element, "roleplay:temp.origX", x, false)
												setElementData(element, "roleplay:temp.origY", y, false)
												setElementData(element, "roleplay:temp.origZ", z, false)
												setElementData(element, "roleplay:temp.origRot", rot, false)
												draggingWorldItem = element
												setElementAlpha(draggingWorldItem, 200)
											end
										end
									end
								end, 200, 1)
							end
						end
					end
				end
			end
		end
		
		if (state == "up") then
			if (draggingWorldItem) then
				local x, y, z = getElementPosition(draggingWorldItem)
				if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) < 14) then
					local itemData = exports['roleplay-items']:isWorldItem(draggingWorldItem)
					triggerServerEvent(":_updateWorldItemPosition_:", localPlayer, itemData[1], draggingWorldItem, x, y, z)
				else
					outputChatBox("Sorry, but that's too far.", 245, 20, 20, false)
					setElementPosition(draggingWorldItem, tonumber(getElementData(draggingWorldItem, "roleplay:temp.origX")), tonumber(getElementData(draggingWorldItem, "roleplay:temp.origY")), tonumber(getElementData(draggingWorldItem, "roleplay:temp.origZ")))
					setElementRotation(draggingWorldItem, 0, 0, tonumber(getElementData(draggingWorldItem, "roleplay:temp.origRot")))
				end
				
				setElementAlpha(draggingWorldItem, 255)
				draggingWorldItem = false
			else
				local element = isHoveringWorldItem()
				if (element) and (getElementType(element) == "object") then
					local itemData = exports['roleplay-items']:isWorldItem(element)
					if (itemData) then
						if (not isPedInVehicle(localPlayer)) then
							if (tonumber(getElementData(localPlayer, "roleplay:characters.weight"))+exports['roleplay-items']:getItemWeight(itemData[2]) <= tonumber(getElementData(localPlayer, "roleplay:characters.maxweight"))) then
								local name = exports['roleplay-items']:getItems()[itemData[2]][1]
								local value = exports['roleplay-items']:getItems()[itemData[2]][2]
								triggerServerEvent(":_pickItemFromWorld_:", localPlayer, itemData[1], element)
								return
							else
								outputChatBox("You don't have enough space for that item in your inventory.", 245, 20, 20, false)
							end
						else
							outputChatBox("You have to get out of the vehicle in order to pick up the item.", 245, 20, 20, false)
						end
					end
				end
				
				if (DRAG_item) then
					if (not col) or (dist >= maxDistance) then
						--outputChatBox("That's outer space, monkey.")
					elseif (element) and (element ~= localPlayer) then
						triggerServerEvent(":_dropItem_:", localPlayer, element, items[cases[CATEGORY_open]][DRAG_item][1], items[cases[CATEGORY_open]][DRAG_item][2], items[cases[CATEGORY_open]][DRAG_item][3], items[cases[CATEGORY_open]][DRAG_item][4], items[cases[CATEGORY_open]][DRAG_item][5], worldX, worldY, worldZ)
					elseif (element) and (element == localPlayer) then
						--outputChatBox("Giving yourself a present? Aw, how cute!")
					else
						triggerServerEvent(":_dropItem_:", localPlayer, false, items[cases[CATEGORY_open]][DRAG_item][1], items[cases[CATEGORY_open]][DRAG_item][2], items[cases[CATEGORY_open]][DRAG_item][3], items[cases[CATEGORY_open]][DRAG_item][4], items[cases[CATEGORY_open]][DRAG_item][5], worldX, worldY, worldZ)
					end
					DRAG_item = nil
				else
					if (cx >= (sx-ROW_width+7)/2) and (cx <= ((sx-ROW_width+7)/2)+ITEM_scale) and (cy >= (sy-(ROW_offset-4))) and (cy <= (sy-(ROW_offset-4))+ITEM_scale) then
						if (not doesContainData(1)) then return end
						if (CATEGORY_open == 1) then CATEGORY_open = nil return end
						CATEGORY_open = 1
						if (not messageSent1) then
							triggerEvent(":_addNewMessage_:", localPlayer, "TIP: You can drag & drop items from your inventory to the world by holding your left mouse button when hovering an item in your inventory.")
							messageSent1 = true
						end
					elseif (cx >= (sx-ROW_width+ITEM_scale*2+12)/2) and (cx <= ((sx-ROW_width+ITEM_scale*2+12)/2)+ITEM_scale) and (cy >= (sy-(ROW_offset-4))) and (cy <= (sy-(ROW_offset-4))+ITEM_scale) then
						if (not doesContainData(2)) then return end
						if (CATEGORY_open == 2) then CATEGORY_open = nil return end
						CATEGORY_open = 2
						if (not messageSent2) then
							triggerEvent(":_addNewMessage_:", localPlayer, "TIP: You can drag & drop keys from your inventory to the world by holding your left mouse button when hovering a key in your inventory.")
							messageSent2 = true
						end
					elseif (cx >= (sx-ROW_width+ITEM_scale*4+17)/2) and (cx <= ((sx-ROW_width+ITEM_scale*4+16)/2)+ITEM_scale) and (cy >= (sy-(ROW_offset-4))) and (cy <= (sy-(ROW_offset-4))+ITEM_scale) then
						if (not doesContainData(3)) then return end
						if (CATEGORY_open == 3) then CATEGORY_open = nil return end
						CATEGORY_open = 3
						if (not messageSent3) then
							triggerEvent(":_addNewMessage_:", localPlayer, "TIP: You can drag & drop weapons from your inventory to the world by holding your left mouse button when hovering a weapon in your inventory.")
							messageSent3 = true
						end
					end
					
					if (items) then
						if (not CATEGORY_open) then return end
						for i,v in pairs(items[cases[CATEGORY_open]]) do
							if (CLICK_currentIndex == GLOBAL_max) then
								CLICK_currentIndex = 0
								CLICK_currentRow = CLICK_currentRow+1
							end
							
							if (i == #items[cases[CATEGORY_open]]) then
								CLICK_currentIndex = 0
								CLICK_currentRow = 1
							end
							
							CLICK_currentIndex = CLICK_currentIndex+1
							
							if (cx >= ((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(CLICK_currentIndex-2)))+(ITEM_margin/2))) and (cx <= (((((sx-(ROW_width)-(ITEM_scale+ITEM_margin))/2)+((ITEM_scale+ITEM_margin)*(CLICK_currentIndex-2)))+(ITEM_margin/2))+ITEM_scale)) and (cy >= ((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(CLICK_currentRow-1)))) and (cy <= (((sy-((ITEM_scale+(ITEM_margin+(ITEM_margin/2)))*2))-((ITEM_scale+ITEM_margin)*(CLICK_currentRow-1)))+ITEM_scale)) then
								triggerServerEvent(":_doItemAction_:", localPlayer, items[cases[CATEGORY_open]][i][1], items[cases[CATEGORY_open]][i][2], items[cases[CATEGORY_open]][i][3])
								
								if (items[cases[CATEGORY_open]][i][2] == 10) then
									LOCKINVENTORY = true
								end
								
								if (exports['roleplay-accounts']:getAccountID(localPlayer) == 1) then
									if (GLOBAL_debug) then
										outputChatBox(" ")
										outputChatBox("Index: " .. CLICK_currentIndex)
										outputChatBox("Row: " .. CLICK_currentRow)
										outputChatBox("Table Index: " .. i)
										outputChatBox("DBID: " .. items[cases[CATEGORY_open]][i][1] .. ", Item: " .. items[cases[CATEGORY_open]][i][2] .. ", Value: " .. items[cases[CATEGORY_open]][i][3])
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

addEvent(":_syncInventory_:", true)
addEventHandler(":_syncInventory_:", root,
	function(items_)
		items = {
			["backpack"] = {},
			["keys"] = {},
			["weapons"] = {}
		}
		
		for i,v in pairs(items_) do
			if (items_[i][2]) then
				local type = cases[exports['roleplay-items']:getItemType(items_[i][2])]
				if (type) then
					table.insert(items[type], {items_[i][1], items_[i][2], items_[i][3], items_[i][4], items_[i][5]})
				end
			end
		end
		
		if (CATEGORY_open) then
			if (not doesContainData(CATEGORY_open)) then
				CATEGORY_open = nil
			end
		end
	end
)

addCommandHandler("fixinventory",
	function(cmd)
		if (not GLOBAL_cooldown) then
			GLOBAL_cooldown = true
			setTimer(function()
				if (isElement(localPlayer)) then
					GLOBAL_cooldown = not GLOBAL_cooldown
				end
			end, 5000, 1)
			outputChatBox("Fix deployed!", 20, 245, 20, false)
			triggerServerEvent(":_doGetInventory_:", localPlayer)
		else
			outputChatBox("Please wait a moment before fixing the inventory again!", 245, 20, 20, false)
		end
	end
)

addCommandHandler("invdebug",
	function(cmd)
		if (exports['roleplay-accounts']:getAccountID(localPlayer) ~= 1) then return end
		GLOBAL_debug = not GLOBAL_debug
		outputChatBox("Debug " .. (GLOBAL_debug and "on" or "off") .. ".")
	end
)

local function toggleInventory()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (LOCKINVENTORY) then
		outputChatBox("Exit your phone in order to toggle the inventory.", 245, 20, 20, false)
	else
		isVisible = not isVisible
		toggleAllControls(not isVisible, true, false)
		showCursor(isVisible, isVisible)
		CATEGORY_hovering = nil
		CATEGORY_open = nil
		DELETING = nil
		draggingWorldItem = false
		
	end
end

addEvent(":_updateLockVar_:", true)
addEventHandler(":_updateLockVar_:", root,
	function()
		LOCKINVENTORY = false
	end
)

addEvent(":_closeInventoryMenu_:", true)
addEventHandler(":_closeInventoryMenu_:", root,
	function()
		isVisible = false
		toggleAllControls(true, true, false)
		showCursor(false, false)
		CATEGORY_hovering = nil
		CATEGORY_open = nil
		DELETING = nil
		draggingWorldItem = false
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("i", "down", toggleInventory)
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		setTimer(function()
			triggerServerEvent(":_doGetInventory_:", localPlayer)
		end, 500, 1)
	end
)