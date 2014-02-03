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

local clientIDs = {}

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			clientIDs[i] = v
			setElementData(v, "roleplay:clients.id", i, false)
			setElementData(v, "roleplay:clients.id_ghost", i, true)
		end
	end
)

addEventHandler("onPlayerJoin", root,
	function()
		local id = nil
	
		for i=1,360 do
			if (clientIDs[i] == nil) then
				id = i
				break
			end
		end
		
		clientIDs[id] = source
		setElementData(source, "roleplay:clients.id", id, false)
		setElementData(source, "roleplay:clients.id_ghost", id, true)
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		local id = tonumber(getElementData(source, "roleplay:clients.id"))
		if (id) then
			clientIDs[id] = nil
		end
	end
)