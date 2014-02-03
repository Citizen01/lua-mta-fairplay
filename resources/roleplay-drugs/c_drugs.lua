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

local sx, sy = guiGetScreenSize()
local isDrugged
local drug
local overdose

local function dxDrawDrugEffect(x, y, w, h, iStart, effectSpeed)
	local gifElement = createElement("dx-gif")
	if (gifElement) then
		setElementData (
			gifElement,
			"gifData", {
				x = x,
				y = y,
				w = w,
				h = h,
				startID = iStart,
				imgID = iStart,
				speed = effectSpeed,
				tick = getTickCount()
			},
			false
		)
		return gifElement
	else
		return false
	end
end

local r1, g1, b1 = 50, 200, 50
local r2, g2, b2 = 0, 100, 0
local drugAlpha = 40
local rolltype = false
local roll = 0
local fov = 140

addEventHandler("onClientRender", root,
	function()
		if (not isDrugged) then return end
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		
		local currentTick = getTickCount()
		
		for index, gif in ipairs(getElementsByType("dx-gif")) do
			local gifData = getElementData(gif, "gifData")
			if (gifData) then
				if (currentTick-gifData.tick >= gifData.speed) then
					gifData.tick = currentTick
					gifData.imgID = (gifData.imgID+1)
					
					if (fileExists("images/drug1_1/" .. gifData.imgID .. "-gif" .. ".jpg")) then
						gifData.imgID = gifData.imgID
						setElementData(gif, "gifData", gifData, false)
					else
						gifData.imgID = gifData.startID
						setElementData(gif, "gifData", gifData, false)
					end
				end
				
				local rand1 = math.random(0, 1)
				local rand2 = math.random(5, 8)
				
				dxDrawImage(gifData.x-100, gifData.y-100, gifData.w, gifData.h, "images/drug1_1/" .. gifData.imgID .. "-gif" .. ".jpg", math.random(-5, 5), math.random(0, 100), math.random(0, 100), tocolor(255, 0, 0, drugAlpha), false)
				dxDrawImage(gifData.x-105, gifData.y-100, gifData.w, gifData.h, "images/drug1_1/" .. gifData.imgID .. "-gif" .. ".jpg", math.random(-5, 5), math.random(0, 100), math.random(0, 100), tocolor(0, 255, 0, drugAlpha), false)
				dxDrawImage(gifData.x-95, gifData.y-100, gifData.w, gifData.h, "images/drug1_1/" .. gifData.imgID .. "-gif" .. ".jpg", math.random(-5, 5), math.random(0, 100), math.random(0, 100), tocolor((rand2 == 5 and 255 or 0), (rand2 == 6 and 255 or (rand2 == 8 and 255 or 0)), (rand2 == 7 and 255 or (rand2 == 8 and 255 or 0)), drugAlpha), false)
				
				dxDrawImage(gifData.x-100, gifData.y-100, gifData.w, gifData.h, "images/drug1_2/" .. gifData.imgID .. "-gif" .. ".jpg", math.random(-5, 10), math.random(0, 100), math.random(0, 100), tocolor(255, 0, 0, drugAlpha), false)
				dxDrawImage(gifData.x-105, gifData.y-100, gifData.w, gifData.h, "images/drug1_2/" .. gifData.imgID .. "-gif" .. ".jpg", math.random(-5, 10), math.random(0, 100), math.random(0, 100), tocolor(0, 255, 0, drugAlpha), false)
				dxDrawImage(gifData.x-95, gifData.y-100, gifData.w, gifData.h, "images/drug1_2/" .. gifData.imgID .. "-gif" .. ".jpg", math.random(-5, 10), math.random(0, 100), math.random(0, 100), tocolor((rand2 == 5 and 255 or 0), (rand2 == 6 and 255 or (rand2 == 8 and 255 or 0)), (rand2 == 7 and 255 or (rand2 == 8 and 255 or 0)), drugAlpha), false)
				
				dxDrawRectangle(0, 0, sx, sy, tocolor((rand2 == 5 and 255 or 0), (rand2 == 6 and 255 or (rand2 == 8 and 255 or 0)), (rand2 == 7 and 255 or (rand2 == 8 and 255 or 0)), 0 .. math.random(0, 2) .. 0))
				
				if (r1 < 250) then
					r1=r1+math.random(1,5)
				else
					r1 = 0
				end
				
				if (g1 < 250) then
					g1=g1+math.random(1,5)
				else
					g1 = 0
				end
				
				if (b1 < 250) then
					b1=b1+math.random(1,5)
				else
					b1 = 0
				end
				
				if (r2 < 250) then
					r2=r2+math.random(1,5)
				else
					r2 = 0
				end
				
				if (g2 < 250) then
					g2=g2+math.random(1,5)
				else
					g2 = 0
				end
				
				if (b1 < 250) then
					b2=b2+math.random(1,5)
				else
					b2 = 0
				end
				
				local x, y, z = getElementPosition(localPlayer)
				local _, _, rz = getElementRotation(localPlayer)
				
				setSkyGradient(r1, g1, b1, r2, g2, b2)
				setFarClipDistance(120)
				setWindVelocity(x, y, z)
				setMinuteDuration(50)
				
				local x2 = x+((math.cos(math.rad(rz-90)))*3)
				local y2 = y+((math.sin(math.rad(rz-90)))*3)
				
				if (rolltype) then
					if (roll < 35) then
						roll = roll+0.1
						fov = fov+0.05
					else
						rolltype = false
					end
				else
					if (roll > -35) then
						roll = roll-0.1
						fov = fov-0.05
					else
						rolltype = true
					end
				end
				
				setCameraMatrix(x2, y2, (overdose and z+10 or z+2), x, y, z+1.4, (overdose and roll*10 or roll), fov)
			end
		end
	end
)

