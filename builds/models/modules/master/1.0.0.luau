local PROTOCOL = { name = "MODULAR", version = "1.0.0" }
local GLOBALS, HandleCommand, pm 

local MODULE_META= {
	name = "UnknownModule",
	displayName = "Sound System",
	commands = {}
}
local commands = MODULE_META.commands

local AfterInit = function() end

local function INIT(sender,globals)
	if sender.PartLocked ~= Microcontroller.PartLocked then return end
	GLOBALS = globals
	if GLOBALS.packageManager ~= Microcontroller then
		GLOBALS.packageManager:Send("REQ_PM")
		local s,c,x = Microcontroller:Receive()
		pm = x
	end
	AfterInit()
	HandleCommand = PostInitHandleCommand
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



local known = {
	Modules = { Master = {
		software = { version = "1.0.0" },
		hardware = { version = "1.0.0" }
	},
	CLI = {
		reference = 123, 
		software = { version = "1.0.0" },
		hardware = { version = "1.0.0" },
		cout = { privilages = "CLI_OUT", }
	}
	
},
	Players = { [Microcontroller:GetOwnerId()] = "root" }
}


local function HandleCall(sender, message) 
	local call = message.call

	if call then
		local command = call.command
		if typeof(command) == "table" then
			if known.Modules[command[1]] then
				known.Modules[command[1]].command[2](command[3])	-- sth like that, just executing method on known module
			else
				error("Master doesnt know module named \""..tostring(command[1]).."\"",0)
			end
		else
			error("Master tried handling call with command not being a table, command: "..tostring(command),0)
		end
	end
end


local function Shutdown() Microcontroller:Shutdown() end


known.Modules.Master.Shutdown = { privilages = nil, }

while true do
	pcall(task.spawn,HandleCall(Microcontroller:Receive()))
end


-----------------------MODULAR-FOTTER-------------------------
local function PreInitHandleCommand(sender,command,...) 
	local _command = commands[command]
	local preInitCommands = { RES_INIT = true, REQ_PROTOCOL = true, REQ_MODULE_META = true }
	if preInitCommands[command] then
		_command(sender,...)
	else
		warn(MODULE_META.displayName .. ": Receive call for command \""..tostring(command).."\" (Before init)",0)
	end
end

local function PostInitHandleCommand(sender,command,...) 
	local _command = commands[command]
	if _command then
		task.spawn(_command,sender,...)
	else
		warn(MODULE_META.displayName .. ": Receive call for command \""..tostring(command).."\"",0)
	end
end

HandleCommand = PreInitHandleCommand 
while true do HandleCommand(Microcontroller:Receive()) end
