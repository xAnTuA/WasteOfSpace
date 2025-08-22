local PROTOCOL = { 
	protocol = {
		name = "MODULAR",
		version = { 1,0,0 },
		author = "AnTuA",
		url = "https://raw.githubusercontent.com/xAnTuA/WasteOfSpace/refs/heads/main/protocols/MODULAR/1.0.0.luau"
	}
}
local MODULE = { 
	name = "SoundSystem",
	version = {	1,0,0 },
	author = "AnTuA",
	url = "https://raw.githubusercontent.com/xAnTuA/WasteOfSpace/refs/heads/main/packages/Sound-System/1.0.0.luau"
}

local COMMANDS = {
	REQ_PROTOCOL = function(sender) sender:Send("PROTOCOL",PROTOCOL) end,
	REQ_MODULE_META = function(sender) sender:Send("INIT",MODULE) end,
	RES_INIT = function(sender,content,env,errorhandler,...)
		local code = loadstring(content)
		setfenv(code,env)
		xpcall(code,errorhandler,...)
	end
}

local function HandleCall(sender,command,callId,...)
	local _command = COMMANDS[command]
	if _command then 
		_command() 
	else
		sender:Send("ERROR",404,callId)
		warn(MODULE.name..": got call for non existing command \""..command.."\" before init",0)
	end
end

while true do HandleCall(Microcontroller:receive()) end 
