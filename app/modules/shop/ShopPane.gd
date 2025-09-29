class_name ShopPane
extends Control

const PRODUCT_TYPE_PURCHASE_BUTTON_SCENE: PackedScene = \
	preload("res://modules/shop/components/ProductTypePurchaseButton.tscn")
const INGREDIENT_PURCHASE_BUTTON_SCENE: PackedScene = \
	preload("res://modules/shop/components/IngredientPurchaseButton.tscn")

@onready var wallet: Label = %Wallet
@onready var items: GridContainer = %Items
@onready var close_button: Button = %CloseButton
@onready var repair_button: Button = %RepairButton

func _ready() -> void:
	hide()
	update_repair_button()
	close_button.pressed.connect(hide)
	repair_button.pressed.connect(EventBus.shop.repair_purchased.emit)
	EventBus.player.money_changed.connect(_on_player_money_changed)


func update_money_label(money: float) -> void:
	wallet.text = "Funds: $%d" % money

func update_repair_button() -> void:
	if Player.inventory.money < Player.REPAIR_COST:
		disable_repair_button()
	else:
		enable_repair_button()

func disable_repair_button() -> void:
	repair_button.disabled = true
	repair_button.text = "Repair Damage: No funds"

func enable_repair_button() -> void:
	repair_button.disabled = false
	repair_button.text = "Repair Damage: $10"

func open() -> void:
	update_money_label(Player.inventory.money)
	update_repair_button()
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

func _on_player_money_changed(new_money: float, _old_money: float) -> void:
	update_money_label(new_money)
	update_repair_button()