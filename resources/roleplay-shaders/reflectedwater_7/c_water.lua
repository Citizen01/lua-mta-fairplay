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

local thisShader = 11
myWaterShader = nil
local isShowing = false
local isSunEnabled = true

setWaveHeight(0.5)
setFPSLimit(0)

local function disableShader()
	if (not isShowing) then return end
	if (isElement(myWaterShader)) then
		if (isTimer(watTimer)) then
			killTimer(watTimer)
		end
		engineRemoveShaderFromWorldTexture(myWaterShader, "waterclear256")
		destroyElement(myWaterShader)
		myWaterShader = nil
	end
	
	if (isElement(textureVol)) then
		destroyElement(textureVol)
		textureVol = nil
	end
	
	if (isElement(textureCube)) then
		destroyElement(textureCube)
		textureCube = nil
	end
	
	isShowing = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 11)) then
		myWaterShader = dxCreateShader("reflectedwater_7/shaders/water.fx", 0, 0, false)
		
		if (myWaterShader) then
			if (isSunEnabled) then enableSunLight() end
			textureVol = dxCreateTexture("reflectedwater_7/images/wavemap.png")
			textureCube = dxCreateTexture("reflectedwater_7/images/cube_env256.dds")
			dxSetShaderValue(myWaterShader, "sRandomTexture", textureVol)
			dxSetShaderValue(myWaterShader, "sReflectionTexture", textureCube)
			engineApplyShaderToWorldTexture(myWaterShader, "waterclear256")
			watTimer = setTimer(function()
				if (myWaterShader) then
					local r, g, b, a = getWaterColor()
					dxSetShaderValue(myWaterShader, "sWaterColor", r/255, g/255, b/255, a/255)
					local rSkyTop, gSkyTop, bSkyTop, rSkyBott, gSkyBott, bSkyBott = getSkyGradient()
					dxSetShaderValue(myWaterShader, "sSkyColorTop", rSkyTop/255, gSkyTop/255, bSkyTop/255)
					dxSetShaderValue(myWaterShader, "sSkyColorBott", rSkyBott/255, gSkyBott/255, bSkyBott/255)
					
				end
			end, 100, 0)
		end
		
		isShowing = true
	end
end
addEventHandler("onClientResourceStart", resourceRoot, enableShader)

addEvent(":_setShader_:", true)
addEventHandler(":_setShader_:", root,
	function(shaderID, shaderState)
		if (not tonumber(shaderID)) or (shaderState == nil) then return end
		local shaderID = tonumber(shaderID)
		if (shaderID == thisShader) then
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 11)) then
				enableShader()
			end
		end
	end
)