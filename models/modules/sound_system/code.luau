local repr = require("repr")
local speakers = GetParts("Speaker")
local quee = {}
local currentQueePossition = 1

local function foreach(array,func)
	local len = #array
	for  i = 1, len do
		func(array[i])
	end
end

local function map(array,func,...)
	local len = #array
	local result = table.create(len)
	for i = 1, len do
		 table[i] = func(array[1],...)
	end
	return result
end

local Collection = {
	ChangeProperty = function(array,property,value)
		foreach(array,function(item)
			item[property] = value
		end)
	end,
	Run = function(array,method,...)
		map(array, function(item,...)
			item[method](item,...)
		end)
	end
}

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

AddToQuee("102848347808845")
LoadSoundFromQuee(1)
task.wait(1)
PlayQueeSound(1)
SetVolume(1)
