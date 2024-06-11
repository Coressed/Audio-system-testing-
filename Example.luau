--// Path: ServerScriptService/AudioSystem --\\

local CustomAudioHandler = require(script.Parent.AudioSystem.CustomAudioHandler) -- Module

local newHandler = CustomAudioHandler.new() -- Creates a new audio instance
local newAudio = CustomAudioHandler.Audio.new()
newAudio:Play() -- Plays audio class (also stops Roblox's sound instance)
newAudio:Stop() -- Stops audio class (also stops Roblox's sound instance)
newAudio:Sync() -- Sync audio class settngs with Roblox's default sound instance
newHandler:_changeGlobalSpeed(10) -- Changes global playbackspeed for all audio classes
