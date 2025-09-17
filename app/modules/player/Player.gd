extends Node

var health: int = 100

var inventory: Inventory = Inventory.new()
var played_encounters: Dictionary[Encounter, bool] = {}

func _ready() -> void:
	inventory.setup([
		ResourceManager.product_types[0],
		ResourceManager.product_types[1],
		ResourceManager.product_types[2]
	],
	{
		ResourceManager.ingredients[0]: 2,
		ResourceManager.ingredients[1]: 10,
		ResourceManager.ingredients[2]: 10,
		ResourceManager.ingredients[3]: 1
	}, 100)

	EventBus.mixer.order_received.connect(_on_order_start)
	EventBus.mixer.serve_mix.connect(_on_product_served)
	EventBus.shop.product_type_purchased.connect(_on_product_type_purchased)
	EventBus.shop.ingredient_purchased.connect(_on_ingredient_purchased)

func _on_order_start(product: Product) -> void:
	inventory.increase_money(product.price)

func _on_product_served(product: MixedProduct) -> void:
	for product_ingredient: Ingredient in product.ingredients:
		if inventory.has_ingredient(product_ingredient):
			inventory.increase_ingredient_amount(product_ingredient, -1)

func _on_ingredient_purchased(ingredient: Ingredient, count: int) -> void:
	if !inventory.has_ingredient(ingredient):
		inventory.set_ingredient(ingredient, 0)

	inventory.increase_ingredient_amount(ingredient, count)
	inventory.increase_money(ingredient.price * count * -1)

func _on_product_type_purchased(product_type: ProductType) -> void:
	if !inventory.has_product_type(product_type):
		inventory.set_product_type(product_type, true)
		inventory.increase_money(product_type.price * -1)

func completed_encounter(encounter: Encounter) -> void:
	played_encounters[encounter] = true