function setDrugEffect(drugID, length)
	if (drugID == 1) then
		drug = dxDrawDrugEffect(0, 0, sx+200, sy+200, 0, 250)
		triggerServerEvent(":_setWalkStyle_:", localPlayer, drugID)
		setCameraGoggleEffect("thermalvision")
		darksong = playSound("wat.mp3", true)
		setSoundVolume(darksong, (overdose and 1.0 or 0.8))
		if (not overdose) then
			setSoundEffectEnabled(darksong, "reverb", true)
			setSoundEffectEnabled(darksong, "compressor", true)
			setSoundEffectEnabled(darksong, "echo", true)
		end
	elseif (not drugID) or (drugID == 0) then
		if (isElement(drug)) then
			destroyElement(drug)
			drug = nil
		end
		if (isElement(darksong)) then
			destroyElement(darksong)
		end
		resetSkyGradient()
		setFarClipDistance(2000)
		setMinuteDuration(60000)
		setWindVelocity(0.1, 0.1, 0.1)
		roll = 0
		rolltype = false
		setCameraTarget(localPlayer)
		setCameraGoggleEffect("normal")
		triggerServerEvent(":_setWalkStyle_:", localPlayer, 0)
	end
	
	isDrugged = (drugID and (drugID ~= 0 and drugID or false) or false)
end
addEvent(":_setDrugEffect_:", true)
addEventHandler(":_setDrugEffect_:", root, setDrugEffect)

addCommandHandler("toggledrugtest",
	function(cmd, drugID)
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		setDrugEffect((isElement(drug) and 0 or (drugID and drugID or 1)))
	end
)

addCommandHandler("overdose",
	function(cmd, drugID)
		if (not exports['roleplay-accounts']:isClientPlaying(localPlayer)) then return end
		overdose = not overdose
		outputChatBox(tostring(overdose))
		if (isElement(darksong)) then
			setSoundVolume(darksong, (overdose and 1.0 or 0.8))
			setSoundEffectEnabled(darksong, "reverb", not overdose)
			setSoundEffectEnabled(darksong, "compressor", not overdose)
			setSoundEffectEnabled(darksong, "echo", not overdose)
		end
	end
)