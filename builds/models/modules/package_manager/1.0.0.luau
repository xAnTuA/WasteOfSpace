local PROTOCOL = { name = "MODULAR", version = "1.0.0" }
local GLOBALS, HandleCommand, pm 

local MODULE_META= {
	name = "UnknownModule",
	displayName = "Sound System",
	commands = {}
}
local commands = MODULE_META.commands

local AfterInit = function() end

local function INIT(sender,globals)
	if sender.PartLocked ~= Microcontroller.PartLocked then return end
	GLOBALS = globals
	GLOBALS.PacketManager:Send("REQ_PM")
	local s,c,x = Microcontroller:Receive()
	pm = x
	AfterInit()
	HandleCommand = PostInitHandleCommand
end

local function ProvideProtocolTo(target)
	target:Send("RES_PROTOCOL", PROTOCOL)
end

local function ProvideMetaTo(target)
	target:Send("RES_MODULE_META",MODULE_META)
end

commands.RES_INIT = INIT
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

AfterInit = function()
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
	local content = loadstring(assert(GLOBALS.modem:GetAsync(packageURL.."/"..package.."/"..version.."/index.luau"),"cannot retrieve package - package manager"))()
	SavePackage(package,version,content)
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
		GetPackage(package,GetBestVersion(package,version))
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


commands.REQ_PM = ProvidePMTo



-----------------------MODULAR-FOTTER-------------------------
local function PreInitHandleCommand(sender,command,...) 
	local _command = commands[command]
	local preInitCommands = { RES_INIT = true, REQ_PROTOCOL = true, REQ_MODULE_META = true }
	if preInitCommands[command] then
		_command(sender,...)
	else
		warn(MODULE_META.displayName .. ": Receive call for command \""..tostring(command).."\" (Before init)",0)
	end
end

local function PostInitHandleCommand(sender,command,...) 
	local _command = commands[command]
	if _command then
		task.spawn(_command,sender,...)
	else
		warn(MODULE_META.displayName .. ": Receive call for command \""..tostring(command).."\"",0)
	end
end

HandleCommand = PreInitHandleCommand 
while true do HandleCommand(Microcontroller:Receive()) end
