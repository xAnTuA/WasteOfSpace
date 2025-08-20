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

