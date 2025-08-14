local function map(array,func,...)
	local len = #array
	local result = table.create(len)
	for i = 1, len do
		 table[i] = func(array[1],...)
	end
	return result
end
