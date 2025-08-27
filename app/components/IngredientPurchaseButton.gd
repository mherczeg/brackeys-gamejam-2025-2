class_name IngredientPurchaseButton
extends TextureButton

@export var pcs: int = 10

var ingredient: Ingredient
var bulk_price: float = 0.0

@onready var icon: TextureRect = $Icon
@onready var base_name: Label = $Name
@onready var price: Label = $Price

func _ready() -> void:
	bulk_price = ingredient.price * pcs
	icon.texture = ingredient.icon
	base_name.text = ingredient.name
	price.text = "$%d / %dpcs" % [bulk_price, pcs]
	pressed.connect(_on_pressed)
	EventBus.player.money_changed.connect(_on_money_changed)
	_set_availability()

func _set_availability() -> void:
	if Player.money >= bulk_price:
		disabled = false
	else:
		disabled = true

func _on_pressed() -> void:
	EventBus.shop.ingredient_purchased.emit(ingredient, pcs)

func _on_money_changed(_new_money: float) -> void:
	_set_availability()
