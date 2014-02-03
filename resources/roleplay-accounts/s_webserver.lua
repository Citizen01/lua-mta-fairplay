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

local web_connection = nil
local web_databaseConfig = {
	["type"] = "mysql",
	["table"] = "",
	["hostname"] = "",
	["username"] = "",
	["password"] = ""
}

function getSQLConnection()
	if (not reconnecting) then
		return web_connection
	else
		setTimer(getSQLConnection, 150, 1)
	end
end

function reconnectWebSQL()
	outputServerLog("Notice: MySQL reconnect incoming.")
	reconnecting = true
	destroyElement(web_connection)
	web_connection = dbConnect(databaseConfig["type"], "dbname=" .. databaseConfig["table"] .. ";host=" .. databaseConfig["hostname"], databaseConfig["username"], databaseConfig["password"])
	if (not web_connection) then
		outputServerLog("Error: MySQL web_connection is not established!")
		setTimer(reconnectWebSQL, 1500, 1)
	else
		reconnecting = false
		outputServerLog("Notice: MySQL web_connection is established!")
		testWebSQLConnection()
	end
	return true
end

function testWebSQLConnection()
	if (web_connection) then
		local query = dbQuery(web_connection, "SELECT `??` FROM `??` WHERE `??` = '??' LIMIT 1", "value", "config", "key", "motd")
		if (query) then
			local result, num_affected_rows, errmsg = dbPoll(query, -1)
			if (num_affected_rows > 0) then
				for result,row in pairs(result) do
					if (row["value"]) then
						outputServerLog("Notice: Connection is working!")
						g_motd = row["value"]
					end
				end
			else
				outputServerLog("Error: MySQL query failed.")
			end	
		else
			outputServerLog("Error: MySQL query failed.")
		end
	else
		outputServerLog("Error: Could not test the query web_connection due to no stable MySQL web_connection.")
		outputServerLog("... attempting a repair ...")
		web_connection = dbConnect(databaseConfig["type"], "dbname=" .. databaseConfig["table"] .. ";host=" .. databaseConfig["hostname"], databaseConfig["username"], databaseConfig["password"])
		if (not web_connection) then
			outputServerLog("... repair failed!")
		else
			outputServerLog("... repair successful!")
		end
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		web_connection = dbConnect(databaseConfig["type"], "dbname=" .. databaseConfig["table"] .. ";host=" .. databaseConfig["hostname"], databaseConfig["username"], databaseConfig["password"])
		
		if (not web_connection) then
			outputServerLog("Error: MySQL web_connection is not established!")
		else
			outputServerLog("Notice: MySQL web_connection is established!")
			testWebSQLConnection()
		end
		
		setTimer(function()
			reconnectWebSQL()
		end, 60000*5, 0)
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		if (isElement(web_connection)) then
			destroyElement(web_connection)
		end
	end
)