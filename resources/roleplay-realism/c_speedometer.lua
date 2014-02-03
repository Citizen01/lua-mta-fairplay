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

local fuellessVehicle = {[594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true}
local enginelessVehicle = {[510]=true, [509]=true, [481]=true}

local sx, sy = guiGetScreenSize()
local warned = false
local isVisible = true
local vehicleFuel = 0

local postGUI = false
local linecolor = tocolor(230, 230, 230, 240)

local function dxDisplaySpeed()
	if (not isVisible) or (isPlayerMapVisible()) then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (vehicle) then
		local speed = exports['roleplay-vehicles']:getElementSpeed(vehicle)-100
		local x_line = sx+math.sin(math.rad(-(speed)-148.9))*90
		local y_line = sy+math.cos(math.rad(-(speed)-148.9))*90
		
		dxDrawImage(sx-210, sy-215, 200, 200, "speedo_speedbase.png", 0, 0, 0, tocolor(255, 255, 255, 200), postGUI)
		dxDrawLine(sx-110, sy-115, x_line-110, y_line-115, linecolor, 2)
		
		if (speed >= 1000) then
			if (warned == false) then
				warned = true
				triggerServerEvent(":_returnCheat_:", localPlayer, 2, speed)
				setTimer(function()
					warned = false
				end, 11500, 1)
			end
		end
		
		local x, y, z = getElementPosition(localPlayer)
		dxDrawRectangle(sx-(102*2), sy-289, 188, 71, tocolor(0, 0, 0, 0.76*255), postGUI)
		dxDrawText("Speed limit: " .. (exports['roleplay-vehicles']:getPlayerSpeedLimit(localPlayer) and exports['roleplay-vehicles']:getPlayerSpeedLimit(localPlayer) or 60), sx-(95*2), sy-278, sx-30, sy, tocolor(245, 245, 245, 250), 1.0, "clear", "center", "top", true, false, postGUI, false, false)
		dxDrawText(exports['roleplay-vehicles']:getPlayerStreet(localPlayer), sx-(95*2), sy-261, sx-30, sy, tocolor(245, 245, 245, 250), 1.0, "clear", "center", "top", true, false, postGUI, false, false)
		dxDrawText(getZoneName(x, y, z, false), sx-(95*2), sy-243, sx-30, sy, tocolor(245, 245, 245, 250), 1.0, "clear", "center", "top", true, false, postGUI, false, false)
	end
end

local function dxDisplayFuel()
	if (not isVisible) or (isPlayerMapVisible()) then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (vehicle) then
		dxDrawImage(sx-300, sy-205, 100, 100, "speedo_fuelbase.png", 0, 0, 0, tocolor(255, 255, 255, 200), postGUI)
		x_line = sx+math.sin(math.rad(-(vehicleFuel)-50))*50
		y_line = sy+math.cos(math.rad(-(vehicleFuel)-50))*50
		dxDrawLine(sx-250, sy-156, x_line-240, y_line-156, linecolor, 2, postGUI)
	end
end

local function disableSpeedometer()
	removeEventHandler("onClientRender", root, dxDisplaySpeed)
	removeEventHandler("onClientRender", root, dxDisplayFuel)
end

local function enableSpeedometer()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (vehicle) then
		if (getVehicleOccupant(vehicle, 0) == localPlayer) or (getVehicleOccupant(vehicle, 1) == localPlayer) then
			if (getVehicleOccupant(vehicle, 0) == localPlayer) and (not fuellessVehicle[getElementModel(vehicle)]) then
				vehicleFuel = (exports['roleplay-vehicles']:getVehicleFuel(vehicle) and exports['roleplay-vehicles']:getVehicleFuel(vehicle) or 100)
				addEventHandler("onClientRender", root, dxDisplayFuel)
			end
			addEventHandler("onClientRender", root, dxDisplaySpeed)
		end
	end
end

local function checkSpeedometer()
	if (exports['roleplay-vehicles']:isPlayerInVehicle(localPlayer)) then
		if (not isVisible) then
			enableSpeedometer()
		end
	else
		if (isVisible) then
			disableSpeedometer()
		end
	end
end
setTimer(checkSpeedometer, 900, 0)

addEventHandler("onClientVehicleEnter", root,
	function(player, seat)
		if (player ~= localPlayer) then return end
		if (seat == 0) or (seat == 1) then
			if (seat == 0) and (not fuellessVehicle[getElementModel(source)]) then
				vehicleFuel = (exports['roleplay-vehicles']:getVehicleFuel(source) and exports['roleplay-vehicles']:getVehicleFuel(source) or 100)
				addEventHandler("onClientRender", root, dxDisplayFuel)
			end
			
			if (not enginelessVehicle[getElementModel(source)]) then
				addEventHandler("onClientRender", root, dxDisplaySpeed)
			end
		end
	end
)

addEventHandler("onClientVehicleExit", root,
	function(player, seat)
		if (player ~= localPlayer) then return end
		if (seat == 0) or (seat == 1) then
			if (seat == 0) and (not fuellessVehicle[getElementModel(source)]) then
				vehicleFuel = 0
				removeEventHandler("onClientRender", root, dxDisplayFuel)
			end
			if (not enginelessVehicle[getElementModel(source)]) then
				removeEventHandler("onClientRender", root, dxDisplaySpeed)
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		enableSpeedometer()
	end
)

addEvent(":_syncFuelAmount_:", true)
addEventHandler(":_syncFuelAmount_:", root,
	function(fuel_)
		vehicleFuel = fuel_
	end
)

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					if (hasObjectPermissionTo(player, "command." .. commandName[1], not restricted)) then
						fn(player, ...)
					end
				end
			)
		end
	end
end

addCommandHandler({"togglespeedo", "togspeed", "togspeedo", "togspeedometer", "togglespeed", "togglespeedo", "togglespeedometer"},
	function(cmd)
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (vehicle) then
			isVisible = not isVisible
			if (isVisible) then
				outputChatBox("Speedometer is now enabled.", 20, 245, 20, false)
			else
				outputChatBox("Speedometer is now disabled.", 20, 245, 20, false)
			end
		end
	end
)