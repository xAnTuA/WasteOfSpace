local PROTOCOL = { name = "MODULAR", version = "1.0.0" }
local GLOBALS, HandleCommand
pm = nil

local MODULE_META= {
	name = "UnknownModule",
	displayName = "Sound System",
	commands = {},
	AfterInit = true
}
local commands = MODULE_META.commands

local function INIT(sender,globals)
	if sender.PartLocked ~= Microcontroller.PartLocked then return end
	GLOBALS = globals
	if GLOBALS.packageManager ~= Microcontroller then
		GLOBALS.packageManager:Send("REQ_PM")
		local s,c,x = Microcontroller:Receive()
		pm = x
	end
	MODULE_META.AfterInit()
	HandleCommand = function(sender,command,...) 
		local _command = commands[command]
		if _command then
			task.spawn(_command,sender,...)
		else
			warn(MODULE_META.displayName .. ": Receive call for not present command \""..tostring(command).."\"",0)
		end
	end
	commands.REQ_INIT = nil
end

local function ProvideProtocolTo(target)
	target:Send("RES_PROTOCOL", PROTOCOL)
end

local function ProvideMetaTo(target)
	target:Send("RES_MODULE_META",MODULE_META)
end

commands.REQ_INIT = INIT
commands.REQ_PROTOCOL = ProvideProtocolTo
commands.REQ_MODULE_META = ProvideMetaTo
-----------------------MODULAR-HEADER-------------------------


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


-----------------------MODULAR-FOTTER-------------------------
local function PreInitHandleCommand(sender,command,...) 
	local _command = commands[command]
	local preInitCommands = { REQ_INIT = true, REQ_PROTOCOL = true, REQ_MODULE_META = true }
	if preInitCommands[command] then
		_command(sender,...)
	else
		warn(MODULE_META.displayName .. ": Receive call for command \""..tostring(command).."\" (Before init)",0)
	end
end

HandleCommand = PreInitHandleCommand 
while true do HandleCommand(Microcontroller:Receive()) end
