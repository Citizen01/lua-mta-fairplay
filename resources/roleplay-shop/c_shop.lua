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

local shopID = 0
local g_shop_tab = {}
local g_shop_grid = {}
local tabs = {
	[1] = {
		["name"]	= "General Shop",
		["itemIDs"] = {	1, 	2, 	3, 	4, 	8, 	10, 13 }, -- Donut, Dice, Water, Coffee, Backpack, Cellphone, Walkie-Talkie
		["price"] 	= {	3, 	1, 	2, 	3, 	10,	50,	40 }
	}
}

local function displayShopMenu(id)
	if (isElement(g_shop_window)) then
		destroyElement(g_shop_window)
		showCursor(false)
		return
	end
	
	-- General
	g_shop_window = guiCreateWindow(496, 371, 672, 381, "Shop", false)
	guiWindowSetSizable(g_shop_window, false)
	guiSetProperty(g_shop_window, "AlwaysOnTop", "true")
	
	-- Shop Tabs
	g_shop_tabs = guiCreateTabPanel(10, 27, 652, 308, false, g_shop_window)
	
	g_shop_tab[id] = guiCreateTab(tabs[id]["name"], g_shop_tabs)
	g_shop_grid[id] = guiCreateGridList(10, 10, 632, 263, false, g_shop_tab[id])
	guiGridListAddColumn(g_shop_grid[id], "Name", 0.23)
	guiGridListAddColumn(g_shop_grid[id], "Description", 0.54)
	guiGridListAddColumn(g_shop_grid[id], "Price", 0.18)
	guiSetAlpha(g_shop_grid[id], 0.85)
	
	for i,v in ipairs(tabs[id]["itemIDs"]) do
		local row = guiGridListAddRow(g_shop_grid[id])
		guiGridListSetItemText(g_shop_grid[id], row, 1, exports['roleplay-items']:getItemName(v), false, false)
		guiGridListSetItemText(g_shop_grid[id], row, 2, exports['roleplay-items']:getItemDescription(v), false, false)
		guiGridListSetItemText(g_shop_grid[id], row, 3, tabs[id]["price"][i] .. " USD", false, false)
	end
	
	-- Buttons
	g_shop_exit = guiCreateButton(10, 339, 326, 31, "Exit Shop", false, g_shop_window)
	g_shop_purchase = guiCreateButton(340, 339, 322, 31, "Purchase Item", false, g_shop_window)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", g_shop_exit, displayShopMenu, false)
	addEventHandler("onClientGUIClick", g_shop_purchase,
		function()
			local row, column = guiGridListGetSelectedItem(g_shop_grid[id])
			if (row ~= -1) and (column ~= -1) then
				triggerServerEvent(":_doShopPurchase_:", localPlayer, guiGridListGetItemText(g_shop_grid[id], row, 1), guiGridListGetItemText(g_shop_grid[id], row, 3):gsub(" USD", ""))
			else
				outputChatBox("Select an item from the list in order to purchase.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIDoubleClick", g_shop_grid[id],
		function()
			local row, column = guiGridListGetSelectedItem(g_shop_grid[id])
			if (row ~= -1) and (column ~= -1) then
				triggerServerEvent(":_doShopPurchase_:", localPlayer, guiGridListGetItemText(g_shop_grid[id], row, 1), guiGridListGetItemText(g_shop_grid[id], row, 3):gsub(" USD", ""))
			else
				outputChatBox("Select an item from the list in order to purchase.", 245, 20, 20, false)
			end
		end, false
	)
end

addEvent(":_closeShopMenu_:", true)
addEventHandler(":_closeShopMenu_:", root,
	function(id)
		if (id) then
			if (shopID ~= 0) then
				if (id == shopID) then
					if (isElement(g_shop_window)) then
						destroyElement(g_shop_window)
						showCursor(false)
					end
				end
			end
		else
			if (isElement(g_shop_window)) then
				destroyElement(g_shop_window)
				showCursor(false)
			end
		end
	end
)

addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if (button == "left") and (state == "up") then
			if (clickedElement) then
				if (getElementType(clickedElement) == "ped") and (getShopID(clickedElement)) then
					if (isElement(g_shop_window)) then return end
					local x, y, z = getElementPosition(localPlayer)
					
					if (getDistanceBetweenPoints3D(x, y, z, worldX, worldY, worldZ) > 2) then
						outputChatBox("Get closer to the clerk in order to view the shop.", 245, 20, 20, false)
						return
					end
					
					shopID = getShopCategoryID(clickedElement)
					displayShopMenu(getShopCategoryID(clickedElement))
				end
			end
		end
	end
)

addEventHandler("onClientPedDamage", root,
	function(attacker, weapon, body, loss)
		if (getShopID(source)) then
			cancelEvent()
		end
	end
)