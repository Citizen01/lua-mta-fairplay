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

local weaponmodels = {
	[1]=331, [2]=333, [3]=326, [4]=335, [5]=336, [6]=337, [7]=338, [8]=339, [9]=341,
	[15]=326, [22]=346, [23]=347, [24]=348, [25]=349, [26]=350, [27]=351, [28]=352,
	[29]=353, [32]=372, [30]=355, [31]=356, [33]=357, [34]=358, [35]=359, [36]=360,
	[37]=361, [38]=362, [16]=342, [17]=343, [18]=344, [39]=363, [41]=365, [42]=366,
	[43]=367, [10]=321, [11]=322, [12]=323, [14]=325, [44]=368, [45]=369, [46]=371,
	[40]=364, [100]=373
}

local weaponweights = {
	[22] = 1.14, [23] = 1.24, [24] = 2, [25] = 3.1, [26] = 2.1, [27] = 4.2, [28] = 3.6, [29] = 2.640, [30] = 4.3, [31] = 2.68, [32] = 3.6, [33] = 4.0, [34] = 4.3
}

local ammoweights = {
	[22] = 0.0224, [23] = 0.0224, [24] = 0.017, [25] = 0.037, [26] = 0.037, [27] = 0.037, [28] = 0.009, [29] = 0.012, [30] = 0.0165, [31] = 0.0112, [32] = 0.009, [33] = 0.0128, [34] = 0.027
}

local itemlist = {
	-- Name, Description, Value, Model, Offset X, Offset Y, Offset Z, Offset RX, Offset RY, Offset RZ, Alpha, Collisions, Type (1 = backpack, 2 = key, 3 = weapon), Weight
	[1]  = {"Donut", 		"A delicious donut for your taste.",					10,		2222,	0, 	0, 	0.08, 	0, 	0, 	0, 255, true,	 1, 0.2},
	[2]  = {"Dice",			"Tonight we're getting lucky!", 						10, 	1271, 	0, 	0, 	0.35, 	0, 	0, 	0, 255, true,	 1, 0.1},
	[3]  = {"Water",		"Fresh and pure natural water.",						10, 	2647, 	0, 	0, 	0.12, 	0, 	0, 	0, 255, true,	 1, 1.0},
	[4]  = {"Coffee",		"Fresh and warm cup of coffee.",						10, 	2647, 	0, 	0, 	0.12, 	0, 	0, 	0, 255, true,	 1, 1.2},
	[5]  = {"LSPD Badge",	"A Los Santos Police Department badge.",				"", 	1581, 	0, 	0, 	0, 		0, 	0, 	0, 255, true,	 1, 0.5},
	[6]  = {"House Key",	"A key to a house.",									0, 		1581, 	0, 	0, 	0, 		0, 	0, 	0, 255, true,	 2, 0.1},
	[7]  = {"Vehicle Key",	"A key to a vehicle.",									0, 		1581, 	0, 	0, 	0, 		0, 	0, 	0, 255, true,	 2, 0.15},
	[8]  = {"Backpack",		"A pack that you carry on your back.",					0, 		2386, 	0, 	0, 	0.1, 	0, 	0, 	0, 255, true,	 1, 1.0},
	[9]  = {"Duty Belt",	"A belt that you can put your duty gear on.",			0, 		2386, 	0, 	0, 	0.1, 	0, 	0, 	0, 255, true,	 1, 1.2},
	[10] = {"Cellphone",	"It's a thing that you use to contact someone.",		"", 	330, 	0, 	0, 	0.1, 	0, 	0, 	0, 255, true,	 1, 0.4},
	[11] = {"Weapon",		"A deadly looking object.",								"", 	1271, 	0, 	0, 	0.1, 	0, 	0, 	0, 255, true,	 3, 0.4},
	[12] = {"Ammopack",		"A container with deadly looking bullets in it.",		"", 	1271, 	0, 	0, 	0.1, 	0, 	0, 	0, 255, true,	 3, 0.4},
	[13] = {"Walkie-Talkie","A thing you can use to communicate with a frequency.",	"", 	330, 	0, 	0, 	0.1, 	0, 	0, 	0, 255, true,	 1, 0.4},
	[14] = {"Megaphone",	"A big thing you can use to jumpscare people with.",	"", 	1271, 	0, 	0, 	0.1, 	0, 	0, 	0, 255, true,	 1, 0.4},
}

function getItem(id)
	if (not tonumber(id)) then return false, 1 end
	if (not itemlist[id]) then return false end
	return itemlist[id]
end

function getItemByName(name)
	if (not name) then return false, 1 end
	local matches = {}
	for i,v in ipairs(itemlist) do
		if (getItemName(i) == name) then
			table.insert(matches, i)
		end
	end
	if (#matches == 1) then
		return matches[1]
	end
	return false
end

function getItems()
	return itemlist
end

function getItemName(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][1]
	else
		return false
	end
end

function getItemDescription(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][2]
	else
		return false
	end
end

function getItemValue(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][3]
	else
		return false
	end
end

function getItemModel(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][4]
	else
		return false
	end
end

function getItemOffset(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][5], itemlist[itemID][6], itemlist[itemID][7], itemlist[itemID][8], itemlist[itemID][9], itemlist[itemID][10]
	else
		return false
	end
end

function getItemAlpha(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][11]
	else
		return false
	end
end

function isItemCollisionsEnabled(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][12]
	else
		return false
	end
end

function getItemType(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][13]
	else
		return false
	end
end

function getItemWeight(itemID)
	if (itemlist[itemID]) then
		return itemlist[itemID][14]
	else
		return false
	end
end

function isWorldItem(element)
	if (not element) or (getElementType(element) ~= "object") then return end
	if (not tonumber(getElementData(element, "roleplay:worlditems.id"))) then return false, 1 end
	local elementData = tonumber(getElementData(element, "roleplay:worlditems.id"))
	if (elementData > 0) then
		return {tonumber(getElementData(element, "roleplay:worlditems.id")), tonumber(getElementData(element, "roleplay:worlditems.itemID")), getElementData(element, "roleplay:worlditems.value")}
	else
		return false, 3
	end
end