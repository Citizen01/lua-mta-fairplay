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

local multiplier = 0.5
local currentMarker = 0
local currentRoute = 0
local totalGather = 0
local isDisabled = false
local spawned = {}
local markers = {
	{
		{1812.47, -1891.63, 13.41},
		{1819.22, -1907.24, 13.39},
		{1836.42, -1934.69, 13.37},
		{1948.35, -1934.69, 13.38},
		{2020.96, -1934.77, 13.33},
		{2082.07, -1934.18, 13.31},
		{2084.11, -1837.33, 13.38},
		{2091.23, -1766.02, 13.39},
		{2114.2,  -1682.53, 13.37},
		{2115.17, -1523.77, 23.7},
		{2115.06, -1394.25, 23.82},
		{2084.11, -1381.7, 	23.82},
		{2073.06, -1312.95, 23.82},
		{2073.06, -1189.35, 23.65},
		{2073.62, -1102.2, 	24.81},
		{2140.51, -1117.61, 25.26},
		{2262.45, -1147.75, 26.83},
		{2362.2,  -1156.73, 27.44},
		{2368.45, -1250.38, 23.83},
		{2368.77, -1374.1,	23.84},
		{2388.58, -1395.21, 23.84},
		{2417.21, -1446.75, 23.83},
		{2520.91, -1446.97, 28.36},
		{2632.54, -1446.82, 30.28},
		{2640.23, -1473.57, 30.28},
		{2640.23, -1674.3, 	10.72},
		{2633.87, -1729.78, 10.72},
		{2445.67, -1729.77, 13.55},
		{2226.25, -1729.9, 	13.38},
		{2213.43, -1756.2, 	13.35},
		{2215.81, -1905.63, 13.38},
		{2211.58, -2003.08, 13.33},
		{2273.68, -2074.35, 13.38},
		{2205.58, -2154.98, 13.38},
		{2113.15, -2108.62, 13.31},
		{1971.6,  -2107.48, 13.38},
		{1959.19, -2158, 	13.38},
		{1767.68, -2163.93, 13.38},
		{1532.34, -1880.54, 13.38},
		{1604.38, -1874.86, 13.38},
		{1692.03, -1825.52, 13.38},
		{1727.51, -1817.21, 13.36},
		{1813.12, -1834.85, 13.41},
		{1811.9,  -1887.3, 	13.41},
		{1790.02, -1911.39, 13.39}
	}
}

addEvent(":_beginRoute_:", true)
addEventHandler(":_beginRoute_:", root,
	function(routeID)
		if (markers[routeID]) then
			if (isDisabled) then
				currentRoute = tonumber(getElementData(localPlayer, "roleplay:jobs.route"))
				currentMarker = tonumber(getElementData(localPlayer, "roleplay:jobs.marker"))
				totalGather = tonumber(getElementData(localPlayer, "roleplay:jobs.gather"))
				spawned[localPlayer] = {}
				spawned[localPlayer][1] = createMarker(markers[currentRoute][currentMarker][1], markers[currentRoute][currentMarker][2], markers[currentRoute][currentMarker][3]-1, "checkpoint", 4, 50, 200, 50, 160)
				spawned[localPlayer][2] = createMarker(markers[currentRoute][currentMarker+1][1], markers[currentRoute][currentMarker+1][2], markers[currentRoute][currentMarker+1][3]-1, "checkpoint", 3, 200, 50, 50, 50)
				outputChatBox("Route continuing - follow the green checkpoints until you reach the yard again.", 210, 160, 25, false)
				outputChatBox("Reminder: You will be paid the amount you've gathered even if you quit or time out.", 210, 160, 25, false)
				isDisabled = false
				if (isTimer(resetTimerLol)) then
					killTimer(resetTimerLol)
				end
			else
				spawned[localPlayer] = {}
				spawned[localPlayer][1] = createMarker(markers[routeID][1][1], markers[routeID][1][2], markers[routeID][1][3]-1, "checkpoint", 4, 50, 200, 50, 160)
				spawned[localPlayer][2] = createMarker(markers[routeID][2][1], markers[routeID][2][2], markers[routeID][2][3]-1, "checkpoint", 3, 200, 50, 50, 50)
				currentRoute = routeID
				currentMarker = 1
				totalGather = 0
				triggerServerEvent(":_updateBusData_:", localPlayer, currentMarker, currentRoute, totalGather)
				outputChatBox("Route started - follow the green checkpoints until you reach the yard again.", 210, 160, 25, false)
				outputChatBox("Reminder: You will be paid the amount you've gathered even if you quit or time out.", 210, 160, 25, false)
			end
		end
	end
)

