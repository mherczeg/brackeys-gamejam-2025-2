class_name ShopPane
extends Control

const PRODUCT_TYPE_PURCHASE_BUTTON_SCENE: PackedScene = \
	preload("res://modules/shop/components/ProductTypePurchaseButton.tscn")
const INGREDIENT_PURCHASE_BUTTON_SCENE: PackedScene = \
	preload("res://modules/shop/components/IngredientPurchaseButton.tscn")

@onready var wallet: Label = $Panel/VBoxContainer/Wallet
@onready var items: GridContainer = $Panel/VBoxContainer/ScrollContainer/Items
@onready var close_button: Button = $Panel/CloseButton

func _ready() -> void:
	hide()
	close_button.pressed.connect(hide)
	EventBus.player.money_changed.connect(func(_n: float, _o: float) -> void: update_money_label())


func update_money_label() -> void:
	wallet.text = "Funds: $%d" % Player.money


func open() -> void:
	update_money_label()
	reset_items()

	for product_type: ProductType in ResourceManager.product_types:
		if !Player.product_types.has(product_type):
			var product_type_purchase_button: ProductTypePurchaseButton = PRODUCT_TYPE_PURCHASE_BUTTON_SCENE.instantiate()
			product_type_purchase_button.product_type = product_type
			items.add_child(product_type_purchase_button)

	for ingredient: Ingredient in ResourceManager.ingredients:
		var ingredient_purchase_button: IngredientPurchaseButton = INGREDIENT_PURCHASE_BUTTON_SCENE.instantiate()
		ingredient_purchase_button.ingredient = ingredient
		items.add_child(ingredient_purchase_button)

	show()

func reset_items() -> void:
	for child: Node in items.get_children():
		child.free()
