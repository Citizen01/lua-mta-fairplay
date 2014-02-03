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

local dmvTruckModels = {[403]=true}

addEvent(":_finishDMVSession_:", true)
addEventHandler(":_finishDMVSession_:", root,
	function(isFinished)
		if (source ~= client) then return end
		local vehicle = getPedOccupiedVehicle(client)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= client) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 3) then return end
		
		if (getElementData(client, "roleplay:jobs.dmv:marker")) then
			removeElementData(client, "roleplay:jobs.dmv:marker")
		end
		
		if (getElementData(client, "roleplay:jobs.dmv:route")) then
			removeElementData(client, "roleplay:jobs.dmv:route")
		end
		
		if (getElementData(client, "roleplay:dmv.school")) then
			removeElementData(client, "roleplay:dmv.school")
		end
		
		if (isFinished) and (isFinished == 1) then
			setElementData(client, "roleplay:characters.dmv:license", tonumber(getElementData(client, "roleplay:jobs.dmv:license")), true)
			setElementData(client, "roleplay:characters.dmv:manual", tonumber(getElementData(client, "roleplay:jobs.dmv:manual")), true)
			dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??', `??` = '??' WHERE `??` = '??'", "characters", "driversLicense", tonumber(getElementData(client, "roleplay:jobs.dmv:license")), "transmissionLicense", tonumber(getElementData(client, "roleplay:jobs.dmv:manual")), "id", exports['roleplay-accounts']:getCharacterID(client))
		end
		
		if (getElementData(client, "roleplay:jobs.dmv:license")) then
			removeElementData(client, "roleplay:jobs.dmv:license")
		end
		
		if (getElementData(client, "roleplay:jobs.dmv:manual")) then
			removeElementData(client, "roleplay:jobs.dmv:manual")
		end
		
		removePedFromVehicle(client)
		fixVehicle(vehicle)
		setVehicleEngineState(vehicle, false)
		setVehicleOverrideLights(vehicle, 1)
		setElementFrozen(vehicle, true)
		setVehicleLocked(vehicle, false)
		setElementData(vehicle, "roleplay:vehicles.fuel", 100, true)
		setElementData(vehicle, "roleplay:vehicles.fuel;", 100, true)
		setElementData(vehicle, "roleplay:vehicles.engine", 0, true)
		setElementData(vehicle, "roleplay:vehicles.winstate", 0, true)
		setElementData(vehicle, "roleplay:vehicles.currentGear", 0, true)
		setElementData(vehicle, "roleplay:vehicles.handbrake", 1, true)
		respawnVehicle(vehicle)
		setElementPosition(client, 929.87, -1717.67, 13.54)
		setElementInterior(client, 0)
		setElementDimension(client, 0)
		setPedRotation(client, 90)
	end
)

addEvent(":_positiveDMVResult_:", true)
addEventHandler(":_positiveDMVResult_:", root,
	function()
		if (source ~= client) then return end
		if (getElementData(client, "roleplay:temp.dmvon")) then
			removeElementData(client, "roleplay:temp.dmvon")
		end
		setElementData(client, "roleplay:dmv.school", 1, false)
	end
)

addEvent(":_takeTheDMVMoney_:", true)
addEventHandler(":_takeTheDMVMoney_:", root,
	function()
		if (source ~= client) then return end
		takePlayerMoney(client, 500)
		setElementData(client, "roleplay:temp.dmvon", 1, false)
	end
)

addEvent(":_giveBackDMVMoney_:", true)
addEventHandler(":_giveBackDMVMoney_:", root,
	function()
		if (source ~= client) then return end
		givePlayerMoney(client, 500)
		outputChatBox("Money has been refunded to you automatically.", client, 20, 245, 20, false)
	end
)

