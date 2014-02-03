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

addEventHandler("onResourceStart", resourceRoot,
	function()
		setRuleValue("Author", "Socialz")
		setRuleValue("Developers", "Socialz")
		setRuleValue("Created", "23rd of December 2010")
		setRuleValue("Website", "mtafairplay.net")
		setRuleValue("Version", getScriptVersion())
		setMapName("San Andreas Roleplay")
		setGameType("Public Beta")
		
		local water = createWater(-2998, -2998, -500, 2998, -2998, -500, -2998, 2998, -500, 2998, 2998, -500)
		local realtime = getRealTime()
		
		if (realtime.hour >= 3) then
			setTime(realtime.hour-3, realtime.minute)
		elseif (realtime.hour == 2) then
			setTime(23, realtime.minute)
		elseif (realtime.hour == 1) then
			setTime(22, realtime.minute)
		elseif (realtime.hour == 0) then
			setTime(21, realtime.minute)
		end
		
		setMinuteDuration(60000)
		setFarClipDistance(2000)
		
		createBlip(1419.08, -1553.65, 13.56, 52) 	-- LS Bank
		createBlip(1480.95, -1772.07, 18.79, 41) 	-- LS City Hall
		createBlip(1451.63, -2287.03, 13.54, 5) 	-- LS Airport
		createBlip(933.13, -1720.93, 13.54, 36) 	-- LS DMV
		
		-- Silenced
		setWeaponProperty(23, "poor", "flags", 0x000020)
		setWeaponProperty(23, "std", "flags", 0x000020)
		setWeaponProperty(23, "pro", "flags", 0x000020)
		
		-- Deagle
		setWeaponProperty(24, "poor", "flags", 0x000020)
		setWeaponProperty(24, "std", "flags", 0x000020)
		setWeaponProperty(24, "pro", "flags", 0x000020)
		
		-- Shotgun
		setWeaponProperty(25, "poor", "flags", 0x000020)
		setWeaponProperty(25, "std", "flags", 0x000020)
		setWeaponProperty(25, "pro", "flags", 0x000020)

		-- Combat Shotty
		setWeaponProperty(27, "poor", "flags", 0x000020)
		setWeaponProperty(27, "std", "flags", 0x000020)
		setWeaponProperty(27, "pro", "flags", 0x000020)
		
		-- MP5
		setWeaponProperty(29, "poor", "flags", 0x000020)
		setWeaponProperty(29, "std", "flags", 0x000020)
		setWeaponProperty(29, "pro", "flags", 0x000020)

		-- AK47
		setWeaponProperty(30, "poor", "flags", 0x000020)
		setWeaponProperty(30, "std", "flags", 0x000020)
		setWeaponProperty(30, "pro", "flags", 0x000020)
		
		-- M4
		setWeaponProperty(31, "poor", "flags", 0x000020)
		setWeaponProperty(31, "std", "flags", 0x000020)
		setWeaponProperty(31, "pro", "flags", 0x000020)
		
		-- Country Rifle
		setWeaponProperty(33, "poor", "flags", 0x000020)
		setWeaponProperty(33, "std", "flags", 0x000020)
		setWeaponProperty(33, "pro", "flags", 0x000020)
		
		-- Sniper Rifle
		setWeaponProperty(34, "poor", "flags", 0x000020)
		setWeaponProperty(34, "std", "flags", 0x000020)
		setWeaponProperty(34, "pro", "flags", 0x000020)
	end
)