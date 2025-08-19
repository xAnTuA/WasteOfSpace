local PROTOCOL = { name = "MSH", version = "1.0.0" }
local MODULE_METATABLE = {
	name = "PackageManager",
	version = "1.0.0"
	methods = {
		REQ_PKG = handlePackageRequire 
	}
}
-- REQ_PROTOCOL
repeat local s,c,x = Microcontroller:Receive(); if(s.PartLocked ~= Microcontroller.PartLocked) then continue end; if c == "RES_INIT" then return assert(loadstring(x))() elseif c == "REQ_MODULE_META" then s:Send("RES_MODULE_META",MODULE_METATABLE) end until false


--local disk = assert(GetPart("Disk"),"Package Manager: disk is nil")

local loadedPackages = { 
	printx = {
		["1.0.0"] = function()
			print("x")
		end
	}
}

local function ProvidePackage(target,package,version)
	target:Send("RES_PAC",package,loadedPackages[package][version])	
end

local function SavePackage(name,version,content)
--	disk:Write(name.."-"..version,content) -- maybe other structure would be better?
end

local function GetPackage(url)end

local function handlePackageRequire(sender, package, version)
	
end


local funcs = { REQ_PKG = ProvidePackage }

local function handleMessage(sender, command, ...) -- possibly should be better if we got it from init
	local func = funcs[command]
	if func then
		func(sender,...)	
	else
		warn("Package Manager: "..sender.." called command ".. command .. " that does not exist")
	end
end

while true do
	handleMessage(Microcontroller:Receive())
end
