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

local weatherAPI = "http://socialz.comuv.com/api_json.php"
local celsius = 20
local weather = {
	sunny = {0, 1, 10, 11, 17, 18},
	clouds = {2, 3, 4, 5, 6, 7},
	fog = {9},
	stormy = {8},
	rainy = {16},
	dull = {12, 13, 14, 15}
}

local function setWeatherEx(str, rain, level, wave)
	local newWeather = weather[str][math.random(#weather[str])]
	
	if (newWeather == 8) or (newWeather == 16) then
		local month = getRealTime().month
		if (month == 10) or (month == 11) or (month == 0) then
			newWeather = math.random(12,15)
			setWeather(newWeather)
		else
			setWeather(newWeather)
		end
	else
		setWeather(newWeather)
	end
	
	setRainLevel((rain and rain or 0))
	setWaterLevel((level and level or 0))
	setWaveHeight((wave and wave or 0.5))
	
	local month = getRealTime().month
	if (month == 10) or (month == 11) or (month == 0) then
		if (getWeather() == 9) or (getWeather() == 12) or (getWeather() == 13) or (getWeather() == 14) or (getWeather() == 15) then
			triggerClientEvent(root, ":_startSnow_:", root)
		else
			triggerClientEvent(root, ":_stopSnow_:", root)
		end
	else
		triggerClientEvent(root, ":_stopSnow_:", root)
	end
	
	for i,v in ipairs(getElementsByType("player")) do
		triggerClientEvent(v, ":_updateRainLevel_:", v, (rain and rain or 0))
		if (not exports['roleplay-accounts']:isClientPlaying(v)) then return end
		local _str = str
		local _cel
		local celsius = tonumber(math.ceil(celsius))
		
		if (str == "clouds") then _str = "cloudy"
		elseif (str == "fog") then _str = "foggy"
		end
		
		if (celsius >= -30) and (celsius <= -21) then
			_cel = "very freezing"
		elseif (celsius >= -20) and (celsius <= -11) then
			_cel = "freezing"
		elseif (celsius >= -10) and (celsius <= 0) then
			_cel = "cold"
		elseif (celsius >= 1) and (celsius <= 15) then
			_cel = "chilly"
		elseif (celsius >= 16) and (celsius <= 20) then
			_cel = "somewhat balanced"
		elseif (celsius >= 21) and (celsius <= 24) then
			_cel = "warm"
		elseif (celsius >= 25) and (celsius <= 30) then
			_cel = "hot"
		elseif (celsius >= 31) and (celsius <= 36) then
			_cel = "very hot"
		elseif (celsius >= 37) and (celsius <= 45) then
			_cel = "dangerously hot"
		end
		
		triggerClientEvent(v, ":_addNewMessage_:", v, "WORLD ACTION: It appears the weather is beginning to get " .. _str .. " and the temperature feels " .. _cel .. ". ")
	end
	
	exports["roleplay-accounts"]:outputAdminLog("Dynamic weather and season system set weather to ID " .. newWeather .. " (" .. str .. ") and temperature to " .. celsius .. " celsius.")
end

local function setWeatherFromRemote(data)
	local weather_, celsius_, windvel_, winddir_ = data[1], data[2], data[3], data[4]
	if (weather_ == nil) or (celsius_ == nil) then
		outputDebugString("Weather: " .. weatherAPI .. " returned no usable data.", 2)
	else
		celsius = celsius_
		if (weather_ == "sky is clear") or (weather_ == "few clouds") or (weather_ == "scattered clouds") or (weather_ == "broken clouds") or (weather_ == "cold") or (weather_ == "hot") then
			setWeatherEx("sunny")
		elseif (weather_ == "overcast clouds") then
			setWeatherEx("clouds")
		elseif (weather_ == "light rain") then
			setWeatherEx("rainy", 0.8, 0.07)
		elseif (weather_ == "moderate rain") or (weather_ == "hail") then
			setWeatherEx("rainy", 1.0, 0.1, 0.8)
		elseif (weather_ == "heavy intensity rain") then
			setWeatherEx("rainy", 1.2, 0.35, 1.0)
		elseif (weather_ == "very heavy rain") then
			setWeatherEx("rainy", 1.4, 1.0, 1.6)
		elseif (weather_ == "extreme rain") or (weather_ == "tropical storm") then
			setWeatherEx("rainy", 1.6, 2.5, 2.0)
		elseif (weather_ == "freezing rain") or (weather_ == "hurricane") then
			setWeatherEx("rainy", 1.8, 4.0, 2.3)
		elseif (weather_ == "light intensity shower rain") then
			setWeatherEx("rainy", 0.75)
		elseif (weather_ == "shower rain") then
			setWeatherEx("rainy", 0.9)
		elseif (weather_ == "heavy intensity shower rain") then
			setWeatherEx("rainy", 0.8)
		elseif (weather_ == "light intensity drizzle") then
			setWeatherEx("rainy", 0.1)
		elseif (weather_ == "drizzle") then
			setWeatherEx("rainy", 0.2)
		elseif (weather_ == "heavy intensity drizzle") then
			setWeatherEx("rainy", 0.35)
		elseif (weather_ == "drizzle rain") then
			setWeatherEx("rainy", 0.4)
		elseif (weather_ == "heavy intensity drizzle rain") then
			setWeatherEx("rainy", 0.55)
		elseif (weather_ == "shower drizzle") then
			setWeatherEx("rainy", 0.62)
		elseif (weather_ == "thunderstorm with light rain") then
			setWeatherEx("stormy", 0.66, 0.2, 0.8)
		elseif (weather_ == "thunderstorm with rain") then
			setWeatherEx("stormy", 1.0, 0.4, 1.2)
		elseif (weather_ == "thunderstorm with heavy rain") then
			setWeatherEx("stormy", 1.2, 0.75, 1.4)
		elseif (weather_ == "light thunderstorm") or (weather_ == "thunderstorm") or (weather_ == "heavy thunderstorm") or (weather_ == "ragged thunderstorm") then
			setWeatherEx("stormy", 0)
		elseif (weather_ == "thunderstorm with light drizzle") then
			setWeatherEx("stormy", 0.1)
		elseif (weather_ == "thunderstorm with drizzle") then
			setWeatherEx("stormy", 0.2)
		elseif (weather_ == "thunderstorm with heavy drizzle") then
			setWeatherEx("stormy", 0.35)
		elseif (weather_ == "mist") or (weather_ == "smoke") or (weather_ == "fog") then
			setWeatherEx("fog")
		elseif (weather_ == "Sand/Dust Whirls") or (weather_ == "haze") or (weather_ == "tornado") or (weather_ == "windy") then
			setWeatherEx("dull", 0.2, 2.1)
		else
			setWeatherEx("sunny")
		end
		
		if (winddir_ == "SSE") or (winddir_ == "SE") then
			setWindVelocity(windvel_, -windvel_, windvel_)
		elseif (winddir_ == "NNE") or (winddir_ == "NE") then
			setWindVelocity(windvel_, windvel_, windvel_)
		elseif (winddir_ == "NNW") or (winddir_ == "NW") then
			setWindVelocity(-windvel_, windvel_, windvel_)
		elseif (winddir_ == "SSW") or (winddir_ == "SW") then
			setWindVelocity(-windvel_, -windvel_, windvel_)
		elseif (winddir_ == "S") then
			setWindVelocity(0.1, -windvel_, windvel_)
		elseif (winddir_ == "N") then
			setWindVelocity(0.1, windvel_, windvel_)
		elseif (winddir_ == "E") then
			setWindVelocity(windvel_, 0.1, windvel_)
		elseif (winddir_ == "W") then
			setWindVelocity(0.1, windvel_, windvel_)
		else
			setWindVelocity(0.3, 0.3, 0.3)
		end
		
		outputServerLog("Weather: Weather API returned " .. weather_ .. ", " .. celsius_ .. ", " .. windvel_ .. ". Weather, temperature and wind speed set.")
	end
end

local function updateWeather()
	callRemote(weatherAPI, setWeatherFromRemote)
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		updateWeather()
		setTimer(updateWeather, 60000*30, 0)
	end
)