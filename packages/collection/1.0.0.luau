local foreach = pm.RequirePackage("foreach","1.0.0")
local map = pm.RequirePackage("map","1.0.0")

return {
	ChangeProperty = function(array,property,value)
		foreach(array,function(item)
			item[property] = value
		end)
	end,
	Run = function(array,method,...)
		return map(array, function(item,...)
			return item[method](item,...)
		end,...)
	end
}
