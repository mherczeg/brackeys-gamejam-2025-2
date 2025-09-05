extends Node

var _beep_sounds: Array[AudioStream] = []
var _pitched_voice_bus_index: int

func _ready() -> void:
	_load_beep_sounds()
	_pitched_voice_bus_index = AudioServer.get_bus_index("Speech")

func _load_beep_sounds() -> void:
	for path: String in VoiceList.beeps_paths:
		var sound: AudioStream = load(path)
		if sound:
			_beep_sounds.append(sound)
		else:
			printerr("VoiceManager: Failed to load sound at path: ", path)

func get_random_voice_pair() -> Array[AudioStream]:
	_beep_sounds.shuffle()

	return [
		_beep_sounds[0],
		_beep_sounds[1]
	]

func set_voice_pitch(pitch: float) -> void:
	if _pitched_voice_bus_index == -1:
		return

	# Get the first effect on the bus (our PitchShift effect)
	var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(_pitched_voice_bus_index, 0)

	if pitch_shift_effect:
		pitch_shift_effect.pitch_scale = pitch
