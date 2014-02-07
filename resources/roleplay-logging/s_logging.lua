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

local logActions = {
	[1]		= "CLIENT-CONNECTION",
	[2]	 	= "CASH-TRANSFER",
	[3] 	= "BANK-TRANSFER",
	[4] 	= "PHONE-SMS",
	[5]		= "PHONE-CALL",
	[6]		= "FACTION-ACTION",
	[7] 	= "ITEM-MOVE",
	[8] 	= "ITEM-DROP",
	[9] 	= "ITEM-PICK",
	[10] 	= "ITEM-TRANSFER",
	[11]	= "CHAT-HEADADMIN",
	[12]	= "CHAT-LEADADMIN",
	[13]	= "CHAT-REGUADMIN",
	[14]	= "CHAT-LOCALIC",
	[15]	= "CHAT-LOCALOOC",
	[16]	= "CHAT-GLOBALOOC",
	[17]	= "CHAT-LOCALME",
	[18]	= "CHAT-LOCALDO",
	[19]	= "CHAT-DISTRICT",
	[20]	= "CHAT-MEGAPHONE",
	[21]	= "CHAT-RADIO",
	[22]	= "CHAT-DEPARTMENT",
	[23]	= "CHAT-FACTION",
	[24]	= "CHAT-PRIVATEMSG",
	[25]	= "CHAT-GOVERNMENT",
	[26]	= "CHAT-LOCALWHISPER",
	[27]	= "CHAT-PLAYERWHISPER",
	[28]	= "CHAT-SHOUT",
	[29]	= "CHAT-DONATOR",
	[30]	= "INT-LOCK",
	[31]	= "INT-INTERACT",
	[32]	= "INT-TRANSFER",
	[33]	= "VEH-LOCK",
	[34]	= "VEH-INTERACT",
	[35]	= "VEH-TRANSFER",
	[36]	= "PERK-TRANSFER",
	[37]	= "PERK-USE",
	[38]	= "SHOP-TRANSFER",
	[39]	= "FACTION-ROADBLOCK",
	[40]	= "ADMIN-COMMAND"
}

local function explode(self, separator)
	exports['roleplay-accounts']:Check("string.explode", "string", self, "ensemble", "string", separator, "separator")
	
	if (#self == 0) then return {} end
	if (#separator == 0) then return { self } end
	
	return loadstring("return {\""..self:gsub(separator, "\",\"").."\"}")()
end

function insertLog(logSource, logActionID, logAffected, logData)
	if (not logSource) or (not tonumber(logActionID)) or (not logAffected) or (not logData) then
		outputDebugString("An argument is missing from the previous attempt to log data.")
	else
		local logActionID = tonumber(logActionID)
		if (not getElementType(logSource)) then
			outputDebugString("Invalid source element from the previous attempt to log data.")
		else
			if (not logActions[logActionID]) then
				outputDebugString("Invalid action ID from the previous attempt to log data.")
			else
				local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??')", "logs", "logSource", "logActionID", "logAffected", "logData", getElementLogID(logSource), logActionID, logAffected, logData)
				if (not query) then
					outputDebugString("Failed to insert log line into log database.")
				else
					local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
					return last_insert_id
				end
			end
		end
	end
	return false
end
addEvent(":insertLog", true)
addEventHandler(":insertLog", root, insertLog)

function getElementLogID(logSource)
	if (isElement(logSource)) then
		local type = getElementType(logSource)
		if (type == "player") then
			local accountID = exports['roleplay-accounts']:getAccountID(logSource)
			if (accountID) then
				return accountID .. ":inPLAYER"
			else
				return getPlayerSerial(logSource) .. ":noPLAYER"
			end
		elseif (type == "vehicle") then
			local vehicleID = exports['roleplay-vehicles']:getVehicleRealID(logSource)
			if (vehicleID) then
				return vehicleID .. ":inVEHICLE"
			else
				return getElementModel(logSource) .. ":noVEHICLE"
			end
		elseif (type == "marker") then
			local interiorID = exports['roleplay-vehicles']:getInteriorID(logSource)
			if (interiorID) then
				return interiorID .. ":inINTERIOR"
			else
				local elevatorID = exports['roleplay-vehicles']:getElevatorID(logSource)
				if (elevatorID) then
					return elevatorID .. ":inELEVATOR"
				else
					return "noELEVATOR"
				end
			end
		end
	end
	return false
end

addCommandHandler("testlog",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientOwner(player)) then return end
		local affected = ""
		local data = ""
		
		for i,v in ipairs(getElementsByType("player")) do
			if (exports['roleplay-accounts']:isClientPlaying(v)) then
				if (string.len(affected) == 0) then
					affected = getPlayerName(v)
				else
					affected = affected .. ";" .. getPlayerName(v)
				end
			end
		end
		
		if (getElementDimension(player) > 0) then
			affected = affected .. ";Interior " .. getElementDimension(player)
		end
		
		local id = insertLog(player, 11, affected, "Fucked in the ass ok")
		outputChatBox("log added id " .. id)
	end
)