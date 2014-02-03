--[[
	- FairPlay Gaming: Roleplay
	Resource content and structure is copyrighted to the authors of the resource.
	Copying and/or re-distribution of the content and structure is prohibited.
	(c) Copyright 2013 FairPlay Gaming. All rights reserved.
]]

local thisShader = 14
local carShader
local isRunning = false

local function disableShader()
	if (not isRunning) then return end
	if (isElement(carShader)) then
		destroyElement(carShader)
	end
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 14)) then
		carShader = dxCreateShader("carreflect_2/shaders/car_paint.fx")
		local textureVol = dxCreateTexture("carreflect_2/images/smallnoise3d.dds")
		local textureCube = dxCreateTexture("carreflect_2/images/cube_env256.dds")
		dxSetShaderValue(carShader, "sRandomTexture", textureVol)
		dxSetShaderValue(carShader, "sReflectionTexture", textureCube)
		engineApplyShaderToWorldTexture(carShader, "vehiclegrunge256")
		engineApplyShaderToWorldTexture(carShader, "?emap*")
		
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
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 15)) then
				enableShader()
			end
		end
	end
)