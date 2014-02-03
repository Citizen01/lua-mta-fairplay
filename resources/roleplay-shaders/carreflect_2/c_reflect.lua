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