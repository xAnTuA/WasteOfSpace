local function foreach(array,func)
	local len = #array
	for  i = 1, len do
		func(array[i])
	end
end
