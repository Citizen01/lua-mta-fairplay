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

local sx, sy = guiGetScreenSize()
local postGUI = false
local viewStep = 0
local isOnShow = false
local viewWait = 15000
local manual = false
local view = {
	[1] = {
		[1] = { --beach
			["posX"] 	=  355.18,
			["posY"] 	= -2015.13,
			["posZ"] 	=  10.34,
			["lookX"] 	=  384.77,
			["lookY"] 	= -2044.13,
			["lookZ"] 	=  13.75,
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  332.01,
			["posY"] 	= -2091.49,
			["posZ"] 	=  22.87,
			["lookX"] 	=  371.45,
			["lookY"] 	= -2035.22,
			["lookZ"] 	=  20.35
		}
	},
	[2] = { --skate
		[1] = {
			["posX"] 	=  1884.1,
			["posY"] 	= -1493.31,
			["posZ"] 	=  57.93,
			["lookX"] 	=  1866.06,
			["lookY"] 	= -1416.63,
			["lookZ"] 	=  56.95, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1952.36,
			["posY"] 	= -1441.8,
			["posZ"] 	=  57.23,
			["lookX"] 	=  1922.16,
			["lookY"] 	= -1399.36,
			["lookZ"] 	=  54.79
		}
	},
	[3] = { --hotel
		[1] = {
			["posX"] 	=  1735.21,
			["posY"] 	= -1551.46,
			["posZ"] 	=  59.11,
			["lookX"] 	=  1703.77,
			["lookY"] 	= -1589.86,
			["lookZ"] 	=  50.97, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1650.9,
			["posY"] 	= -1509.6,
			["posZ"] 	=  58.4,
			["lookX"] 	=  1629.38,
			["lookY"] 	= -1552.92,
			["lookZ"] 	=  51.61
		}
	},
	[4] = { --ash
		[1] = {
			["posX"] 	=  1270.75,
			["posY"] 	= -1448.81,
			["posZ"] 	=  60.67,
			["lookX"] 	=  1238.36,
			["lookY"] 	= -1419.34,
			["lookZ"] 	=  48.46, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1288.34,
			["posY"] 	= -1387.58,
			["posZ"] 	=  43.7,
			["lookX"] 	=  1236.03,
			["lookY"] 	= -1366.18,
			["lookZ"] 	=  27.63
		}
	},
	[5] = { --hollywood
		[1] = {
			["posX"] 	=  1234.71,
			["posY"] 	= -889.78,
			["posZ"] 	=  99.23,
			["lookX"] 	=  1272.56,
			["lookY"] 	= -831.81,
			["lookZ"] 	=  91.42, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1456,
			["posY"] 	= -886.55,
			["posZ"] 	=  86.06,
			["lookX"] 	=  1419.13,
			["lookY"] 	= -820.43,
			["lookZ"] 	=  77.92
		}
	},
	[6] = { --hollywood2
		[1] = {
			["posX"] 	=  1494.02,
			["posY"] 	= -868.41,
			["posZ"] 	=  71.7,
			["lookX"] 	=  1549.87,
			["lookY"] 	= -921.25,
			["lookZ"] 	=  71.62, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1409.22,
			["posY"] 	= -917.05,
			["posZ"] 	=  68.29,
			["lookX"] 	=  1333.67,
			["lookY"] 	= -926.57,
			["lookZ"] 	=  63.2
		}
	},
	[7] = { --bank
		[1] = {
			["posX"] 	=  634.39,
			["posY"] 	= -1199.82,
			["posZ"] 	=  19.65,
			["lookX"] 	=  629.48,
			["lookY"] 	= -1206.88,
			["lookZ"] 	=  17.1, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  625.68,
			["posY"] 	= -1212.96,
			["posZ"] 	=  20.24,
			["lookX"] 	=  610.22,
			["lookY"] 	= -1239.29,
			["lookZ"] 	=  38.65
		}
	},
	[8] = { --old dmv
		[1] = {
			["posX"] 	=  1084.2,
			["posY"] 	= -1661.73,
			["posZ"] 	=  43.92,
			["lookX"] 	=  1126.76,
			["lookY"] 	= -1711.3,
			["lookZ"] 	=  30.81, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1142.84,
			["posY"] 	= -1643.07,
			["posZ"] 	=  44.81,
			["lookX"] 	=  1197.27,
			["lookY"] 	= -1568.83,
			["lookZ"] 	=  67.34
		}
	},
	[9] = { --cityhall
		[1] = {
			["posX"] 	=  1361.47,
			["posY"] 	= -1632.74,
			["posZ"] 	=  57.47,
			["lookX"] 	=  1398.05,
			["lookY"] 	= -1662.05,
			["lookZ"] 	=  47.61, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1424.94,
			["posY"] 	= -1673.66,
			["posZ"] 	=  37.58,
			["lookX"] 	=  1445.65,
			["lookY"] 	= -1702.9,
			["lookZ"] 	=  52.3
		}
	},
	[10] = { --grove
		[1] = {
			["posX"] 	=  2215.87,
			["posY"] 	= -1741.28,
			["posZ"] 	=  58.25,
			["lookX"] 	=  2216.99,
			["lookY"] 	= -1797.69,
			["lookZ"] 	=  43.65, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  2235.32,
			["posY"] 	= -1726.06,
			["posZ"] 	=  46.16,
			["lookX"] 	=  2289.33,
			["lookY"] 	= -1699.87,
			["lookZ"] 	=  29.65
		}
	},
	[11] = { --montgomery
		[1] = {
			["posX"] 	=  1797.26,
			["posY"] 	=  612.6,
			["posZ"] 	=  46.67,
			["lookX"] 	=  1721.25,
			["lookY"] 	=  568.61,
			["lookZ"] 	=  38.12, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1456.22,
			["posY"] 	=  503.2,
			["posZ"] 	=  32.32,
			["lookX"] 	=  1382.97,
			["lookY"] 	=  429.48,
			["lookZ"] 	=  29.64
		}
	},
	[12] = { --lv
		[1] = {
			["posX"] 	=  1665.58,
			["posY"] 	=  837.97,
			["posZ"] 	=  28.36,
			["lookX"] 	=  1615.3,
			["lookY"] 	=  865.32,
			["lookZ"] 	=  21.72, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	=  1739.89,
			["posY"] 	=  838.43,
			["posZ"] 	=  31.35,
			["lookX"] 	=  1794.67,
			["lookY"] 	=  887.94,
			["lookZ"] 	=  34.54
		}
	},
	[13] = { --sf
		[1] = {
			["posX"] 	= -890.83,
			["posY"] 	=  659.15,
			["posZ"] 	=  108.86,
			["lookX"] 	= -973.88,
			["lookY"] 	=  715.54,
			["lookZ"] 	=  105.18, 
			["speed"]	=  15000
		},
		[2] = {
			["posX"] 	= -1032.87,
			["posY"] 	=  515.4,
			["posZ"] 	=  108.14,
			["lookX"] 	= -1144.52,
			["lookY"] 	=  539.62,
			["lookZ"] 	=  110.78
		}
	}
}