addEvent(":_updateDMVData_:", true)
addEventHandler(":_updateDMVData_:", root,
	function(currentMarker, currentRoute, currentType, currentTransmission)
		if (source ~= client) then return end
		if (not exports['roleplay-accounts']:isClientPlaying(client)) then return end
		local vehicle = getPedOccupiedVehicle(client)
		if (not vehicle) then return end
		if (getVehicleController(vehicle) ~= client) then return end
		if (not tonumber(getElementData(vehicle, "roleplay:vehicles.job"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.job")) ~= 3) then return end
		
		if (exports['roleplay-accounts']:hasDriversLicense(client)) then
			if (dmvTruckModels[getElementModel(vehicle)]) then
				if (exports['roleplay-accounts']:hasTruckLicense(client)) then
					removePedFromVehicle(client)
					outputChatBox("You already possess a Heavy Duty driver's license.", client, 245, 20, 20, false)
					return
				end
			else
				if (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == tonumber(getElementData(client, "roleplay:characters.dmv:manual"))) or (tonumber(getElementData(vehicle, "roleplay:vehicles.geartype")) == 0 and tonumber(getElementData(client, "roleplay:characters.dmv:manual")) == 1) then
					removePedFromVehicle(client)
					outputChatBox("You already have a Standard driver's license for " .. (currentTransmission == 0 and "Automatic" or "Manual") .. " transmission.", client, 245, 20, 20, false)
					if (getElementData(client, "roleplay:jobs.dmv:marker")) then
						removeElementData(client, "roleplay:jobs.dmv:marker")
					end
					
					if (getElementData(client, "roleplay:jobs.dmv:route")) then
						removeElementData(client, "roleplay:jobs.dmv:route")
					end
					
					if (getElementData(client, "roleplay:jobs.dmv:license")) then
						removeElementData(client, "roleplay:jobs.dmv:license")
					end
					
					if (getElementData(client, "roleplay:jobs.dmv:manual")) then
						removeElementData(client, "roleplay:jobs.dmv:manual")
					end
					return
				end
			end
		end
		
		setElementData(client, "roleplay:jobs.dmv:marker", currentMarker, true)
		setElementData(client, "roleplay:jobs.dmv:route", currentRoute, true)
		setElementData(client, "roleplay:jobs.dmv:license", currentType, true)
		setElementData(client, "roleplay:jobs.dmv:manual", currentTransmission, true)
	end
)

addEventHandler("onVehicleStartEnter", root,
	function(player, seat, jacked)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) or (seat ~= 0) then return end
		if (seat ~= 0) then return end
		if (not tonumber(getElementData(source, "roleplay:vehicles.job"))) or (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= 3) then return end
		
		if (exports['roleplay-accounts']:hasDriversLicense(player)) then
			if (dmvTruckModels[getElementModel(source)]) then
				if (exports['roleplay-accounts']:hasTruckLicense(player)) then
					return
				end
			else
				if (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == tonumber(getElementData(player, "roleplay:characters.dmv:manual"))) or (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == 0 and tonumber(getElementData(player, "roleplay:characters.dmv:manual")) == 1) then
					return
				end
			end
		end
		
		if (not tonumber(getElementData(player, "roleplay:dmv.school"))) then
			cancelEvent()
			outputChatBox("You're not on a driving school lesson.", player, 245, 20, 20, false)
		end
	end
)

addEventHandler("onVehicleEnter", root,
	function(player, seat, jacked)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) or (seat ~= 0) then return end
		if (not tonumber(getElementData(source, "roleplay:vehicles.job"))) or (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= 3) then return end
		
		if (exports['roleplay-accounts']:hasDriversLicense(player)) then
			if (dmvTruckModels[getElementModel(source)]) then
				if (exports['roleplay-accounts']:hasTruckLicense(player)) then
					return
				end
			else
				if (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == tonumber(getElementData(player, "roleplay:characters.dmv:manual"))) or (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == 0 and tonumber(getElementData(player, "roleplay:characters.dmv:manual")) == 1) then
					return
				end
			end
		end
		
		triggerClientEvent(player, ":_beginDMVRoute_:", player, math.random(1, 1), (dmvTruckModels[getElementModel(source)] and 2 or 1), tonumber(getElementData(source, "roleplay:vehicles.geartype")))
	end
)

addEventHandler("onVehicleExit", root,
	function(player, seat, jacker)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) or (seat ~= 0) then return end
		if (not tonumber(getElementData(source, "roleplay:vehicles.job"))) or (tonumber(getElementData(source, "roleplay:vehicles.job")) ~= 3) then return end
		
		if (exports['roleplay-accounts']:hasDriversLicense(player)) then
			if (dmvTruckModels[getElementModel(source)]) then
				if (exports['roleplay-accounts']:hasTruckLicense(player)) then
					return
				end
			else
				if (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == tonumber(getElementData(player, "roleplay:characters.dmv:manual"))) or (tonumber(getElementData(source, "roleplay:vehicles.geartype")) == 0 and tonumber(getElementData(player, "roleplay:characters.dmv:manual")) == 1) then
					return
				end
			end
		end
		
		triggerClientEvent(player, ":_disableDMVRoute_:", player)
	end
)

addEventHandler("onResourceStop", root,
	function(resource)
		if (getResourceName(resource) == "roleplay-vehicles") then
			restartResource(getThisResource())
		elseif (resource == getThisResource()) then
			for i,v in ipairs(getElementsByType("player")) do
				if (getElementData(v, "roleplay:temp.dmvon")) then
					givePlayerMoney(v, 500)
					outputChatBox("Money has been refunded to you automatically.", v, 20, 245, 20, false)
					removeElementData(v, "roleplay:temp.dmvon")
				end
			end
		end
	end
)