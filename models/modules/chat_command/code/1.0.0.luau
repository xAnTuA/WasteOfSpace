local parseOnlyCommands = true

local commandPrefixes = {
	[";"] = true,
	[":"] = true
}
local aliases = {
	["shutdown"] = { "Master", "Shutdown" }
}

local function AddPrefix(newPrefix)
	commandPrefixes[newPrefix] = true
end

local function SwapPrefixTo(newPrefix)
	commandPrefixes = { [newPrefix] = true }
end

local function ParseUserMessage(input: string)
	local isCommand = commandPrefixes[input:sub(1,1)]

	if not parseOnlyCommands or isCommand then
		local startIndex = isCommand and 2 or 1
		local tokens = {}
		local current = ""
		local escape = false
		local inQuotes = false
		
		local function addToken()
			tokens[#tokens+1] = current
			current = ""
		end

		for i = startIndex,#input do
			local c = input:sub(i,i)		

			if escape then
				current ..= c
				escape = false

			elseif c == "\\" then
				escape = true

			elseif c == '"' then
				inQuotes = not inQuotes

			elseif not inQuotes then
				if c == " " or c == "\t" then
				addToken()
			else
				local twoChars = input:sub(i, i+1)
				if twoChars == ">>" or twoChars == "&&" or twoChars == "||" then
					addToken()
					table.insert(tokens, twoChars)
					continue
				elseif c == "|" or c == ">" or c == "<" then
					addToken()
					table.insert(tokens, c)
				else
					current ..= c
				end
				end

			else
				-- inside quotes, just append chars including spaces
				current ..= c
			end
		end

		addToken()

		return tokens
	end

	return false
end
