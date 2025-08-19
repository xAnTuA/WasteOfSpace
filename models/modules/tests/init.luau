local PROTOCOL = "MODULAR"
local MODULE_META = { name = "Sound System"}
repeat
	local funcs = {
		REQ_PROTOCOL = function(s) s:Send(PROTOCOL) end,
		REQ_MODULE_META = function(s) s:Send("RES_MODULE_META",MODULE_META) end,
		RES_INIT = function(s,x)
			if s.PartLocked == Microcontroller.PartLocked then
				assert(loadstring(x))()
				return true 
			end
		end
}
	local s,c,x = Microcontroller:Receive()
	if funcs[c](s,x) then break end
until false
print("After Loop")
