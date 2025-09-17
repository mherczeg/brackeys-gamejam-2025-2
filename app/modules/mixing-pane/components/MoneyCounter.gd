class_name MoneyCounter
extends HBoxContainer

@onready var money_label: Label = $Label
@onready var coin: TextureRect = $Coin
@onready var animation: AnimatedTexture

func _ready() -> void:
	animation = coin.texture
	EventBus.player.money_changed.connect(_on_money_changed)
	update_money_label(Player.inventory.money, Player.inventory.money)

func update_money_label(new_money: float, old_money: float) -> void:
	prints("update_money_label", new_money, old_money)
	money_label.text = '$%d' % new_money
	if new_money > old_money:
		animation.current_frame = 0
		animation.pause = false

func _on_money_changed(new_money: float, old_money: float) -> void:
	prints("wallet change through signal", new_money, old_money)
	update_money_label(new_money, old_money)
