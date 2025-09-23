class_name ShopPane
extends Control

const PRODUCT_TYPE_PURCHASE_BUTTON_SCENE: PackedScene = \
	preload("res://modules/shop/components/ProductTypePurchaseButton.tscn")
const INGREDIENT_PURCHASE_BUTTON_SCENE: PackedScene = \
	preload("res://modules/shop/components/IngredientPurchaseButton.tscn")

@onready var wallet: Label = %Wallet
@onready var items: GridContainer = %Items
@onready var close_button: Button = %CloseButton

func _ready() -> void:
	hide()
	close_button.pressed.connect(hide)
	EventBus.player.money_changed.connect(func(_n: float, _o: float) -> void: update_money_label())


func update_money_label() -> void:
	wallet.text = "Funds: $%d" % Player.inventory.money


func open() -> void:
	update_money_label()
	Utils.clear_children(items)

	for product_type: ProductType in ResourceManager.product_types:
		if !Player.inventory.has_product_type(product_type):
			var product_type_purchase_button: ProductTypePurchaseButton = PRODUCT_TYPE_PURCHASE_BUTTON_SCENE.instantiate()
			product_type_purchase_button.product_type = product_type
			items.add_child(product_type_purchase_button)

	for ingredient: Ingredient in ResourceManager.ingredients:
		var ingredient_purchase_button: IngredientPurchaseButton = INGREDIENT_PURCHASE_BUTTON_SCENE.instantiate()
		ingredient_purchase_button.ingredient = ingredient
		items.add_child(ingredient_purchase_button)

	show()
