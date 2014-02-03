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

local perkShop = {
	{"Custom phone with custom phone number", 0, 4}
}

addEvent(":_activateDonationPerk_:", true)
addEventHandler(":_activateDonationPerk_:", root,
	function(perkID)
		if (source ~= client) then return end
		if (not tonumber(perkID)) then return end
		local perkID = tonumber(perkID)+1
		if (not perkShop[perkID]) then return end
		if (getAccountPoints(client) >= perkShop[perkID][3]) then
			if (not hasAccountPerk(client, perkID)) then
				if (perkID == 1) then
					return
				end
				
				giveAccountPerk(client, perkID, perkShop[perkID][2])
			else
				outputChatBox("You already have that perk activated on your account.", client, 245, 20, 20, false)
			end
		else
			outputChatBox("You lack the amount of points in order to activate this product.", client, 245, 20, 20, false)
		end
	end
)

addEvent(":_fetchCurrentDonationStatus_:", true)
addEventHandler(":_fetchCurrentDonationStatus_:", root,
	function()
		if (source ~= client) then return end
		triggerClientEvent(client, ":_updateCurrentDonationStatus_:", client, getAccountPoints(client), perkShop)
	end
)

function getAccountPoints(element)
	if (element) or (getElementType(element) ~= "player") then return false end
	if (not exports['roleplay-accounts']:getAccountID(element)) then return false end
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "points", "accounts", "id", exports['roleplay-accounts']:getAccountID(element))
	if (query) then
		local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
		for result,row in pairs(result) do
			return tonumber(row["points"])
		end
	else
		return false
	end
end

function hasAccountPerk(element, perkID)
	if (element) or (getElementType(element) ~= "player") or (not tonumber(perkID)) or (tonumber(perkID) <= 0) then return false end
	local perkID = tonumber(perkID)
	if (not exports['roleplay-accounts']:getAccountID(element)) then return false end
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "perks", "accounts", "id", exports['roleplay-accounts']:getAccountID(element))
	if (query) then
		local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
		for result,row in pairs(result) do
			local perks = fromJSON(row["perks"])
			if (perks[perkID]) then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

function getAccountPerks(element)
	if (element) or (getElementType(element) ~= "player") then return false end
	if (not exports['roleplay-accounts']:getAccountID(element)) then return false end
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "perks", "accounts", "id", exports['roleplay-accounts']:getAccountID(element))
	if (query) then
		local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
		for result,row in pairs(result) do
			return row["perks"]
		end
	else
		return false
	end
end

function giveAccountPerk(element, perkID, duration)
	if (element) or (getElementType(element) ~= "player") or (not tonumber(perkID)) or (tonumber(perkID) <= 0) or (tonumber(duration) and tonumber(duration) < 0) then return false end
	local perkID = tonumber(perkID)
	local duration = (tonumber(duration) and tonumber(duration) or perkShop[perkID][2])
	if (not exports['roleplay-accounts']:getAccountID(element)) then return false end
	local perks = getAccountPerks(element)
	if (perks) then
		local newPerks = fromJSON(perks)
		newPerks[perkID] = duration
		local query = dbExec(exports['roleplay-accounts']:getSQLConnection(), "UPDATE `??` SET `??` = '??' WHERE `??` = '??'", "accounts", "perks", newPerks, "id", exports['roleplay-accounts']:getAccountID(element))
		if (query) then
			return true
		else
			return false
		end
	else
		return false
	end
end