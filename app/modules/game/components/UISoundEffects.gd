class_name UISoundEffects
extends AudioStreamPlayer2D

func _ready() -> void:
	EventBus.ui.play_sound_effect.connect(_on_ui_play_sound_effect)

func _on_ui_play_sound_effect(
	sound_effect: AudioStream,
	stream_settings: Dictionary = {}
) -> void:
	_stop_playing_sound_effect()
	_start_playing_sound_effect(sound_effect, stream_settings)

	await finished
	EventBus.ui.play_sound_effect_complete.emit(stream)

func _stop_playing_sound_effect() -> void:
	if playing:
		stop()
		EventBus.ui.play_sound_effect_complete.emit(stream)

func _start_playing_sound_effect(
	sound_effect: AudioStream,
	stream_settings: Dictionary = {}
) -> void:
	stream = sound_effect

	for prop: StringName in stream_settings.keys():
		set(prop, stream_settings.get(prop))

	play()
