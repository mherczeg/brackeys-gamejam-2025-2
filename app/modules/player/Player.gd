extends Node

var money: float = 100:
	set(new_money):
		var old_money: float = money
		money = new_money
		EventBus.player.money_changed.emit(new_money, old_money)

var health: int = 100

var ingredients: Dictionary[Ingredient, int] = {}
var bases: Array[Base] = []
var played_encounters: Dictionary[Encounter, bool] = {}

func _ready() -> void:
	bases = [
		ResourceManager.bases[0],
		ResourceManager.bases[1],
		ResourceManager.bases[2]
	]
	ingredients = {
		ResourceManager.ingredients[0]: 2,
		ResourceManager.ingredients[1]: 10,
		ResourceManager.ingredients[2]: 10,
		ResourceManager.ingredients[3]: 1
	}
	EventBus.mixer.order_received.connect(_on_order_start)
	EventBus.mixer.serve_mix.connect(_on_product_served)
	EventBus.shop.base_purchased.connect(_on_base_purchased)
	EventBus.shop.ingredient_purchased.connect(_on_ingredient_purchased)

func _on_order_start(product: Product) -> void:
	money += product.price

func _on_product_served(product: MixedProduct) -> void:
	for product_ingredient: Ingredient in product.ingredients:
		if ingredients.has(product_ingredient):
			ingredients[product_ingredient] -= 1
			EventBus.player.ingredient_stock_changed.emit(product_ingredient)

func _on_ingredient_purchased(ingredient: Ingredient, count: int) -> void:
	if !ingredients.has(ingredient):
		ingredients[ingredient] = 0

	ingredients[ingredient] += count
	money -= (ingredient.price * count)
	EventBus.player.ingredient_stock_changed.emit(ingredient)

func _on_base_purchased(base: Base) -> void:
	if !bases.has(base):
		bases.append(base)
		money -= base.price
	EventBus.player.bases_available_changed.emit()


func completed_encounter(encounter: Encounter) -> void:
	played_encounters[encounter] = true