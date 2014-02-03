function table.concat(tab,del,min,max,skiptable)
        --these check to make sure the arguments are correct.
        assert(type(tab) == "table", 
        "Bad argument #1 to 'concat'. (table expected, got "..type(tab)..")")           
        assert(type(del) == "string" or type(del)== "nil" or type(del)=="number", 
                "Bad argument #2 to 'concat'. (string expected, got "..type(del)..")")
        assert(type(min) == "number" or type(min)=="nil", 
                "Bad argument #3 to 'concat'. (number expected, got "..type(min)..")")
        assert(type(max) == "number" or type(max)=="nil", 
                "Bad argument #4 to 'concat'. (number expected, got "..type(max)..")")
        if type(skiptable) ~= "boolean" then skiptable = true end
        local tab = table.condense(tab, false)
        local concated = nil 
        local del = del or ""
        local min = min or 1
        max = max or #tab 
        for key,val in ipairs(tab) do
                local typ = type(tab[key])
                if key>=min and key<=max then
                        if typ == "string" or typ=="number" or typ=="nil" then
                                if tab[key]~=nil then
                                concated = (not concated and val) or (concated .. del .. val)
                                end
                        elseif not skiptable then
                                error("invalid value ("..typ..") at index "..key..[[ in 
                                       table for 'concat']])
                        end
                end
        end
        return concated or ""
end

function table.condense(tab,rewrite)
--this function condenses a tables numerical keys into the lowest it can.
--note, if rewrite is false, it will just return the condensed form. It will not rewrite the table.
--initiation of variables
        if type(rewrite) ~="boolean" then rewrite = true end
        local condensing = {}
        assert(type(tab) == "table", 
                "Bad item to 'condense'. (table expected, got "..type(tab)..")")
--part to get all the numeric pairs off.
        for key,value in pairs(tab) do 
                if type(key)=="number" then 
                        condensing[#condensing+1]=tab[key]
                        if rewrite then tab[key]=nil end
                end
        end
--part to stick them back in.
        if rewrite then
                for i=1,#condensing do 
                        tab[i]=condensing[i]
                end
        else
                 return condensing
        end
end

function condense(tab,rewrite)
	table.condense(tab,rewrite)
end