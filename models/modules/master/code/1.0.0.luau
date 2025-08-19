
local known = {
	Modules = { Master = {
		software = { version = "1.0.0" },
		hardware = { version = "1.0.0" }
	},
	CLI = {
		reference = 123, 
		software = { version = "1.0.0" },
		hardware = { version = "1.0.0" },
		cout = { privilages = "CLI_OUT", }
	}
	
},
	Players = { [Microcontroller:GetOwnerId()] = "root" }
}


local function HandleCall(sender, message) 
	local call = message.call

	if call then
		local command = call.command
		if typeof(command) == "table" then
			if known.Modules[command[1]] then
				known.Modules[command[1]].command[2](command[3])	-- sth like that, just executing method on known module
			else
				error("Master doesnt know module named \""..tostring(command[1]).."\"",0)
			end
		else
			error("Master tried handling call with command not being a table, command: "..tostring(command),0)
		end
	end
end


local function Shutdown() Microcontroller:Shutdown() end


known.Modules.Master.Shutdown = { privilages = nil, }

while true do
	pcall(task.spawn,HandleCall(Microcontroller:Receive()))
end
