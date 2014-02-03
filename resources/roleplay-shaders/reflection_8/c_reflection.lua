--[[
	- FairPlay Gaming: Roleplay
	Resource content and structure is copyrighted to the authors of the resource.
	Copying and/or re-distribution of the content and structure is prohibited.
	(c) Copyright 2013 FairPlay Gaming. All rights reserved.
]]

local thisShader = 13
local scx, scy = guiGetScreenSize()
local scx = scx/2
local scy = scy/2
local settings = {
	["var"] = {
		["bloom"] = 1.176,
		["xzoom"] = 1,
		["yzoom"] = 0.78,
		["bFac"] = 0.5,
		["xval"] = 0.00,
		["yval"] = -0.02,
		["efInte"] = 0.6,
		["brFac"] = 0.5
	}
}

local removeList = {
	"",												-- unnamed
	"basketball2","skybox_tex",	   				    -- other
	"muzzle_texture*",								-- guns
	"font*","radar*",								-- hud
	"fireba*",
	"vehicle*", "?emap*", "?hite*",					-- vehicles
	"*92*", "*wheel*", "*interior*",				-- vehicles
	"*handle*", "*body*", "*decal*",				-- vehicles
	"*8bit*", "*logos*", "*badge*",					-- vehicles
	"*plate*", "*sign*", "*headlight*",				-- vehicles
	"vehiclegeneric256","vehicleshatter128", 		-- vehicles
	"*shad*",										-- shadows
	"coronastar","coronamoon","coronaringa",
	"coronaheadlightline",							-- coronas
	"lunar",										-- moon
	"tx*",											-- grass effect
	--"lod*",										-- lod models
	"cj_w_grad",									-- checkpoint texture
	"*cloud*",										-- clouds
	"*smoke*",										-- smoke
	"sphere_cj",									-- nitro heat haze mask
	"particle*",									-- particle skid and maybe others
	"water*","newaterfal1_256",
	--"sw_sand", "coral",							-- sea
	"boatwake*","splash_up","carsplash_*",			-- splash
	"gensplash","wjet4","bubbles","blood*",			-- splash
	--"sm_des_bush*", "*tree*", "*ivy*", "*pine*",	-- trees and shrubs
	--"veg_*", "*largefur*", "hazelbr*", "weeelm",
	--"*branch*", "cypress*", "plant*", "sm_josh_leaf",
	--"trunk3", "*bark*", "gen_log", "trunk5","veg_bush2", 
	"fist","*icon","headlight*",
	"unnamed",
}

function applyBumpToTexture(fakeBumpMapShader)
	engineApplyShaderToWorldTexture(fakeBumpMapShader, "*")
	dxSetShaderValue(fakeBumpMapShader, "xzoom", settings.var.xzoom)
	dxSetShaderValue(fakeBumpMapShader, "yzoom", settings.var.yzoom)
	dxSetShaderValue(fakeBumpMapShader, "bFac", settings.var.bFac)	
	dxSetShaderValue(fakeBumpMapShader, "xval", settings.var.xval)
	dxSetShaderValue(fakeBumpMapShader, "yval", settings.var.yval)	
    dxSetShaderValue(fakeBumpMapShader, "efInte", settings.var.efInte)	
    dxSetShaderValue(fakeBumpMapShader, "brFac", settings.var.brFac)
	
	for _,removeMatch in ipairs(removeList) do
		engineRemoveShaderFromWorldTexture(fakeBumpMapShader, removeMatch)
	end
end

local function disableShader()
	if (not isShowing) then return end
	if (isElement(blurHShader)) then
		destroyElement(blurHShader)
	end
	
	if (isElement(blurVShader)) then
		destroyElement(blurVShader)
	end
	
	if (isElement(fakeBumpMapShader)) then
		destroyElement(fakeBumpMapShader)
	end
	
	removeEventHandler("onClientHUDRender", root, renderReflection)
	
	blurHShader = nil
	blurVShader = nil
	fakeBumpMapShader = nil
	isValid = false
	isShowing = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 13)) then
		myScreenSource = dxCreateScreenSource(scx, scy)
		
		blurHShader = dxCreateShader("reflection_8/shaders/blurH.fx")
		blurVShader = dxCreateShader("reflection_8/shaders/blurV.fx")
		fakeBumpMapShader = dxCreateShader("reflection_8/shaders/shader_bump.fx", 1, 400, false, "world,object")
		
		if (not fakeBumpMapShader) then return end
		applyBumpToTexture(fakeBumpMapShader)
		
		isValid = (myScreenSource) and (blurHShader) and (blurVShader) and (fakeBumpMapShader)
		if (isValid) then
			isShowing = true
			addEventHandler("onClientHUDRender", root, renderReflection)
		else
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
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 13)) then
				enableShader()
			end
		end
	end
)

function renderReflection()
	if (not isShowing) or (not settings.var) or (not isValid) then return end
	reflectPool.frameStart()
	dxUpdateScreenSource(myScreenSource)
	current = myScreenSource
	current = applyGBlurH(current, settings.var.bloom)
	current = applyGBlurV(current, settings.var.bloom)
	dxSetRenderTarget()
	dxSetShaderValue(fakeBumpMapShader, "sReflectionTexture", current)
end

function applyGBlurH(src, bloom)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = reflectPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(blurHShader, "TEX0", src)
	dxSetShaderValue(blurHShader, "TEX0SIZE", mx, my)
	dxSetShaderValue(blurHShader, "BLOOM", bloom)
	dxDrawImage(0, 0, mx, my, blurHShader)
	return newRT
end

function applyGBlurV(src, bloom)
	if (not src) then return nil end
	local mx, my = dxGetMaterialSize(src)
	local newRT = reflectPool.GetUnused(mx, my)
	if (not newRT) then return nil end
	dxSetRenderTarget(newRT, true) 
	dxSetShaderValue(blurVShader, "TEX0", src)
	dxSetShaderValue(blurVShader, "TEX0SIZE", mx, my)
	dxSetShaderValue(blurVShader, "BLOOM", bloom)
	dxDrawImage(0, 0, mx, my, blurVShader)
	return newRT
end