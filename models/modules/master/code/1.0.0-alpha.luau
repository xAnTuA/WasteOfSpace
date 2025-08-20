-- THIS SCRIPT START FIRST 
-- we set globals that we will later provide to other modules, they should be unable to be modified from other modules, as same as security
local mcus = GetPartsFromPort(1,"Microcontroller")

local function otherMcu(mcus)
	for _,mcu in mcus do
		if mcu ~= Microcontroller then return mcu end
	end
end

local GLOBALS = {
	packageManager = otherMcu(mcus),
	modem = GetPart("Modem"),
	master = Microcontroller
}
--local PRIVILAGES = setmetatable({},{})

-- so basicaly this is a system boot, not yet a functional module



if GLOBALS.packageManager == Microcontroller then print("same mcu") end

GLOBALS.packageManager:Send("REQ_INIT",GLOBALS)
GLOBALS.packageManager:Send("HELLO")

local SoundSystem = GetPart("Microcontroller")
SoundSystem:Send("REQ_INIT",GLOBALS)
task.wait(10)
SoundSystem:Send("REQ_Add","102848347808845")
SoundSystem:Send("REQ_Play",1)
