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
DebugResults = {}
contrastPool = {}
contrastPool.list = {}

function contrastPool.frameStart()
	for rt,info in pairs(contrastPool.list) do
		info.bInUse = false
	end
end

function contrastPool.GetUnused(sx, sy)
	for rt,info in pairs(contrastPool.list) do
		if (not info.bInUse) and (info.sx == sx) and (info.sy == sy) then
			info.bInUse = true
			return rt
		end
	end
	
	local rt = dxCreateRenderTarget(sx, sy)
	if (rt) then
		contrastPool.list[rt] = {
			bInUse = true,
			sx = sx,
			sy = sy
		}
	end
	return rt
end

function contrastPool.clear()
	for rt,info in pairs(contrastPool.list) do
		destroyElement(rt)
	end
	contrastPool.list = {}
end

function DebugResults.frameStart()
	DebugResults.items = {}
end

function DebugResults.addItem(rt, label)
	table.insert(DebugResults.items, {
		rt = rt,
		label = label
	})
end

function DebugResults.drawItems(sizeX, sliderX, sliderY)
	local posX = 5
	local gapX = 4
	local sizeY = sizeX*90/140
	local textSizeY = 15+10
	local posY = 5
	local textColor = tocolor(0, 255, 0, 255)
	local textShad = tocolor(0, 0, 0, 255)
	
	local numImages = #DebugResults.items
	local totalWidth = numImages*sizeX+(numImages-1)*gapX
	local totalHeight = sizeY+textSizeY
	
	posX = posX - (totalWidth-(sx-10))*sliderX/100
	posY = posY - (totalHeight-sy)*sliderY/100
	
	local textY = posY+sizeY+1
	for index,item in ipairs(DebugResults.items) do
		dxDrawImage(posX, posY, sizeX, sizeY, item.rt)
		local sizeLabel = string.format("%d) %s %dx%d", index, item.label, dxGetMaterialSize(item.rt))
		dxDrawText(sizeLabel, posX+1.0, textY+1, posX+sizeX+1.0, textY+16, textShad, 1, "arial", "center", "top", true)
		dxDrawText(sizeLabel, posX, textY, posX+sizeX, textY+15, textColor, 1, "arial", "center", "top", true)
		posX = posX+sizeX+gapX
	end
end