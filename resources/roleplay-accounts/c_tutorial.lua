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
local postGUI = true
local tutorialStep = 0
local tutorialShow = false
local tutorialWait = 17300
local tutorial = {
	[1] = {
		["posX"] 	=  1701.24,
		["posY"] 	= -1899.09,
		["posZ"] 	=  109.29,
		["lookX"] 	=  1609.51,
		["lookY"] 	= -1751.45,
		["lookZ"] 	=  109.29,
		["subject"] =  "Welcome to Los Santos",
		["body"] 	=  "You have just arrived to Los Santos. The city of the rich and the city of the poor - Vinewood stars and gangbangers through out the city. Take a peek behind the Vinewood hills at the country side or live among the famous stars at Richman district. It's all your choice. This is a tutorial by the way. This lasts for about three minutes so learn as much as you can!",
		["width"] 	=  510,
		["height"] 	=  125,
		["speed"]	=  0
	},
	[2] = {
		["posX"] 	=  1497,
		["posY"] 	= -1675.54,
		["posZ"] 	=  48.35,
		["lookX"] 	=  1553.09,
		["lookY"] 	= -1675.59,
		["lookZ"] 	=  16.19,
		["subject"] =  "San Andreas State Police",
		["body"] 	=  "If you'd like to help the state maintain its peace and justice, join the peacekeepers, also known as the San Andreas State Police. State Police is a state-wide police force able to respond to any duty call within San Andreas.",
		["width"] 	=  500,
		["height"] 	=  115,
		["speed"]	=  4000
	},
	[3] = {
		["posX"] 	=  1993.79,
		["posY"] 	= -1464.75,
		["posZ"] 	=  39.35,
		["lookX"] 	=  2029.19,
		["lookY"] 	= -1415.47,
		["lookZ"] 	=  16.99,
		["subject"] =  "San Andreas Medical and Fire Rescue",
		["body"] 	=  "If you feel like rescuing poor people, feel free to join the hardworking fire fighters and emergency medical technicians at the San Andreas Medical and Fire Rescue Department. Like in State Police, the rescue department is able to respond to calls within San Andreas.",
		["width"] 	=  500,
		["height"] 	=  115,
		["speed"]	=  4000
	},
	[4] = {
		["posX"] 	=  2283.69,
		["posY"] 	= -1658.99,
		["posZ"] 	=  14.97,
		["lookX"] 	=  2382.98,
		["lookY"] 	= -1658.9,
		["lookZ"] 	=  14.05,
		["subject"] =  "Gangs",
		["body"] 	=  ".. or if you feel like becoming part of the illegal side of the server, you can join a gang or make your own! Of course, we're not limited to just gangs in the hoods, but mafias, triads, you name it.",
		["width"] 	=  500,
		["height"] 	=  105,
		["speed"]	=  4000
	},
	[5] = {
		["posX"] 	=  1923.47,
		["posY"] 	= -1418.15,
		["posZ"] 	=  49.25,
		["lookX"] 	=  1865.6,
		["lookY"] 	= -1369.74,
		["lookZ"] 	=  61.83,
		["subject"] =  "Businesses",
		["body"] 	=  "You are also able to create and join businesses. Some examples for businesses are for example the Los Santos News Office, or a local high-class bakery in Rodeo. You can become anything you want in Los Santos, to make it simple.",
		["width"] 	=  500,
		["height"] 	=  115,
		["speed"]	=  4000
	},
	[6] = {
		["posX"] 	=  1332.18,
		["posY"] 	= -1334.31,
		["posZ"] 	=  62.95,
		["lookX"] 	=  1398.71,
		["lookY"] 	= -1311.77,
		["lookZ"] 	=  71,
		["subject"] =  "What's new?",
		["body"] 	=  "Totally scripted from a scratch, given a look of our own to give it a finishing, truly amazing touch. Design looks great and works out well with nearly any resolution. Giving you the exclusive feeling of real roleplay and close to real life economy, it will be a great chance to improve your skills and experience something greatly new and fancy. Tens of thousands lines of code piling up and more to come.",
		["width"] 	=  520,
		["height"] 	=  145,
		["speed"]	=  4000
	},
	[7] = {
		["posX"] 	=  1444.66,
		["posY"] 	= -1504.27,
		["posZ"] 	=  13.38,
		["lookX"] 	=  1434.21,
		["lookY"] 	= -1491.87,
		["lookZ"] 	=  24.15,
		["subject"] =  "Downtown",
		["body"] 	=  "After this tutorial you'll arrive at Unity Station, just next to the city center, also known as Pershing Square, surrounded with the court house, police station, city hall and a few good hotels to stay and have a nap at. Here is a view of one of the cheapest hotels near Pershing Square.",
		["width"] 	=  500,
		["height"] 	=  115,
		["speed"]	=  4000
	},
	[8] = {
		["posX"] 	=  1394.39,
		["posY"] 	= -1649.14,
		["posZ"] 	=  53.71,
		["lookX"] 	=  1433.28,
		["lookY"] 	= -1707.95,
		["lookZ"] 	=  66.22,
		["subject"] =  "Factions",
		["body"] 	=  "How about the ability to create your very own company? Sure - fill up a form at City Hall and the employees will process it through for you. A wait of one day gives you access to all features of the system if accepted. Even though details about your company are needed, it will do everything for you so you can just sit back and relax! You are able to hire people to work for you and they'll be payed their wage for their work hours.",
		["width"] 	=  505,
		["height"] 	=  145,
		["speed"]	=  5000
	},
	[9] = {
		["posX"] 	=  907.45,
		["posY"] 	= -1772.51,
		["posZ"] 	=  30.48,
		["lookX"] 	=  932.87,
		["lookY"] 	= -1743.92,
		["lookZ"] 	=  17.46,
		["subject"] =  "Vehicles",
		["body"] 	=  "Giving you a realistic touch of driving and making it a bit more difficult ensures that driving will never again be unbalanced and unrealistic. Access vehicles with keys or hotwire and steal them if you have the right tools and skills! Car running low on gasoline? Stop at the next gas station to fill up the gas tank and perhaps have a tasty cup of coffee inside in the store.",
		["width"] 	=  500,
		["height"] 	=  145,
		["speed"]	=  5000
	},
	[10] = {
		["posX"] 	=  1314.81,
		["posY"] 	= -684.14,
		["posZ"] 	=  117.77,
		["lookX"] 	=  1328.85,
		["lookY"] 	= -661.34,
		["lookZ"] 	=  109.13,
		["subject"] =  "Properties",
		["body"] 	=  "Ability to purchase your own properties and manage them has always been amazing and fun. Having a place to live at is great. If you have enough money, why not buy a big house with a lot of space in the back, including a big cosy pool! Have a swim or dive, either way it's always refreshing and cooling you up on a hot sunny summer day.",
		["width"] 	=  500,
		["height"] 	=  135,
		["speed"]	=  5000
	},
	[11] = {
		["posX"] 	=  998.84,
		["posY"] 	= -385.87,
		["posZ"] 	=  98.79,
		["lookX"] 	=  1041.52,
		["lookY"] 	= -344.64,
		["lookZ"] 	=  81.55,
		["subject"] =  "Weather and Seasons",
		["body"] 	=  "Spring, summer, fall, winter. All within the server and fully functional. Making streets and areas snowy when snowing, and making them hard to drive on, while during summer there is most of the time sunny and bright. These are taken into account in the script. Weather also changes dynamically and realistically.",
		["width"] 	=  500,
		["height"] 	=  130,
		["speed"]	=  5000
	},
	[12] = {
		["posX"] 	=  850.98,
		["posY"] 	= -1607.62,
		["posZ"] 	=  13.34,
		["lookX"] 	=  841.86,
		["lookY"] 	= -1597.53,
		["lookZ"] 	=  14.54,
		["subject"] =  "Education",
		["body"] 	=  "Experience new things and educate yourself. Improve your skills and learn about stuff. These are also taken into account and are worth mentioning as they always change your character's mood and how the character works and reacts. You can learn new languages and improve your skills on hotwiring a car, for example.",
		["width"] 	=  500,
		["height"] 	=  135,
		["speed"]	=  5000
	},
	[13] = {
		["posX"] 	=  1711.12,
		["posY"] 	= -1912,
		["posZ"] 	=  92.34,
		["lookX"] 	=  1713.12,
		["lookY"] 	= -1912,
		["lookZ"] 	=  13.56,
		["subject"] =  "Are you ready to begin?",
		["body"] 	=  "This is the end of the tutorial scene. You are now put in controls of your role-play character. Spend time in creating the most unique and awesome experience for your character. If you ever need assistance with gameplay or have a thing to report to us, please use the report tool by pressing F2 or typing /report. Without any further, do enjoy and have fun!",
		["width"] 	=  500,
		["height"] 	=  130,
		["speed"]	=  6000
	},
}

