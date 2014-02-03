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
local currentQuestion = 1
local _currentQuestion = 1
local maxQuestions = 12
local valids = 0
local isEnabled = false
local questions = {
	{"On which side of the road should you drive on?", false, false,
		{
			{"Left", false},
			{"Right", true},
			{"Either", false}
		}
	},
	
	{"How many gears are there on automatic transmission vehicles?", false, false,
		{
			{"None", false},
			{"One", false},
			{"Three", true}
		}
	},
	
	{"How many gears are there on manual transmission vehicles?", false, false,
		{
			{"Five", true},
			{"One", false},
			{"Four", false}
		}
	},
	
	{"When especially should you turn on your headlights?", false, false,
		{
			{"At noon", false},
			{"When it's foggy", true},
			{"When it's bright", false}
		}
	},
	
	{"If an Ambulance is ringing their sirens behind you, what should you do?", false, false,
		{
			{"Keep on going", false},
			{"Make a full stop right where you are", false},
			{"Park your car half on the pavement", true}
		}
	},
	
	{"If there is a road accident ahead of you and you're alone, what should you do?", false, false,
		{
			{"Keep on going and call 911", false},
			{"Turn around and escape", false},
			{"Park your car safely, call 911 and provide help", true}
		}
	},
	
	{"When at a intersection, which car can go first?", false, false,
		{
			{"Anybody", false},
			{"One on your left", false},
			{"One on your right", true}
		}
	},
	
	{"When should you be using the horn?", false, false,
		{
			{"When a car isn't moving when there's a green light", true},
			{"When a car is moving when there's a green light", false},
			{"When a car crashes into a tree", false}
		}
	},
	
	{"Which one of the following is the best place for parking?", false, false,
		{
			{"The pavement", false},
			{"A parking lot", true},
			{"Neighbour's parking lot", false}
		}
	},
	
	{"If you possess a Standard driver's license, can you drive a truck?", false, false,
		{
			{"No", true},
			{"Yes", false},
			{"No, unless you know how to", false}
		}
	},
	
	{"When should you be using the indicators?", false, false,
		{
			{"When you turn left or right", true},
			{"When you ask a question from your friend", false},
			{"When you're about to perform a stunt", false}
		}
	},
	
	{"When should you turn on the emergency indicators?", false, false,
		{
			{"When you need to warn other bypasses of a danger", true},
			{"When you're about to park your car", false},
			{"When you're about to press the brake pedal", false}
		}
	},
	
	{"How far should you take the warning sign from your trunk?", false, false,
		{
			{"50 meters", false},
			{"100 meters", true},
			{"150 meters", false}
		}
	},
	
	{"How many backup wheels do you must commonly find from a trunk?", false, false,
		{
			{"None", false},
			{"Two", false},
			{"One", true}
		}
	},
	
	{"How many different license types are there?", false, false,
		{
			{"One", false},
			{"Two", false},
			{"Four", true}
		}
	},
	
	{"How do you increase speed while driving a car?", false, false,
		{
			{"By pressing the acceleration pedal", true},
			{"By pressing the brake pedal", false},
			{"By turning on the left indicator", false}
		}
	}
}

exam = {
    button = {},
    window = {},
    radiobutton = {},
    label = {}
}

