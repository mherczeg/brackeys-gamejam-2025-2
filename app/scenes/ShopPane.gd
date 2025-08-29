class_name ShopPane
extends Control

const BASE_PURCHASE_BUTTON_SCENE: PackedScene = preload("res://components/BasePurchaseButton.tscn")
const INGREDIENT_PURCHASE_BUTTON_SCENE: PackedScene = preload("res://components/IngredientPurchaseButton.tscn")

@onready var wallet: Label = $Panel/VBoxContainer/Wallet
@onready var items: GridContainer = $Panel/VBoxContainer/Items
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

	for base: Base in ResourceManager.bases:
		if !Player.bases.has(base):
			var base_purchase_button: BasePurchaseButton = BASE_PURCHASE_BUTTON_SCENE.instantiate()
			base_purchase_button.base = base
			items.add_child(base_purchase_button)

	for ingredient: Ingredient in ResourceManager.ingredients:
		var ingredient_purchase_button: IngredientPurchaseButton = INGREDIENT_PURCHASE_BUTTON_SCENE.instantiate()
		ingredient_purchase_button.ingredient = ingredient
		items.add_child(ingredient_purchase_button)

	show()

func reset_items() -> void:
	for child: Node in items.get_children():
		child.free()
