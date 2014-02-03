--[[
	- FairPlay Gaming: Roleplay
	Resource content and structure is copyrighted to the authors of the resource.
	Copying and/or re-distribution of the content and structure is prohibited.
	(c) Copyright 2013 FairPlay Gaming. All rights reserved.
]]

local thisShader = 6
local sx, sy = guiGetScreenSize()
local isRunning = false
local settings = {
	["var"] = {
		["cutoff"] = 0.08,
		["power"] = 1.88,
		["bloom"] = 2.0,
		["blendR"] = 204,
		["blendG"] = 153,
		["blendB"] = 130,
		["blendA"] = 140
	}
}

local function applyBrightPass(src, cutoff, power)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = bloomPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(brightPassShader, "TEX0", src)
	dxSetShaderValue(brightPassShader, "CUTOFF", cutoff)
	dxSetShaderValue(brightPassShader, "POWER", power)
	dxDrawImage(0, 0, mx, my, brightPassShader)
	return newRT
end

local function applyDownsample(src, amount)
	if (not src) then return nil end
	amount = (amount or 2)
	local mx, my = dxGetMaterialSize(src)
	mx = mx/amount
	my = my/amount
	local newRT = bloomPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT)
	dxDrawImage(0, 0, mx, my, src)
	return newRT
end

local function applyGBlurH(src, bloom)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = bloomPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(blurHShader, "TEX0", src)
	dxSetShaderValue(blurHShader, "TEX0SIZE", mx,my)
	dxSetShaderValue(blurHShader, "BLOOM", bloom)
	dxDrawImage(0, 0, mx, my, blurHShader)
	return newRT
end

local function applyGBlurV(src, bloom)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = bloomPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(blurVShader, "TEX0", src)
	dxSetShaderValue(blurVShader, "TEX0SIZE", mx,my)
	dxSetShaderValue(blurVShader, "BLOOM", bloom)
	dxDrawImage(0, 0, mx, my, blurVShader)
	return newRT
end

local function renderBloom()
	if (not myScreenSource) or (not blurHShader) or (not blurVShader) or (not brightPassShader) or (not addBlendShader) then return end
	bloomPool.frameStart()
	dxUpdateScreenSource(myScreenSource)
	
	local privateShader = myScreenSource
	privateShader = applyBrightPass(privateShader, settings.var.cutoff, settings.var.power)
	privateShader = applyDownsample(privateShader)
	privateShader = applyDownsample(privateShader)
	privateShader = applyGBlurH(privateShader, settings.var.bloom)
	privateShader = applyGBlurV(privateShader, settings.var.bloom)
	
	dxSetRenderTarget()
	
	if (privateShader) then
		dxSetShaderValue(addBlendShader, "TEX0", privateShader)
		local col = tocolor(settings.var.blendR, settings.var.blendG, settings.var.blendB, settings.var.blendA)
		dxDrawImage(0, 0, sx, sy, addBlendShader, 0, 0, 0, col)
	end
end

local function disableShader()
	if (not isRunning) then return end
	removeEventHandler("onClientHUDRender", root, renderBloom)
	
	if (isElement(blurHShader)) then
		destroyElement(blurHShader)
	end
	
	if (isElement(blurVShader)) then
		destroyElement(blurVShader)
	end
	
	if (isElement(brightPassShader)) then
		destroyElement(brightPassShader)
	end
	
	if (isElement(addBlendShader)) then
		destroyElement(addBlendShader)
	end
	
	isRunning = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 6)) then
		myScreenSource = dxCreateScreenSource(sx/2, sy/2)
		blurHShader = dxCreateShader("bloom_1/shaders/blurH.fx")
		blurVShader = dxCreateShader("bloom_1/shaders/blurV.fx")
		brightPassShader = dxCreateShader("bloom_1/shaders/brightPass.fx")
		addBlendShader = dxCreateShader("bloom_1/shaders/addBlend.fx")
		if (not myScreenSource) or (not blurHShader) or (not blurVShader) or (not brightPassShader) or (not addBlendShader) then return end
		addEventHandler("onClientHUDRender", root, renderBloom)
		
		isRunning = true
	end
end
addEventHandler("onClientResourceStart", resourceRoot, enableShader)

addEvent(":_setShader_:", true)
addEventHandler(":_setShader_:", root,
	function(shaderID, shaderState)
		if (not tonumber(shaderID)) or (shaderState == nil) then return end
		local shaderID = tonumber(shaderID)
		if (shaderID == thisShader) then
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 6)) then
				enableShader()
			end
		end
	end
)