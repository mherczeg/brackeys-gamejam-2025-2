extends Node

var _beep_sounds: Array[AudioStream] = []
var _pitched_voice_bus_index: int

func _ready() -> void:
	_load_beep_sounds("res://assets/audio/beeps/")
	_pitched_voice_bus_index = AudioServer.get_bus_index("Speech")

# This function now lives in the global script and runs only once.
func _load_beep_sounds(path: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if not dir:
		printerr("Textbox: Could not open directory at path: ", path)
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and (file_name.ends_with(".mp3") or file_name.ends_with(".ogg")):
			var sound: AudioStream = load(path.path_join(file_name))
			if sound:
				_beep_sounds.append(sound)
		file_name = dir.get_next()

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
