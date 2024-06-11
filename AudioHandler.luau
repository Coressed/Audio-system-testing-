--// !Place in server protected area! \\--
-- Made by @.sickk on Discord. (in progress)

--// Services
local RunService = game:GetService("RunService")

--// Other
local AudioHandler = {}
AudioHandler.__index = AudioHandler

local default = {
	["Sound"] = Instance.new("Sound"),
	["IsPlaying"] = false,
	["PlaybackSpeed"] = 1,
	["Volume"] = 1,
	
	-- Hidden
	["_Signals"] = {},
	["_GlobalOverRide"] = true, -- Wether global settings affect the audio
}

--// Signals \\--
local globalSignals = {
	["ChangeGlobalPlaybackSpeed"] = {
		Type = "Changed",
		Changed = "PlaybackSpeed",
		_event = Instance.new("BindableEvent")
	},
	
	["ChangeGlobalVolume"] = {
		Type = "Changed",
		Changed = "Volume",
		_event = Instance.new("BindableEvent")
	},
}

--// Private \\--
local function deepClone(Table: {})
	local clone = {}
	for key, v in pairs(Table) do
		if typeof(v) == "table" then
			clone[key] = deepClone(v)
		else
			clone[key] = v
		end
	end
	return clone
end

--// Audio base class \\--
local Audio = {}
Audio.__index = Audio

function Audio.new()
	local self = setmetatable(deepClone(default), Audio)
	self:_connectGlobalSignals()

	return self
end

function Audio:Sync()
	for property, value in pairs(self) do
		if not string.match(property, "_") then -- We ignore hidden property's
			self[property] = value
		end
	end
end

function Audio:Play()
	self.IsPlaying = not self.IsPlaying
	self.Sound:Play()
end

function Audio:Stop()
	self.IsPlaying = not self.IsPlaying
	self.Sound:Stop()
end

function Audio:_connectGlobalSignals()
	assert(RunService:IsServer(), "Attempt to connect global signals on Client.")
	assert(not self._Signals[1], "Attempt to connect connected global signals")
	assert(self._GlobalOverRide, "Attempt to connect global signals when GlobalOverRide is false.")

	for key, signal: Instance in pairs(globalSignals) do
		print(self, signal)
		self._Signals[key] = signal._event
		self._Signals[key].Event:Connect(function(newValue)
			self[signal.Changed] = newValue
			print(self)
		end)
	end
	print(self)
end

--// Functions \\--

function AudioHandler.new()
	local self = setmetatable({}, AudioHandler)
	return self
end

function AudioHandler:_changeGlobalSpeed(newSpeed)
	assert(RunService:IsServer(), "Attempt to change global setting on Client.")
	assert(typeof(newSpeed) == "number", "Attempt to change global speed with nil.")
	assert(newSpeed > -0.1, "Attempt to change global speed with negative values")
	
	local signal: BindableEvent = globalSignals.ChangeGlobalVolume
	signal._event:Fire(newSpeed)
end

--// Exporting classes

AudioHandler.Audio = Audio

return AudioHandler
