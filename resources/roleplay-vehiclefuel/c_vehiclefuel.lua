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
local enginelessVehicle = {[510]=true, [509]=true, [481]=true}
local windowless = {[568]=true, [601]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [528]=true, [530]=true, [531]=true, [532]=true, [571]=true, [572]=true}
local roofless = {[568]=true, [500]=true, [439]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [530]=true, [531]=true, [533]=true, [536]=true, [555]=true, [571]=true, [572]=true, [575]=true, [536]=true, [567]=true, [555]=true}
local bike = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true}
local isRefueling
local fuelAmount = 0
local fuelOriginal = 0
local lastX, lastY = sx/2, sy/2
local postGUI = false
local fuelTimers = {}
local fuelWindow = {
    window = {},
    label = {},
    button = {}
}

local function dxDisplayRefuel()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) or (not isRefueling) then return end
	
	local cx, cy = getCursorPosition()
	if (cx) and (cy) then
		cx, cy = cx*sx, cy*sy
		lastX, lastY = cx, cy
	end
	
	dxDrawRectangle(lastX, lastY, 150, 45, tocolor(0, 0, 0, 0.8*255), postGUI)
	dxDrawText(fuelAmount .. "%", lastX, lastY, lastX+150, lastY+45, (fuelAmount <= 25 and tocolor(230, 50, 50, 0.9*255) or ((fuelAmount > 25 and fuelAmount <= 50) and tocolor(230, 150, 50, 0.9*255) or tocolor(40, 190, 40, 0.9*255))), 1.5, "default", "center", "center", true, false, postGUI, false, true)
end

local function displayRefuelWindow()
	if (isElement(fuelWindow.window[1])) then
		destroyElement(fuelWindow.window[1])
		showCursor(false)
		isRefueling = false
		return
	end
	
	fuelWindow.window[1] = guiCreateWindow(646, 424, 380, 112, "Confirm Refuel", false)
	guiWindowSetSizable(fuelWindow.window[1], false)
	
	fuelWindow.label[1] = guiCreateLabel(11, 33, 359, 15, "Would you like to proceed to refueling?", false, fuelWindow.window[1])
	guiLabelSetHorizontalAlign(fuelWindow.label[1], "center", false)
	
	fuelWindow.button[1] = guiCreateButton(10, 66, 176, 34, "Continue", false, fuelWindow.window[1])
	addEventHandler("onClientGUIClick", fuelWindow.button[1],
		function()
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if (not vehicle) then displayRefuelWindow() return end
			triggerServerEvent(":_doRefuelAction_:", localPlayer)
			displayRefuelWindow()
			addEventHandler("onClientRender", root, dxDisplayRefuel)
			fuelAmount = math.ceil(tonumber(getElementData(vehicle, "roleplay:vehicles.fuel;")))
			fuelOriginal = math.ceil(tonumber(getElementData(vehicle, "roleplay:vehicles.fuel;")))
			triggerEvent(":_destroyDescription_:", localPlayer)
			isRefueling = true
		end, false
	)
	
	fuelWindow.button[2] = guiCreateButton(196, 66, 174, 34, "Cancel", false, fuelWindow.window[1])
	addEventHandler("onClientGUIClick", fuelWindow.button[2], displayRefuelWindow, false)
	
	showCursor(true)
	isRefueling = true
end

addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if (not clickedElement) then return end
		if (button == "left") then
			if (state == "down") then
				if (getElementType(clickedElement) == "vehicle") then
					if (tonumber(getElementData(localPlayer, "roleplay:temp.isRefueling"))) then
						if (exports['roleplay-vehicles']:getVehicleRealID(clickedElement)) and (exports['roleplay-vehicles']:getVehicleRealID(clickedElement) == tonumber(getElementData(localPlayer, "roleplay:temp.isRefueling"))) then
							if (fuelAmount < 100) then
								fuelTimers[clickedElement] = setTimer(function(vehicle, player)
									if (isElement(vehicle)) and (isElement(player)) then
										if (fuelAmount >= 100) then
											fuelAmount = 100
											killTimer(fuelTimers[clickedElement])
										else
											if (fuelAmount >= 95) then
												outputChatBox("Your tank is now filled. Right click to finish the payment.", 20, 245, 20, false)
												killTimer(fuelTimers[clickedElement])
											end
											fuelAmount = math.min(100, fuelAmount+5)
										end
									else
										killTimer(fuelTimers[clickedElement])
									end
								end, 600, 0, clickedElement, localPlayer)
							else
								fuelAmount = math.min(100, fuelAmount)
							end
						end
					end
				end
			elseif (state == "up") then
				if (getElementType(clickedElement) == "ped") then
					if (getFuelPointID(clickedElement)) then
						local x, y, z = getElementPosition(localPlayer)
						if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(clickedElement)) <= 2.5) then
							if (isRefueling) then return end
							local vehicle = getPedOccupiedVehicle(localPlayer)
							if (not vehicle) or (getVehicleController(vehicle) ~= localPlayer) or (vehicle and not exports['roleplay-vehicles']:getVehicleRealID(vehicle) or exports['roleplay-vehicles']:getVehicleRealID(vehicle) <= 0) then return end
							if (enginelessVehicle[getElementModel(vehicle)]) then
								outputChatBox("You cannot refuel a vehicle like this.", 245, 20, 20, false)
								return
							end
							
							if (not windowless[getElementModel(vehicle)]) and (not roofless[getElementModel(vehicle)]) and (not bike[getElementModel(vehicle)]) then
								if (not exports['roleplay-vehicles']:isVehicleWindowsDown(vehicle)) then
									outputChatBox("Roll down your window in order to interact with the employee.", 245, 20, 20, false)
									return
								end
							end
							
							displayRefuelWindow()
						end
					end
				end
				
				if (fuelTimers[clickedElement]) and (isTimer(fuelTimers[clickedElement])) then
					killTimer(fuelTimers[clickedElement])
					fuelAmount = math.min(100, fuelAmount)
				end
			end
		elseif (button == "right") then
			if (state == "down") then
				if (getElementType(clickedElement) == "vehicle") then
					if (tonumber(getElementData(localPlayer, "roleplay:temp.isRefueling"))) and (isRefueling) then
						if (exports['roleplay-vehicles']:getVehicleRealID(clickedElement)) and (exports['roleplay-vehicles']:getVehicleRealID(clickedElement) == tonumber(getElementData(localPlayer, "roleplay:temp.isRefueling"))) then
							if (fuelTimers[clickedElement]) and (isTimer(fuelTimers[clickedElement])) then
								killTimer(fuelTimers[clickedElement])
								fuelAmount = math.min(100, fuelAmount)
							end
							triggerServerEvent(":_finishRefuel_:", localPlayer, clickedElement, fuelAmount)
							removeEventHandler("onClientRender", root, dxDisplayRefuel)
							isRefueling = false
						end
					end
				end
			end
		end
	end
)