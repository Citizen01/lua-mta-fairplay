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

local playerAmount = 0

function returnedValue(val)
	outputDebugString("API returned '" .. tostring(val) .. "' when sending " .. playerAmount .. " player(s) to web server.")
end

local function sendPlayerAmount()
	callRemote("http://fairplaymta.net/routers/fairplay/web/api_setcount.php", returnedValue, playerAmount .. "/" .. getMaxPlayers())
end

local function updatePlayerAmount()
	playerAmount = 0
	for i,v in ipairs(getElementsByType("player")) do
		playerAmount = playerAmount+1
	end
	sendPlayerAmount()
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		updatePlayerAmount()
		setTimer(updatePlayerAmount, 60000, 0)
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		playerAmount = "Offline"
		sendPlayerAmount()
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		playerAmount = playerAmount+1
		sendPlayerAmount()
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		playerAmount = playerAmount-1
		sendPlayerAmount()
	end
)