addEvent(":_stopRoute_:", true)
addEventHandler(":_stopRoute_:", root,
	function()
		if (spawned[localPlayer]) then
			for i,v in ipairs(spawned[localPlayer]) do
				if (isElement(v)) then
					destroyElement(v)
				end
			end
			
			spawned[localPlayer] = nil
		end
		
		currentRoute = 0
		currentMarker = 1
		totalGather = 0
		triggerServerEvent(":_updateBusData_:", localPlayer, currentMarker, currentRoute, totalGather)
	end
)

addEvent(":_disableRoute_:", true)
addEventHandler(":_disableRoute_:", root,
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
			outputChatBox("Your current route position has been saved. Continue the route by entering a bus (5 minutes until reset).", 210, 160, 25, false)
			
			if (not isTimer(resetTimerLol)) then
				resetTimerLol = setTimer(function()
					triggerEvent(":_stopRoute_:", localPlayer)
					outputChatBox("Your bus route save has expired. You have to start from the beginning when you enter a bus.", 210, 160, 25, false)
				end, 5000*60000, 1)
			else
				resetTimer(resetTimerLol)
			end
		end
	end
)

--[[addEvent(":_onClientMarkerHit_:", true)
addEventHandler(":_onClientMarkerHit_:", root,
	function(marker, vehicle)
		if (marker ~= spawned[localPlayer][1]) then return end
		if (#markers[currentRoute] == currentMarker) then
			if (not spawned[localPlayer]) or (not spawned[localPlayer][1]) then return end
			--outputChatBox("Points: " .. currentMarker .. "/" .. #markers[currentRoute] .. " (#D1)")
			
			for i,v in pairs(spawned[localPlayer]) do
				if (not spawned[localPlayer]) then break end
				if (isElement(v)) then
					destroyElement(v)
				end
			end
			
			totalGather = math.ceil(totalGather)
			currentMarker = 0
			currentRoute = 0
			outputChatBox("You've finished the bus route. You gathered " .. totalGather .. " USD for the trip. It has been transferred to your bank account.", 20, 245, 20, false)
			outputChatBox("If you want to start a route again, type /reroute, if not, remember to park your bus to the spot.", 210, 160, 25, false)
			totalGather = 0
			triggerServerEvent(":_payBusJob_:", localPlayer, totalGather)
		else
			if (isTimer(nextTimer)) then return end
			if (not spawned[localPlayer]) or (not spawned[localPlayer][1]) then return end
			if (multiplier > 1) then multiplier = 0.5 end
			--outputChatBox("Points: " .. currentMarker .. "/" .. #markers[currentRoute] .. " (#D2)")
			
			currentMarker = currentMarker+1
			totalGather = totalGather+multiplier
			
			if (isElement(spawned[localPlayer][1])) then
				destroyElement(spawned[localPlayer][1])
			end
			
			if (isElement(spawned[localPlayer][2])) then
				nextTimer = setTimer(function()
					spawned[localPlayer][1] = spawned[localPlayer][2]
					setMarkerColor(spawned[localPlayer][1], 50, 200, 50, 160)
					setMarkerSize(spawned[localPlayer][1], 4)
				
					triggerServerEvent(":_updateBusData_:", localPlayer, currentMarker, currentRoute, totalGather)
					
					if (markers[currentRoute][currentMarker+1]) then
						spawned[localPlayer][2] = createMarker(markers[currentRoute][currentMarker+1][1], markers[currentRoute][currentMarker+1][2], markers[currentRoute][currentMarker+1][3]-1, "checkpoint", 3, 200, 50, 50, 50)
					end
				end, 500, 1)
			end
		end
		
		playSoundFrontEnd(45)
	end
)]]

addEventHandler("onClientMarkerHit", resourceRoot,
	function(hitPlayer, matchingDimension)
		if (not exports['roleplay-accounts']:isClientPlaying(hitPlayer)) or (not matchingDimension) then return end
		if (exports['roleplay-accounts']:getCharacterJob(hitPlayer) ~= 1) then return end
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= hitPlayer) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 1) then return end
		if (source ~= spawned[localPlayer][1]) then return end
		
		if (#markers[currentRoute] == currentMarker) then
			if (not spawned[hitPlayer]) or (not spawned[hitPlayer][1]) then return end
			--outputChatBox("Points: " .. currentMarker .. "/" .. #markers[currentRoute] .. " (#D1)")
			
			for i,v in pairs(spawned[hitPlayer]) do
				if (not spawned[hitPlayer]) then break end
				if (isElement(v)) then
					destroyElement(v)
				end
			end
			
			totalGather = math.ceil(totalGather)
			currentMarker = 0
			currentRoute = 0
			outputChatBox("You've finished the bus route. You gathered " .. totalGather .. " USD for the trip. It has been transferred to your bank account.", 20, 245, 20, false)
			outputChatBox("If you want to start a route again, type /reroute, if not, remember to park your bus to the spot.", 210, 160, 25, false)
			totalGather = 0
			triggerServerEvent(":_payBusJob_:", hitPlayer, totalGather)
		else
			if (isTimer(nextTimer)) then return end
			if (not spawned[hitPlayer]) or (not spawned[hitPlayer][1]) then return end
			if (multiplier > 1) then multiplier = 0.5 end
			--outputChatBox("Points: " .. currentMarker .. "/" .. #markers[currentRoute] .. " (#D2)")
			
			currentMarker = currentMarker+1
			totalGather = totalGather+multiplier
			
			if (isElement(spawned[hitPlayer][1])) then
				destroyElement(spawned[hitPlayer][1])
			end
			
			if (isElement(spawned[hitPlayer][2])) then
				nextTimer = setTimer(function()
					spawned[hitPlayer][1] = spawned[hitPlayer][2]
					setMarkerColor(spawned[hitPlayer][1], 50, 200, 50, 160)
					setMarkerSize(spawned[hitPlayer][1], 4)
				
					triggerServerEvent(":_updateBusData_:", hitPlayer, currentMarker, currentRoute, totalGather)
					
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
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		if (exports['roleplay-accounts']:getCharacterJob(localPlayer) ~= 1) then return end
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= localPlayer) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 1) then return end
		if (not tonumber(getElementData(localPlayer, "roleplay:jobs.route"))) or (not tonumber(getElementData(localPlayer, "roleplay:jobs.marker"))) then return end
		
		currentRoute = tonumber(getElementData(localPlayer, "roleplay:jobs.route"))
		currentMarker = tonumber(getElementData(localPlayer, "roleplay:jobs.marker"))
		totalGather = tonumber(getElementData(localPlayer, "roleplay:jobs.gather"))
		
		if (markers[currentRoute]) then
			spawned[localPlayer] = {}
			spawned[localPlayer][1] = createMarker(markers[currentRoute][currentMarker][1], markers[currentRoute][currentMarker][2], markers[currentRoute][currentMarker][3]-1, "checkpoint", 4, 50, 200, 50, 160)
			spawned[localPlayer][2] = createMarker(markers[currentRoute][currentMarker+1][1], markers[currentRoute][currentMarker+1][2], markers[currentRoute][currentMarker+1][3]-1, "checkpoint", 3, 200, 50, 50, 50)
			triggerServerEvent(":_updateBusData_:", localPlayer, currentMarker, currentRoute, totalGather)
		else
			triggerServerEvent(":_takeShitFromBus_:", localPlayer)
		end
	end
)

addCommandHandler("reroute",
	function(cmd, routeID)
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		if (exports['roleplay-accounts']:getCharacterJob(localPlayer) ~= 1) then return end
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= localPlayer) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 1) then return end
		
		if (currentMarker == 1) or (not currentRoute) or (currentRoute == 0) or (currentMarker >= #markers[currentRoute]-5) then
			local _routeID = math.random(1, 1)
			if (tonumber(routeID)) and (markers[routeID]) then
				_routeID = routeID
			end
			
			triggerEvent(":_stopRoute_:", localPlayer)
			triggerEvent(":_beginRoute_:", localPlayer, _routeID)
		else
			outputChatBox("You aren't able to start all over again from this point. You have to be closer to the end of the route.", 245, 20, 20, false)
		end
	end
)

addCommandHandler("stoproute",
	function(cmd, routeID)
		if (not exports['roleplay-accounts']:isClientOwner(localPlayer)) then return end
		if (exports['roleplay-accounts']:getCharacterJob(localPlayer) ~= 1) then return end
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= localPlayer) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 1) then return end
		if (currentMarker == 0) or (currentRoute == 0) then return end
		
		triggerEvent(":_stopRoute_:", localPlayer)
		totalGather = math.ceil(totalGather)
		currentMarker = 0
		currentRoute = 0
		triggerServerEvent(":_payBusJob_:", localPlayer, totalGather)
		outputChatBox("You've finished the bus route. You gathered " .. totalGather .. " USD for the trip. It has been transferred to your bank account.", 20, 245, 20, false)
		totalGather = 0
		outputChatBox("If you want to start a route again, type /reroute, if not, remember to park your bus to the spot.", 210, 160, 25, false)
	end
)