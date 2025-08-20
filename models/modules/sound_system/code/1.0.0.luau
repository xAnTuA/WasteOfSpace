MODULE_META.name = "SoundSystem"
MODULE_META.displayName = "Sound System"

local Collection
afterInit = function()
	Collection = pm:RequirePackage("collection","1.0.0")
end

---------------FUNCTIONALITY-OF-MODULE--------------------
local speakers = GetParts("Speaker")
local quee = {}
local currentQueePossition = 1

local function LoadSoundFromQuee(queePossition)
	quee[queePossition] = Collection.Run(speakers,"LoadSound", "rbxassetid://"..quee[queePossition]) 
end

local function PlayQueeSound(queePossition) 
	Collection.Run(quee[queePossition],"Play") 
end

local function AddToQuee(soundId)
	table.insert(quee,soundId)
end

local function SetVolume(volume) 
	Collection.ChangeProperty(speakers,"Volume",volume)
end

local function UpdateSpeakers() speakers = GetParts("Speakers") end


commands.REQ_Add = AddToQuee
commands.REQ_SetVolume = SetVolume
commands.REQ_UpdateSpeakers = UpdateSpeakers
