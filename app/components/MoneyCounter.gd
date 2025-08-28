class_name MoneyCounter
extends HBoxContainer

@onready var money_label: Label = $Label
@onready var coin: TextureRect = $Coin
@onready var animation: AnimatedTexture

func _ready() -> void:
	animation = coin.texture
	update_money_label(Player.money, true)
	EventBus.player.money_changed.connect(update_money_label)

func update_money_label(new_money: float, skip_animation: bool = false) -> void:
	money_label.text = '$%d' % new_money
	if !skip_animation:
		animation.current_frame = 0
		animation.pause = false
