class_name Inventory
extends Resource

var money: float: get = get_money, set = set_money

var _product_types: Dictionary[ProductType, bool] = {}
var _ingredients: Dictionary[Ingredient, int] = {}
var _money: float = 0

func setup(
	starting_product_types: Array[ProductType],
	starting_ingredients: Dictionary[Ingredient, int],
	starting_money: float
) -> void:
	for product_type: ProductType in ResourceManager.product_types:
		_product_types[product_type] = starting_product_types.has(product_type)
	for ingredient: Ingredient in ResourceManager.ingredients:
		_ingredients[ingredient] = starting_ingredients.get(ingredient, 0)
		EventBus.player.ingredient_stock_changed.emit(ingredient)
	EventBus.player.product_types_available_changed.emit()
	set_money(starting_money)

func has_product_type(product_type: ProductType) -> bool:
	return _product_types.get(product_type, false)

func set_product_type(product_type: ProductType, availability: bool) -> void:
	_product_types[product_type] = availability
	EventBus.player.product_types_available_changed.emit()

func get_available_product_types() -> Array[ProductType]:
	var available_products: Array[ProductType]

	for product_type: ProductType in _product_types.keys():
		if _product_types[product_type]:
			available_products.append(product_type)

	return available_products

func has_ingredient(ingredient: Ingredient) -> bool:
	return get_ingredient_amount(ingredient) > 0

func get_ingredient_amount(ingredient: Ingredient) -> int:
	return _ingredients.get(ingredient, 0)

func set_ingredient(ingredient: Ingredient, amount: int) -> void:
	_ingredients[ingredient] = amount
	EventBus.player.ingredient_stock_changed.emit(ingredient)

func increase_ingredient_amount(ingredient: Ingredient, amount: int) -> void:
	var new_amount: int = get_ingredient_amount(ingredient) + amount
	set_ingredient(ingredient, max(new_amount, 0))

func get_available_ingredients() -> Array[Ingredient]:
	var available_ingredients: Array[Ingredient]

	for ingredient: Ingredient in _ingredients.keys():
		if _ingredients[ingredient] > 0:
			available_ingredients.append(ingredient)

	return available_ingredients

func get_money() -> float:
	return _money

func set_money(new_value: float) -> void:
	var old_value: float = money
	money = new_value
	EventBus.player.money_changed.emit(new_value, old_value)

func increase_money(amount: float) -> void:
	var new_money: float = get_money() + amount
	set_money(max(new_money, 0))