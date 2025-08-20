return {
	ChangeProperty = function(array,property,value)
		foreach(array,function(item)
			item[property] = value
		end)
	end,
	Run = function(array,method,...)
		map(array, function(item,...)
			item[method](item,...)
		end)
	end
}
