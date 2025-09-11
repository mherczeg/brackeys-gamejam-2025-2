@icon("res://tools/custom-node-icons/AudioStreamPlayer2D.svg")
class_name MixingPaneAudioPlayer
extends Node

var _coin_insert_delay: float = 0

@onready var coin_insert: AudioStreamPlayer2D = $CoinInsert
@onready var product_drop: AudioStreamPlayer2D = $ProductDrop

func set_coin_insert_delay(coin_insert_delay: float) -> void:
	_coin_insert_delay = coin_insert_delay


func play_coin_insert() -> Signal:
	product_drop.stop()
	coin_insert.play()
	return get_tree().create_timer(_coin_insert_delay).timeout

func play_product_drop() -> Signal:
	coin_insert.stop()
	product_drop.play()
	return product_drop.finished