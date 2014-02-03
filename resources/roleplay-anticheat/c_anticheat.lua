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
	
	Special thanks to mabako for sharing world check function via Paradise.
]]

local dYHZ_loc = localPlayer
local DP_triggerServerEvent_ = triggerServerEvent
local DK_setTimer_ = setTimer
local cS_isWorldSpecialPropertyEnabled_ = isWorldSpecialPropertyEnabled
local cG_getGameSpeed_ = getGameSpeed
local bI_getGravity_ = getGravity
local xI_ipairs_ = ipairs
local Xz_math_ = math
local XyP_setElementData = setElementData
local worldProperties = {"hovercars", "aircars", "extrabunny", "extrajump"}
local Bh_cancelEvent = cancelEvent
local SG_getElementType = getElementType
local SI_addEventHandler = addEventHandler

local function performWorldCheck()
	for _,prop in xI_ipairs_(worldProperties) do
		if (cS_isWorldSpecialPropertyEnabled_(prop)) then
			DP_triggerServerEvent_(":_returnCheat_:", dYHZ_loc, 0, prop)
		end
	end
	
	DP_triggerServerEvent_(":_returnCheat_:", dYHZ_loc, 1, "", cG_getGameSpeed_(), cG_getGameSpeed_() == 1, bI_getGravity_())
end
DK_setTimer_(performWorldCheck, Xz_math_.random(15, 30)*1000, 0)

SI_addEventHandler("onClientPedDamage", root,
	function()
		if (SG_getElementType(source) ~= "ped") then return end
		Bh_cancelEvent()
	end
)