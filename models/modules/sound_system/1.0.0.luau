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
	pm = GLOBALS.PacketManager
	AfterInit()
	HandleCommand = PostInitHandleCommand
end

local function ProvideProtocolTo(target)
	target:Send("RES_PROTOCOL", PROTOCOL)
end

local function ProvideMetaTo(target)
	target:Send("RES_MODULE_META",MODULE_META)
end

commands = {
	RES_INIT = INIT,
	REQ_PROTOCOL = ProvideProtocolTo,
	REQ_MODULE_META = ProvideMetaTo,
}
-----------------------MODULAR-HEADER-------------------------


MODULE_META.name = "SoundSystem"
MODULE_META.displayName = "Sound System"

local Collection
afterInit = function()
	Collection = pm:RequirePackage("collection","1.0.0")
end

---------------FUNCTIONALITY-OF-MODULE--------------------
local speakers = GetParts("Speaker")
local quee = {}
local currentQueePossition = 1

local function LoadSoundFromQuee(queePossition)
	quee[queePossition] = Collection.Run(speakers,"LoadSound", "rbxassetid://"..quee[queePossition]) 
end

local function PlayQueeSound(queePossition) 
	Collection.Run(quee[queePossition],"Play") 
end

local function AddToQuee(soundId)
	table.insert(quee,soundId)
end

local function SetVolume(volume) 
	Collection.ChangeProperty(speakers,"Volume",volume)
end

local function UpdateSpeakers() speakers = GetParts("Speakers") end


commands.REQ_Add = AddToQuee
commands.REQ_SetVolume = SetVolume
commands.REQ_UpdateSpeakers = UpdateSpeakers


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