local function displayTutorialInfo()
	if (not tutorialShow) or (tutorialStep == 0) then return end
	dxDrawRectangle(45, sy-(tutorial[tutorialStep]["height"]+55), tutorial[tutorialStep]["width"], tutorial[tutorialStep]["height"], tocolor(0, 0, 0, 0.85*255), postGUI)
	dxDrawText(tutorial[tutorialStep]["subject"], 62, sy-(tutorial[tutorialStep]["height"]+44), sx, sy, tocolor(245, 245, 245, 246), 1.5, "clear", "left", "top", true, false, postGUI, false, false)
	dxDrawText(tutorial[tutorialStep]["body"], 64, sy-(tutorial[tutorialStep]["height"]+14), tutorial[tutorialStep]["width"]+37, sy, tocolor(245, 245, 245, 246), 1.0, "clear", "left", "top", false, true, postGUI, false, false)
end

function startShow(x, y, z)
	if (isTimer(tutorialTimer)) then
		killTimer(tutorialTimer)
		removeEventHandler("onClientRender", root, displayTutorialInfo)
	end
	
	showChat(false)
	setElementFrozen(localPlayer, true)
	addEventHandler("onClientRender", root, displayTutorialInfo)
	
	tutorialStep = 1
	setCameraMatrix(tutorial[tutorialStep]["posX"], tutorial[tutorialStep]["posY"], tutorial[tutorialStep]["posZ"], tutorial[tutorialStep]["lookX"], tutorial[tutorialStep]["lookY"], tutorial[tutorialStep]["lookZ"])
	
	tutorialTimer = setTimer(function()
		if (tutorialStep == #tutorial) then
			setElementPosition(localPlayer, x, y, z)
			setElementRotation(localPlayer, 0, 0, 90)
			tutorialStep = 1
			tutorialShow = false
			smoothMoveCamera(tutorial[#tutorial]["posX"], tutorial[#tutorial]["posY"], tutorial[#tutorial]["posZ"], tutorial[#tutorial]["lookX"], tutorial[#tutorial]["lookY"], tutorial[#tutorial]["lookZ"]-0.17, tutorial[#tutorial]["lookX"], tutorial[#tutorial]["lookY"], tutorial[#tutorial]["lookZ"]+0.1, x, y, z, 4500)
			setTimer(function()
				killTimer(tutorialTimer)
				setCameraTarget(localPlayer)
				setElementFrozen(localPlayer, false)
				showChat(true)
				triggerServerEvent(":_makeMeWorkOK_:", localPlayer, x, y, z)
				triggerEvent(":_stopMitis_:", localPlayer)
				triggerEvent(":_runRealPlayTimer_:", localPlayer)
			end, 5750, 1)
		else
			setElementPosition(localPlayer, x, y, z)
			setElementRotation(localPlayer, 0, 0, 90)
			tutorialStep = tutorialStep+1
			smoothMoveCamera(tutorial[tutorialStep-1]["posX"], tutorial[tutorialStep-1]["posY"], tutorial[tutorialStep-1]["posZ"], tutorial[tutorialStep-1]["lookX"], tutorial[tutorialStep-1]["lookY"], tutorial[tutorialStep-1]["lookZ"], tutorial[tutorialStep]["posX"], tutorial[tutorialStep]["posY"], tutorial[tutorialStep]["posZ"], tutorial[tutorialStep]["lookX"], tutorial[tutorialStep]["lookY"], tutorial[tutorialStep]["lookZ"], tutorial[tutorialStep]["speed"])
		end
	end, tutorialWait, 0)
	
	tutorialShow = true
end
addEvent(":_displayTutorial_:", true)
addEventHandler(":_displayTutorial_:", root, startShow)

addEventHandler("onClientPedDamage", root,
	function(attacker, weapon, bodypart, loss)
		if (isClientInTutorial(source)) then
			cancelEvent()
		end
	end
)

addCommandHandler("tutorial",
	function(cmd)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(localPlayer)) then return end
		setCameraTarget(localPlayer)
		if (tutorialShow == true) then
			if (isTimer(tutorialTimer)) then
				killTimer(tutorialTimer)
			end
			removeEventHandler("onClientRender", root, displayTutorialInfo)
		else
			startShow(1732.25, -1912.09, 13.56)
		end
	end
)