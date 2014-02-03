_createObject = createObject

function createObject(model, x, y, z, rx, ry, rz, interior, dimension, alpha)
	local object = _createObject(model, x, y, z, (rx and rx or 0), (ry and ry or 0), (rz and rz or 0))
	
	if (interior) then
		setElementInterior(object, interior)
	end
	
	if (dimension) then
		setElementDimension(object, dimension)
	end
	
	if (alpha) then
		setElementAlpha(object, alpha)
	end
	
	return object
end