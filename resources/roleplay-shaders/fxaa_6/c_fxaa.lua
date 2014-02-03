--[[
	- FairPlay Gaming: Roleplay
	Resource content and structure is copyrighted to the authors of the resource.
	Copying and/or re-distribution of the content and structure is prohibited.
	(c) Copyright 2013 FairPlay Gaming. All rights reserved.
]]

local thisShader = 12
local sx, sy = guiGetScreenSize()
local orderPriority = "-2.5"
local maxAntialiasing = 4
local varAntialiasing = 4
local isShowing = false
local isValid = false
local settings = {
	["var"] = {}
}

local function disableShader()
	if (not isShowing) then return end
	for _,part in ipairs(effectParts) do
		if (part) then
			destroyElement(part)
		end
	end
	
	removeEventHandler("onClientHUDRender", root, renderFXAA)
	
	effectParts = {}
	isValid = false
	fxaaPool.clear()
	isShowing = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader(aaVal)
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 12)) then
		aaValue = tonumber(aaVal)
		if (aaValue > maxAntialiasing or aaValue < 1) then 
			aaValue = 0 
			disableShader()
		end
		
		if (isShowing) then return end
		myScreenSource = dxCreateScreenSource(sx, sy)
		fXAAShader = dxCreateShader("fxaa_6/shaders/FXAA.fx")
		
		effectParts = {
			myScreenSource,
			fXAAShader
		}
		
		isValid = true
		for _,part in ipairs(effectParts) do
			isValid = (part and isValid)
		end
		
		setEffectVariables()
		isShowing = true
		
		addEventHandler("onClientHUDRender", root, renderFXAA, true, "low" .. orderPriority)
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		enableShader(varAntialiasing)
	end
)

addEvent(":_setShader_:", true)
addEventHandler(":_setShader_:", root,
	function(shaderID, shaderState, arg1)
		if (not tonumber(shaderID)) or (not tonumber(arg1)) or (tonumber(arg1) > 4) or (tonumber(arg1) < 0) or (shaderState == nil) then return end
		local shaderID = tonumber(shaderID)
		local arg1 = tonumber(arg1)
		if (shaderID == thisShader) then
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 12)) then
				enableShader(arg1)
			end
		end
	end
)

function setEffectVariables()
    local v = settings.var
	
	v.FXAA_LINEAR=0
	v.FXAA_QUALITY__EDGE_THRESHOLD = (1.0/32.0)
	v.FXAA_QUALITY__EDGE_THRESHOLD_MIN = (1.0/16.0)
	v.FXAA_QUALITY__SUBPIX_CAP = (7.0/8.0)
	v.FXAA_QUALITY__SUBPIX_TRIM = (1.0/12.0)
	v.FXAA_SEARCH_STEPS = 16
	v.FXAA_SEARCH_THRESHOLD = (1.0/4.0)
	
    v.PreviewEnable = 0
    v.PreviewPosY = 0
    v.PreviewPosX = 100
    v.PreviewSize = 70
	
	applySettings(v)
end

function applySettings(v)
	if (not fXAAShader) then return end
	dxSetShaderValue(fXAAShader, "FXAA_LINEAR", v.FXAA_LINEAR)
	dxSetShaderValue(fXAAShader, "FXAA_QUALITY__EDGE_THRESHOLD", v.FXAA_QUALITY__EDGE_THRESHOLD)
	dxSetShaderValue(fXAAShader, "FXAA_QUALITY__EDGE_THRESHOLD_MIN", v.FXAA_QUALITY__EDGE_THRESHOLD_MIN)
	dxSetShaderValue(fXAAShader, "FXAA_QUALITY__SUBPIX_CAP", v.FXAA_QUALITY__SUBPIX_CAP)
	dxSetShaderValue(fXAAShader, "FXAA_QUALITY__SUBPIX_TRIM", v.FXAA_QUALITY__SUBPIX_TRIM)
	dxSetShaderValue(fXAAShader, "FXAA_SEARCH_STEPS", v.FXAA_SEARCH_STEPS)
	dxSetShaderValue(fXAAShader, "FXAA_SEARCH_THRESHOLD", v.FXAA_SEARCH_THRESHOLD)
end

function renderFXAA()
	if (not isValid) or (not settings.var) then return end
	local v = settings.var
	
	fxaaPool.frameStart()
	DebugResults.frameStart()
	
	dxUpdateScreenSource(myScreenSource, true)
	
	local current = myScreenSource
	
	for i=1,tonumber(aaValue) do
		current = applyFXAA(current, i)
	end			
	
	dxSetRenderTarget()
	
	if (current) then
		dxDrawImage(0, 0, sx, sy, current, 0, 0, 0, tocolor(255, 255, 255, 255))
	end
	
	if (v.PreviewEnable > 0.5) then
		DebugResults.drawItems(v.PreviewSize, v.PreviewPosX, v.PreviewPosY)
	end
end

function applyFXAA(src, pass)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local scrRes = {mx, my}
	local newRT = fxaaPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(fXAAShader, "screenResolution", scrRes)
	dxSetShaderValue(fXAAShader, "TEX0", src)
	dxDrawImage(0, 0, mx, my, fXAAShader)
	local passId = 'fxAA: pass '..pass
	DebugResults.addItem(newRT, passId)
	return newRT
end