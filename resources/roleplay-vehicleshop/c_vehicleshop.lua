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
local price, bank, cash, vehicle = 0, 0, 0, 0

local function displayPurchaseWindow()
	if (isElement(g_purchase_window)) then
		destroyElement(g_purchase_window)
		showCursor(false)
		return
	end
	
	if (not tonumber(price)) or (not tonumber(bank)) or (not tonumber(cash)) or (not vehicle) then
		outputChatBox("Error occurred when trying to display the vehicle purchase options.", 245, 20, 20, false)
		return
	end
	
	if (getVehicleType(vehicle) == "Automobile") then
		g_purchase_window = guiCreateWindow((sx-380)/2, (sy-204)/2, 380, 204, "Purchase Vehicle", false)
		guiWindowSetSizable(g_purchase_window, false)
		guiSetProperty(g_purchase_window, "AlwaysOnTop", "true")
		
		g_purchase_label = guiCreateLabel(15, 31, 349, 59, "You can purchase this vehicle by cash or by bank. Choose your way of payment below.\n\nPrice: " .. exports['roleplay-banking']:getFormattedValue(price) .. " USD", false, g_purchase_window)
		guiLabelSetHorizontalAlign(g_purchase_label, "left", true)
		
		g_purchase_translabel = guiCreateLabel(15, 105, 111, 15, "Transmission:", false, g_purchase_window)
		guiSetFont(g_purchase_translabel, "clear-normal")
		
		g_purchase_trans = guiCreateComboBox(136, 100, 226, 61, "Select...", false, g_purchase_window)
		guiComboBoxAddItem(g_purchase_trans, "Manual Transmission")
		guiComboBoxAddItem(g_purchase_trans, "Automatic Transmission")
		guiComboBoxSetSelected(g_purchase_trans, 0)
		
		g_purchase_cash = guiCreateButton(136, 146, 108, 41, "Pay by Cash", false, g_purchase_window)
		
		if (cash < price) then
			guiSetEnabled(g_purchase_cash, false)
		end
		
		g_purchase_bank = guiCreateButton(254, 146, 108, 41, "Pay by Bank", false, g_purchase_window)
		
		if (bank < price) then
			guiSetEnabled(g_purchase_bank, false)
		end
		
		g_purchase_cancel = guiCreateButton(18, 146, 108, 41, "Cancel", false, g_purchase_window)
	else
		g_purchase_window = guiCreateWindow((sx-380)/2, (sy-204)/2, 380, 160, "Purchase Vehicle", false)
		guiWindowSetSizable(g_purchase_window, false)
		guiSetProperty(g_purchase_window, "AlwaysOnTop", "true")
		
		g_purchase_label = guiCreateLabel(15, 31, 349, 59, "You can purchase this vehicle by cash or by bank. Choose your way of payment below.\n\nPrice: " .. exports['roleplay-banking']:getFormattedValue(price) .. " USD", false, g_purchase_window)
		guiLabelSetHorizontalAlign(g_purchase_label, "left", true)
		
		g_purchase_cash = guiCreateButton(136, 107, 108, 41, "Pay by Cash", false, g_purchase_window)
		
		if (cash < price) then
			guiSetEnabled(g_purchase_cash, false)
		end
		
		g_purchase_bank = guiCreateButton(254, 107, 108, 41, "Pay by Bank", false, g_purchase_window)
		
		if (bank < price) then
			guiSetEnabled(g_purchase_bank, false)
		end
		
		g_purchase_cancel = guiCreateButton(18, 107, 108, 41, "Cancel", false, g_purchase_window)
	end
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", g_purchase_cancel, displayPurchaseWindow, false)
	addEventHandler("onClientGUIClick", g_purchase_cash,
		function()
			if (cash < price) then
				outputChatBox("You have insufficient funds in order to purchase this vehicle by cash.", 245, 20, 20, false)
			else
				triggerServerEvent(":_purchaseVehicle_:", localPlayer, false, vehicle)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_purchase_bank,
		function()
			if (bank < price) then
				outputChatBox("You have insufficient funds in order to purchase this vehicle by bank.", 245, 20, 20, false)
			else
				triggerServerEvent(":_purchaseVehicle_:", localPlayer, true, vehicle)
			end
		end, false
	)
end

local function buyVehicle()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (getPedOccupiedVehicle(localPlayer)) then return end
	for i,v in ipairs(getElementsByType("marker")) do
		if (isElementWithinMarker(localPlayer, v)) and (getElementData(v, "roleplay:markers.carname")) then
			local x, y, z = getElementPosition(v)
			if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) < 2) then
				if (getElementInterior(localPlayer) == getElementInterior(v)) and (getElementDimension(localPlayer) == getElementDimension(v)) then
					triggerServerEvent(":_initPurchase:VEH_:", localPlayer, v)
					break
				end
			end
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		bindKey("f", "down", buyVehicle)
		bindKey("enter", "down", buyVehicle)
	end
)

addEventHandler("onClientRender", root,
	function()
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		if (getPedOccupiedVehicle(localPlayer)) then return end
		for i,v in ipairs(getElementsByType("marker")) do
			if (isElementWithinMarker(localPlayer, v)) and (getElementData(v, "roleplay:markers.carname")) then
				local x, y, z = getElementPosition(v)
				if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) < 2) then
					if (getElementInterior(localPlayer) == getElementInterior(v)) and (getElementDimension(localPlayer) == getElementDimension(v)) then
						local text = getElementData(v, "roleplay:markers.carname")
						if (not text) then return end
						local tip
						
						if (isElement(g_purchase_window)) then
							tip = "Choose your way of payment in order to finish the purchase."
						else
							tip = "Press 'F' or 'Enter' to open up payment options."
						end
						
						dxDrawRectangle(0, sy-200, sx, 120, tocolor(0, 0, 0, 0.75*255))
						dxDrawText(text, (sx-dxGetTextWidth(text)*2.4)/2, sy-168, dxGetTextWidth(text), 60, tocolor(0, 0, 0, 0.4*255), 2.0, "clear", "left", "top", false, false, false, false, false)
						dxDrawText(text, (sx-dxGetTextWidth(text)*2.4)/2, sy-170, dxGetTextWidth(text), 60, tocolor(250, 250, 250, 1.0*255), 2.0, "clear", "left", "top", false, false, false, false, false)
						dxDrawText(tip, (sx-dxGetTextWidth(tip)*1.2)/2, sy-125, dxGetTextWidth(tip), 60, tocolor(250, 250, 250, 1.0*255), 1.0, "clear", "left", "top", false, false, false, false, false)
					end
				end
			end
		end
	end
)

addEvent(":_displayPurchaseOptions:VEH_:", true)
addEventHandler(":_displayPurchaseOptions:VEH_:", root,
	function(_price, _bank, _cash, _vehicle)
		price, bank, cash, vehicle = _price, _bank, _cash, _vehicle
		displayPurchaseWindow()
	end
)

addEvent(":_closeVehiclePurchaseMenu_:", true)
addEventHandler(":_closeVehiclePurchaseMenu_:", root,
	function()
		if (isElement(g_purchase_window)) then
			destroyElement(g_purchase_window)
			showCursor(false)
		end
	end
)