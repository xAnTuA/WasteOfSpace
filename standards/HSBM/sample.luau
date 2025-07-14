-- HSBM
-- 1.0.0
local HSBM_INFO= {
	protocol	={
		name	= [string]
		version = {major: number, minor: number, patch: number}
		url	= [string?]
	}
}

-- now if other mcu want to start conversation with this one we need to agree on protocol we are using

local function HSBM(sender)
	-- we can add security check if we want to
	sender:Send(HSBM_INFO)
end

local function Receive(sender, command: string, ...)
	-- we can add switch, with functions here. but to keep it simple in this example we only do check if command want to stat conversation
	-- every mcu on command "HSBM" we need to return info about potocol
	if (command == "HSBM")
		HSBM(sender)
	end
end

-- we could do infinite loop here if we just want to await for new request and wait for another one
Receive(Microcontroller:Receive()) -- we pass returned info from Receive (MCU method) to the local function