local function displayView()
	if (not isOnShow) then return end
	if (manual) then
		dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 0.4*255), postGUI)
		dxDrawRectangle(0, 0, sx, 100, tocolor(0, 0, 0, 255), postGUI)
		dxDrawRectangle(0, sy-100, sx, 100, tocolor(0, 0, 0, 255), postGUI)
	end
end

function startView()
	if (isTimer(amazingViewTimer)) then
		stopView() -- Just fuck everything up until the session is restarted
	end
	
	fadeCamera(true, 1.5)
	showChat(false)
	setElementFrozen(localPlayer, true)
	
	viewStep = 1
	setCameraMatrix(view[viewStep][1]["posX"], view[viewStep][1]["posY"], view[viewStep][1]["posZ"], view[viewStep][1]["lookX"], view[viewStep][1]["lookY"], view[viewStep][1]["lookZ"])
	
	launcherTimer = setTimer(function()
		smoothMoveCamera(view[viewStep][1]["posX"], view[viewStep][1]["posY"], view[viewStep][1]["posZ"], view[viewStep][1]["lookX"], view[viewStep][1]["lookY"], view[viewStep][1]["lookZ"], view[viewStep][2]["posX"], view[viewStep][2]["posY"], view[viewStep][2]["posZ"], view[viewStep][2]["lookX"], view[viewStep][2]["lookY"], view[viewStep][2]["lookZ"], view[viewStep][1]["speed"])
		
		amazingViewTimer = setTimer(function()
			if (isOnShow) then
				if (viewStep == #view) then
					viewStep = 1
				else
					viewStep = viewStep+1
				end
				
				smoothMoveCamera(view[viewStep][1]["posX"], view[viewStep][1]["posY"], view[viewStep][1]["posZ"], view[viewStep][1]["lookX"], view[viewStep][1]["lookY"], view[viewStep][1]["lookZ"], view[viewStep][2]["posX"], view[viewStep][2]["posY"], view[viewStep][2]["posZ"], view[viewStep][2]["lookX"], view[viewStep][2]["lookY"], view[viewStep][2]["lookZ"], view[viewStep][1]["speed"])
			else
				stopView()
			end
		end, view[viewStep][1]["speed"]+500, 0)
	end, 400, 1)
	
	addEventHandler("onClientRender", root, displayView)
	
	isOnShow = true
end
addEvent(":_runViewPoint_:", true)
addEventHandler(":_runViewPoint_:", root, startView)

function stopView()
	if (isTimer(launcherTimer)) then
		killTimer(launcherTimer)
	end
	
	if (isTimer(amazingViewTimer)) then
		killTimer(amazingViewTimer)
	end
	
	isOnShow = false
	viewStep = 0
	manual = false
	showChat(true)
	setElementFrozen(localPlayer, false)
	setCameraTarget(localPlayer)
	stopSmoothMoveCamera()
	removeEventHandler("onClientRender", root, displayView)
end
addEvent(":_stopViewPoint_:", true)
addEventHandler(":_stopViewPoint_:", root, startView)

addCommandHandler("view",
	function(cmd)
		if (not exports['roleplay-accounts']:isClientLeadAdmin(localPlayer)) then return end
		setCameraTarget(localPlayer)
		
		if (isOnShow == true) then
			stopView()
			manual = false
		else
			manual = true
			startView()
		end
	end
)