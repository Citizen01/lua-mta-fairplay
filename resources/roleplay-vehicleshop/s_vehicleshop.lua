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

local bike = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true, [536]=true, [575]=true, [567]=true, [480]=true, [555]=true}
local vehicles = {
	-- Richman
	{
		["name"] = "Grotti's Car Dealership",
		["open"] = true,
		["blip"] = {55, 544.3, -1283.08, 17.24, false},
		["positions"] = {
			-- X, Y, Z, RX, RY, RZ, Interior, Dimension, Vehicle, Marker
			{562.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{557.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{552.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{547.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{542.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{537.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{532.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{527.89, -1286.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{562.89, -1277.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{557.89, -1277.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{552.89, -1277.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{547.89, -1277.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{542.89, -1277.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil},
			{537.89, -1277.09, 17.24, 0, 0, 358.37, 0, 0, nil, nil}
		},
		["models"] = {
			-- Model, Price
			{"Mesa", 		63000},
			{"Elegy", 		88000},
			{"Feltzer", 	95000},
			{"Jester", 		96500},
			{"Flash", 		100000},
			{"Uranus", 		100000},
			{"Windsor", 	101000},
			{"Broadway", 	105000},
			{"Comet", 		125000},
			{"Patriot", 	129000},
			{"Hotknife",  	135000},
			{"Phoenix", 	144000},
			{"ZR-350", 		175000},
			{"Stretch", 	225000},
			{"Banshee",		400000},
			{"Super GT", 	460000},
			{"Turismo", 	550000},
			{"Cheetah", 	650000},
			{"Bullet",		700000},
			{"Stafford", 	750000},
			{"Infernus",  	900000}
		}
	},
	
	-- Jefferson
	{
		["name"] = "Coutt And Schutz's Car Dealership",
		["open"] = true,
		["blip"] = {55, 2128.41, -1136.75, 25.52, false},
		["positions"] = {
			-- X, Y, Z, RX, RY, RZ, Interior, Dimension, Vehicle, Marker
			{2135.78, -1145.51, 24.74, 5.5, 0, 356.8, 0, 0, nil, nil},
			{2130.78, -1145.51, 24.74, 5.5, 0, 356.8, 0, 0, nil, nil},
			{2125.78, -1145.51, 24.6,  5.5, 0, 356.8, 0, 0, nil, nil},
			{2120.78, -1145.51, 24.5,  5.5, 0, 356.8, 0, 0, nil, nil},
			
			{2135.78, -1137.51, 25.45, 5.5, 0, 356.8, 0, 0, nil, nil},
			{2130.78, -1137.51, 25.4,  5.5, 0, 356.8, 0, 0, nil, nil},
			{2125.78, -1137.51, 25.3,  5.5, 0, 356.8, 0, 0, nil, nil},
			{2120.78, -1137.51, 25.1,  5.5, 0, 356.8, 0, 0, nil, nil},
			
			{2135.78, -1129.51, 25.6, 0, 0, 356.8, 0, 0, nil, nil},
			{2130.78, -1129.51, 25.6,  0, 0, 356.8, 0, 0, nil, nil},
			{2125.78, -1129.51, 25.6,  0, 0, 356.8, 0, 0, nil, nil},
			{2120.78, -1129.51, 25.5,  0, 0, 356.8, 0, 0, nil, nil},
		},
		["models"] = {
			-- Model, Price
			{"Manana", 			11000},
			{"Clover", 			12000},
			{"Tampa", 			12000},
			{"Perennial", 		15000},
			{"Walton", 			15000},
			{"Primo", 			16000},
			{"Club", 			17000},
			{"Blista Compact", 	17500},
			{"Voodoo", 			18000},
			{"Stallion", 		19000},
			{"Glendale", 		20000},
			{"Greenwood", 		20000},
			{"Bravura", 		21000},
			{"Moonbeam", 		21500},
			{"Intruder", 		22000},
			{"Previon", 		22000},
			{"Solair", 			23000},
			{"Oceanic", 		23000},
			{"Willard", 		23000},
			{"Picador", 		23000},
			{"Savanna", 		23500},
			{"Sabre", 			24500},
			{"Pony", 			26000},
			{"Rumpo", 			27000},
			{"Majestic", 		27000},
			{"Bobcat", 			28000},
			{"Hustler", 		30000},
			{"Regina", 			30000},
			{"Burrito", 		30000},
			{"Sadler", 			30000},
			{"Admiral", 		31000},
			{"Merit", 			31300},
			{"Stratum", 		32000},
			{"Nebula", 			32000},
			{"Sunrise", 		32000},
			{"Esperanto", 		33000},
			{"Tahoma", 			38000},
			{"Cadrona", 		39000},
			{"Camper", 			40000},
			{"Premier", 		40000},
			{"Hermes", 			41000},
			{"Buffalo", 		42800},
			{"Emperor", 		42750},
			{"Fortune", 		43100},
			{"Blade", 			44000},
			{"Sentinel", 		44500},
			{"Virgo", 			48000},
			{"Tornado", 		49000},
			{"Vincent", 		52000},
			{"Elegant", 		55000},
			{"Alpha", 			59000},
			{"Washington", 		61000},
			{"Slamvan", 		68000},
			{"Huntley", 		74000},
			{"Sultan", 			80000},
			{"Buccaneer", 		82000},
			{"Yosemite", 		85000},
			{"Landstalker", 	86000}
		},
	},
	
	-- Docks
	{
		["name"] = "Docks Car Dealership",
		["open"] = true,
		["blip"] = {55, 2133.14, -2144.81, 13.54, false},
		["positions"] = {
			-- X, Y, Z, RX, RY, RZ, Interior, Dimension, Vehicle, Marker
			{2115, -2161.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2120, -2161.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2125, -2161.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2130, -2161.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2135, -2161.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2115, -2153.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2120, -2153.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2125, -2153.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2130, -2153.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2135, -2153.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2140, -2153.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2145, -2153.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2115, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2120, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2125, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2130, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2135, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2140, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2145, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2150, -2145.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2115, -2137.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2120, -2137.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2125, -2137.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2130, -2137.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2135, -2137.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2140, -2137.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2145, -2137.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2115, -2129.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2120, -2129.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2125, -2129.26, 13.54, 0, 0, 0, 0, 0, nil, nil},
			{2130, -2129.26, 13.54, 0, 0, 0, 0, 0, nil, nil}
		},
		["models"] = {
			-- Model, Price
			{"Manana", 			11000},
			{"Clover", 			12000},
			{"Tampa", 			12000},
			{"Perennial", 		15000},
			{"Walton", 			15000},
			{"Primo", 			16000},
			{"Club", 			17000},
			{"Blista Compact", 	17500},
			{"Voodoo", 			18000},
			{"Stallion", 		19000},
			{"Glendale", 		20000},
			{"Greenwood", 		20000},
			{"Bravura", 		21000},
			{"Moonbeam", 		21500},
			{"Intruder", 		22000},
			{"Previon", 		22000},
			{"Solair", 			23000},
			{"Oceanic", 		23000},
			{"Willard", 		23000},
			{"Picador", 		23000},
			{"Savanna", 		23500},
			{"Sabre", 			24500},
			{"Pony", 			26000},
			{"Rumpo", 			27000},
			{"Majestic", 		27000},
			{"Bobcat", 			28000},
			{"Hustler", 		30000},
			{"Regina", 			30000},
			{"Burrito", 		30000},
			{"Sadler", 			30000},
			{"Admiral", 		31000},
			{"Merit", 			31300},
			{"Stratum", 		32000},
			{"Nebula", 			32000},
			{"Sunrise", 		32000},
			{"Esperanto", 		33000},
			{"Tahoma", 			38000},
			{"Cadrona", 		39000},
			{"Camper", 			40000},
			{"Premier", 		40000},
			{"Hermes", 			41000},
			{"Buffalo", 		42800},
			{"Emperor", 		42750},
			{"Fortune", 		43100},
			{"Blade", 			44000},
			{"Sentinel", 		44500},
			{"Virgo", 			48000},
			{"Tornado", 		49000},
			{"Vincent", 		52000},
			{"Elegant", 		55000},
			{"Alpha", 			59000},
			{"Washington", 		61000},
			{"Slamvan", 		68000},
			{"Huntley", 		74000},
			{"Sultan", 			80000},
			{"Buccaneer", 		82000},
			{"Yosemite", 		85000},
			{"Landstalker", 	86000}
		}
	},
	
	-- IGS Bike Shop
	{
		["name"] = "Idlewood Bike Store",
		["open"] = true,
		["blip"] = {55, 1909.73, -1873.43, 13.54, false},
		["positions"] = {
			-- X, Y, Z, RX, RY, RZ, Interior, Dimension, Vehicle, Marker
			{1909.73, -1873.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1909.73, -1870.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1909.73, -1867.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1909.73, -1864.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1909.73, -1861.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1909.73, -1858.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1909.73, -1855.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			
			{1914.73, -1873.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1914.73, -1870.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1914.73, -1867.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1914.73, -1864.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1914.73, -1861.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1914.73, -1858.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1914.73, -1855.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			
			{1919.73, -1873.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1919.73, -1870.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1919.73, -1867.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1919.73, -1864.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1919.73, -1861.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1919.73, -1858.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1919.73, -1855.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			
			{1924.73, -1873.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1924.73, -1870.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1924.73, -1867.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1924.73, -1864.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1924.73, -1861.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1924.73, -1858.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
			{1924.73, -1855.43, 13.54, 0, 0, -90, 0, 0, nil, nil},
		},
		["models"] = {
			-- Model, Price
			{"BMX", 			300},
			{"Bike", 			250},
			{"Mountain Bike", 	550},
			{"NRG-500", 		60000},
			{"BF-400", 			8000},
			{"FCR-900", 		8000},
			{"PCJ-600", 		8000},
			{"Pizza Boy", 		5000},
			{"Sanchez", 		7500},
			{"Wayfarer", 		7750},
			{"Freeway", 		9000},
			{"Faggio", 			5750}
		}
	}
}

local countVehicles
local function getVehicleCount(model)
	local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "SELECT `??` FROM `??` WHERE `??` = '??'", "id", "vehicles", "modelid", model)
	if (query) then
		local result, num_affected_rows, errmsg = dbPoll(query, -1)
		if (num_affected_rows > 0) then
			local count = 1
			for result,row in pairs(result) do
				count = count+1
			end
			return count
		else
			return 1
		end
	else
		outputServerLog("Error: MySQL query failed when trying to calculate the amount of vehicles.")
		return 1
	end
end

local function spawnShopVehicle(modelid, positionid, shop)
	if (vehicles[shop]["open"]) then
		if (isElement(vehicles[shop]["positions"][positionid][9])) then
			destroyElement(vehicles[shop]["positions"][positionid][9])
		end
		
		if (isElement(vehicles[shop]["positions"][positionid][10])) then
			destroyElement(vehicles[shop]["positions"][positionid][10])
		end
		
		for i,v in ipairs(getElementsByType("player")) do
			if (shop ~= 4) then
				if (getDistanceBetweenPoints3D(vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3], getElementPosition(v)) <= 3) then
					outputDebugString("Skipping vehicle shop position ID " .. positionid .. " at " .. vehicles[shop]["name"] .. " (player nearby).")
					return
				end
			elseif (shop == 4) then
				if (getDistanceBetweenPoints3D(vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3], getElementPosition(v)) <= 1) then
					outputDebugString("Skipping vehicle shop position ID " .. positionid .. " at " .. vehicles[shop]["name"] .. " (player nearby).")
					return
				end
			end
		end
		
		for i,v in ipairs(getElementsByType("vehicle")) do
			if (shop ~= 4) then
				if (getDistanceBetweenPoints3D(vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3], getElementPosition(v)) <= 3) then
					outputDebugString("Skipping vehicle shop position ID " .. positionid .. " at " .. vehicles[shop]["name"] .. " (vehicle nearby).")
					return
				end
			elseif (shop == 4) then
				if (getDistanceBetweenPoints3D(vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3], getElementPosition(v)) <= 1) then
					outputDebugString("Skipping vehicle shop position ID " .. positionid .. " at " .. vehicles[shop]["name"] .. " (vehicle nearby).")
					return
				end
			end
		end
		
		local vehicle
		if (modelid == "Mountain Bike") then
			vehicle = createVehicle(510, vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3], vehicles[shop]["positions"][positionid][4], vehicles[shop]["positions"][positionid][5], vehicles[shop]["positions"][positionid][6])
		elseif (modelid == "Pizza Boy") then
			vehicle = createVehicle(448, vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3], vehicles[shop]["positions"][positionid][4], vehicles[shop]["positions"][positionid][5], vehicles[shop]["positions"][positionid][6])
		else
			vehicle = createVehicle(getVehicleModelFromName(modelid), vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3], vehicles[shop]["positions"][positionid][4], vehicles[shop]["positions"][positionid][5], vehicles[shop]["positions"][positionid][6])
		end
		
		setElementInterior(vehicle, vehicles[shop]["positions"][positionid][7])
		setElementDimension(vehicle, vehicles[shop]["positions"][positionid][8])
		setElementFrozen(vehicle, true)
		setElementAlpha(vehicle, 170)
		setVehicleDamageProof(vehicle, true)
		setVehicleDoorsUndamageable(vehicle, true)
		setVehicleEngineState(vehicle, false)
		setVehicleOverrideLights(vehicle, 1)
		setElementCollisionsEnabled(vehicle, false)
		setElementData(vehicle, "roleplay:vehicles.id", -1, true)
		setElementData(vehicle, "roleplay:vehicles.type", 0, true)
		
		local price = 0
		
		for i,v in ipairs(vehicles[shop]["models"]) do
			if (v[1] == modelid) then
				price = math.ceil(tonumber(v[2] or 0+600)/105)*100
				setElementData(vehicle, "roleplay:vehicles.price", price, true)
			end
		end
		
		vehicles[shop]["positions"][positionid][9] = vehicle
		
		local marker = createMarker(vehicles[shop]["positions"][positionid][1], vehicles[shop]["positions"][positionid][2], vehicles[shop]["positions"][positionid][3]-1, "cylinder", 2.5, 0, 0, 0, 0)
		setElementData(marker, "roleplay:markers.type", 0, true)
		setElementData(marker, "roleplay:markers.carshop", shop, true)
		setElementData(marker, "roleplay:markers.carname", modelid, true)
		setElementData(marker, "roleplay:markers.price", price, true)
		vehicles[shop]["positions"][positionid][10] = marker
		
		setElementParent(marker, vehicle)
		
		return vehicle, marker
	end
end

function spawnShopVehicles(shopid)
	for i=1,#vehicles[shopid]["positions"] do
		if (vehicles[shopid]["open"] == true) then
			if (vehicles[shopid]["blip"][5] == false) then
				createBlip(vehicles[shopid]["blip"][2], vehicles[shopid]["blip"][3], vehicles[shopid]["blip"][4], vehicles[shopid]["blip"][1], 2, 255, 0, 0, 255, 0, 200, root)
				vehicles[shopid]["blip"][5] = true
			end
			spawnShopVehicle(vehicles[shopid]["models"][math.random(#vehicles[shopid]["models"])][1], i, shopid)
		else
			break
		end
	end
	return true
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i=1,#vehicles do
			spawnShopVehicles(i)
		end
		
		setTimer(function()
			for i=1,#vehicles do
				spawnShopVehicles(i)
			end
			
			for i,v in ipairs(getElementsByType("player")) do
				triggerClientEvent(v, ":_closeVehiclePurchaseMenu_:", v)
			end
		end, 60000*15, 0)
	end
)

addEvent(":_initPurchase:VEH_:", true)
addEventHandler(":_initPurchase:VEH_:", root,
	function(marker)
		if (source ~= client) then return end
		triggerClientEvent(client, ":_displayPurchaseOptions:VEH_:", client, tonumber(getElementData(marker, "roleplay:markers.price")), exports['roleplay-banking']:getBankValue(client), getPlayerMoney(client), getElementParent(marker))
	end
)

addEvent(":_purchaseVehicle_:", true)
addEventHandler(":_purchaseVehicle_:", root,
	function(bankOrNot, vehicle)
		if (source ~= client) then return end
		if (vehicle) and (isElement(vehicle)) then
			local x, y, z = getElementPosition(client)
			if (exports['roleplay-vehicles']:getVehicleRealID(vehicle) == -1) and (exports['roleplay-vehicles']:getVehicleRealType(vehicle) == 0) then
				if (not bike[getElementModel(vehicle)]) then
					if (not exports['roleplay-accounts']:hasDriversLicense(client)) then
						outputChatBox("You need a valid driver's license in order to purchase this vehicle.", client, 245, 20, 20, false)
						return
					end
				end
				
				local ix, iy, iz = getElementPosition(vehicle)
				local distance = getDistanceBetweenPoints3D(x, y, z, ix, iy, iz)
				if (distance <= 5) and (getElementInterior(vehicle) == getElementInterior(client)) and (getElementDimension(vehicle) == getElementDimension(client)) then
					if (tonumber(getElementData(vehicle, "roleplay:vehicles.price")) <= (bankOrNot and exports['roleplay-banking']:getBankValue(client) or getPlayerMoney(client))) then
						local rx, ry, rz = getElementRotation(vehicle)
						local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
						local query = dbQuery(exports['roleplay-accounts']:getSQLConnection(), "INSERT INTO `??` (`??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`, `??`) VALUES ('??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??', '??')", "vehicles", "modelid", "posX", "posY", "posZ", "rotX", "rotY", "rotZ", "interior", "dimension", "rPosX", "rPosY", "rPosZ", "rRotX", "rRotY", "rRotZ", "respawnInterior", "respawnDimension", "color1", "color2", "userID", "created", getElementModel(vehicle), ix, iy, iz, rx, ry, rz, interior, dimension, ix, iy, iz, rx, ry, rz, interior, dimension, toJSON({r1, g1, b1}), toJSON({r2, g2, b2}), exports['roleplay-accounts']:getCharacterID(client), getRealTime().timestamp)
						if (query) then
							local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
							local x = x+((math.cos(math.rad(rz)))*3)
							local y = y+((math.sin(math.rad(rz)))*3)
							setElementPosition(client, x, y, z)
							
							if (bankOrNot) then
								exports['roleplay-banking']:takeBankValue(client, tonumber(getElementData(vehicle, "roleplay:vehicles.price")))
							else
								takePlayerMoney(client, tonumber(getElementData(vehicle, "roleplay:vehicles.price")))
							end
							
							outputChatBox("Congratulations! You've bought this " .. getVehicleName(vehicle) .. " for " .. exports['roleplay-banking']:getFormattedValue(getElementData(vehicle, "roleplay:vehicles.price")) .. " USD.", client, 20, 245, 20, false)
							outputServerLog("Vehicles: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] bought " .. getVehicleName(vehicle) .. " (" .. getElementModel(vehicle) .. ") for " .. exports['roleplay-banking']:getFormattedValue(getElementData(vehicle, "roleplay:vehicles.price")) .. " USD (" .. (bankOrNot and "by bank" or "by cash") .. ") (dbEntryID: " .. last_insert_id .. ").")
							
							exports['roleplay-vehicles']:addVehicle(last_insert_id, getElementModel(vehicle), ix, iy, iz, rx, ry, rz, getElementInterior(vehicle), getElementDimension(vehicle), ix, iy, iz, rx, ry, rz, getElementInterior(vehicle), getElementDimension(vehicle), 1, exports['roleplay-accounts']:getCharacterID(client), toJSON({r1, g1, b1}), toJSON({r2, g2, b2}), 0, 0, 0, 0, 0, 1000, 100, 1)
							exports['roleplay-items']:giveItem(client, 7, last_insert_id)
							
							for i,v in ipairs(getElementChildren(vehicle, "marker")) do
								destroyElement(v)
							end
							
							destroyElement(vehicle)
						end
					else
						outputChatBox("You have insufficient funds in order to purchase this vehicle by " .. (bankOrNot and "bank" or "cash") .. ".", client, 245, 20, 20, false)
					end
				else
					outputChatBox("You need to be near the interior you want to buy.", client, 245, 20, 20, false)
					exports['roleplay-accounts']:outputAdminLog(getPlayerName(client):gsub("_", " ") .. " tried to purchase a vehicle as far away as " .. distance .. " meters.")
				end
			else
				outputChatBox("Apparently that vehicle is not a purchasable vehicle.", client, 245, 20, 20, false)
			end
		else
			outputChatBox("Apparently that vehicle no longer exists.", client, 245, 20, 20, false)
		end
		triggerClientEvent(client, ":_closeVehiclePurchaseMenu_:", client)
	end
)