local foreach = AcquirePackage("foreach","1.0.0")

return function(a,b,n)
	n = n or 2
	local function grams(str)
		local result = {}
		for i = 1, #str - n + 1 do
			result[str:sub(i,i + n - 1)] = true
		end
		return result
	end

	local aGrams, bGrams = grams(a), grams(b)
	local matches = 0

	foreach(aGrams, function(gram)
		if bGrams[gram] then
			matches += 1
		end
	end)
	return matches
end
