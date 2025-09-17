class_name ProductTypePurchaseButton
extends TextureButton

signal disabled_changed

var product_type: ProductType

@onready var product_type_name: Label = $Name
@onready var price: Label = $Price

func _ready() -> void:
	texture_normal = product_type.icon
	product_type_name.text = product_type.name
	price.text = "$%d" % product_type.price

	pressed.connect(_on_pressed)
	EventBus.player.money_changed.connect(_on_money_changed)

	_set_availability()

func _set_availability() -> void:
	if Player.inventory.money >= product_type.price && !Player.inventory.has_product_type(product_type):
		disabled = false
	else:
		disabled = true

	disabled_changed.emit()

func _on_pressed() -> void:
	EventBus.shop.product_type_purchased.emit(product_type)
	_set_availability()

func _on_money_changed(_new_money: float, _old_money: float) -> void:
	_set_availability()
