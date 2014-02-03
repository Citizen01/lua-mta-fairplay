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

local thisShader = 8
local orderPriority = "-2.7"
local isShowing = false
local isValid = false
Settings = {}
Settings.var = {}

local function disableShader()
	if (not isShowing) then return end
	for _,part in ipairs(effectParts) do
		if part then
			destroyElement(part)
		end
	end
	
	removeEventHandler("onClientHUDRender", root, renderDoFBokeh)
	
	effectParts = {}
	isValid = false
	RTPool.clear()
	isShowing = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 8)) then
		myScreenSource = dxCreateScreenSource(scx, scy)
		
		lumTemp = dxCreateScreenSource(512, 512)
		lumSamples = {}
		currLumSample = 0
		
		DoFBokehShader = dxCreateShader("shaders/DoFBokeh.fx")
		GetDepthShader = dxCreateShader("shaders/GetDepthPix.fx")
		
		effectParts = {
			myScreenSource,
			lumTemp,
			DoFBokehShader,
			GetDepthShader
		}
		
		isValid = true
		for _,part in ipairs(effectParts) do
			isValid = part and isValid
		end
		
		if (not isValid) then
			disableShader()
		else
			setEffectVariables()
			isShowing = true
			addEventHandler("onClientHUDRender", root, renderDoFBokeh, true, "low" .. orderPriority)
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, enableShader)

addEvent(":_setShader_:", true)
addEventHandler(":_setShader_:", root,
	function(shaderID, shaderState)
		if (not tonumber(shaderID)) or (shaderState == nil) then return end
		local shaderID = tonumber(shaderID)
		if (shaderID == thisShader) then
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 8)) then
				enableShader()
			end
		end
	end
)

function setEffectVariables()
    local v = Settings.var
    v.DoF_Auto = true
    v.DoF_Vignetting = false
    v.vignint = 4
    v.znear = 100
    v.zfar = 3500
    v.focalDepth = 90
    v.focalLength = 80
    v.fstop = 90
    v.CoC = 0.1

    v.namount = 0.00004
    v.DOFdownsample = 4
    v.maxblur = 2.5
    v.threshold = 2.5
    v.gain = 0.1
    v.bias = 0.2
    v.fringe = 0.5
	
    v.timeGap = 5
    v.maxLumSamples = 50
    v.PreviewEnable=0
    v.PreviewPosY=0
    v.PreviewPosX=100
    v.PreviewSize=70
	
	setShaderValues()
end

function setShaderValues()
	if (not DoFBokehShader) then return end
	local v = Settings.var
	dxSetShaderValue(DoFBokehShader, "znear", v.znear)
	dxSetShaderValue(DoFBokehShader, "zfar", v.zfar)
	dxSetShaderValue(DoFBokehShader, "focalDepth", v.focalDepth) 
	dxSetShaderValue(DoFBokehShader, "focalLength", v.focalLength)
	dxSetShaderValue(DoFBokehShader, "fstop", v.fstop)
	dxSetShaderValue(DoFBokehShader, "CoC", v.CoC)

	dxSetShaderValue(DoFBokehShader, "namount", v.namount)
	dxSetShaderValue(DoFBokehShader, "DOFdownsample", v.DOFdownsample)
	dxSetShaderValue(DoFBokehShader, "maxblur", v.maxblur)
	dxSetShaderValue(DoFBokehShader, "threshold", v.threshold)
	dxSetShaderValue(DoFBokehShader, "gain", v.gain)
	dxSetShaderValue(DoFBokehShader, "bias", v.bias)
	dxSetShaderValue(DoFBokehShader, "fringe", v.fringe) 
end

function renderDoFBokeh()
	if (not isValid) or (not Settings.var) then return end
	local v = Settings.var
	
	RTPool.frameStart()
	DebugResults.frameStart()
	
	dxUpdateScreenSource(myScreenSource, true)
	dxUpdateScreenSource(lumTemp)
	
	local current = myScreenSource
	local curDepthPix = applyGetDepthShader(lumTemp)
	local myPixel = countLuminanceForPalette(curDepthPix, v.timeGap, v.maxLumSamples)			
	current = applyDoFBokeh(current, myPixel)
	
	dxSetRenderTarget()
	
	if (current) then dxDrawImage(0, 0, scx, scy, current, 0, 0, 0, tocolor(255, 255, 255, 255)) end
	
	if (v.PreviewEnable > 0.5) then
		DebugResults.drawItems(v.PreviewSize, v.PreviewPosX, v.PreviewPosY)
	end
end

function applyGetDepthShader(src)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = RTPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(GetDepthShader, "TEX0", src)
	dxDrawImage(0, 0, mx, my, GetDepthShader)
	DebugResults.addItem(newRT, "DoFBokeh")
	return newRT
end

function applyDoFBokeh(src, lumPixel)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local ScreenSize = {mx,1/mx,mx/my,my/mx}
	local newRT = RTPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(DoFBokehShader, "ScreenSize", ScreenSize)
	dxSetShaderValue(DoFBokehShader, "TEX0", src)
	dxSetShaderValue(DoFBokehShader, "sLumPixel", lumPixel)
	dxDrawImage(0, 0, mx, my, DoFBokehShader)
	DebugResults.addItem(newRT, "DoFBokeh")
	return newRT
end

function countMedianPixelColor(daTable)
	local sum_r,sum_g,sum_b=0,0,0
	for _,tValue in ipairs(daTable) do
	local r,g,b,a = dxGetPixelColor(tValue, 0, 0)
		sum_r=sum_r+r
		sum_g=sum_g+g
		sum_b=sum_b+b
	end
	return {(sum_r/#daTable)/255,(sum_g/#daTable)/255,(sum_b/#daTable)/255}
end

local lastPix = {1, 1, 1}
local lastTickCount = 0
function countLuminanceForPalette(luminance, lumPause, maxLumSamples)
	if getTickCount() > lastTickCount then
		local mx, my = dxGetMaterialSize(luminance);
		local size = 1
		while (size < mx / 2 or size < my / 2) do
			size = size * 2
		end
		luminance = applyResize(luminance, size, size)
		while (size > 1) do
			size = size / 2
			luminance = applyDownsample(luminance, 2)
		end
		if (currLumSample>maxLumSamples) then 
			currLumSample=0 
		end
		lumSamples[currLumSample]=dxGetTexturePixels(luminance)
		local pix=countMedianPixelColor(lumSamples)
		currLumSample=currLumSample+1
		lastPix=pix
		lastTickCount=getTickCount()+lumPause
		return pix
	else
		return lastPix
	end
end

function applyResize(src, tx, ty)
	if (not src) then return nil end
	local newRT = RTPool.GetUnused(tx, ty)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT)
	dxDrawImage(0,  0, tx, ty, src)
	DebugResults.addItem(newRT, "Resize")
	return newRT
end

function applyDownsample(src)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	mx = mx / 2
	my = my / 2
	local newRT = RTPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT)
	dxDrawImage(0, 0, mx, my, src)
	DebugResults.addItem(newRT, "Downsample")
	return newRT
end