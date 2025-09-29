@icon("res://tools/custom-node-icons/AudioStreamPlayer2D.svg")
class_name MixingPaneAudioPlayer
extends Node

@export var coin_insert: AudioStream
@export var product_drop: AudioStream

var _coin_insert_delay: float = 0

func set_coin_insert_delay(coin_insert_delay: float) -> void:
	_coin_insert_delay = coin_insert_delay

func play_coin_insert() -> Signal:
	EventBus.ui.play_sound_effect.emit(coin_insert, {"volume_db": 10.0})
	return get_tree().create_timer(_coin_insert_delay).timeout

func play_product_drop() -> Signal:
	EventBus.ui.play_sound_effect.emit(product_drop, {"volume_db": - 10.0})

	var completed_sound_effect: AudioStream = null
	while completed_sound_effect != product_drop:
		completed_sound_effect = await EventBus.ui.play_sound_effect_complete

	return get_tree().create_timer(0).timeout
