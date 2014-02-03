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

local jobs = {}
local jobMenu = {
    window = {},
    button = {},
    gridlist = {}
}

local jobBlip
local jobBlips = {
	{1790.28, -1923.45, 13.39, 255, 185, 40, 235},
	{1790.28, -1923.45, 13.39, 255, 255, 30, 235}
}

addEventHandler("onClientPedDamage", resourceRoot, cancelEvent)

local function displayJobMenu()
	if (isElement(jobMenu.window[1])) then
		destroyElement(jobMenu.window[1])
		showCursor(false)
		return
	end
	
	jobMenu.window[1] = guiCreateWindow(699, 336, 263, 305, "Select a Job...", false)
	guiWindowSetSizable(jobMenu.window[1], false)
	
	jobMenu.gridlist[1] = guiCreateGridList(9, 24, 244, 174, false, jobMenu.window[1])
	guiGridListAddColumn(jobMenu.gridlist[1], "Job ID", 0.25)
	guiGridListAddColumn(jobMenu.gridlist[1], "Name", 0.65)
	
	if (#jobs > 0) then
		for index,value in ipairs(jobs) do
			local row = guiGridListAddRow(jobMenu.gridlist[1])
			guiGridListSetItemText(jobMenu.gridlist[1], row, 1, index, false, false)
			guiGridListSetItemText(jobMenu.gridlist[1], row, 2, value["name"], false, false)
		end
	end
	
	jobMenu.button[1] = guiCreateButton(9, 204, 244, 42, "Accept Job", false, jobMenu.window[1])
	jobMenu.button[2] = guiCreateButton(9, 252, 244, 42, "Exit Menu", false, jobMenu.window[1])
	
	local function proceedSelection()
		local row, col = guiGridListGetSelectedItem(jobMenu.gridlist[1])
		if (row ~= -1) and (col ~= -1) then
			triggerServerEvent(":_verifyJobAbility_:", localPlayer, guiGridListGetItemText(jobMenu.gridlist[1], row, 1))
		else
			outputChatBox("Please select a job from the list to proceed.", 245, 20, 20, false)
		end
	end
	addEventHandler("onClientGUIClick", jobMenu.button[1], proceedSelection, false)
	addEventHandler("onClientGUIDoubleClick", jobMenu.gridlist[1], proceedSelection, false)
	
	addEventHandler("onClientGUIClick", jobMenu.button[2], displayJobMenu, false)
	
	showCursor(true)
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local cityPed = createPed(141, 1465.51, -1777.98, 1251.42, 180)
		setElementInterior(cityPed, 4)
		setElementDimension(cityPed, 15)
		setElementData(cityPed, "roleplay:jobs.ped", true, false)
		setElementData(cityPed, "roleplay:peds.name", "Selena_Rodriguez", false)
		setTimer(setPedAnimation, 100, 1, cityPed, "FOOD", "FF_Sit_Look", -1, true, false, false, true)
		setTimer(setPedAnimation, 5000, 0, cityPed, "FOOD", "FF_Sit_Look", -1, true, false, false, true)
		setTimer(setElementPosition, 20000, 0, cityPed, 1465.51, -1777.98, 1251.42)
		triggerEvent(":_loadRealJobs_:", localPlayer)
	end
)

addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if (button == "left") and (state == "up") and (clickedElement) and (getElementType(clickedElement) == "ped") then
			if (getDistanceBetweenPoints3D(worldX, worldY, worldZ, getElementPosition(localPlayer)) <= 5) then
				if (not getElementData(clickedElement, "roleplay:jobs.ped")) then return end
				if (isElement(jobMenu.window[1])) then return end
				displayJobMenu()
			end
		end
	end
)

addEvent(":_putRealJobs_:", true)
addEventHandler(":_putRealJobs_:", root,
	function(joblist)
		jobs = joblist
	end
)

addEvent(":_loadRealJobs_:", true)
addEventHandler(":_loadRealJobs_:", root,
	function()
		if (exports['roleplay-accounts']:isClientPlaying(localPlayer)) then
			triggerServerEvent(":_getRealJobs_:", localPlayer)
			triggerEvent(":_syncDutyBlip_:", localPlayer, exports['roleplay-accounts']:getCharacterJob(localPlayer))
		end
	end
)

addEvent(":_beginRoute_:", true)
addEventHandler(":_beginRoute_:", root,
	function()
		if (isElement(jobBlip)) then
			destroyElement(jobBlip)
		end
	end
)

addEvent(":_stopRoute_:", true)
addEventHandler(":_stopRoute_:", root,
	function()
		triggerEvent(":_syncDutyBlip_:", localPlayer, exports['roleplay-accounts']:getCharacterJob(localPlayer))
	end
)

addEvent(":_syncDutyBlip_:", true)
addEventHandler(":_syncDutyBlip_:", root,
	function(jobID)
		if (not jobBlips[jobID]) then return end
		if (jobBlip) and (isElement(jobBlip)) then destroyElement(jobBlip) end
		jobBlip = createBlip(jobBlips[jobID][1], jobBlips[jobID][2], jobBlips[jobID][3], 0, 5, jobBlips[jobID][4], jobBlips[jobID][5], jobBlips[jobID][6], jobBlips[jobID][7], 0, 180)
	end
)

addEvent(":_exitJobMenu_:", true)
addEventHandler(":_exitJobMenu_:", root,
	function()
		if (isElement(jobMenu.window[1])) then
			destroyElement(jobMenu.window[1])
			showCursor(false)
		end
	end
)