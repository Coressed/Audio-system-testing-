--// Services
local RunService = game:GetService("RunService")

--// Other
local AudioHandler = {}
AudioHandler.__index = AudioHandler

local default = {
	["IsPlaying"] = false,
	["PlaybackSpeed"] = 1,
	["Volume"] = 1,
	["Signals"] = {},
	["GlobalOverRide"] = true, -- Wether global settings affect the audio
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

--// Functions \\--
function AudioHandler.add()
	local self = deepClone(default)
	self = setmetatable(self, AudioHandler)
	self:_connectGlobalSignals()
	
	return self
end

function AudioHandler:_connectGlobalSignals()
	assert(RunService:IsServer(), "Attempt to connect global signals on Client.")
	assert(not self.Signals[1], "Attempt to connect connected global signals")
	
	for key, signal: Instance in pairs(globalSignals) do
		print(self, signal)
		self.Signals[key] = signal._event
		self.Signals[key].Event:Connect(function(newValue)
			self[signal.Changed] = newValue
			print(self)
		end)
	end
	print(self)
end

function AudioHandler:_changeGlobalSpeed(newSpeed)
	assert(RunService:IsServer(), "Attempt to change global setting on Client.")
	assert(typeof(newSpeed) == "number", "Attempt to change global speed with nil.")
	assert(newSpeed > -0.1, "Attempt to change global speed with negative values")
	
	local signal: BindableEvent = globalSignals.ChangeGlobalVolume
	signal._event:Fire(newSpeed)
end

return AudioHandler
