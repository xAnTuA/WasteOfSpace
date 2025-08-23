local MODULE = {
	name = "InitManager",
	version = { 1,0,0 },
	author = "AnTuA",
	url = "https://raw.githubusercontent.com/xAnTuA/WasteOfSpace/refs/heads/main/packages/InitManager/1.stable.luau" -- template url, not real
}


local modem = GetPart("Modem")
local disk = GetPart("Disk")

local rootDir = disk:ReadAll()
local bootDir = rootDir.boot
if not bootDir then rootDir.boot = {} end

local initFile = bootDir["init.luau"]

if not initFile then
	initFile= modem:GetAsync(MODULE.url)

	disk:WriteAll(rootDir)
end

local success, result = pcall(loadstring,initFile)

if success then print("[Init Manager] successfully loaded its code")
else return error("[Init Manager] failed to load its code : ".. result , 0) end

success, result = pcall(result)

if success then print("[Init Manager] exited returning: ",result)	
else error("[Init Manager] yield error: ",result) end
