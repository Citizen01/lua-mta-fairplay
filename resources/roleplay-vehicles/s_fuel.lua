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
	
	ok sry ok vg
]]

local fuellessVehicle = {[594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true}

function fuelDepleting(type)
	if (type == 1) then
		for _,player in ipairs(getElementsByType("player")) do
			if (isPedInVehicle(player)) then
				local vehicle = getPedOccupiedVehicle(player)
				if (vehicle) then
					local seat = getPedOccupiedVehicleSeat(player)	
					if (seat == 0) then
						if (not fuellessVehicle[getElementModel(vehicle)]) then
							if (isVehicleEngineOn(vehicle)) then
								local fuel = getVehicleRealFuel(vehicle)
								if (fuel >= 1) then
									local oldx = tonumber(getElementData(vehicle, "roleplay:vehicles.oldx"))
									local oldy = tonumber(getElementData(vehicle, "roleplay:vehicles.oldy"))
									local oldz = tonumber(getElementData(vehicle, "roleplay:vehicles.oldz"))
									local x, y, z = getElementPosition(vehicle)
									local distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
									local zdiff = oldz-z
									local ignore = false
									
									if (zdiff >= 50) then
										ignore = true
									elseif (zdiff <= -50) then
										ignore = true
									end
									
									if (not ignore) then
										local distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
										if (distance < 10) then
											distance = 10
										end
										
										newFuel = fuel-(distance/290)
										setElementData(vehicle, "roleplay:vehicles.fuel", newFuel, false)
										setElementData(vehicle, "roleplay:vehicles.fuel;", newFuel, true)

										if (newFuel < 1) then
											setVehicleEngineState(vehicle, false)
											setElementData(vehicle, "roleplay:vehicles.engine", 0, false)
											toggleControl(player, "accelerate", false)
											toggleControl(player, "brake_reverse", false)
										end
									end
									
									setElementData(vehicle, "roleplay:vehicles.fuel", newFuel, false)
									setElementData(vehicle, "roleplay:vehicles.fuel;", newFuel, true)
									setElementData(vehicle, "roleplay:vehicles.oldx", x, false)
									setElementData(vehicle, "roleplay:vehicles.oldy", y, false)
									setElementData(vehicle, "roleplay:vehicles.oldz", z, false)
									
									triggerClientEvent(player, ":_syncFuelAmount_:", player, newFuel)
								end
							end
						end
					end
				end
			end
		end
	elseif (type == 2) then
		for _,vehicle in ipairs(getElementsByType("vehicles")) do
			if (isVehicleEngineOn(vehicle)) then
				if (not getVehicleOccupant(vehicle)) then
					local fuel = getVehicleRealFuel(vehicle)
					if (fuel >= 1) then
						local newFuel = fuel-0.9
						
						setElementData(vehicle, "roleplay:vehicles.fuel", newFuel, false)
						setElementData(vehicle, "roleplay:vehicles.fuel;", newFuel, false)
						
						if (newFuel < 1) then
							setVehicleEngineState(vehicle, false)
							setElementData(vehicle, "roleplay:vehicles.engine", 0, false)
						end
					end
				end
			end
		end
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		setTimer(function() fuelDepleting(1) end, 20000, 0)
		setTimer(function() fuelDepleting(2) end, 120000, 0)
	end
)