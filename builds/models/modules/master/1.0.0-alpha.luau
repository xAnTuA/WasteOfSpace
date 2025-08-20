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


-- THIS SCRIPT START FIRST 
-- we set globals that we will later provide to other modules, they should be unable to be modified from other modules, as same as security
local mcus = GetPartsFromPort(1,"Microcontroller")

local function otherMcu(mcus)
	for _,mcu in mcus do
		if mcu ~= Microcontroller then return mcu end
	end
end

local GLOBALS = {
	packageManager = otherMcu(mcus),
	modem = GetPart("Modem"),
	master = Microcontroller
}
--local PRIVILAGES = setmetatable({},{})

-- so basicaly this is a system boot, not yet a functional module



if GLOBALS.packageManager == Microcontroller then print("same mcu") end

GLOBALS.packageManager:Send("REQ_INIT",GLOBALS)
GLOBALS.packageManager:Send("HELLO")

local SoundSystem = GetPart("Microcontroller")
SoundSystem:Send("REQ_INIT",GLOBALS)
task.wait(10)
SoundSystem:Send("REQ_Add","102848347808845")
SoundSystem:Send("REQ_Play",1)


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
