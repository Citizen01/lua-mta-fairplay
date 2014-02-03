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

addEvent(":_syncTaxiLights_:", true)
addEventHandler( ":_syncTaxiLights_:", root, 
	function(vehicle)
		setVehicleTaxiLightOn(vehicle, not isVehicleTaxiLightOn(vehicle))
	end
)

addEventHandler("onVehicleRespawn", root,
	function()
		if (isVehicleTaxiLightOn(source)) then
			setVehicleTaxiLightOn(source, false)
		end
	end
)

addEventHandler("onVehicleStartExit", root,
	function(player, seat, jacked)
		if (isVehicleTaxiLightOn(source)) then
			setVehicleTaxiLightOn(source, false)
		end
	end
)