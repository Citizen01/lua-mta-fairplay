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

local bike = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true, [536]=true, [575]=true, [567]=true, [480]=true, [555]=true}
local payday = false
local stateBenefit = 200
local propertyTax = 90
local vehicleTax = 60

local function addATM(id, x, y, z, rotation, interior, dimension, deposit, withdraw, limit)
	local object = createObject(2942, x, y, z, 0, 0, rotation-180)
	setElementDimension(object, dimension)
	setElementInterior(object, interior)
	setElementData(object, "roleplay:atms.id", id, true)
	setElementData(object, "roleplay:atms.deposit", deposit, true)
	setElementData(object, "roleplay:atms.withdraw", withdraw, true)
	setElementData(object, "roleplay:atms.limit", limit, true)
	
	--outputDebugString("ATM ID " .. id .. " loaded.")
end

function getStateBenefitValue()
	return tonumber(stateBenefit)
end

function getStatePropertyTaxValue()
	return tonumber(propertyTax)
end

function getStateVehicleTaxValue()
	return tonumber(vehicleTax)
end

local function checkPayday()
	if (not payday) then
		local time = getRealTime()
		local minute = time.minute
		if (minute >= 0) and (minute <= 5) then
			payday = true
			
			setTimer(function()
				payday = false
			end, 60000*30, 1)
			
			for _,player in ipairs(getElementsByType("player")) do
				local playerTime = tonumber(getElementData(player, "roleplay:characters.time"))
				if (playerTime) then
					if (playerTime >= 25) then
						local totalAmount = 0
						local propertyTax = 0
						local vehicleTax = 0
						local rent = 0
						local money = getBankValue(player)
						--local interest = math.ceil(0.003*money)
						local interest = 200
						local factionWage = 0
						local isFakeWage = false
						
						local factionID = exports['roleplay-accounts']:getPlayerFaction(player)
						local factionRank = exports['roleplay-accounts']:getFactionRank(player)
						local faction = exports['roleplay-factions']:getFactionByID(factionID)
						if (factionID) and (faction) then
							factionWage = fromJSON(exports['roleplay-factions']:getFactionWages(faction))[factionRank]
						else
							factionWage = getStateBenefitValue()
							isFakeWage = true
						end
						
						if (money > 20000) then
							factionWage = 0
						elseif (money > 30000) then
							interest = 100
						elseif (money > 40000) then
							interest = 0
						end
						
						money = money+interest+factionWage
						
						outputChatBox("------------------ HOURLY INCOME ------------------", player, 210, 160, 25, false)
						
						if (not exports['roleplay-accounts']:getPlayerFaction(player)) then
							if (money < 20000) then
								outputChatBox("  State Benefits: #00FF00" .. getFormattedValue(factionWage) .. " USD", player, 210, 160, 25, true)
							end
						else
							if (factionWage > 0) then
								outputChatBox("  Faction Wage: #00FF00" .. getFormattedValue(factionWage) .. " USD " .. (isFakeWage and "(Fake Wage)" or ""), player, 210, 160, 25, true)
							end
						end
						
						if (interest > 0) then
							outputChatBox("  Bank Interest: #00FF00" .. getFormattedValue(interest) .. " USD", player, 210, 160, 25, true)
						end
						
						for _,interior in ipairs(getElementsByType("pickup")) do
							if (exports['roleplay-interiors']:getInteriorOwner(interior)) and (exports['roleplay-interiors']:getInteriorOwner(interior) == exports['roleplay-accounts']:getCharacterID(player)) then
								if (exports['roleplay-interiors']:getInteriorType(interior) == 3) then
									rent = rent+exports['roleplay-interiors']:getInteriorPrice(interior)
								else
									propertyTax = propertyTax+(getStatePropertyTaxValue())
								end
							end
						end
						
						for _,vehicle in ipairs(getElementsByType("vehicle")) do
							if (exports['roleplay-vehicles']:getVehicleOwner(vehicle)) and (exports['roleplay-vehicles']:getVehicleOwner(vehicle) == exports['roleplay-accounts']:getCharacterID(player)) then
								if (not bike[getElementModel(vehicle)]) then
									vehicleTax = vehicleTax+(getStatePropertyTaxValue())
								end
							end
						end
						
						if (propertyTax > 0) then
							money = money-propertyTax
							outputChatBox("  Property Tax: #FF0000" .. getFormattedValue(propertyTax) .. " USD", player, 210, 160, 25, true)
						end
						
						if (rent > 0) then
							money = money-propertyTax
							outputChatBox("  Property Rent: #FF0000" .. getFormattedValue(rent) .. " USD", player, 210, 160, 25, true)
						end
						
						if (vehicleTax > 0) then
							money = money-vehicleTax
							outputChatBox("  Vehicle Tax: #FF0000" .. getFormattedValue(vehicleTax) .. " USD", player, 210, 160, 25, true)
						end
						
						money = math.ceil(money)-getBankValue(player)
						
						outputChatBox("-------------------------------------------------------------", player, 210, 160, 25, true)
						outputChatBox("  Total Income: " .. (money >= 0 and "#00FF00" or "#FF0000") .. getFormattedValue(money) .. " USD", player, 210, 160, 25, true)
						
						if (rent ~= 0) and (rent > money) then
							local ids = ""
							for _,interior in ipairs(getElementsByType("pickup")) do
								if (exports['roleplay-interiors']:getInteriorOwner(interior)) and (exports['roleplay-interiors']:getInteriorOwner(interior) == exports['roleplay-accounts']:getCharacterID(player)) then
									if (exports['roleplay-interiors']:getInteriorType(interior) == 3) then
										if (ids == "") then
											ids = exports['roleplay-interiors']:getInteriorID(interior)
										else
											ids = ids .. ", " .. exports['roleplay-interiors']:getInteriorID(interior)
										end
										
										exports['roleplay-interiors']:setInteriorOwner(exports['roleplay-interiors']:getInteriorID(interior), 0)
									end
								end
							end
							
							if (ids ~= "") then
								if (string.find(ids, ", ")) then
									outputChatBox("  Notification: You were thrown out of properties with IDs: " .. ids, player, 210, 160, 25, false)
								else
									outputChatBox("  Notification: You were thrown out of property with ID: " .. ids, player, 210, 160, 25, false)
								end
							end
						end
						
						money = money-rent
						
						outputChatBox("-------------------------------------------------------------", player, 210, 160, 25, true)
						
						setBankValue(player, money+getBankValue(player))
					else
						outputChatBox("You didn't receive any income this hour as you have been online for less than 25 minutes.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		setTimer(checkPayday, 5000, 1)
		setTimer(checkPayday, 1000*60, 0)
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "atms")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 ATM is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " ATMs are about to be loaded.")
				end
				
				for result,row in pairs(result) do
					addATM(row["id"], row["posX"], row["posY"], row["posZ"], row["rotation"], row["interior"], row["dimension"], row["deposit"], row["withdraw"], row["limit"])
				end
			else
				outputDebugString("0 ATMs loaded. Does the ATM table contain data and are the settings correct?")
			end
		else
			outputServerLog("Error: MySQL query failed when tried to fetch all ATMs.")
		end
		
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??'", "value", "config", "key", "gov_state_benefit")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				for result,row in pairs(result) do
					stateBenefit = row["value"]
					outputDebugString("State benefit set to " .. getFormattedValue(stateBenefit) .. " USD.")
				end
			end
		end
		
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??'", "value", "config", "key", "gov_property_tax")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				for result,row in pairs(result) do
					propertyTax = row["value"]
					outputDebugString("State property tax set to " .. getFormattedValue(propertyTax) .. " USD.")
				end
			end
		end
		
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??'", "value", "config", "key", "gov_vehicle_tax")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				for result,row in pairs(result) do
					vehicleTax = row["value"]
					outputDebugString("State vehicle tax set to " .. getFormattedValue(vehicleTax) .. " USD.")
				end
			end
		end
	end
)

