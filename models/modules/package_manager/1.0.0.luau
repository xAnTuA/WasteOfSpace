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


local PROTOCOL = { name = "MSH", version = "1.0.0" }
local MODULE_METATABLE = {
	name = "PackageManager",
	version = "1.0.0"
	methods = {
		REQ_PKG = handlePackageRequire 
	}
}
-- REQ_PROTOCOL
repeat local s,c,x = Microcontroller:Receive(); if(s.PartLocked ~= Microcontroller.PartLocked) then continue end; if c == "RES_INIT" then return assert(loadstring(x))() elseif c == "REQ_MODULE_META" then s:Send("RES_MODULE_META",MODULE_METATABLE) end until false


--local disk = assert(GetPart("Disk"),"Package Manager: disk is nil")

local loadedPackages = { 
	printx = {
		["1.0.0"] = function()
			print("x")
		end
	}
}

local function ProvidePackage(target,package,version)
	target:Send("RES_PAC",package,loadedPackages[package][version])	
end

local function SavePackage(name,version,content)
--	disk:Write(name.."-"..version,content) -- maybe other structure would be better?
end

local function GetPackage(url)end

local function handlePackageRequire(sender, package, version)
	
end


local funcs = { REQ_PKG = ProvidePackage }

local function handleMessage(sender, command, ...) -- possibly should be better if we got it from init
	local func = funcs[command]
	if func then
		func(sender,...)	
	else
		warn("Package Manager: "..sender.." called command ".. command .. " that does not exist")
	end
end

while true do
	handleMessage(Microcontroller:Receive())
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
