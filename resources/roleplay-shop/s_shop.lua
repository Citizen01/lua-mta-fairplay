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

local shopids = {[1]=1}
local workskins = {{211, 217}}

local function createShop(dbEntryID, shopID, modelID, x, y, z, rotation, interior, dimension, frozen, synchronized)
	local dbEntryID_
	if (not dbEntryID) then
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??')", "shops", "posX", "posY", "posZ", "rotation", "interior", "dimension", "shopID", "skinID", "created", x, y, z, tonumber(rotation), tonumber(interior), tonumber(dimension), tonumber(shopID), (modelID and modelID or workskins[tonumber(shopID)][math.random(#workskins[tonumber(shopID)])]), getRealTime().timestamp)
		if (query) then
			local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
			dbEntryID_ = last_insert_id
		else
			outputDebugString("Failed when inserting a new shop to database.", 2)
		end
	else
		dbEntryID_ = dbEntryID
	end
	
	local shop = createPed((tonumber(modelID) and tonumber(modelID) or workskins[tonumber(shopID)][math.random(#workskins[tonumber(shopID)])]), x, y, z, (tonumber(rotation) and tonumber(rotation) or 0), (synchronized and synchronized or false))
	setElementInterior(shop, (interior and interior or 0))
	setElementDimension(shop, (dimension and dimension or 0))
	--setElementFrozen(shop, (frozen and frozen or true)) --bugged rot
	setTimer(setPedAnimation, 500, 1, shop, "COP_AMBIENT", "Coplook_loop", -1, false, true, false, true)
	
	setTimer(function(shop)
		if (not isElement(shop)) then return end
		setPedAnimation(shop, "COP_AMBIENT", "Coplook_loop", -1, false, true, false, true)
	end, 5000, 0, shop)
	
	setElementData(shop, "roleplay:shops.id", tonumber(dbEntryID_), true)
	setElementData(shop, "roleplay:shops.shopid", tonumber(shopID), true)
	
	return dbEntryID_, shop
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT * FROM `??`", "shops")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				if (num_affected_rows == 1) then
					outputDebugString("1 shop is about to be loaded.")
				else
					outputDebugString(num_affected_rows .. " shops are about to be loaded.")
				end
				
				for result,row in pairs(result) do
					createShop(row["id"], row["shopID"], row["skinID"], row["posX"], row["posY"], row["posZ"], row["rotation"], row["interior"], row["dimension"])
				end
			else
				outputDebugString("0 shops loaded. Does the shops table contain data and are the settings correct?")
			end
		else
			outputServerLog("Error: MySQL query failed when tried to fetch all shops.")
		end
	end
)

addEvent(":_doShopPurchase_:", true)
addEventHandler(":_doShopPurchase_:", root,
	function(itemName, itemPrice)
		if (source ~= client) then return end
		if (exports['roleplay-items']:getItemByName(itemName)) then
			if (getPlayerMoney(client) >= tonumber(itemPrice)) then
				local itemID = exports['roleplay-items']:getItemByName(itemName)
				takePlayerMoney(client, tonumber(itemPrice))
				outputChatBox("You purchased a " .. itemName .. " for " .. itemPrice .. " USD.", client, 20, 245, 20, false)
				
				if (itemID == 10) then
					exports['roleplay-items']:giveItem(client, itemID, tostring(math.random(0,1) .. math.random(3,5) .. math.random(0,6) .. math.random(0,7) .. math.random(0,8) .. math.random(0,9)))
				else
					exports['roleplay-items']:giveItem(client, itemID)
				end
				
				triggerClientEvent(client, ":_closeShopMenu_:", client)
			else
				outputChatBox("You lack the money to purchase the item.", client, 245, 20, 20, false)
			end
		else
			outputChatBox("This shop appears to be corrupted. Close the window and try again.", client, 245, 20, 20, false)
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

addCommandHandler({"addshop", "createshop", "makeshop"},
	function(player, cmd, shopid, modelid)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local shopid = tonumber(shopid)
			
			if (not shopid) or (shopid and shopid == 0) or (tonumber(modelid) and (tonumber(modelid) < 0)) then
				outputChatBox("SYNTAX: /" .. cmd .. " [shop id] <[model id]>", player, 210, 160, 25, false)
				return
			end
			
			if (not shopids[shopid]) then
				outputChatBox("Invalid shop ID entered.", player, 245, 20, 20, false)
				outputChatBox("Shop IDs:", player, 210, 160, 25, false)
				outputChatBox("  1 = General Store", player, 210, 160, 25, false)
				return
			end
			
			if (tonumber(modelid)) then
				local ped = createPed(tonumber(modelid), 0, 0, 0)
				if (not ped) then
					outputChatBox("Invalid model ID entered.", player, 245, 20, 20, false)
					return
				else
					destroyElement(ped)
				end
			else
				modelid = workskins[shopid][math.random(#workskins[shopid])]
			end
			
			local modelid = tonumber(modelid)
			local x, y, z = getElementPosition(player)
			local rotation = getPedRotation(player)
			local dbEntryID = createShop(false, shopid, modelid, x, y, z, rotation, getElementInterior(player), getElementDimension(player), true, true)				
			local x = x+((math.cos(math.rad(rotation)))*2)
			local y = y+((math.sin(math.rad(rotation)))*2)
			setElementPosition(player, x, y, z)
			outputChatBox("Created a new shop (" .. shopid .. ") with ID " .. dbEntryID .. ".", player, 20, 245, 20, false)
			outputServerLog("Shops: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] created a new shop (" .. shopid .. ") with ID " .. dbEntryID .. ".")
		end
	end
)

addCommandHandler({"delshop", "deleteshop"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if ((not id) or (id and (id < 0))) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local shop = getShop(id)
				if (shop) then
					local x, y, z = getElementPosition(player)
					local vx, vy, vz = getElementPosition(shop)
					if (getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 10) then
						local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "DELETE FROM `??` WHERE `??` = '??'", "shops", "id", id)
						if (query) then
							destroyElement(shop)
							outputChatBox("Shop ID " .. id .. " has been deleted.", player, 20, 245, 20, false)
							outputServerLog("ATMs: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] deleted shop ID " .. id .. ".")
							triggerClientEvent(root, ":_closeShopMenu_:", root, id)
						else
							outputChatBox("MySQL query failed when tried to delete the shop.", player, 245, 20, 20, false)
							outputServerLog("Error: MySQL query failed when tried to delete shop with ID " .. id .. " (" .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "]).")
						end
					else
						outputChatBox("You need to be near the shop you want to delete.", player, 245, 20, 20, false)
					end
				else
					outputChatBox("Couldn't find a shop with ID " .. id .. ".", player, 245, 20, 20, false)
				end
			end
		end
	end
)

addCommandHandler({"gotoshop", "tptoshop"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id and id < 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id]", player, 210, 160, 25, false)
				return
			else
				local shop = getShop(id)
				if (shop) then
					local rx, ry, rz = getElementRotation(shop)
					local x, y, z = getElementPosition(shop)
					local x = x+((math.cos(math.rad(rz)))*2)
					local y = y+((math.sin(math.rad(rz)))*2)
					setElementPosition(player, x, y, z)
					setPedRotation(player, rz)
					setElementInterior(player, getElementInterior(shop))
					setElementDimension(player, getElementDimension(shop))
					outputChatBox("Teleported to shop ID " .. id .. ".", player, 20, 245, 20, false)
					outputServerLog("ATMs: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] teleported to shop ID " .. id .. ".")
				else
					outputChatBox("Couldn't find an shop with ID " .. id .. ".", player, 245, 20, 20, false)
				end
			end
		end
	end
)