addEvent(":_doGetMoneyAmount_:", true)
addEventHandler(":_doGetMoneyAmount_:", root,
	function()
		if (source ~= client) then return end
		triggerClientEvent(client, ":_doFetchMoneyAmount_:", client, getBankValue(client), getPlayerMoney(client))
	end
)

addEvent(":_doWithdraw_:", true)
addEventHandler(":_doWithdraw_:", root,
	function(value)
		if (source ~= client) or (not tonumber(value)) then return end
		if (getBankValue(client) >= value) then
			takeBankValue(client, value)
			givePlayerMoney(client, value)
			triggerClientEvent(client, ":_doneWithdraw_:", client, value)
		else
			exports['roleplay-accounts']:outputAdminLog(getPlayerName(client):gsub("_", " ") .. " tried to do a money hack on withdraw (fake: " .. tostring(value) .. ", real: " .. getBankValue(client) .. ").", 5)
		end
	end
)

addEvent(":_doDeposit_:", true)
addEventHandler(":_doDeposit_:", root,
	function(value)
		if (source ~= client) or (not tonumber(value)) then return end
		if (getPlayerMoney(client) >= value) then
			giveBankValue(client, value)
			takePlayerMoney(client, value)
			triggerClientEvent(client, ":_doneDeposit_:", client, value)
		else
			exports['roleplay-accounts']:outputAdminLog(getPlayerName(client):gsub("_", " ") .. " tried to do a money hack on deposit (fake: " .. tostring(value) .. ", real: " .. getPlayerMoney(client) .. ").", 5)
		end
	end
)

