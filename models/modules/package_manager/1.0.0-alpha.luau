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


local PROTOCOL = { name = "MODULAR", version = "1.0.0"}
-- musimy sie jakos odroznic / gdzies zdefiniowac kim jestesmy
--
-- najpierw czekamy na starter kit - cos co kazdy modul posiada / co ma wspulne

-- wspulne:
-- globalne wartosci,
-- 3 komendy, init, protocol i module meta,
-- petla czekania na komende, i przetwarzanie jej,
--
-- requirePackage -- nie potrzebujemy promise, jezeli jest to asynch task, i funckcja zwraca wartosc
--
-- w takim razie liepiej zrobic object packetMenagera, ktory ma swoje kolalne variables, i jest wstanie dostac nowe pakiety z sieci. i udostepnic obiekt i jego funckcje, jezeli pytajacy ma tego samego wlasciciela badz ma uprawnienia


local PackageManager = {}
PackageManager.__Index = PackageManager


function PackageManager.Require(package,version)

	return package
end

-- podajemy jakie pakiety potrzebujemy - dostajemy do nich referencje


-- implementcja funkcjonalnosci


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
