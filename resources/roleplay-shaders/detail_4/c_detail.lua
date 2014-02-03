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

local thisShader = 10

local function disableShader()
	if (not isShowing) then return end
	for _,part in ipairs(effects) do
		if part then
			destroyElement(part)
		end
	end
	
	effects = {}
	isValid = false
	isShowing = false
end
addEventHandler("onClientResourceStop", resourceRoot, disableShader)

local function enableShader()
	disableShader()
	
	if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 10)) then
		detail22Texture = dxCreateTexture("detail_4/images/detail22.png", "dxt3")
		detail58Texture = dxCreateTexture("detail_4/images/detail58.png", "dxt3")
		detail68Texture = dxCreateTexture("detail_4/images/detail68.png", "dxt1")
		detail63Texture = dxCreateTexture("detail_4/images/detail63.png", "dxt3")
		dirtyTexture = dxCreateTexture("detail_4/images/dirty.png", "dxt3")
		detail04Texture = dxCreateTexture("detail_4/images/detail04.png", "dxt3")
		detail29Texture = dxCreateTexture("detail_4/images/detail29.png", "dxt3")
		detail55Texture = dxCreateTexture("detail_4/images/detail55.png", "dxt3")
		detail35TTexture = dxCreateTexture("detail_4/images/detail35T.png", "dxt3")
		
		brickWallShader = getBrickWallShader()
		
		if (brickWallShader) then
			grassShader = getGrassShader()
			roadShader = getRoadShader()
			road2Shader = getRoad2Shader()
			paveDirtyShader = getPaveDirtyShader()
			paveStretchShader = getPaveStretchShader()
			barkShader = getBarkShader()
			rockShader = getRockShader()
			mudShader = getMudShader()
			concreteShader = getBrickWallShader()
			sandShader = getMudShader()
		end
		
		effects = {
			detail22Texture, detail58Texture, detail68Texture, detail63Texture, dirtyTexture,
			detail04Texture, detail29Texture, detail55Texture, detail35TTexture,
			brickWallShader, grassShader, roadShader, road2Shader, paveDirtyShader,
			paveStretchShader, barkShader, rockShader, mudShader, concreteShader, sandShader
		}
		
		isValid = true
		for _,part in ipairs(effects) do
			isValid = part and isValid
		end
		
		isShowing = true
		
		if (not isValid) then
			disableDetail()
		else
			engineApplyShaderToWorldTexture(roadShader, "*road*")
			engineApplyShaderToWorldTexture(roadShader, "*tar*")
			engineApplyShaderToWorldTexture(roadShader, "*asphalt*")
			engineApplyShaderToWorldTexture(roadShader, "*freeway*")
			engineApplyShaderToWorldTexture(concreteShader, "*wall*")
			engineApplyShaderToWorldTexture(concreteShader, "*floor*")
			engineApplyShaderToWorldTexture(concreteShader, "*bridge*")
			engineApplyShaderToWorldTexture(concreteShader, "*conc*")
			engineApplyShaderToWorldTexture(concreteShader, "*drain*")
			engineApplyShaderToWorldTexture(paveDirtyShader, "*walk*")
			engineApplyShaderToWorldTexture(paveDirtyShader, "*pave*")
			engineApplyShaderToWorldTexture(paveDirtyShader, "*cross*")
			
			engineApplyShaderToWorldTexture(mudShader, "*mud*")
			engineApplyShaderToWorldTexture(mudShader, "*dirt*")
			engineApplyShaderToWorldTexture(rockShader, "*rock*")
			engineApplyShaderToWorldTexture(rockShader, "*stone*")
			engineApplyShaderToWorldTexture(grassShader, "*grass*")
			engineApplyShaderToWorldTexture(grassShader, "desertgryard256")	-- grass
			
			engineApplyShaderToWorldTexture(sandShader, "*sand*")
			engineApplyShaderToWorldTexture(barkShader, "*leave*")
			engineApplyShaderToWorldTexture(barkShader, "*log*")
			engineApplyShaderToWorldTexture(barkShader, "*bark*")
			
			engineApplyShaderToWorldTexture(roadShader, "*carpark*")
			engineApplyShaderToWorldTexture(road2Shader, "*hiway*")
			engineApplyShaderToWorldTexture(roadShader, "*junction*")
			engineApplyShaderToWorldTexture(paveStretchShader, "snpedtest*")
			
			engineApplyShaderToWorldTexture(paveStretchShader, "sidelatino*")
			engineApplyShaderToWorldTexture(paveStretchShader, "sjmhoodlawn41")
			
			for i,part in ipairs(effects) do
				if (getElementType(part) == "shader") then
					engineRemoveShaderFromWorldTexture(part, "tx*")
					engineRemoveShaderFromWorldTexture(part, "lod*")
				end
			end
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
			if (exports['roleplay-settings']:isSettingEnabled(localPlayer, 10)) then
				enableShader()
			end
		end
	end
)

