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
local isShowing = false
local updatingTimers = {}
local vehicle

local vehoptions = {
	window = {},
	button = {}
}

local vehdesc = {
	window = {},
	edit = {},
	button = {}
}

local function explode(self, separator)
	exports['roleplay-accounts']:Check("explode", "string", self, "ensemble", "string", separator, "separator")
	
	if (#self == 0) then return {} end
	if (#separator == 0) then return { self } end
	
	return loadstring("return {\"" .. self:gsub(separator, "\",\"") .. "\"}")()
end

local function displayVehicleDescription()
	if (isElement(vehdesc.window[1])) then
		destroyElement(vehdesc.window[1])
		guiSetEnabled(vehoptions.window[1], true)
		guiBringToFront(vehoptions.window[1])
		guiSetProperty(vehoptions.window[1], "AlwaysOnTop", "true")
	end
	
	guiMoveToBack(vehoptions.window[1])
	guiSetProperty(vehoptions.window[1], "AlwaysOnTop", "false")
	
	local exploded = explode(getVehicleDescription(vehicle), "\n")
	
	vehdesc.window[1] = guiCreateWindow((sx-283)/2, (sy-258)/2, 283, 258, "Edit Description", false)
	guiWindowSetSizable(vehdesc.window[1], false)
	guiSetProperty(vehdesc.window[1], "AlwaysOnTop", "true")
	guiBringToFront(vehdesc.window[1])
	
	local indexy = 0
	
	for i=1,5 do
		indexy = (indexy or 0)+31
		vehdesc.edit[i] = guiCreateEdit(10, indexy, 263, 27, (exploded[i] and exploded[i] or ""), false, vehdesc.window[1])
	end
	
	vehdesc.button[1] = guiCreateButton(10, 188, 263, 29, "Set Description", false, vehdesc.window[1])
	guiSetFont(vehdesc.button[1], "default-bold-small")
	vehdesc.button[2] = guiCreateButton(10, 221, 263, 29, "Close Window", false, vehdesc.window[1])
	
	addEventHandler("onClientGUIClick", vehdesc.button[1],
		function()
			local text = guiGetText(vehdesc.edit[1]) .. "\n" .. guiGetText(vehdesc.edit[2]) .. "\n" .. guiGetText(vehdesc.edit[3]) .. "\n" .. guiGetText(vehdesc.edit[4]) .. "\n" .. guiGetText(vehdesc.edit[5])
			triggerServerEvent(":_doSetVehicleDescOption_:", localPlayer, vehicle, text)
			destroyElement(vehdesc.window[1])
			guiSetEnabled(vehoptions.window[1], true)
			guiBringToFront(vehoptions.window[1])
		end, false
	)
	
	addEventHandler("onClientGUIClick", vehdesc.button[2],
		function()
			destroyElement(vehdesc.window[1])
			guiSetEnabled(vehoptions.window[1], true)
			guiBringToFront(vehoptions.window[1])
		end, false
	)
end

local doors = {
    button = {},
    window = {},
    scrollbar = {},
    label = {}
}

local function displayDoorStateMenu()
	if (isElement(doors.window[1])) then
		destroyElement(doors.window[1])
		guiSetEnabled(vehoptions.window[1], true)
		guiBringToFront(vehoptions.window[1])
		guiSetProperty(vehoptions.window[1], "AlwaysOnTop", "true")
		return
	end
	
	guiMoveToBack(vehoptions.window[1])
	guiSetProperty(vehoptions.window[1], "AlwaysOnTop", "false")
	
	local seat = -1
	for currentSeat=0,(getVehicleMaxPassengers(vehicle) or 0) do
		if (getVehicleOccupant(vehicle, currentSeat) == localPlayer) then
			seat = currentSeat
			break
		end
	end
	
	local yPos = 30
	local vehDoors = getVehicleDoors(getElementModel(vehicle), seat)
	if (#vehDoors == 0) then return end
	
	doors.window[1] = guiCreateWindow(689, 331, 290, (yPos+(25*#vehDoors))+38, "Door State", false)
	guiWindowSetSizable(doors.window[1], false)
	guiBringToFront(doors.window[1])
	guiSetProperty(doors.window[1], "AlwaysOnTop", "true")
	
	for i,entry in ipairs(vehDoors) do
		doors.label[i] = guiCreateLabel(11, yPos, 125, 15, entry[1], false, doors.window[1])
		guiSetFont(doors.label[i], "default-bold-small")
		doors.scrollbar[i] = guiCreateScrollBar(130, yPos, 152, 16, true, false, doors.window[1])
		setElementData(doors.scrollbar[i], "roleplay:guidata.doorstate", entry[2], false)
		addEventHandler("onClientGUIScroll", doors.scrollbar[i], updatingTimer)
		
		yPos = yPos+25
		
		local doorPos = getVehicleDoorOpenRatio(vehicle, entry[2])
		if (doorPos) then
			local doorPos = doorPos*100
			guiScrollBarSetScrollPosition(doors.scrollbar[i], doorPos)
		end	
	end
	
	doors.button[1] = guiCreateButton(10, yPos+3, 285, 25, "Exit", false, doors.window[1])
	guiSetFont(doors.button[1], "default-bold-small")
	
	addEventHandler("onClientGUIClick", doors.button[1], displayDoorStateMenu, false)
end

function updatingTimer(guiElement)
	if (not isElement(doors.window[1])) or (isTimer(updatingTimers[guiElement])) or (not tonumber(getElementData(guiElement, "roleplay:guidata.doorstate"))) then return end
	local position = guiScrollBarGetScrollPosition(guiElement)
	local ratio = (position/100)
	
	if (position == 0) then
		ratio = 0
	elseif (position == 100) then
		ratio = 1
	end
	
	setVehicleDoorOpenRatio(vehicle, tonumber(getElementData(guiElement, "roleplay:guidata.doorstate")), ratio, 0.5)
	updatingTimers[guiElement] = setTimer(processDoorSync, 200, 1, guiElement)
end

function processDoorSync(guiElement)
	if (not isElement(doors.window[1])) or (isVehicleLocked(vehicle)) then return end
	local vx, vy, vz = getElementPosition(vehicle)
	
	if (not getPedOccupiedVehicle(localPlayer) == vehicle) and (getDistanceBetweenPoints3D(vx, vy, vz, getElementPosition(localPlayer)) > 6) then
		displayDoorStateMenu()
		displayVehicleOptions()
		return
	end
	
	triggerServerEvent(":_syncVehicleDoorStates_:", root, vehicle, tonumber(getElementData(guiElement, "roleplay:guidata.doorstate")), guiScrollBarGetScrollPosition(guiElement))
	updatingTimers[guiElement] = nil
end

local function displayVehicleOptions(x, y, cVehicle)
	if (isElement(vehoptions.window[1])) then
		destroyElement(vehoptions.window[1])
		showCursor(false)
		return
	end
	
	vehicle = cVehicle
	
	vehoptions.window[1] = guiCreateWindow(x, y, 171, 206, "Vehicle Options", false)
	guiWindowSetSizable(vehoptions.window[1], false)
	guiSetProperty(vehoptions.window[1], "AlwaysOnTop", "true")
	
	vehoptions.button[1] = guiCreateButton(9, 27, 152, 29, "Inventory", false, vehoptions.window[1])
	guiSetEnabled(vehoptions.button[1], false)
	
	vehoptions.button[2] = guiCreateButton(9, 62, 152, 29, (isVehicleLocked(vehicle) and "Unlock Vehicle" or "Lock Vehicle"), false, vehoptions.window[1])
	guiSetEnabled(vehoptions.button[2], false)
	
	vehoptions.button[3] = guiCreateButton(9, 97, 152, 29, "Edit Description", false, vehoptions.window[1])
	guiSetEnabled(vehoptions.button[3], false)
	vehoptions.button[4] = guiCreateButton(9, 132, 152, 29, "Door State", false, vehoptions.window[1])
	
	local seat = -1
	for currentSeat=0,(getVehicleMaxPassengers(vehicle) or 0) do
		if (getVehicleOccupant(vehicle, currentSeat) == localPlayer) then
			seat = currentSeat
			break
		end
	end
	
	local vehDoors = getVehicleDoors(getElementModel(vehicle), seat)
	if (#vehDoors == 0) then
		guiSetEnabled(vehoptions.button[4], false)
	end
	
	vehoptions.button[5] = guiCreateButton(9, 165, 152, 29, "Close Menu", false, vehoptions.window[1])
	guiSetFont(vehoptions.button[5], "default-bold-small")
	
	showCursor(true)
	
	triggerServerEvent(":_doFetchOptionMenuData_:", localPlayer, vehicle)
	
	addEventHandler("onClientGUIClick", vehoptions.button[2],
		function()
			triggerServerEvent(":_doToggleVehicleLockOption_:", localPlayer, vehicle)
		end, false
	)
	
	addEventHandler("onClientGUIClick", vehoptions.button[3],
		function()
			guiSetEnabled(vehoptions.window[1], false)
			displayVehicleDescription(vehicle)
		end, false
	)
	
	addEventHandler("onClientGUIClick", vehoptions.button[4],
		function()
			guiSetEnabled(vehoptions.window[1], false)
			displayDoorStateMenu(vehicle)
		end, false
	)
	
	addEventHandler("onClientGUIClick", vehoptions.button[5],
		function()
			destroyElement(vehoptions.window[1])
			showCursor(false)
		end, false
	)
end

addEvent(":_doUpdateOptionMenu_:", true)
addEventHandler(":_doUpdateOptionMenu_:", root,
	function(bool)
		if (isElement(vehoptions.button[2])) then
			guiSetEnabled(vehoptions.button[2], bool)
			guiSetEnabled(vehoptions.button[3], bool)
		end
	end
)

addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if (button == "right") and (state == "up") then
			if (clickedElement) and (getElementType(clickedElement) == "vehicle") then
				if (getVehicleRealID(clickedElement)) and (getVehicleRealType(clickedElement) > 0) then
					local x, y, z = getElementPosition(localPlayer)
					local vx, vy, vz = getElementPosition(clickedElement)
					if (getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 6) and (getElementInterior(localPlayer) == getElementInterior(clickedElement)) and (getElementDimension(localPlayer) == getElementDimension(clickedElement)) then
						if (not tonumber(getElementData(localPlayer, "roleplay:temp.isRefueling"))) then
							if (isElement(vehoptions.window[1])) then
								if (not isElement(vehdesc.window[1])) and (not isElement(doors.window[1])) then
									local cx, cy = guiGetPosition(vehoptions.window[1], false)
									local csx, csy = guiGetSize(vehoptions.window[1], false)
									if ((absoluteX > cx+csx) or (absoluteX < cx)) and ((absoluteY > cy+csy) or (absoluteY < cy)) then
										displayVehicleOptions(absoluteX, absoluteY, clickedElement)
									end
								end
							else
								displayVehicleOptions(absoluteX, absoluteY, clickedElement)
							end
						else
							if (isElement(vehoptions.window[1])) then
								destroyElement(vehoptions.window[1])
							end
							
							if (isElement(vehdesc.window[1])) then
								destroyElement(vehdesc.window[1])
							end
							
							if (isElement(doors.window[1])) then
								destroyElement(doors.window[1])
							end
							
							vehicle = nil
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientPlayerVehicleExit", localPlayer,
	function()
		if (isElement(vehoptions.window[1])) then
			destroyElement(vehoptions.window[1])
		end
		
		if (isElement(vehdesc.window[1])) then
			destroyElement(vehdesc.window[1])
		end
		
		if (isElement(doors.window[1])) then
			destroyElement(doors.window[1])
		end
		
		vehicle = nil
	end
)

addEvent(":_destroyDescription_:", true)
addEventHandler(":_destroyDescription_:", root,
	function()
		if (isElement(vehoptions.window[1])) then
			destroyElement(vehoptions.window[1])
		end
		
		if (isElement(vehdesc.window[1])) then
			destroyElement(vehdesc.window[1])
		end
		
		if (isElement(doors.window[1])) then
			destroyElement(doors.window[1])
		end
		
		vehicle = nil
	end
)

-- Descriptions
local function displayDescriptionDX()
	if (not isShowing) then return end
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	local x, y, z = getElementPosition(localPlayer)
	for _,vehicle in ipairs(getElementsByType("vehicle")) do
		local vx, vy, vz = getElementPosition(vehicle)
		if (getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 15) and (getElementInterior(localPlayer) == getElementInterior(vehicle)) and (getElementDimension(localPlayer) == getElementDimension(vehicle)) then
			local mx, my, mz = getCameraMatrix()
			local col, _, _, _, hitElement = processLineOfSight(mx, my, mz, vx, vy, vz+1, true, true, true, true, false, false, true, false, vehicle)
			if (not col) and (isElementOnScreen(vehicle)) then
				local vsx, vsy = getScreenFromWorldPosition(vx, vy, vz)
				
				if (not vsx) or (not vsy) then
					vsx = -1000
					vsy = -1000
				end
				
				local description = (getElementData(vehicle, "roleplay:vehicles.description") and getVehicleDescription(vehicle) or "")
				local spaces = 0
				
				for i=1,#description do
					local char = string.sub(description, i, i)
					if (char == "\n") then
						spaces = spaces+1
					end
				end
				
				dxDrawText(description, vsx-224, vsy-199, (vsx-224)+430, vsy+(dxGetFontHeight(0.6, "bankgothic")*spaces), tocolor(0, 0, 0, 0.5*255), 0.6, "bankgothic", "center", "top", false, true, false, false, false)
				dxDrawText(description, vsx-225, vsy-200, (vsx-224)+430, vsy+(dxGetFontHeight(0.6, "bankgothic")*spaces), tocolor(20, 245, 20, 0.93*255), 0.6, "bankgothic", "center", "top", false, true, false, false, false)
			end
		end
	end
end

local function toggleDescription()
	if (isShowing) then
		isShowing = false
		removeEventHandler("onClientRender", root, displayDescriptionDX)
	else
		isShowing = true
		addEventHandler("onClientRender", root, displayDescriptionDX)
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("lalt", "both", toggleDescription)
		bindKey("ralt", "both", toggleDescription)
	end
)