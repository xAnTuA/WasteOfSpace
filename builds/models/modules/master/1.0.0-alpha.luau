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


-- THIS SCRIPT START FIRST 
-- we set globals that we will later provide to other modules, they should be unable to be modified from other modules, as same as security
local GLOBALS = {
	packageManager = GetPartFromPort(1,"Microcontroller"),
	modem = GetPart("Modem"),
	master = Microcontroller
}
--local PRIVILAGES = setmetatable({},{})

-- so basicaly this is a system boot, not yet a functional module





GLOBALS.packageManager:Send("REQ_INIT",GLOBALS)


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