addEvent(":_doTransfer_:", true)
addEventHandler(":_doTransfer_:", root,
	function(value, receiver)
		if (source ~= client) or (not tonumber(value)) then return end
		if (exports['roleplay-accounts']:getCharacterHour(client) >= 10) then
			if (getBankValue(client) >= value) then
				local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??`, `??`, `??` FROM `??` WHERE LCASE(`??`) = '??'", "characterName", "id", "userID", "characters", "characterName", string.lower(receiver:gsub(" ", "_")))
				if (query) then
					local result, num_affected_rows, errmsg = dbPoll(query, -1)
					if (num_affected_rows == 1) then
						for result,row in pairs(result) do
							if (row["characterName"] == getPlayerName(client)) then
								outputChatBox("You can't really transfer your money to your own account you know.", client, 245, 20, 20, false)
								return
							end
							
							if (row["userID"] ~= exports['roleplay-accounts']:getAccountID(client)) then
								takeBankValue(client, value)
								local target = getPlayerFromName(row["characterName"])
								
								if (target) then
									giveBankValue(target, value)
								else
									giveBankValue(row["id"], value)
								end
								
								triggerClientEvent(client, ":_doneTransfer_:", client, value, row["characterName"])
								exports['roleplay-logging']:insertLog(client, 3, getPlayerName(client) .. ";" .. row["characterName"], "Transferred " .. value)
							else
								outputChatBox("Sorry, transferring stuff from your characters to your other characters is prohibited. Make sure this was your first and last try!", client, 245, 20, 20, false)
								exports['roleplay-accounts']:outputAdminLog(exports['roleplay-accounts']:getRealPlayerName(client) .. " tried to transfer money from their current character to their alternative character '" .. row["characterName"]:gsub("_", " ") .. "'.")
								outputServerLog("Player Warning: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] tried to transfer money from their current character to their alternative character '" .. row["characterName"] .. "'.")
							end
						end
					elseif (num_affected_rows > 1) then
						outputChatBox("Too many results, please make sure you enter a firstname and a lastname.", client, 245, 20, 20, false)
					else
						if (exports['roleplay-factions']:getFactionByName(receiver)) then
							dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = `??`+'??' WHERE `??` = '??'", "factions", "bankValue", "bankValue", value, "name", receiver)
							triggerClientEvent(client, ":_doneTransfer_:", client, value, receiver)
							exports['roleplay-logging']:insertLog(client, 3, getPlayerName(client) .. ";faction: " .. receiver, "Transferred " .. value)
						else
							outputChatBox("No results for that name.", client, 245, 20, 20, false)
						end
					end
				end
			else
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(client):gsub("_", " ") .. " tried to do a money hack on transfer (fake: " .. tostring(value) .. ", real: " .. getBankValue(client) .. ", receiver: " .. tostring(receiver) .. ").", 5)
			end
		else
			outputChatBox("You cannot transfer money until you've played for at least 10 hours.", client, 245, 20, 20, false)
		end
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
			addCommandHandler_(value, fn, restricted, false)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end, false, false
			)
		end
	end
end

addCommandHandler({"wallet", "mymoney", "money", "mywallet"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		outputChatBox("You have " .. getFormattedValue(getPlayerMoney(player)) .. " USD in your wallet.", player)
	end
)

addCommandHandler({"addatm", "createatm", "makeatm"},
	function(player, cmd, deposit, withdraw, limit)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local deposit = (deposit and tonumber(deposit) or 0)
			local withdraw = (withdraw and tonumber(withdraw) or 1)
			local limit = (limit and tonumber(limit) or 5000)
			if (deposit and deposit ~= 0 and deposit ~= 1) or (withdraw and withdraw ~= 0 and withdraw ~= 1) or (limit and limit < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [deposit (0/1)] [withdraw (0/1)] [limit]", player, 210, 160, 25, false)
				return
			else
				local x, y, z = getElementPosition(player)
				local rotation = getPedRotation(player)
				local interior = getElementInterior(player)
				local dimension = getElementDimension(player)
				local z = z-0.3
				local time = getRealTime()
				
				local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "atms", "posX", "posY", "posZ", "rotation", "interior", "dimension", "deposit", "withdraw", "limit", "created", x, y, z, rotation, interior, dimension, deposit, withdraw, limit, time.timestamp)
				if (query) then
					local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "id", "atms", "created", time.timestamp)
					if (query) then
						local result, num_affected_rows, errmsg = dbPoll(query, -1)
						if (num_affected_rows > 0) then
							for result,row in pairs(result) do
								addATM(row["id"], x, y, z, rotation, interior, dimension, deposit, withdraw, limit)
								local x = x + ((math.cos(math.rad(rotation)))*2)
								local y = y + ((math.sin(math.rad(rotation)))*2)
								setElementPosition(player, x, y, z)
								outputChatBox("Created a new ATM with ID " .. row["id"] .. ".", player, 20, 245, 20, false)
								outputServerLog("ATMs: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new ATM with ID " .. row["id"] .. ".")
							end
						else
							outputChatBox("MySQL query returned nothing when tried to fetch the ATM ID.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query returned nothing when tried to fetch the new ATM's ID (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("MySQL error occured when tried to fetch the ATM ID.", player, 245, 20, 20, false)
						outputServerLog("Error: MySQL query failed when tried to fetch the new ATM's ID (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
					end
				else
					outputChatBox("MySQL error occured when tried to create the ATM.", player, 245, 20, 20, false)
					outputServerLog("Error: MySQL query failed when tried to create a new ATM (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
				end
			end
		end
	end
)

addCommandHandler({"delatm", "deleteatm"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if ((not id) or (id and (id < 0))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local atm = getATM(id)
				if (atm) then
					local x, y, z = getElementPosition(player)
					local vx, vy, vz = getElementPosition(atm)
					if (getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 10) then
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "atms", "id", id)
						if (query) then
							destroyElement(atm)
							outputChatBox("ATM ID " .. id .. " has been deleted.", player, 20, 245, 20, false)
							outputServerLog("ATMs: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] deleted ATM ID " .. id .. ".")
						else
							outputChatBox("MySQL query failed when tried to delete the ATM.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to delete ATM with ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You need to be near the ATM you want to delete.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find a ATM with ID " .. id .. ".", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"gotoatm", "tptoatm"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id and id < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local atm = getATM(id)
				if (atm) then
					local rx, ry, rz = getElementRotation(atm)
					local x, y, z = getElementPosition(atm)
					local x = x+((math.cos(math.rad(rz)))*2)
					local y = y+((math.sin(math.rad(rz)))*2)
					setElementPosition(player, x, y, z)
					setPedRotation(player, rz)
					setElementInterior(player, getElementInterior(atm))
					setElementDimension(player, getElementDimension(atm))
					outputChatBox("Teleported to ATM ID " .. id .. ".", player, 20, 245, 20, false)
					outputServerLog("ATMs: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] teleported to ATM ID " .. id .. ".")
				else
					outputChatBox("Couldn't find an ATM with ID " .. id .. ".", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler("setstatebenefit",
	function(player, cmd, value)
		if (not exports['roleplay-accounts']:isClientLeader(player)) and ((not exports['roleplay-accounts']:getPlayerFaction(player)) or (exports['roleplay-accounts']:getPlayerFaction(player) and exports['roleplay-accounts']:getPlayerFaction(player) ~= 2 and exports['roleplay-accounts']:getFactionPrivileges(player) ~= 2)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local value = tonumber(value)
			if (not value) or (value and value < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [new value]", player, 210, 160, 25, false)
				return
			else
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "config", "value", value, "key", "gov_state_benefit")
				stateBenefit = value
				outputChatBox("State benefit is now set to " .. getFormattedValue(value) .. " USD.", player, 20, 245, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " set the state benefit value to " .. getFormattedValue(value) .. " USD.")
				outputServerLog("Banking: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set the state benefit value to " .. getFormattedValue(value) .. " USD.")
			end
		end
	end
)

addCommandHandler("setpropertytax",
	function(player, cmd, value)
		if (not exports['roleplay-accounts']:isClientLeader(player)) and ((not exports['roleplay-accounts']:getPlayerFaction(player)) or (exports['roleplay-accounts']:getPlayerFaction(player) and exports['roleplay-accounts']:getPlayerFaction(player) ~= 2 and exports['roleplay-accounts']:getFactionPrivileges(player) ~= 2)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local value = tonumber(value)
			if (not value) or (value and value < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [new value]", player, 210, 160, 25, false)
				return
			else
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "config", "value", value, "key", "gov_property_tax")
				stateBenefit = value
				outputChatBox("Property tax is now set to " .. getFormattedValue(value) .. " USD.", player, 20, 245, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " set the property tax value to " .. getFormattedValue(value) .. " USD.")
				outputServerLog("Banking: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set the property tax value to " .. getFormattedValue(value) .. " USD.")
			end
		end
	end
)

addCommandHandler("setvehicletax",
	function(player, cmd, value)
		if (not exports['roleplay-accounts']:isClientLeader(player)) and ((not exports['roleplay-accounts']:getPlayerFaction(player)) or (exports['roleplay-accounts']:getPlayerFaction(player) and exports['roleplay-accounts']:getPlayerFaction(player) ~= 2 and exports['roleplay-accounts']:getFactionPrivileges(player) ~= 2)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local value = tonumber(value)
			if (not value) or (value and value < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [new value]", player, 210, 160, 25, false)
				return
			else
				dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "config", "value", value, "key", "gov_vehicle_tax")
				stateBenefit = value
				outputChatBox("Vehicle tax is now set to " .. getFormattedValue(value) .. " USD.", player, 20, 245, 20, false)
				exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " set the vehicle tax value to " .. getFormattedValue(value) .. " USD.")
				outputServerLog("Banking: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] set the vehicle tax value to " .. getFormattedValue(value) .. " USD.")
			end
		end
	end
)

addCommandHandler("nearbyatms",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local pass = false
			local px, py, pz = getElementPosition(player)
			outputChatBox("Nearby ATMs:", player, 210, 160, 25, false)
			for i,v in ipairs(getElementsByType("object")) do
				if (getATMID(v)) and (getElementInterior(v) == getElementInterior(player) and getElementDimension(v) == getElementDimension(player)) then
					local x, y, z = getElementPosition(v)
					if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10) then
						outputChatBox("  ATM with ID " .. getATMID(v), player, 220, 170, 28, false)
						if (not pass) then pass = true end
					end
				end
			end
			
			if (not pass) then
				outputChatBox("  None.", player, 220, 170, 28, false)
			end
		end
	end
)

addCommandHandler("pay",
	function(player, cmd, name, value)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		local value = tonumber(value)
		if (not name) or (not value) or (value and value <= 0) then
			outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [value]", player, 210, 160, 25, false)
		else
			if (exports['roleplay-accounts']:getCharacterHour(client) >= 10) then
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (target) then
					if (target ~= player) then
						local x, y, z = getElementPosition(player)
						if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(target)) <= 5) then
							local value = math.ceil(value)
							local oldValue = getPlayerMoney(player)
							if (oldValue >= value) then
								takePlayerMoney(player, value)
								givePlayerMoney(target, value)
								exports['roleplay-chat']:outputLocalActionMe(player, "takes out a " .. (value <= 500 and "few" or "bunch of") .. " bills and gives them to " .. getPlayerName(target):gsub("_", " ") .. ".")
								outputChatBox("You gave " .. getPlayerName(target):gsub("_", " ") .. " " .. value .. " USD.", player, 20, 245, 20, false)
								outputChatBox(getPlayerName(player):gsub("_", " ") .. " gave you " .. value .. " USD.", target, 20, 245, 20, false)
								exports['roleplay-logging']:insertLog(player, 2, getPlayerName(player) .. ";" .. getPlayerName(target), "Gave " .. value .. " (had " .. oldValue .. ")")
							else
								outputChatBox("You don't have that much money.", player, 245, 20, 20, false)
							end
						else
							outputChatBox("You have to be close to the player in order to do that.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("You can't pay yourself, you know.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("No such player found.", player, 245, 20, 20, false)
				end
			else
				outputChatBox("You cannot transfer money until you've played for at least 10 hours.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler("givemoney",
	function(player, cmd, name, value)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local value = tonumber(value)
			if (not name) and ((not value) or (value and value <= 0)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [value]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						givePlayerMoney(target, value)
						outputChatBox("You gave " .. getFormattedValue(value) .. " USD in cash to " .. getPlayerName(target):gsub("_", " ") .. ".", player, 210, 160, 25, false)
						outputChatBox("Administrator gave you " .. getFormattedValue(value) .. " USD in cash.", target, 210, 160, 25, false)
						exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " gave " .. getPlayerName(target):gsub("_", " ") .. " " .. getFormattedValue(value) .. " USD.", 7)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " (" .. value .. ") command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler("takemoney",
	function(player, cmd, name, value)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local value = tonumber(value)
			if (not name) and ((not value) or (value and value <= 0)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [value]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						if (getPlayerMoney(target) >= value) then
							takePlayerMoney(target, value)
							outputChatBox("You took " .. getFormattedValue(value) .. " USD in cash from " .. getPlayerName(target):gsub("_", " ") .. ".", player, 210, 160, 25, false)
							outputChatBox("Administrator took " .. getFormattedValue(value) .. " USD in cash from you.", target, 210, 160, 25, false)
						exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " took " .. getFormattedValue(value) .. " USD from " .. getPlayerName(target):gsub("_", " ") .. ".", 7)
							outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " (" .. value .. ") command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
						else
							outputChatBox("You cannot take " .. value .. " USD as the player only has " .. getPlayerMoney(target) .. " USD.", player, 245, 20, 20, false)
						end
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)

addCommandHandler("setmoney",
	function(player, cmd, name, value)
		if (not exports['roleplay-accounts']:isClientHeadAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local value = tonumber(value)
			if (not name) and ((not value) or (value and value < 0)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [partial player name] [value]", player, 210, 160, 25, false)
				return
			else
				local target = exports['roleplay-accounts']:getPlayerFromPartialName(name, player)
				if (not target) then
					outputChatBox("Couldn't find a player with that name or ID.", player, 245, 20, 20, false)
				else
					if (not isElement(target)) then
						outputChatBox("The player has to be spawned in order to execute the command.", player, 245, 20, 20, false)
						return
					end
					
					if (getElementHealth(target) > 0) then
						setPlayerMoney(target, value)
						outputChatBox("You set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " cash to " .. getFormattedValue(value) .. " USD.", player, 210, 160, 25, false)
						outputChatBox("Administrator set your cash to " .. getFormattedValue(value) .. " USD.", target, 210, 160, 25, false)
						exports['roleplay-accounts']:outputAdminLog(getPlayerName(player):gsub("_", " ") .. " set " .. exports['roleplay-accounts']:getRealPlayerName2(target) .. " to " .. getFormattedValue(value) .. " USD.", 7)
						outputServerLog("Admin: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] executed the /" .. cmd .. " (" .. value .. ") command on " .. getPlayerName(target) .. " [" .. exports['roleplay-accounts']:getAccountName(target) .. "].")
					else
						outputChatBox("The player has to be alive in order to execute the command.", player, 245, 20, 20, false)
					end
				end
			end
		end
	end
)