local isEffectEnabled, maxEffectDistance, updateTimer = false, getFarClipDistance()
local snowShader, treeShader, naughtyTreeShader, noiseTexture
local snowApplyList = {
	"*",
}

local snowRemoveList = {
	"",	"vehicle*", "?emap*", "?hite*",
	"*92*", "*wheel*", "*interior*",
	"*handle*", "*body*", "*decal*",
	"*8bit*", "*logos*", "*badge*",
	"*plate*", "*sign*",
	"headlight", "headlight1",
	"shad*",
	"coronastar",
	"tx*",
	"lod*",
	"cj_w_grad",
	"*cloud*",
	"*smoke*",
	"sphere_cj",
	"particle*"
}

local treeApplyList = {
	"sm_des_bush*", "*tree*", "*ivy*", "*pine*",
	"veg_*", "*largefur*", "hazelbr*", "weeelm",
	"*branch*", "cypress*",
	"*bark*", "gen_log", "trunk5",
	"bchamae", "vegaspalm01_128",
}

local naughtyTreeApplyList = {
	"planta256", "sm_josh_leaf", "kbtree4_test", "trunk3",
	"newtreeleaves128", "ashbrnch", "pinelo128", "tree19mi",
	"lod_largefurs07", "veg_largefurs05","veg_largefurs06",
	"fuzzyplant256", "foliage256", "cypress1", "cypress2",
}

function disableShader()
	if (not isEffectEnabled) then
		return false
	end

	if (isElement(snowShader)) then
		destroyElement(snowShader)
		destroyElement(treeShader)
		destroyElement(naughtyTreeShader)
		destroyElement(noiseTexture)
	end
	
	resetSkyGradient()
	
	if (isTimer(updateTimer)) then
		killTimer(updateTimer)
	end
	
	isEffectEnabled = false
	return true
end
addEvent(":_disableSnowShader_:", true)
addEventHandler(":_disableSnowShader_:", root, disableShader)
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

function enableShader()
	disableShader()
	
	snowShader = dxCreateShader("snow/shaders/snow_ground.fx", 0, maxEffectDistance)
	treeShader = dxCreateShader("snow/shaders/snow_trees.fx" )
	naughtyTreeShader = dxCreateShader("snow/shaders/snow_naughty_trees.fx")
	noiseTexture = dxCreateTexture("snow/images/smallnoise3d.dds")
	
	if (not snowShader) or (not treeShader) or (not naughtyTreeShader) or (not noiseTexture) then
		return false
	end
	
	dxSetShaderValue(treeShader, "sNoiseTexture", noiseTexture)
	dxSetShaderValue(naughtyTreeShader, "sNoiseTexture", noiseTexture)
	dxSetShaderValue(snowShader, "sNoiseTexture", noiseTexture)
	dxSetShaderValue(snowShader, "sFadeEnd", maxEffectDistance)
	dxSetShaderValue(snowShader, "sFadeStart", maxEffectDistance-getFogDistance())
	
	for _,applyMatch in ipairs(snowApplyList) do
		engineApplyShaderToWorldTexture(snowShader, applyMatch)
	end
	
	for _,removeMatch in ipairs(snowRemoveList) do
		engineRemoveShaderFromWorldTexture(snowShader, removeMatch)
	end
	
	for _,applyMatch in ipairs(treeApplyList) do
		engineApplyShaderToWorldTexture(treeShader, applyMatch)
	end
	
	for _,applyMatch in ipairs(naughtyTreeApplyList) do
		engineApplyShaderToWorldTexture(naughtyTreeShader, applyMatch)
	end
	
	setSkyGradient(175, 175, 175, 175, 175, 175)
	
	updateTimer = setTimer(processShader, 2500, 0)
	
	isEffectEnabled = true
	return true
end
addEvent(":_enableSnowShader_:", true)
addEventHandler(":_enableSnowShader_:", root, enableShader)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local month = getRealTime().month
		if (month == 10) or (month == 11) or (month == 0) then
			if (getWeather() == 9) or (getWeather() == 12) or (getWeather() == 13) or (getWeather() == 14) or (getWeather() == 15) then
				enableShader()
			end
		end
	end
)

addEvent(":_setShader_:", true)
addEventHandler(":_setShader_:", root,
	function(shaderID, shaderState)
		if (not tonumber(shaderID)) or (shaderState == nil) then return end
		local shaderID = tonumber(shaderID)
		if (shaderID == thisShader) then
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 14)) then
				if (not isEffectEnabled) then
					enableShader()
				else
					disableShader()
				end
			end
		end
	end
)

function processShader()
	if (maxEffectDistance ~= getFarClipDistance()) then
		maxEffectDistance = getFarClipDistance()
		dxSetShaderValue(snowShader, "sFadeEnd", maxEffectDistance)
		dxSetShaderValue(snowShader, "sFadeStart", maxEffectDistance-getFogDistance())
	end
end

function setShaderEnabled(doEnableShader)
	if (doEnableShader) then
		return enableShader()
	else
		return disableShader()
	end
end

function isShaderEnabled()
	return (isEffectEnabled and isElement(snowShader))
end

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, false)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end, false, false
			)
		end
	end
end

addCommandHandler({"snowyground", "snowground", "togsnowground", "togsnowyground", "togglesnowground", "togglesnowyground"},
	function(cmd)
		if (isShaderEnabled) then
			disableShader()
		else
			enableShader()
		end
	end
)