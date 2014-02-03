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

local thisShader = 7
local sx, sy = guiGetScreenSize()
local isShowing = false
local isValid = false
local effects = {}
local settings = {
	["var"] = {}
}

local function setEffectType()
    local v = settings.var
    v.Brightness = 0.32
    v.Contrast = 2.24

    v.ExtractThreshold = 0.72

    v.DownSampleSteps = 2
    v.GBlurHBloom = 1.68
    v.GBlurVBloom = 1.52

    v.BloomIntensity = 0.94
    v.BloomSaturation = 1.66
    v.BaseIntensity = 0.94
    v.BaseSaturation = -0.38

    v.LumSpeed = 51
    v.LumChangeAlpha = 27

    v.MultAmount = 0.46
    v.Mult = 0.70
    v.Add = 0.10
    v.ModExtraFrom = 0.11
    v.ModExtraTo = 0.58
    v.ModExtraMult = 4

    v.MulBlend = 0.82
    v.BloomBlend = 0.25

    v.Vignette = 0.47
	
    v.PreviewEnable = 0
    v.PreviewPosY = 0
    v.PreviewPosX = 100
    v.PreviewSize = 70
end

local function applyBloomCombine(src, base, sBloomIntensity, sBloomSaturation, sBaseIntensity, sBaseSaturation)
	if (not src) or (not base) then return nil end
	local mx, my = dxGetMaterialSize(base)
	local newRT = contrastPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(bloomCombineShader, "sBloomTexture", src)
	dxSetShaderValue(bloomCombineShader, "sBaseTexture", base)
	dxSetShaderValue(bloomCombineShader, "sBloomIntensity", sBloomIntensity)
	dxSetShaderValue(bloomCombineShader, "sBloomSaturation", sBloomSaturation)
	dxSetShaderValue(bloomCombineShader, "sBaseIntensity", sBaseIntensity)
	dxSetShaderValue(bloomCombineShader, "sBaseSaturation", sBaseSaturation)
	dxDrawImage(0, 0, mx, my, bloomCombineShader)
	DebugResults.addItem(newRT, "BloomCombine")
	return newRT
end

local function applyBloomExtract(src, sceneLuminance, sBloomThreshold)
	if (not src) or (not sceneLuminance) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = contrastPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(bloomExtractShader, "sBaseTexture", src)
	dxSetShaderValue(bloomExtractShader, "sBloomThreshold", sBloomThreshold)
	dxSetShaderValue(bloomExtractShader, "sLumTexture", sceneLuminance)
	dxDrawImage(0, 0, mx, my, bloomExtractShader)
	DebugResults.addItem(newRT, "BloomExtract")
	return newRT
end

local function applyContrast(src, Brightness, Contrast)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = contrastPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT)
	dxSetShaderValue(contrastShader, "sBaseTexture", src)
	dxSetShaderValue(contrastShader, "sBrightness", Brightness)
	dxSetShaderValue(contrastShader, "sContrast", Contrast)
	dxDrawImage(0, 0, mx, my, contrastShader)
	DebugResults.addItem(newRT, "Contrast")
	return newRT
end

local function applyModulation(src, sceneLuminance, MultAmount, Mult, Add, ExtraFrom, ExtraTo, ExtraMult)
	if (not src) or (not sceneLuminance) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = contrastPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT)
	dxSetShaderValue(modulationShader, "sBaseTexture", src)
	dxSetShaderValue(modulationShader, "sMultAmount", MultAmount)
	dxSetShaderValue(modulationShader, "sMult", Mult)
	dxSetShaderValue(modulationShader, "sAdd", Add)
	dxSetShaderValue(modulationShader, "sLumTexture", sceneLuminance)
	dxSetShaderValue(modulationShader, "sExtraFrom", ExtraFrom)
	dxSetShaderValue(modulationShader, "sExtraTo", ExtraTo)
	dxSetShaderValue(modulationShader, "sExtraMult", ExtraMult)
	dxDrawImage(0, 0, mx, my, modulationShader)
	DebugResults.addItem(newRT, "Modulation")
	return newRT
end

local function applyResize(src, tx, ty)
	if (not src) then return nil end
	local newRT = contrastPool.GetUnused(tx, ty)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT)
	dxDrawImage(0,  0, tx, ty, src)
	DebugResults.addItem(newRT, "Resize")
	return newRT
end

local function applyDownsample(src)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	mx = mx/2
	my = my/2
	local newRT = contrastPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT)
	dxDrawImage(0, 0, mx, my, src)
	DebugResults.addItem(newRT, "Downsample")
	return newRT
end

local function applyDownsampleSteps(src, steps)
	if (not src) then return nil end
	for i=1,steps do
		src = applyDownsample(src)
	end
	return src
end

