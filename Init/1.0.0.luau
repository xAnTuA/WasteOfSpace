local GLOBALS = {
	packageManager = ,
	master = ,
	modem = ,
	starmap = ,
	telescope = ,
	blackbox = ,
	-- disk?
	instrument = ,
	lifeSensor =,
	scanner = ,
}

local function newResolvable()
    local resolver, rejecter
    local p = GLOBALS.Promise.new(function(resolve, reject)
        resolver = resolve
        rejecter = reject
    end)
    return p, resolver, rejecter
end

local function requirePackage(name, version)
	local promise, resolve, reject = newResolvable()
	GLOBALS.packageManager:Send("REQ_PKG",name,version,resolve,reject)
	return promise
end
