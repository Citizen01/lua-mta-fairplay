--[[
	- FairPlay Gaming: Roleplay
	Resource content and structure is copyrighted to the authors of the resource.
	Copying and/or re-distribution of the content and structure is prohibited.
	(c) Copyright 2013 FairPlay Gaming. All rights reserved.
]]

local thisShader = 9
local sphereObjScale = 100
local sphereShadScale = {1, 1, 0.9}
local makeAngular = true
local isRunning = false

local sphereTexScale = {1, 1, 1}
local ColorAdd = -0.12
local ColorPow = 2
local shadCloudsTexDisabled = false
local modelID = 15057

local skydome_shader = dxCreateShader("skybox_12/shaders/shader_skydome.fx", 0, 0, true, "object")
local null_shader = dxCreateShader("skybox_12/shaders/shader_null.fx")
local getLastTick, getLastTock = 0, 0
local lastWeather = 0

local function applyWeatherInfluence()
	setSunSize(0)
	setSunColor(0, 0, 0, 0, 0, 0)
end

local function renderSphere()
	if (getTickCount()-getLastTock < 2) then return end
	local cam_x, cam_y, cam_z, lx, ly, lz = getCameraMatrix()
	
	if (cam_z <= 200) then
		setElementPosition(skyBoxBoxa, cam_x, cam_y, 80, false) 
	else
		setElementPosition(skyBoxBoxa, cam_x, cam_y, 80+cam_z-200, false)
	end
	
	if (getWeather() ~= lastWeather) then applyWeatherInfluence() end
	
	lastWeather = getWeather()
	getLastTock = getTickCount()
end

local function renderTime()
	local hour, minute = getTime()
	if (getTickCount()-getLastTick < 100) then return end
	if (not skydome_shader) then return end
	if (hour >= 20) then
		local dusk_aspect = ((hour-20)*60+minute)/240
		dusk_aspect = 1-dusk_aspect
		dxSetShaderValue(skydome_shader, "gAlpha", dusk_aspect)
	end
	
	if (hour <= 2) then
		dxSetShaderValue(skydome_shader, "gAlpha", 0)
	end
	
	if (hour > 2) and (hour <= 6) then
		local dawn_aspect = ((hour-3)*60+minute)/180
		dawn_aspect = dawn_aspect
		dxSetShaderValue(skydome_shader, "gAlpha", dawn_aspect)
	end
	
	if (hour > 6) and (hour < 20) then
		dxSetShaderValue(skydome_shader, "gAlpha", 1)
	end
	
	getLastTick = getTickCount()
end

local function runShader()
	if (not skydome_shader) or (not null_shader) then return end
	setCloudsEnabled(false)
	
	local skydomeTexture = dxCreateTexture("skybox_12/textures/skydome.jpg")
	dxSetShaderValue(skydome_shader, "gTEX", skydomeTexture)
	dxSetShaderValue(skydome_shader, "gAlpha", 1)
	dxSetShaderValue(skydome_shader, "makeAngular", makeAngular)
	dxSetShaderValue(skydome_shader, "gObjScale", sphereShadScale)
	dxSetShaderValue(skydome_shader, "gTexScale", sphereTexScale)
	dxSetShaderValue(skydome_shader, "gColorAdd", ColorAdd)
	dxSetShaderValue(skydome_shader, "gColorPow", ColorPow)
	engineApplyShaderToWorldTexture(skydome_shader, "skybox_tex") 
	
	if (shadCloudsTexDisabled) then
		engineApplyShaderToWorldTexture(null_shader, "cloudmasked*")
	end
	
	txd_skybox = engineLoadTXD("skybox_12/models/skybox_model.txd")
	engineImportTXD(txd_skybox, modelID)
	dff_skybox = engineLoadDFF("skybox_12/models/skybox_model.dff", modelID)
	engineReplaceModel(dff_skybox, modelID)  

	local cam_x, cam_y, cam_z = getElementPosition(localPlayer)
	skyBoxBoxa = createObject(modelID, cam_x, cam_y, cam_z, 0, 0, 0, true)
	setObjectScale(skyBoxBoxa, sphereObjScale)
	--setElementAlpha(skyBoxBoxa, 1) -- Disable night-time visibility
	addEventHandler("onClientHUDRender", root, renderSphere)
	addEventHandler("onClientHUDRender", root, renderTime)
	applyWeatherInfluence()
	
	isRunning = true
end

local function disableShader()
	if (not isRunning) then return end
	removeEventHandler("onClientHUDRender", root, renderSphere)
	removeEventHandler("onClientHUDRender", root, renderTime)
	
	if (isElement(skyBoxBoxa)) then
		destroyElement(skyBoxBoxa)
	end
	
	if (isElement(skydome_shader)) then
		destroyElement(skydome_shader)
	end
	
	if (isElement(null_shader)) then
		destroyElement(null_shader)
	end
	
	skyBoxBoxa = nil
	skydome_shader = nil
	null_shader = nil
	isRunning = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 9)) then
		skydome_shader = dxCreateShader("skybox_12/shaders/shader_skydome.fx", 0, 0, true, "object")
		null_shader = dxCreateShader("skybox_12/shaders/shader_null.fx")
		
		runShader()
	end
end
addEventHandler("onClientResourceStart", resourceRoot, enableShader)

addEvent(":_setShader_:", true)
addEventHandler(":_setShader_:", root,
	function(shaderID, shaderState)
		if (not tonumber(shaderID)) or (shaderState == nil) then return end
		local shaderID = tonumber(shaderID)
		if (shaderID == thisShader) then
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 9)) then
				enableShader()
			end
		end
	end
)