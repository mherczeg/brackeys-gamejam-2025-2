extends Node

var money: float = 0:
	set(new_money):
		money = new_money
		EventBus.player.money_changed.emit(new_money)

var health: int = 100

var ingredients: Dictionary[Ingredient, int] = {}
var bases: Array[Base] = []

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

func _on_order_start(product: Product) -> void:
	money += product.price

func _on_product_served(product: MixedProduct) -> void:
	for product_ingredient: Ingredient in product.ingredients:
		if ingredients.has(product_ingredient):
			ingredients[product_ingredient] -= 1
			EventBus.player.ingredient_stock_changed.emit(product_ingredient)