local function getRandomQuestion()
	local whileFalsed = 0
	local randomed = math.random(1, #questions)
	if (whileFalsed < #questions) then
		for i,v in ipairs(questions[randomed]) do
			if (questions[randomed][3] == false) then
				return questions[randomed], randomed
			else
				whileFalsed = whileFalsed+1
			end
		end
	end
end

addEvent(":_fetchTheyEvenHaveAccessToThatMoney_:", true)
addEventHandler(":_fetchTheyEvenHaveAccessToThatMoney_:", root,
	function(yesOrNo, current)
		if (yesOrNo == 1) or (current < 600) then
			displayExamMenu(1)
		else
			outputChatBox("You don't have enough cash to begin the exam and driving test.", 245, 20, 20, false)
		end
	end
)

function displayExamMenu(bForceOpen)
	if (isElement(exam.window[1])) then
		destroyElement(exam.window[1])
		guiSetVisible(school.window[1], true)
		return
	end
	
	if (not bForceOpen) then
		triggerServerEvent(":_doTheyEvenHaveAccessToThatMoney_:", localPlayer, 600)
	else
		outputChatBox("You've paid the 500 USD fee to the Department of Motor Vehicles to attend to the exam.", 210, 160, 25, false)
		triggerServerEvent(":_takeTheDMVMoney_:", localPlayer)
		
		guiSetVisible(school.window[1], false)
		
		exam.window[1] = guiCreateWindow((sx-475)/2, (sy-225)/2, 475, 225, "Exam (Question " .. currentQuestion .. " of " .. maxQuestions .. ")", false)
		guiWindowSetSizable(exam.window[1], false)
		
		local randomQuestion, randomID = getRandomQuestion()
		if (randomQuestion) and (randomID) then
			_currentQuestion = randomID
			exam.label[1] = guiCreateLabel(15, 37, 445, 22, randomQuestion[1], false, exam.window[1])
			guiLabelSetHorizontalAlign(exam.label[1], "center", false)
			
			local posY = 63
			for i,v in ipairs(randomQuestion[4]) do
				if (i ~= 1) then
					posY = (posY or 63)+20
				end
				exam.radiobutton[#exam.radiobutton+1] = guiCreateRadioButton(45, posY, 405, 18, v[1], false, exam.window[1])
			end
			
			questions[randomID][3] = true
		end
		
		exam.button[1] = guiCreateButton(105, 143, 266, 29, "Proceed to Next Question »", false, exam.window[1])
		guiSetFont(exam.button[1], "default-bold-small")
		exam.button[2] = guiCreateButton(105, 178, 266, 29, "Cancel Exam", false, exam.window[1])
		
		addEventHandler("onClientGUIClick", exam.button[1],
			function()
				local whichOne = false
				
				for i,v in ipairs(exam.radiobutton) do
					if (isElement(v)) then
						if (guiRadioButtonGetSelected(v)) then
							whichOne = i
							break
						end
					else
						whichOne = i
						break
					end
				end
				
				if (not whichOne) then
					outputChatBox("Please select your answer before proceeding.", 245, 20, 20, false)
					return
				end
				
				guiSetText(exam.label[1], "")
				
				if (currentQuestion < maxQuestions) then
					currentQuestion = currentQuestion+1
					
					for i,v in ipairs(exam.radiobutton) do
						if (isElement(v)) then
							destroyElement(v)
							exam.radiobutton[i] = nil
						end
					end
					
					if (questions[_currentQuestion][4][whichOne][2] == true) then
						questions[whichOne][2] = true
						valids = valids+1
					else
						questions[whichOne][2] = false
					end
					
					local randomQuestion, randomID = getRandomQuestion()
					if (randomQuestion) and (randomID) then
						_currentQuestion = randomID
						questions[randomID][3] = true
						
						local posY = 63
						for i,v in ipairs(randomQuestion[4]) do
							if (i ~= 1) then
								posY = (posY or 63)+20
							end
							
							guiSetText(exam.label[1], randomQuestion[1])
							exam.radiobutton[#exam.radiobutton+1] = guiCreateRadioButton(45, posY, 405, 18, randomQuestion[4][i][1], false, exam.window[1])
						end
						
						guiSetText(exam.window[1], "Exam (Question " .. currentQuestion .. " of " .. maxQuestions .. ")")
					else
						guiSetText(exam.label[1], "Error occured! Click 'Cancel Exam' to get an instant refund.")
						guiSetEnabled(exam.button[1], false)
					end
				else
					if (valids+1 < maxQuestions) then
						outputChatBox("Unfortunately you failed the exam. You had " .. valids+1 .. "/" .. maxQuestions .. " correct answers on your exam, and we require all answers to be correct.", 245, 20, 20, false)
					else
						outputChatBox("You passed the exam. Please pick up your choice of vehicle from outside. Each model has a different meaning, so make sure you pick the one you want.", 20, 245, 20, false)
						triggerServerEvent(":_positiveDMVResult_:", localPlayer)
					end
					
					destroyElement(school.window[1])
					destroyElement(exam.window[1])
					showCursor(false)
					
					currentQuestion = 1
					_currentQuestion = 1
				end
			end, false
		)
		
		addEventHandler("onClientGUIClick", exam.button[2],
			function()
				destroyElement(school.window[1])
				destroyElement(exam.window[1])
				showCursor(false)
				triggerServerEvent(":_giveBackDMVMoney_:", localPlayer)
			end, false
		)
	end
end

school = {
    button = {},
    window = {},
    label = {}
}

local function displayProceedMenu()
	if (isElement(school.window[1])) then
		destroyElement(school.window[1])
		showCursor(false)
		if (isElement(exam.window[1])) then
			destroyElement(exam.window[1])
		end
		return
	end
	
	school.window[1] = guiCreateWindow(549, 412, 583, 244, "Department of Motor Vehicles", false)
	guiWindowSetSizable(school.window[1], false)
	
	school.label[1] = guiCreateLabel(15, 31, 552, 91, "Welcome to the San Andreas Department of Motor Vehicles. You can do your driver's license for any type in this place.\n\nThe exam costs 500 USD and if you pass the exam, you will proceed to the driving session, which costs additional 100 USD. If you pass both of these steps, you will be issued a driver's license for the desired type you've chosen.", false, school.window[1])
	guiLabelSetHorizontalAlign(school.label[1], "left", true)
	
	school.button[1] = guiCreateButton(15, 135, 552, 44, "Begin the Exam", false, school.window[1])
	guiSetFont(school.button[1], "default-bold-small")
	school.button[2] = guiCreateButton(15, 187, 552, 44, "Cancel", false, school.window[1])
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", school.button[1], displayExamMenu, false)
	addEventHandler("onClientGUIClick", school.button[2], displayProceedMenu, false)
end

addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if (button == "left") and (state == "down") then
			if (clickedElement and getElementType(clickedElement) == "ped") then
				if (getElementData(clickedElement, "roleplay:dmv.element")) then
					if (isElement(school.window[1])) then return end
					local x, y, z = getElementPosition(localPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, worldX, worldY, worldZ) > 3.5) then return end
					displayProceedMenu()
				end
			end
		end
	end
)

local dmvTruckModels = {[403]=true}
local currentMarker = 0
local currentRoute = 0
local currentType = 1
local currentTransmission = 0
local failed = false
local isDisabled = false
local spawned = {}
local markers = {
	{
		{915.09, -1762.9,  13.38},
		{832.2,	 -1767.01, 13.39},
		{735.21, -1758.02, 13.96}
	}
}

local function checkForFailure()
	if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
	if (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:route"))) or (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:marker"))) or (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:license"))) or (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:manual"))) then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then return end
	if (getVehicleController(vehicle) ~= localPlayer) then return end
	if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 3) then return end
	if (failed == 3) then return end
	
	if (failed ~= 2) then
		if (exports['roleplay-vehicles']:getElementSpeed(vehicle) > 105) then
			failed = (failed == 1 and 3 or 2)
		end
	end
	
	if (failed ~= 1) then
		for i=0,6 do
			local panel = getVehiclePanelState(vehicle, i)
			if (panel > 1) then
				failed = (failed == 2 and 3 or 1)
			end
		end
	end
