local prefixes = {
	[";"] = true,
	[":"] = true
}

local function AddPrefix(newPrefix)
	prefixes[newPrefix] = true
end

local function SwapPrefixTo(newPrefix)
	prefixes = { [newPrefix] = true }
end
