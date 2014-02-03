local PAINT_TYPE = "clean"
local skyLightIntensity = 0.20
local filmDepth = 0.05
local filmIntensity = 0.11

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if (getVersion().sortable < "1.3.3-9.05658") then
			return 
		end
		
		if (PAINT_TYPE == "clean") then
			local myShader,tec = dxCreateShader("carpaint/car_paint_clean.fx")
			if (myShader) then
				engineApplyShaderToWorldTexture(myShader, "vehiclegrunge256")
			end
		elseif (PAINT_TYPE == "reflection") then
			local myShader,tec = dxCreateShader("carpaint/car_paint.fx")
			
			if (myShader) then
				local textureVol = dxCreateTexture("carpaint/images/smallnoise3d.dds")
				local textureCube = dxCreateTexture("carpaint/images/cube_env256.dds")
				local textureFringe = dxCreateTexture("carpaint/images/ColorRamp01.png")
				
				dxSetShaderValue(myShader, "sRandomTexture", textureVol)
				dxSetShaderValue(myShader, "sReflectionTexture", textureCube)
				dxSetShaderValue(myShader, "sFringeMap", textureFringe)
				dxSetShaderValue(myShader, "gFilmDepth", filmDepth)
				dxSetShaderValue(myShader, "gFilmIntensity", filmIntensity)
				
				engineApplyShaderToWorldTexture(myShader, "vehiclegrunge256")
				engineApplyShaderToWorldTexture(myShader, "?emap*")
				
				local texturegrun = {
					"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
					"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
					"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
					"coach92interior128","combinetexpage128","hotdog92body256",
					"raindance92body128", "cargobob92body256", "andromeda92body", "at400_92_256", "nevada92body256",
					"polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , "seasparrow92floats64" , 
					"dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 
					"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256" 
				}
				
				for _,addList in ipairs(texturegrun) do
					engineApplyShaderToWorldTexture(myShader, addList)
				end
				
				if (skyLightIntensity ~= 0) then
					local pntBright = skyLightIntensity
					setTimer(function()
						if (myShader) then
							local rSkyTop, gSkyTop, bSkyTop, rSkyBott, gSkyBott, bSkyBott = getSkyGradient()
							local cx, cy, cz = getCameraMatrix()
							
							if (isLineOfSightClear(cx, cy, cz, cx, cy, cz+30, true, false, false, true, false, true, false, localPlayer)) then 
								pntBright = pntBright+0.015
							else
								pntBright = pntBright-0.015
							end
							
							if (pntBright > skyLightIntensity) then
								pntBright = skyLightIntensity
							end
							
							if (pntBright < 0) then
								pntBright = 0
							end
							
							dxSetShaderValue(myShader, "sSkyColorTop", pntBright*rSkyTop/255, pntBright*gSkyTop/255, pntBright*bSkyTop/255)
							dxSetShaderValue(myShader, "sSkyColorBott", pntBright*rSkyBott/255, pntBright*gSkyBott/255, pntBright*bSkyBott/255)
							
						end
					end, 50, 0)
				end
			end
		end
	end
)