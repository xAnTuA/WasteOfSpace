callId = math.randomseed(tick() * 1e6 + os.clock() * 1e3)
callerId = 1235561231244532
local message = {
	call = { -- we need to know for sure that its call
		id = callId, -- sth random so we can refer to that call layter on
		callerId = callerId,
		timestamp = os.clock(),
		command = {
			"target","method", "args1" , ...
		}
	}
}
-- after that we can make promise, and resoleve after completing promise
--
--
-- this way the call is nuclear, secure, and asynch
