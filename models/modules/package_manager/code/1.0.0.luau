MODULE_META.name = "PackageManager"
MODULE_META.displayName = "Package Manager"


----------------------------------------------
local disk = assert(GetPart("Disk"),MODULE_META.displayName..": disk not found")
cache = {}
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

