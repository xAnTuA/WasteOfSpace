local mcu = GetPart("Microcontroller")

local function handleM(s,c,x)
	local _x = x or "nil"
	print("From ",s)
	print("Got ", c)
	print("Arg ", x)
end

mcu:Send("REQ_PROTOCOL")
handleM(Microcontroller:Receive())
mcu:Send("REQ_MODULE_META")
handleM(Microcontroller:Receive())
mcu:Send("RES_INIT","print(\"Init executed\")")