function getBrickWallShader()
	return getMakeShader(getBrickWallSettings())
end

function getGrassShader()
	return getMakeShader(getGrassSettings())
end

function getRoadShader()
	return getMakeShader(getRoadSettings())
end

function getRoad2Shader()
	return getMakeShader(getRoad2Settings())
end

function getPaveDirtyShader()
	return getMakeShader(getPaveDirtySettings())
end

function getPaveStretchShader()
	return getMakeShader(getPaveStretchSettings())
end

function getBarkShader()
	return getMakeShader(getBarkSettings())
end

function getRockShader()
	return getMakeShader(getRockSettings())
end

function getMudShader()
	return getMakeShader(getMudSettings())
end

function getMakeShader(v)
	local shader = dxCreateShader("detail_4/shaders/detail.fx", 1, 100)
	if (shader) then
		dxSetShaderValue(shader, "sDetailTexture", v.texture);
		dxSetShaderValue(shader, "sDetailScale", v.detailScale)
		dxSetShaderValue(shader, "sFadeStart", v.sFadeStart)
		dxSetShaderValue(shader, "sFadeEnd", v.sFadeEnd)
		dxSetShaderValue(shader, "sStrength", v.sStrength)
		dxSetShaderValue(shader, "sAnisotropy", v.sAnisotropy)
	end
	return shader
end

function getBrickWallSettings()
	local v = {}
	v.texture = detail22Texture
	v.detailScale = 3
	v.sFadeStart = 60
	v.sFadeEnd = 100
	v.sStrength = 0.6
	v.sAnisotropy = 1
	return v
end

function getGrassSettings()
	local v = {}
	v.texture = detail58Texture
	v.detailScale = 2
	v.sFadeStart = 60
	v.sFadeEnd = 100
	v.sStrength = 0.6
	v.sAnisotropy = 1
	return v
end

function getRoadSettings()
	local v = {}
	v.texture = detail68Texture
	v.detailScale = 1
	v.sFadeStart = 60
	v.sFadeEnd = 100
	v.sStrength = 0.6
	v.sAnisotropy = 1
	return v
end

function getRoad2Settings()
	local v = {}
	v.texture = detail63Texture
	v.detailScale = 1
	v.sFadeStart = 90
	v.sFadeEnd = 100
	v.sStrength = 0.7
	v.sAnisotropy = 0.9
	return v
end

function getPaveDirtySettings()
	local v = {}
	v.texture = dirtyTexture
	v.detailScale = 1
	v.sFadeStart = 60
	v.sFadeEnd = 100
	v.sStrength = 0.4
	v.sAnisotropy = 1
	return v
end

function getPaveStretchSettings()
	local v = {}
	v.texture = detail04Texture
	v.detailScale = 1
	v.sFadeStart = 80
	v.sFadeEnd = 100
	v.sStrength = 0.3
	v.sAnisotropy = 1
	return v
end

function getBarkSettings()
	local v = {}
	v.texture = detail29Texture
	v.detailScale = 1
	v.sFadeStart = 80
	v.sFadeEnd = 100
	v.sStrength = 0.6
	v.sAnisotropy = 1
	return v
end

function getRockSettings()
	local v = {}
	v.texture = detail55Texture
	v.detailScale = 1
	v.sFadeStart = 80
	v.sFadeEnd = 100
	v.sStrength = 0.5
	v.sAnisotropy = 1
	return v
end

function getMudSettings()
	local v = {}
	v.texture = detail35TTexture
	v.detailScale = 2
	v.sFadeStart = 80
	v.sFadeEnd = 100
	v.sStrength = 0.6
	v.sAnisotropy = 1
	return v
end