local function applyGBlurH(src, bloom)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = contrastPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(blurHShader, "tex0", src)
	dxSetShaderValue(blurHShader, "tex0size", mx, my)
	dxSetShaderValue(blurHShader, "bloom", bloom)
	dxDrawImage(0, 0, mx, my, blurHShader)
	DebugResults.addItem(newRT, "GBlurH")
	return newRT
end

local function applyGBlurV(src, bloom)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = contrastPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(blurVShader, "tex0", src)
	dxSetShaderValue(blurVShader, "tex0size", mx, my)
	dxSetShaderValue(blurVShader, "bloom", bloom)
	dxDrawImage(0, 0, mx, my, blurVShader)
	DebugResults.addItem(newRT, "GBlurV")
	return newRT
end

local function updateLumSource(current, changeRate, changeAlpha)
	if (not current) then return nil end
	changeRate = (changeRate or 50)
	
	local mx, my = dxGetMaterialSize(current)
	
	local size = 1
	while (size < mx/2 or size < my/2) do
		size = size*2
	end
	
	current = applyResize(current, size, size)
	while (size > 1) do
		size = size/2
		current = applyDownsample(current, 2)
	end
	
	if (getTickCount() > nextLumSampleTime) then
		nextLumSampleTime = getTickCount()+changeRate
		dxSetRenderTarget(lumTarget)
		dxDrawImage(0, 0, 1, 1, current, 0, 0, 0, tocolor(255, 255, 255, changeAlpha))
	end
	
	current = applyResize(lumTarget, 1, 1)
	
	return lumTarget
end

local function renderContrast()
	if (not isValid) or (not settings.var) then return end
	local v = settings.var
	
	contrastPool.frameStart()
	DebugResults.frameStart()
	
	dxUpdateScreenSource(myScreenSourceFull)
	
	local current1 = myScreenSourceFull
	local current2 = myScreenSourceFull
	local sceneLuminance = lumTarget
	
	current1 = applyModulation(current1, sceneLuminance, v.MultAmount, v.Mult, v.Add, v.ModExtraFrom, v.ModExtraTo, v.ModExtraMult)
	current1 = applyContrast(current1, v.Brightness, v.Contrast)
	
	current2 = applyBloomExtract(current2, sceneLuminance, v.ExtractThreshold)
	current2 = applyDownsampleSteps(current2, v.DownSampleSteps)
	current2 = applyGBlurH(current2, v.GBlurHBloom)
	current2 = applyGBlurV(current2, v.GBlurVBloom)
	current2 = applyBloomCombine(current2, current1, v.BloomIntensity, v.BloomSaturation, v.BaseIntensity, v.BaseSaturation)
	
	updateLumSource(current1, v.LumSpeed, v.LumChangeAlpha)
	
	dxSetRenderTarget()
	dxDrawImage(0, 0, sx, sy, current1, 0, 0, 0, tocolor(255 ,255, 255, v.MulBlend*255))
	dxDrawImage(0, 0, sx, sy, current2, 0, 0, 0, tocolor(255, 255, 255, v.BloomBlend*255))
	dxDrawImage(0, 0, sx, sy, textureVignette, 0, 0, 0, tocolor(255, 255, 255, v.Vignette*255))
	
	if (v.PreviewEnable > 0.5) then
		DebugResults.drawItems(v.PreviewSize, v.PreviewPosX, v.PreviewPosY)
	end
end

local function disableShader()
	if (not isShowing) then return end
	removeEventHandler("onClientHUDRender", root, renderContrast)
	
	for _,part in ipairs(effects) do
		if (isElement(part)) then
			destroyElement(part)
		end
	end
	
	effects = {}
	isValid = false
	contrastPool.clear()
	isShowing = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 7)) then
		myScreenSourceFull = dxCreateScreenSource(sx, sy)
		
		contrastShader = dxCreateShader("contrast_3/shaders/contrast.fx")
		bloomCombineShader = dxCreateShader("contrast_3/shaders/bloom_combine.fx")
		bloomExtractShader = dxCreateShader("contrast_3/shaders/bloom_extract.fx")
		blurHShader = dxCreateShader("contrast_3/shaders/blurH.fx")
		blurVShader = dxCreateShader("contrast_3/shaders/blurV.fx")
		modulationShader = dxCreateShader("contrast_3/shaders/modulation.fx")
		
		lumTarget = dxCreateRenderTarget(1, 1)
		nextLumSampleTime = 0
		
		textureVignette = dxCreateTexture("contrast_3/images/vignette1.dds")
		
		effects = {
			myScreenSourceFull,
			contrastShader,
			bloomCombineShader,
			bloomExtractShader,
			blurHShader,
			blurVShader,
			modulationShader,
			lumTarget,
			textureVignette
		}
		
		isValid = true
		for _,part in ipairs(effects) do
			isValid = (part and isValid)
		end
		
		setEffectType()
		isShowing = true
		addEventHandler("onClientHUDRender", root, renderContrast)
		
		if (not isValid) then
			disableShader()
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
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 7)) then
				enableShader()
			end
		end
	end
)