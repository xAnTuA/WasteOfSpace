MODULE.status = "WAITING_FOR_INIT" 
local lastProtocolInfoSendTo = nil

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
		if not env then env = {} end
		env.INITIALIZER =  nil
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
	if #args == 1 and args[1].protocol and lastProtocolInfoSendTo ~= sender then
		lastProtocolInfoSendTo = sender
		sender:Send(PROTOCOL)
		return	
	end

	local call = args[2].call

	if call and call.type == "request" then
		local command = call.command :: string
		local _command = COMMANDS[command] 

		if _command then
			_command(sender,call)
		end
	end
end

while true do HandleReceive(Microcontroller:Receive()) end
