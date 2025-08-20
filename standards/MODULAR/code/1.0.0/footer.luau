
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
