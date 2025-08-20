return function(array,func,...)
	local len = #array
	local result = table.create(len)
	for i = 1, len do
		 table[i] = func(array[i],...)
	end
	return result
end