end

addEvent(":_beginDMVRoute_:", true)
addEventHandler(":_beginDMVRoute_:", root,
	function(routeID, iType, iTransmission)
		if (spawned[localPlayer]) then return end
		if (markers[routeID]) then
			if (isDisabled) then
				currentRoute = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:route"))
				currentMarker = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:marker"))
				currentType = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:license"))
				currentTransmission = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:manual"))
				
				spawned[localPlayer] = {}
				spawned[localPlayer][1] = createMarker(markers[currentRoute][currentMarker][1], markers[currentRoute][currentMarker][2], markers[currentRoute][currentMarker][3]-1, "checkpoint", 4, 50, 200, 50, 160)
				spawned[localPlayer][2] = createMarker(markers[currentRoute][currentMarker+1][1], markers[currentRoute][currentMarker+1][2], markers[currentRoute][currentMarker+1][3]-1, "checkpoint", 3, 200, 50, 50, 50)
				outputChatBox("Session continuing - follow the green checkpoints until you reach the DMV again.", 210, 160, 25, false)
				outputChatBox("Reminder: Do not scratch your car or drive too fast or your driving test will fail.", 210, 160, 25, false)
				outputChatBox("Fatal note: This is a " .. (currentType == 0 and "Automatic" or "Manual") .. " transmission vehicle. Switch if you want to use else.", 190, 20, 20, false)
				isDisabled = false
				failed = false
				
				if (isTimer(resetTimerLol)) then
					killTimer(resetTimerLol)
				end
				
				addEventHandler("onClientRender", root, checkForFailure)
			else
				spawned[localPlayer] = {}
				spawned[localPlayer][1] = createMarker(markers[routeID][1][1], markers[routeID][1][2], markers[routeID][1][3]-1, "checkpoint", 4, 50, 200, 50, 160)
				spawned[localPlayer][2] = createMarker(markers[routeID][2][1], markers[routeID][2][2], markers[routeID][2][3]-1, "checkpoint", 3, 200, 50, 50, 50)
				currentRoute = routeID
				currentMarker = 1
				currentType = iType
				currentTransmission = iTransmission
				triggerServerEvent(":_updateDMVData_:", localPlayer, currentMarker, currentRoute, currentType, currentTransmission)
				outputChatBox("Session started - follow the green checkpoints until you reach the DMV again.", 210, 160, 25, false)
				outputChatBox("Reminder: Do not scratch your car or drive too fast or your driving test will fail.", 210, 160, 25, false)
				outputChatBox("Fatal note: This is a " .. (currentType == 0 and "Automatic" or "Manual") .. " transmission vehicle. Switch if you want to use else.", 190, 20, 20, false)
				
				addEventHandler("onClientRender", root, checkForFailure)
			end
		end
	end
)

