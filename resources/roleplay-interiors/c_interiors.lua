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
local price, bank, cash, id = 0, 0, 0, 0

local function displayPurchaseWindow()
	if (isElement(g_purchase_window)) then
		destroyElement(g_purchase_window)
		showCursor(false)
		return
	end
	
	if (not tonumber(price)) or (not tonumber(bank)) or (not tonumber(cash)) or ((not tonumber(id)) or (tonumber(id) and tonumber(id) <= 0)) then
		outputChatBox("Error occurred when trying to display the property purchase options.", 245, 20, 20, false)
		return
	end
	
	g_purchase_window = guiCreateWindow((sx-380)/2, (sy-169)/2, 380, 169, "Purchase Property", false)
	guiWindowSetSizable(g_purchase_window, false)
	guiSetProperty(g_purchase_window, "AlwaysOnTop", "true")
	
	g_purchase_label = guiCreateLabel(15, 31, 349, 59, "You can purchase this property by cash or by bank. Choose your way of payment below.\n\nPrice: " .. exports['roleplay-banking']:getFormattedValue(price) .. " USD", false, g_purchase_window)
	guiLabelSetHorizontalAlign(g_purchase_label, "left", true)
	
	g_purchase_cancel = guiCreateButton(18, 115, 108, 41, "Cancel", false, g_purchase_window)
	g_purchase_cash = guiCreateButton(136, 115, 108, 41, "Pay by Cash", false, g_purchase_window)
	
	if (cash < price) then
		guiSetEnabled(g_purchase_cash, false)
	end
	
	g_purchase_bank = guiCreateButton(254, 115, 108, 41, "Pay by Bank", false, g_purchase_window)
	
	if (bank < price) then
		guiSetEnabled(g_purchase_bank, false)
	end
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", g_purchase_cancel, displayPurchaseWindow, false)
	addEventHandler("onClientGUIClick", g_purchase_cash,
		function()
			if (cash < price) then
				outputChatBox("You have insufficient funds in order to purchase this property by cash.", 245, 20, 20, false)
			else
				triggerServerEvent(":_purchaseProperty_:", localPlayer, false, id)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_purchase_bank,
		function()
			if (bank < price) then
				outputChatBox("You have insufficient funds in order to purchase this property by bank.", 245, 20, 20, false)
			else
				triggerServerEvent(":_purchaseProperty_:", localPlayer, true, id)
			end
		end, false
	)
end

local function enterInterior()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (getPedOccupiedVehicle(localPlayer)) then return end
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getInteriorID(v)) then
			local x, y, z = getElementPosition(localPlayer)
			local px, py, pz = getElementPosition(v)
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 1) then
				if (getElementInterior(localPlayer) == getElementInterior(v)) and (getElementDimension(localPlayer) == getElementDimension(v)) then
					if ((getInteriorOwner(v) == 0 and getInteriorOwner(v) == 0 or not isInteriorLocked(v))) then
						if (not isInteriorDisabled(v)) then
							triggerServerEvent(":_doEnterInterior_:", localPlayer, v)
							break
						else
							outputChatBox("The interior is disabled.", 245, 20, 20, false)
						end
					else
						outputChatBox("The door is locked.", 245, 20, 20, false)
					end
				end
			end
		end
	end
end

local function lockInterior()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (getPedOccupiedVehicle(localPlayer)) then return end
	local x, y, z = getElementPosition(localPlayer)
	for i,v in ipairs(getElementsByType("pickup")) do
		if (getInteriorID(v)) or (getElevatorID(v)) then
			local px, py, pz = getElementPosition(v)
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 1) then
				if (getElementInterior(localPlayer) == getElementInterior(v)) and (getElementDimension(localPlayer) == getElementDimension(v)) then
					triggerServerEvent(":_doLockInterior_:", localPlayer, v)
				end
			end
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("f", "down", enterInterior)
		bindKey("enter", "down", enterInterior)
		bindKey("k", "down", lockInterior)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		unbindKey("f", "down", enterInterior)
		unbindKey("enter", "down", enterInterior)
		unbindKey("k", "down", lockInterior)
	end
)

addEventHandler("onClientRender", root,
	function()
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		if (getPedOccupiedVehicle(localPlayer)) then return end
		for i,v in ipairs(getElementsByType("pickup")) do
			local x, y, z = getElementPosition(localPlayer)
			local px, py, pz = getElementPosition(v)
			if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 1) then
				if (getInteriorID(v)) then
					if (getElementInterior(localPlayer) == getElementInterior(v)) and (getElementDimension(localPlayer) == getElementDimension(v)) then
						local text = getInteriorName(v)
						local tip
						
						if (not text) then return end
						if (isInteriorForSale(v)) and (getInteriorType(v) ~= 0) then
							if (isElement(g_purchase_window)) then
								tip = "Choose your way of payment in order to finish the purchase."
							else
								tip = "Press 'F' or 'Enter' to open up payment options."
							end
						else
							tip = "Press 'F' or 'Enter' to interact with the door handle."
						end
						
						dxDrawRectangle(0, sy-200, sx, 120, tocolor(0, 0, 0, 0.75*255))
						dxDrawText(text, (sx-dxGetTextWidth(text)*2.4)/2, sy-168, dxGetTextWidth(text), 60, tocolor(0, 0, 0, 0.4*255), 2.0, "clear", "left", "top", false, false, false, false, false)
						dxDrawText(text, (sx-dxGetTextWidth(text)*2.4)/2, sy-170, dxGetTextWidth(text), 60, tocolor(250, 250, 250, 1.0*255), 2.0, "clear", "left", "top", false, false, false, false, false)
						dxDrawText(tip, (sx-dxGetTextWidth(tip)*1.2)/2, sy-125, dxGetTextWidth(tip), 60, tocolor(250, 250, 250, 1.0*255), 1.0, "clear", "left", "top", false, false, false, false, false)
						
						if (not getElementData(localPlayer, "roleplay:temp.stopvehlocking")) then
							setElementData(localPlayer, "roleplay:temp.stopvehlocking", 1, true)
						end
						
						break
					else
						if (getElementData(localPlayer, "roleplay:temp.stopvehlocking")) then
							triggerServerEvent(":_clearSuchTempVehData_:", localPlayer)
						end
					end
				elseif (getElevatorID(v)) then
					if (getElementInterior(localPlayer) == getElementInterior(v)) and (getElementDimension(localPlayer) == getElementDimension(v)) then
						if (not getElementData(localPlayer, "roleplay:temp.stopvehlocking")) then
							setElementData(localPlayer, "roleplay:temp.stopvehlocking", 1, true)
						end
						
						break
					else
						if (getElementData(localPlayer, "roleplay:temp.stopvehlocking")) then
							triggerServerEvent(":_clearSuchTempVehData_:", localPlayer)
						end
					end
				end
			end
		end
	end
)

addEvent(":_displayPurchaseOptions:INT_:", true)
addEventHandler(":_displayPurchaseOptions:INT_:", root,
	function(_price, _bank, _cash, _id)
		price, bank, cash, id = _price, _bank, _cash, _id
		displayPurchaseWindow()
	end
)

addEvent(":_closePropertyPurchaseMenu_:", true)
addEventHandler(":_closePropertyPurchaseMenu_:", root,
	function()
		if (isElement(g_purchase_window)) then
			destroyElement(g_purchase_window)
			showCursor(false)
		end
	end
)