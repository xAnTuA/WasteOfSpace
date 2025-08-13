local name = "SoundSystem"
local speakers = GetParts("Speakers")
local queeLooped = false
local currentVolume = 50
local quee = {  {} , {} ,144444, 14444}

local function Speakers(thing,...)
	local result = {}
	for speaker in ipairs(speakers) do
		table.insert(result,speaker[thing](speaker,...))
	end
	return result
end

local function LoadSoundFromQuee(queeI)
	quee[queeI] = Speakers("LoadSound", quee[queeI])  
-- end

local function Play() end
local function Stop() end
local function Skip() end

local function SetVolume() end

local function UpdateSpeakers() speakers = GetParts("Speakers") end