addEvent(":_stopDMVRoute_:", true)
addEventHandler(":_stopDMVRoute_:", root,
	function()
		if (spawned[localPlayer]) then
			for i,v in ipairs(spawned[localPlayer]) do
				if (isElement(v)) then
					destroyElement(v)
				end
			end
			
			spawned[localPlayer] = nil
		end
		
		removeEventHandler("onClientRender", root, checkForFailure)
		currentRoute = 0
		currentMarker = 1
		currentType = 1
		currentTransmission = 0
		failed = false
		triggerServerEvent(":_updateDMVData_:", localPlayer, currentMarker, currentRoute, currentType, currentTransmission)
	end
)

addEvent(":_disableDMVRoute_:", true)
addEventHandler(":_disableDMVRoute_:", root,
	function()
		if (not spawned[localPlayer]) or (#spawned[localPlayer] == 0) then return end
		for i,v in ipairs(spawned[localPlayer]) do
			if (isElement(v)) then
				destroyElement(v)
			end
		end
		
		spawned[localPlayer] = nil
		
		if (currentMarker > 1) then
			isDisabled = true
			outputChatBox("Your current session position has been saved. Continue the session by entering a DMV car (5 minutes until reset).", 210, 160, 25, false)
			removeEventHandler("onClientRender", root, checkForFailure)
			
			if (not isTimer(resetTimerLol)) then
				resetTimerLol = setTimer(function()
					triggerEvent(":_stopDMVRoute_:", localPlayer)
					outputChatBox("Your DMV session save has expired. You have to start from the beginning when you enter a DMV car.", 210, 160, 25, false)
				end, 5000*60000, 1)
			else
				resetTimer(resetTimerLol)
			end
		end
	end
)

addEventHandler("onClientMarkerHit", resourceRoot,
	function(hitPlayer, matchingDimension)
		if (not exports['roleplay-accounts']:isClientPlaying(hitPlayer)) or (not matchingDimension) then return end
		if (not tonumber(getElementData(hitPlayer, "roleplay:jobs.dmv:route"))) or (not tonumber(getElementData(hitPlayer, "roleplay:jobs.dmv:marker"))) or (not tonumber(getElementData(hitPlayer, "roleplay:jobs.dmv:license"))) or (not tonumber(getElementData(hitPlayer, "roleplay:jobs.dmv:manual"))) then return end
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= hitPlayer) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 3) then return end
		if (source ~= spawned[hitPlayer][1]) then return end
		
		if (exports['roleplay-accounts']:hasDriversLicense(hitPlayer)) then
			if (dmvTruckModels[getElementModel(vehicle)]) then
				if (exports['roleplay-accounts']:hasTruckLicense(hitPlayer)) then
					removePedFromVehicle(hitPlayer)
					outputChatBox("You already possess a Heavy Duty driver's license.", 245, 20, 20, false)
					return
				end
			else
				if (tonumber(getElementData(vehicle, "roleplay:vehicles.geartype")) == tonumber(getElementData(hitPlayer, "roleplay:characters.dmv:manual"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.geartype")) == 0 and tonumber(getElementData(localPlayer, "roleplay:characters.dmv:manual")) == 1) then
					removePedFromVehicle(hitPlayer)
					outputChatBox("You already have a Standard driver's license for " .. (tonumber(getElementData(vehicle, "roleplay:vehicles.geartype")) == 0 and "Automatic" or "Manual") .. " transmission.", 245, 20, 20, false)
					return
				end
			end
		end
		
		if (#markers[currentRoute] == currentMarker) then
			if (not spawned[hitPlayer]) or (not spawned[hitPlayer][1]) then return end
			--outputChatBox("Points: " .. currentMarker .. "/" .. #markers[currentRoute] .. " (#D1)")
			
			for i,v in pairs(spawned[hitPlayer]) do
				if (not spawned[hitPlayer]) then break end
				if (isElement(v)) then
					destroyElement(v)
				end
			end
			
			currentMarker = 0
			currentRoute = 0
			outputChatBox(" You've finished a driving session.", 20, 245, 20, false)
			
			if (failed) then
				if (failed == 1) then
					outputChatBox(" Result: You failed the driving test because you damaged your vehicle.", 245, 20, 20, false)
				elseif (failed == 2) then
					outputChatBox(" Result: You failed the driving test because you drove too fast.", 245, 20, 20, false)
				elseif (failed == 3) then
					outputChatBox(" Result: You failed the driving test because you damaged your vehicle and drove too fast.", 245, 20, 20, false)
				else
					outputChatBox(" Result: You failed the driving test.", 245, 20, 20, false)
				end
				triggerServerEvent(":_finishDMVSession_:", hitPlayer)
			else
				outputChatBox(" Result: You passed the driving test and you were issued a " .. (currentType == 1 and "Standard" or "Heavy Duty") .. " license for " .. (currentTransmission == 0 and "Automatic" or "Manual") .. " transmission.", 210, 160, 25, false)
				triggerServerEvent(":_finishDMVSession_:", hitPlayer, 1)
			end
			
			currentType = 1
			currentTransmission = 0
		else
			if (isTimer(nextTimer)) then return end
			if (not spawned[hitPlayer]) or (not spawned[hitPlayer][1]) then return end
			--outputChatBox("Points: " .. currentMarker .. "/" .. #markers[currentRoute] .. " (#D2)")
			
			currentMarker = currentMarker+1
			
			if (isElement(spawned[hitPlayer][1])) then
				destroyElement(spawned[hitPlayer][1])
			end
			
			if (isElement(spawned[hitPlayer][2])) then
				nextTimer = setTimer(function()
					spawned[hitPlayer][1] = spawned[hitPlayer][2]
					setMarkerColor(spawned[hitPlayer][1], 50, 200, 50, 160)
					setMarkerSize(spawned[hitPlayer][1], 4)
				
					triggerServerEvent(":_updateDMVData_:", hitPlayer, currentMarker, currentRoute, currentType, currentTransmission)
					
					if (markers[currentRoute][currentMarker+1]) then
						spawned[hitPlayer][2] = createMarker(markers[currentRoute][currentMarker+1][1], markers[currentRoute][currentMarker+1][2], markers[currentRoute][currentMarker+1][3]-1, "checkpoint", 3, 200, 50, 50, 50)
					end
				end, 500, 1)
			end
		end
		
		playSoundFrontEnd(45)
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if (isEnabled) then
			local dmv = createPed(150, 359.29, 173.56, 1008.88, -90)
			setElementInterior(dmv, 3)
			setElementDimension(dmv, 281)
			setTimer(setPedAnimation, 100, 1, dmv, "FOOD", "FF_Sit_Look", -1, true, false, false, true)
			setTimer(setPedAnimation, 5000, 0, dmv, "FOOD", "FF_Sit_Look", -1, true, false, false, true)
			setElementData(dmv, "roleplay:dmv.element", 1, false)
			setElementData(dmv, "roleplay:peds.name", "Elizabeth_Harris", false)
		end
		
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		if (exports['roleplay-accounts']:getCharacterJob(localPlayer) ~= 1) then return end
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= localPlayer) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 3) then return end
		if (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:route"))) or (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:marker"))) or (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:license"))) or (not tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:manual"))) then return end
		
		currentRoute = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:route"))
		currentMarker = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:marker"))
		currentType = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:license"))
		currentTransmission = tonumber(getElementData(localPlayer, "roleplay:jobs.dmv:manual"))
		
		if (markers[currentRoute]) then
			spawned[localPlayer] = {}
			spawned[localPlayer][1] = createMarker(markers[currentRoute][currentMarker][1], markers[currentRoute][currentMarker][2], markers[currentRoute][currentMarker][3]-1, "checkpoint", 4, 50, 200, 50, 160)
			spawned[localPlayer][2] = createMarker(markers[currentRoute][currentMarker+1][1], markers[currentRoute][currentMarker+1][2], markers[currentRoute][currentMarker+1][3]-1, "checkpoint", 3, 200, 50, 50, 50)
			triggerServerEvent(":_updateDMVData_:", localPlayer, currentMarker, currentRoute, totalGather)
		else
			triggerServerEvent(":_finishDMVSession_:", localPlayer)
		end
	end
)

local lx, ly, lz = 941.15, -1744.54, 13.54
local li, ld = 0, 0
addEventHandler("onClientRender", root,
	function()
		if (isEnabled) then return end
		if (getElementInterior(localPlayer) == li) and (getElementDimension(localPlayer) == ld) then
			if (getDistanceBetweenPoints3D(lx, ly, lz, getElementPosition(localPlayer)) < 10) then
				local theX, theY = getScreenFromWorldPosition(lx, ly, lz)
				if (theX) and (theY) then
					local text = "Note: The DMV is currently disabled."
					local tWidth = dxGetTextWidth(text, 1.5, "default-bold")
					local tHeight = dxGetFontHeight(1.5, "default-bold")
					dxDrawText(text, theX-(tWidth/2)+1, theY+1, sx, sy, tocolor(5, 5, 5, 0.35*255), 1.5, "default-bold", "left", "top", true, false, false, false, true)
					dxDrawText(text, theX-(tWidth/2), theY, sx, sy, tocolor(245, 245, 245, 0.9*255), 1.5, "default-bold", "left", "top", true, false, false, false, true)
				end
			end
		end
	end
)