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
local gatesLoaded = false
local gates = {}
local easingMethods = {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

local gateeditor = {
	window = {},
	button = {},
	gridlist = {}
}

local creategate = {
	window = {},
	button = {},
	label = {},
	edit = {},
	gridlist = {}
}

local verification = {
	window = {},
	button = {},
	label = {}
}

function getMethodName(methodID)
	local methodID = tonumber(methodID)
	if (methodID == 1) then
		return "Everybody"
	elseif (methodID == 2) then
		return "Faction"
	elseif (methodID == 3) then
		return "Item ID"
	elseif (methodID == 4) then
		return "Item ID & Value"
	elseif (methodID == 5) then
		return "Item Value"
	elseif (methodID == 6) then
		return "Password"
	else
		return "?"
	end
end

function displayGateEditor()
	if (not gatesLoaded) then
		outputChatBox("The gates haven't loaded yet. Try again in a few seconds.", 245, 20, 20, false)
		return
	end
	
	if (isElement(gateeditor.window[1])) then
		destroyElement(gateeditor.window[1])
		showCursor(false, false)
		return
	end
	
	gateeditor.window[1] = guiCreateWindow((sx-482)/2, (sy-337)/2, 482, 337, "Gate Editor", false)
	guiWindowSetSizable(gateeditor.window[1], false)

	gateeditor.gridlist[1] = guiCreateGridList(9, 24, 463, 208, false, gateeditor.window[1])
	guiGridListAddColumn(gateeditor.gridlist[1], "ID", 0.15)
	guiGridListAddColumn(gateeditor.gridlist[1], "Name", 0.31)
	guiGridListAddColumn(gateeditor.gridlist[1], "Method", 0.25)
	guiGridListAddColumn(gateeditor.gridlist[1], "Condition", 0.25)
	
	for i,v in pairs(gates) do
		if (gates[i]["id"]) then
			local row = guiGridListAddRow(gateeditor.gridlist[1])
			guiGridListSetItemText(gateeditor.gridlist[1], row, 1, gates[i]["id"], false, false)
			guiGridListSetItemText(gateeditor.gridlist[1], row, 2, (gates[i]["gateName"] and gates[i]["gateName"] or "?"), false, false)
			guiGridListSetItemText(gateeditor.gridlist[1], row, 3, getMethodName(gates[i]["lockMethod"]), false, false)
			guiGridListSetItemText(gateeditor.gridlist[1], row, 4, (string.len(gates[i]["openCondition"]) == 0 and "None" or gates[i]["openCondition"]), false, false)
		end
	end
	
	gateeditor.button[1] = guiCreateButton(9, 242, 148, 35, "Create Gate", false, gateeditor.window[1])
	gateeditor.button[2] = guiCreateButton(166, 242, 148, 35, "Delete Gate", false, gateeditor.window[1])
	gateeditor.button[3] = guiCreateButton(324, 242, 148, 35, "Go to Gate", false, gateeditor.window[1])
	gateeditor.button[4] = guiCreateButton(166, 287, 306, 35, "Exit Editor", false, gateeditor.window[1])
	guiSetFont(gateeditor.button[4], "default-bold-small")
	
	gateeditor.button[5] = guiCreateButton(9, 287, 148, 35, "Modify Gate", false, gateeditor.window[1])
	
	showCursor(true, true)
	
	addEventHandler("onClientGUIClick", gateeditor.button[1], function() displayGateEdit(false) end, false)
	addEventHandler("onClientGUIClick", gateeditor.button[4], displayGateEditor, false)
	
	addEventHandler("onClientGUIClick", gateeditor.button[2],
		function()
			local row, col = guiGridListGetSelectedItem(gateeditor.gridlist[1])
			if (row ~= -1) and (col ~= -1) then
				displayVerificationWindow()
			else
				outputChatBox("Select a gate from the gridlist first.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", gateeditor.button[3],
		function()
			local row, col = guiGridListGetSelectedItem(gateeditor.gridlist[1])
			if (row ~= -1) and (col ~= -1) then
				triggerServerEvent(":_goToGate_:", localPlayer, guiGridListGetItemText(gateeditor.gridlist[1], row, 1))
			else
				outputChatBox("Select a gate from the gridlist first.", 245, 20, 20, false)
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", gateeditor.button[5],
		function()
			local row, col = guiGridListGetSelectedItem(gateeditor.gridlist[1])
			if (row ~= -1) and (col ~= -1) then
				displayGateEdit(tonumber(guiGridListGetItemText(gateeditor.gridlist[1], row, 1)))
			else
				outputChatBox("Select a gate from the gridlist first.", 245, 20, 20, false)
			end
		end, false
	)
end

function displayGateEdit(gateID)
	if (isElement(creategate.window[1])) then
		destroyElement(creategate.window[1])
		guiSetEnabled(gateeditor.window[1], true)
		return
	end
	
	gateID = (gateID and gateID or false)
	
	guiSetEnabled(gateeditor.window[1], false)
	
	creategate.window[1] = guiCreateWindow((sx-460)/2, (sy-548)/2, 460, 548, "Manage Gate", false)
	guiWindowSetSizable(creategate.window[1], false)
	
	-- Start
	creategate.edit[1] = guiCreateEdit(10, 28, 92, 27, (gateID and gates[gateID]["posX"] or ""), false, creategate.window[1]) -- x
	creategate.edit[2] = guiCreateEdit(112, 28, 92, 27, (gateID and gates[gateID]["posY"] or ""), false, creategate.window[1]) -- y
	creategate.edit[3] = guiCreateEdit(214, 28, 92, 27, (gateID and gates[gateID]["posZ"] or ""), false, creategate.window[1]) -- z
	creategate.edit[4] = guiCreateEdit(10, 65, 92, 27, (gateID and gates[gateID]["rotX"] or "0"), false, creategate.window[1]) -- rx
	creategate.edit[5] = guiCreateEdit(112, 65, 92, 27, (gateID and gates[gateID]["rotY"] or "0"), false, creategate.window[1]) -- ry
	creategate.edit[6] = guiCreateEdit(214, 65, 92, 27, (gateID and gates[gateID]["rotZ"] or "0"), false, creategate.window[1]) -- rz
	
	creategate.label[3] = guiCreateLabel(322, 34, 31, 16, "Int:", false, creategate.window[1])
	creategate.edit[13] = guiCreateEdit(359, 28, 92, 27, (gateID and gates[gateID]["interior"] or getElementInterior(localPlayer)), false, creategate.window[1])
	creategate.label[4] = guiCreateLabel(322, 70, 31, 16, "Dim:", false, creategate.window[1])
	creategate.edit[14] = guiCreateEdit(359, 65, 92, 27, (gateID and gates[gateID]["dimension"] or getElementDimension(localPlayer)), false, creategate.window[1])
	
	-- Div
	creategate.label[1] = guiCreateLabel(10, 92, 441, 15, "______________________________________________________________________________________", false, creategate.window[1])
	
	-- End
	creategate.edit[7] = guiCreateEdit(10, 117, 92, 27, (gateID and gates[gateID]["endPosX"] or ""), false, creategate.window[1])
	creategate.edit[8] = guiCreateEdit(112, 117, 92, 27, (gateID and gates[gateID]["endPosY"] or ""), false, creategate.window[1])
	creategate.edit[9] = guiCreateEdit(214, 117, 92, 27, (gateID and gates[gateID]["endPosZ"] or ""), false, creategate.window[1])
	creategate.edit[10] = guiCreateEdit(10, 154, 92, 27, (gateID and gates[gateID]["endRotX"] or "0"), false, creategate.window[1])
	creategate.edit[11] = guiCreateEdit(112, 154, 92, 27, (gateID and gates[gateID]["endRotY"] or "0"), false, creategate.window[1])
	creategate.edit[12] = guiCreateEdit(214, 154, 92, 27, (gateID and gates[gateID]["endRotZ"] or "0"), false, creategate.window[1])
	
	creategate.label[5] = guiCreateLabel(322, 123, 31, 16, "Int:", false, creategate.window[1])
	creategate.edit[15] = guiCreateEdit(359, 117, 92, 27, (gateID and gates[gateID]["endInterior"] or getElementInterior(localPlayer)), false, creategate.window[1])
	creategate.label[6] = guiCreateLabel(322, 160, 31, 16, "Dim:", false, creategate.window[1])
	creategate.edit[16] = guiCreateEdit(359, 154, 92, 27, (gateID and gates[gateID]["endDimension"] or getElementDimension(localPlayer)), false, creategate.window[1])
	
	-- Div
	creategate.label[2] = guiCreateLabel(10, 181, 441, 15, "______________________________________________________________________________________", false, creategate.window[1])
	
	-- Move Speed
	creategate.label[7] = guiCreateLabel(11, 203, 43, 15, "Speed:", false, creategate.window[1])
	creategate.edit[17] = guiCreateEdit(11, 228, 92, 27, (gateID and gates[gateID]["moveSpeed"] or "1100"), false, creategate.window[1])
	
	-- Time Open
	creategate.label[8] = guiCreateLabel(113, 203, 67, 15, "Time Open:", false, creategate.window[1])
	creategate.edit[18] = guiCreateEdit(113, 228, 92, 27, (gateID and gates[gateID]["openTime"] or "5000"), false, creategate.window[1])
	
	-- Lock Value
	creategate.label[9] = guiCreateLabel(215, 203, 86, 15, "I/IV/FID/PWD:", false, creategate.window[1])
	creategate.edit[19] = guiCreateEdit(214, 228, 135, 27, (gateID and gates[gateID]["openCondition"] or "-"), false, creategate.window[1])
	
	-- Easing Method
	creategate.label[10] = guiCreateLabel(11, 265, 86, 15, "Eas. Method:", false, creategate.window[1])
	creategate.gridlist[1] = guiCreateGridList(9, 290, 195, 116, false, creategate.window[1])
	guiGridListAddColumn(creategate.gridlist[1], "Name", 0.8)
	
	for i,v in ipairs(easingMethods) do
		guiGridListAddRow(creategate.gridlist[1])
		guiGridListSetItemText(creategate.gridlist[1], i-1, 1, v, false, false)
		if (gates[gateID]["easingMethod"] == v) then
			guiGridListSetSelectedItem(creategate.gridlist[1], i-1, 1)
		end
	end
	
	-- Lock Method
	creategate.label[11] = guiCreateLabel(215, 265, 86, 15, "Lock Method:", false, creategate.window[1])
	creategate.gridlist[2] = guiCreateGridList(214, 290, 195, 116, false, creategate.window[1])
	guiGridListAddColumn(creategate.gridlist[2], "Name", 0.8)
	
	for i=1,6 do
		guiGridListAddRow(creategate.gridlist[2])
	end
	
	guiGridListSetItemText(creategate.gridlist[2], 0, 1, "Everybody", false, false)
	guiGridListSetItemText(creategate.gridlist[2], 1, 1, "Faction", false, false)
	guiGridListSetItemText(creategate.gridlist[2], 2, 1, "Item ID", false, false)
	guiGridListSetItemText(creategate.gridlist[2], 3, 1, "Item ID & Value", false, false)
	guiGridListSetItemText(creategate.gridlist[2], 4, 1, "Item Value", false, false)
	guiGridListSetItemText(creategate.gridlist[2], 5, 1, "Password", false, false)
	guiGridListSetSelectedItem(creategate.gridlist[2], 0, 1)
	
	-- Easing Period
	creategate.label[12] = guiCreateLabel(11, 416, 68, 15, "Eas. Period:", false, creategate.window[1])
	creategate.edit[20] = guiCreateEdit(11, 441, 92, 27, (gateID and gates[gateID]["easingPeriod"] or "0.0"), false, creategate.window[1])
	
	-- Easing Amplitude
	creategate.label[13] = guiCreateLabel(113, 416, 91, 15, "Eas. Amplitude:", false, creategate.window[1])
	creategate.edit[21] = guiCreateEdit(113, 441, 92, 27, (gateID and gates[gateID]["easingAmplitude"] or "0.0"), false, creategate.window[1])
	
	-- Easing Overshoot
	creategate.label[14] = guiCreateLabel(215, 416, 91, 15, "Eas. Overshoot:", false, creategate.window[1])
	creategate.edit[22] = guiCreateEdit(214, 441, 92, 27, (gateID and gates[gateID]["easingOvershoot"] or "0.0"), false, creategate.window[1])
	
	-- Gate Name
	creategate.label[15] = guiCreateLabel(318, 416, 91, 15, "Gate Name:", false, creategate.window[1])
	creategate.edit[23] = guiCreateEdit(318, 441, 132, 27, (gateID and gates[gateID]["gateName"] or ""), false, creategate.window[1])
	
	-- Object ID
	creategate.label[16] = guiCreateLabel(359, 203, 86, 15, "Object ID:", false, creategate.window[1])
	creategate.edit[24] = guiCreateEdit(358, 228, 92, 27, (gateID and gates[gateID]["modelID"] or "1557"), false, creategate.window[1])
	
	-- Finish Button
	creategate.button[1] = guiCreateButton(11, 478, 439, 27, "Finish Management", false, creategate.window[1])
	
	-- Cancel Button
	creategate.button[2] = guiCreateButton(11, 510, 439, 27, "Cancel Management", false, creategate.window[1])
	
	addEventHandler("onClientGUIClick", creategate.button[2], displayGateEdit, false)
	addEventHandler("onClientGUIClick", creategate.button[1],
		function()
			local posX = guiGetText(creategate.edit[1])
			local posY = guiGetText(creategate.edit[2])
			local posZ = guiGetText(creategate.edit[3])
			local rotX = guiGetText(creategate.edit[4])
			local rotY = guiGetText(creategate.edit[5])
			local rotZ = guiGetText(creategate.edit[6])
			local interior = guiGetText(creategate.edit[13])
			local dimension = guiGetText(creategate.edit[14])
			
			local endPosX = guiGetText(creategate.edit[7])
			local endPosY = guiGetText(creategate.edit[8])
			local endPosZ = guiGetText(creategate.edit[9])
			local endRotX = guiGetText(creategate.edit[10])
			local endRotY = guiGetText(creategate.edit[11])
			local endRotZ = guiGetText(creategate.edit[12])
			local endInterior = guiGetText(creategate.edit[15])
			local endDimension = guiGetText(creategate.edit[16])
			
			local moveSpeed = guiGetText(creategate.edit[17])
			local openTime = guiGetText(creategate.edit[18])
			local openCondition = guiGetText(creategate.edit[19])
			local objectID = guiGetText(creategate.edit[24])
			
			local easingMethod, _ = guiGridListGetSelectedItem(creategate.gridlist[1])
			local lockMethod, _ = guiGridListGetSelectedItem(creategate.gridlist[2])
			
			local easingPeriod = guiGetText(creategate.edit[20])
			local easingAmplitude = guiGetText(creategate.edit[21])
			local easingOvershoot = guiGetText(creategate.edit[22])
			local gateName = guiGetText(creategate.edit[23])
			
			if (tonumber(posX)) and (tonumber(posY)) and (tonumber(posZ)) and (tonumber(rotX)) and (tonumber(rotY)) and (tonumber(rotZ)) and (tonumber(interior) and tonumber(interior) >= 0 and tonumber(interior) <= 255) and (tonumber(dimension) and tonumber(dimension) >= 0 and tonumber(dimension) <= 65535) and
			(tonumber(endPosX)) and (tonumber(endPosY)) and (tonumber(endPosZ)) and (tonumber(endRotX)) and (tonumber(endRotY)) and (tonumber(endRotZ)) and (tonumber(endInterior) and tonumber(endInterior) >= 0 and tonumber(endInterior) <= 255) and (tonumber(endDimension) and tonumber(endDimension) >= 0 and tonumber(endDimension) <= 65535) and
			(tonumber(moveSpeed) and (tonumber(moveSpeed) >= 0)) and (tonumber(openTime) and tonumber(openTime) >= 0) and (openCondition) and (tonumber(objectID) and tonumber(objectID) > 0) and (tonumber(easingMethod) and tonumber(easingMethod) ~= -1) and (tonumber(lockMethod) and tonumber(lockMethod) ~= -1) and (tonumber(easingPeriod) and tonumber(easingPeriod) >= 0 and tonumber(easingPeriod) <= 1) and (tonumber(easingAmplitude) and tonumber(easingAmplitude) >= 0 and tonumber(easingAmplitude) <= 1) and (tonumber(easingOvershoot) and tonumber(easingOvershoot) >= 0 and tonumber(easingOvershoot) <= 1) and (gateName and string.len(gateName) > 0) then
				local objectIDtest = createObject(tonumber(objectID), 0, 0, 0)
				if (objectIDtest) then
					if (not gateID) then
						triggerServerEvent(":_createGate_:", localPlayer, tonumber(posX), tonumber(posY), tonumber(posZ), tonumber(rotX), tonumber(rotY), tonumber(rotZ), tonumber(interior), tonumber(dimension), tonumber(endPosX), tonumber(endPosY), tonumber(endPosZ), tonumber(endRotX), tonumber(endRotY), tonumber(endRotZ), tonumber(endInterior), tonumber(endDimension), tonumber(moveSpeed), tonumber(openTime), tonumber(openCondition), tonumber(objectID), guiGridListGetItemText(creategate.gridlist[1], easingMethod, 1), guiGridListGetItemText(creategate.gridlist[2], lockMethod, 1), tonumber(easingPeriod), tonumber(easingAmplitude), tonumber(easingOvershoot), gateName)
					else
						triggerServerEvent(":_editGate_:", localPlayer, gateID, tonumber(posX), tonumber(posY), tonumber(posZ), tonumber(rotX), tonumber(rotY), tonumber(rotZ), tonumber(interior), tonumber(dimension), tonumber(endPosX), tonumber(endPosY), tonumber(endPosZ), tonumber(endRotX), tonumber(endRotY), tonumber(endRotZ), tonumber(endInterior), tonumber(endDimension), tonumber(moveSpeed), tonumber(openTime), tonumber(openCondition), tonumber(objectID), guiGridListGetItemText(creategate.gridlist[1], easingMethod, 1), guiGridListGetItemText(creategate.gridlist[2], lockMethod, 1), tonumber(easingPeriod), tonumber(easingAmplitude), tonumber(easingOvershoot), gateName)
					end
					displayGateEdit()
				else
					outputChatBox("Object ID is invalid.", 245, 20, 20, false)
				end
			else
				outputChatBox("Make sure you have filled in all the fields.", 245, 20, 20, false)
			end
		end, false
	)
end

function displayVerificationWindow()
	if (isElement(verification.window[1])) then
		destroyElement(verification.window[1])
		guiSetEnabled(gateeditor.window[1], true)
		return
	end
	
	guiSetEnabled(gateeditor.window[1], false)
	
	verification.window[1] = guiCreateWindow((sx-259)/2, (sy-130)/2, 259, 130, "Verify Action", false)
	guiWindowSetSizable(verification.window[1], false)
	guiSetAlpha(verification.window[1], 1.0)
	guiSetProperty(verification.window[1], "AlwaysOnTop", "true")
	
	verification.label[1] = guiCreateLabel(10, 27, 239, 43, "Are you sure you want to delete this gate? If you delete the gate, it cannot be restored.", false, verification.window[1])
	guiSetFont(verification.label[1], "default-bold-small")
	guiLabelSetHorizontalAlign(verification.label[1], "left", true)
	
	verification.button[1] = guiCreateButton(10, 86, 116, 34, "Continue", false, verification.window[1])
	verification.button[2] = guiCreateButton(133, 86, 116, 34, "Cancel", false, verification.window[1])
	
	addEventHandler("onClientGUIClick", verification.button[1],
		function()
			local row, col = guiGridListGetSelectedItem(gateeditor.gridlist[1])
			if (row ~= -1) and (col ~= -1) then
				triggerServerEvent(":_deleteGate_:", localPlayer, guiGridListGetItemText(gateeditor.gridlist[1], row, 1))
				displayVerificationWindow()
			else
				outputChatBox("Select a gate from the gridlist first.", 245, 20, 20, false)
			end
		end
	)
	
	addEventHandler("onClientGUIClick", verification.button[2], displayVerificationWindow, false)
end

addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if (button ~= "left") or (state ~= "down") then return end
		if (clickedElement) then
			if (getElementType(clickedElement) == "marker") or (getElementType(clickedElement) == "object") then
				if (getGateID(clickedElement)) then
					triggerServerEvent(":_openGate_:", localPlayer, getGateID(clickedElement))
				end
			end
		end
	end
)

addEvent(":_placeAllGatesInGUI_:", true)
addEventHandler(":_placeAllGatesInGUI_:", root,
	function(returnGates)
		gates = returnGates
		gatesLoaded = true
	end
)

addEvent(":_refreshGateGUI_:", true)
addEventHandler(":_refreshGateGUI_:", root,
	function(returnGates)
		gates = returnGates
		
		if (isElement(gateeditor.gridlist[1])) then
			guiGridListClear(gateeditor.gridlist[1])
			
			for i,v in pairs(gates) do
				if (v["id"]) then
					local row = guiGridListAddRow(gateeditor.gridlist[1])
					guiGridListSetItemText(gateeditor.gridlist[1], row, 1, v["id"], false, false)
					guiGridListSetItemText(gateeditor.gridlist[1], row, 2, (v["gateName"] and v["gateName"] or "?"), false, false)
					guiGridListSetItemText(gateeditor.gridlist[1], row, 3, getMethodName(v["lockMethod"]), false, false)
					guiGridListSetItemText(gateeditor.gridlist[1], row, 4, (string.len(v["openCondition"]) == 0 and "None" or v["openCondition"]), false, false)
				end
			end
		end
	end
)

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler = function(commandName, fn, restricted, caseSensitive)
	
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end
			)
		end
	end
end

addCommandHandler({"editgates", "gates", "gateedit", "editgate"},
	function(cmd, gateID)
		if (not exports['roleplay-accounts']:isClientAdmin(localPlayer)) then return end
		if (gateID) then
			return -- jajaajaja
		else
			displayGateEditor()
		end
	end
)