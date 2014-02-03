DebugResults = {}

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