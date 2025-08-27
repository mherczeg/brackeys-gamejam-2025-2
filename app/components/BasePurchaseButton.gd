class_name BasePurchaseButton
extends TextureButton

var base: Base

@onready var icon: TextureRect = $Icon
@onready var base_name: Label = $Name
@onready var price: Label = $Price

func _ready() -> void:
	icon.texture = base.icon
	base_name.text = base.name
	price.text = "$%d" % base.price
	pressed.connect(_on_pressed)
	EventBus.player.money_changed.connect(_on_money_changed)
	_set_availability()

func _set_availability() -> void:
	if Player.money >= base.price && !Player.bases.has(base):
		disabled = false
	else:
		disabled = true

func _on_pressed() -> void:
	EventBus.shop.base_purchased.emit(base)
	_set_availability()

func _on_money_changed(_new_money: float) -> void:
	_set_availability()
