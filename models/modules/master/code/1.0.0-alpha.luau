-- THIS SCRIPT START FIRST 
-- we set globals that we will later provide to other modules, they should be unable to be modified from other modules, as same as security
local GLOBALS = {
	packageManager = GetPartFromPort(999,"Microcontroller"),
	modem = false,
	master = Microcontroller
}
local PRIVILAGES = setmetatable({},{})

-- so basicaly this is a system boot, not yet a functional module





local moduleVersionManager = GetPart("Microcontroller")
moduleVersionManager:Send("REQ_INIT",GLOBALS)
Microcontroller:Receive()
GLOBALS.packageManager:Send("REQ_INIT",GLOBALS)

