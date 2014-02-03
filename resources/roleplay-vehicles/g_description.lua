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
	
	ok sry vg
]]

local doorCount = {[583]=1, [574]=1} -- 1 means two doors, 2=3 doors, etc. Tugs have two doors, hence.
local controllableDoors = {
	{"Hood", 				0, 	1, 	0, {Bike=true, BMX=true, Boat=true, Quad=true, Trailer=true, Plane=true, Helicopter=true, ["Monster Truck"]=true, [441]=true, [564]=true, [568]=true, [424]=true, [457]=true, [483]=true, [571]=true, [530]=true, [583]=true, [532]=true, [486]=true, [573]=true, [588]=true, [403]=true, [514]=true, [407]=true, [544]=true, [432]=true, [601]=true, [574]=true, [431]=true, [437]=true}},
	{"Trunk", 				1,	1, 	0, {Bike=true, BMX=true, Boat=true, Quad=true, Trailer=true, Plane=true, Helicopter=true, ["Monster Truck"]=true, [485]=true, [564]=true, [568]=true, [424]=true, [457]=true, [483]=true, [508]=true, [571]=true, [459]=true, [422]=true, [482]=true, [605]=true, [530]=true, [418]=true, [572]=true, [582]=true, [413]=true, [440]=true, [543]=true, [478]=true, [554]=true, [583]=true, [524]=true, [532]=true, [578]=true, [486]=true, [455]=true, [573]=true, [403]=true, [514]=true, [423]=true, [414]=true, [443]=true, [515]=true, [531]=true, [456]=true, [416]=true, [433]=true, [427]=true, [528]=true, [407]=true, [544]=true, [432]=true, [601]=true, [408]=true, [525]=true, [574]=true, [431]=true, [437]=true, [552]=true}},
	{"Front left door", 	2, 	1, 	0, {Bike=true, BMX=true, Boat=true, Quad=true, Trailer=true, [485]=true, [464]=true, [501]=true, [465]=true, [564]=true, [568]=true, [424]=true, [457]=true, [571]=true, [530]=true, [572]=true, [486]=true, [531]=true}},
	{"Front right door", 	3, 	1, 	1, {Bike=true, Plane=true, [464]=true, [501]=true, [465]=true, [424]=true, [457]=true}},
	{"Back left door", 		4, 	3, 	2, {[431]=true, [437]=true}},
	{"Back right door", 	5, 	4, 	3, {[431]=true, [437]=true}}
}

function getVehicleDoors(model, seat)
	local t = {}
	for _,v in ipairs(controllableDoors) do
		if (seat == -1 or seat == 0 or seat == v[4]) and v[4] <= (doorCount[model] or getVehicleMaxPassengers(model) or 0) then
			if (not v[5][model]) and (not v[5][getVehicleType(model)]) then
				table.insert(t, v)
			end
		end
	end
	return t
end