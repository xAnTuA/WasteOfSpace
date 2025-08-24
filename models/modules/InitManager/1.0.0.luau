local MODULE = {
	name = "InitManager",
	version = { 1,0,0 },
	author = "AnTuA",
	url = "https://raw.githubusercontent.com/xAnTuA/WasteOfSpace/refs/heads/main/packages/InitManager/1.stable.luau" -- template url, not real
}

local function IM(message: string) return "[Init Manager] "..message end

print(IM("started"))
local modem = assert(GetPart("Modem"),IM("cannot find modem"))
local disk = assert(GetPart("Disk"),IM("cannot find disk"))

local rootDir = disk:ReadAll()
if not rootDir then rootDir = {} end
local bootDir = rootDir.boot
if not bootDir then bootDir = {}; rootDir.boot = bootDir end

local initCode = bootDir["init.luau"]

if not initCode then
	print(IM("fetching init code"))
	initCode = modem:GetAsync(MODULE.url) 
	bootDir["init.luau"] = initCode
	disk:WriteAll(rootDir)
end

local function TryLoad(code)
	local fn, err =loadstring(code)
	if not fn then
		warn(IM("failed to load code : "..err))
		return false
	end
	print(IM("successfully loaded code"))
	return fn 
end
print(IM("will try to load init code..."))
local init = TryLoad(initCode)

if not init then
	print(IM("failed to execute init code"))
	print(IM("will try to load backup code..."))

	local backupInitFile = assert(bootDir["init.luau.bak"],IM("didn't find backup code"))
	print(IM("backup code found, loading..."))
	init = TryLoad(backupInitFile)
	if not init then return warn(IM("shutting down...")) end
end

print(IM("code loaded successfully, starting..."))

local success, result = pcall(init)

if success then 
	print(IM("exited returning: "),result)
else 
	warn(IM("exited, yielding error: "),result) 
end
