local PROTOCOL = { name = "MODULAR", version = "1.0.0" }
local GLOBALS, HandleCommand
pm = nil

local MODULE_META= {
	name = "UnknownModule",
	displayName = "Sound System",
	commands = {},
	AfterInit = true
}
local commands = MODULE_META.commands

local function INIT(sender,globals)
	if sender.PartLocked ~= Microcontroller.PartLocked then return end
	GLOBALS = globals
	if GLOBALS.packageManager ~= Microcontroller then
		GLOBALS.packageManager:Send("REQ_PM")
		local s,c,x = Microcontroller:Receive()
		pm = x
	end
	MODULE_META.AfterInit()
	HandleCommand = function(sender,command,...) 
		local _command = commands[command]
		if _command then
			task.spawn(_command,sender,...)
		else
			warn(MODULE_META.displayName .. ": Receive call for not present command \""..tostring(command).."\"",0)
		end
	end
	commands.REQ_INIT = nil
end

local function ProvideProtocolTo(target)
	target:Send("RES_PROTOCOL", PROTOCOL)
end

local function ProvideMetaTo(target)
	target:Send("RES_MODULE_META",MODULE_META)
end

commands.REQ_INIT = INIT
commands.REQ_PROTOCOL = ProvideProtocolTo
commands.REQ_MODULE_META = ProvideMetaTo
-----------------------MODULAR-HEADER-------------------------


MODULE_META.name = "PackageManager"
MODULE_META.displayName = "Package Manager"


----------------------------------------------
local disk = assert(GetPart("Disk"),MODULE_META.displayName..": disk not found")
local cache = {}
local packageList
local packageURL= "https://raw.githubusercontent.com/xAnTuA/WasteOfSpace/refs/heads/main/packages"

local function ensurePackageSlot(name)
    if not cache[name] then
        cache[name] = {}
    end
    return cache[name]
end

local function LoadPackagesToCache()
	local packages = disk:ReadAll()
	local len = #packages

	for key,content in ipairs(packages) do
		cache[key] = content
	end
end

MODULE_META.AfterInit = function()
	LoadPackagesToCache()
end

local function SavePackage(name,version,content)
	local versionsContent = disk:Read(name)
	
	if not versionsContent then versionsContent = {} end

	versionsContent[version] = content

	disk:Write(name,versionsContent)
end

local function GetPackageList()
	packageList = JSONDecode(assert(GLOBALS.modem:GetAsync(packageURL.."/list.json"),MODULE_META.displayName..": cannot retrieve package list from url"))
end

local function GetPackage(package,version)
	local content = loadstring(assert(GLOBALS.modem:GetAsync(packageURL.."/"..package.."/"..version..".luau"),"cannot retrieve package - package manager"))()
	
	local slot = ensurePackageSlot(package)
	slot[version] = content
	SavePackage(package,version,content)

	return slot[version]
end

local function GetBestVersion(package,version)
	if not packageList then GetPackageList() end
	local versions = packageList[package]
	local major = version:sub(1,1)

	for _,v in ipairs(versions) do
		if v:sub(1,1) == major then return v end
	end
end

local function AcquirePackage(package,version)
	local content = ensurePackageSlot(package)[version]
	if not content then
		return GetPackage(package,GetBestVersion(package,version))
	end
	return content 
end

local PackageManager = {}
PackageManager.__Index = PackageManager


function PackageManager.RequirePackage(package,version)
	return AcquirePackage(package, version) 
end


local function ProvidePMTo(target)
	target:Send("RES_PM",PackageManager)
end

pm = PackageManager

commands.REQ_PM = ProvidePMTo



-----------------------MODULAR-FOTTER-------------------------
local function PreInitHandleCommand(sender,command,...) 
	local _command = commands[command]
	local preInitCommands = { REQ_INIT = true, REQ_PROTOCOL = true, REQ_MODULE_META = true }
	if preInitCommands[command] then
		_command(sender,...)
	else
		warn(MODULE_META.displayName .. ": Receive call for command \""..tostring(command).."\" (Before init)",0)
	end
end

HandleCommand = PreInitHandleCommand 
while true do HandleCommand(Microcontroller:Receive()) end
