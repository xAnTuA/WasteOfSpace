MODULE.status = "WAITING_FOR_INIT" 

local PROTOCOL = {
	protocol = {
		name = "MODULAR_BOOT",
		version = { 1,0,0 },
		author = "AnTuA",
		url = ""
	}
}

local COMMANDS = {
	INIT = function(sender,call)
		local payload = call.payload
		local func = loadstring(payload.code)
		local env = payload.env
		if env then env {}; env.INITIALIZER end
		setfenv(func, env) -- we shall pass info to confirm that init was successful too
		xpcall(func(),call.payload.errorHandler)
	end,
	MODULE_INFO = function(sender,call)
		local newCall = {
			type = "response",
			callId = call.callId,
			code = 200,
			payload = {
				module_info = MODULE
			}
		}
		sender:Send(PROTOCOL,newCall)	
	end
}

local function HandleReceive(sender,...)
	local args = {...}
	if #args == 1 and args[1].protocol then sender:Send(PROTOCOL) end
	local call = args[2].call

	if call and call.type == "request" then
		local command = call.command
		local _command = COMMANDS[command]

		if _command then
			_command(sender,call)
		end
	end
end
