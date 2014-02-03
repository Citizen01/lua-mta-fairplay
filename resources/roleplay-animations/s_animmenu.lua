addEvent("AnimationSet",true)
addEventHandler("AnimationSet",getRootElement(), 
	function (block, ani, loop)
		if(source)then
			if(block)then
				if loop then
					setPedAnimation(source,block,ani,-1,loop)
				else
					setPedAnimation(source,block,ani,1,false)
				end
			else
				setPedAnimation(source)
			end
		end
	end)
	
addCommandHandler("anim",
	function (gracz, block, ani)
		if (getElementData(gracz, "roleplay:temp.isRefueling")) then return end
		if(block and ani)then
			triggerEvent("AnimationSet",gracz, tostring(block),tostring(ani), true)
		else
			triggerEvent("AnimationSet",gracz)
		end
	end)