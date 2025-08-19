
repeat
	local funcs = {
		REQ_PROTOCOL = function(s) s:Send(PROTOCOL) end,
		REQ_MODULE_META = function(s) s:Send("RES_MODULE_META",MODULE_META)
		RES_INIT = function(s,x) s.PartLocked == Microcontroller.PartLocked? assert(loadstring(x))();break : continue
}
	local s,c,x = Microcontroller:Receive()
	funcs[c](s,x)
until false
