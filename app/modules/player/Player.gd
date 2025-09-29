extends Node

var health: int = 100

var inventory: Inventory = Inventory.new()
var order_history: OrderHistory = OrderHistory.new()

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

func _on_product_served(served_order: ServedOrder) -> void:
	var order_history_element: OrderHistoryElement = order_history.add_order(served_order)
	_decrease_used_ingredients(served_order.mixed_product.ingredients)
	_log_npc_preferences(order_history_element)

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

func _decrease_used_ingredients(used_ingredients: Array[Ingredient]) -> void:
	for used_ingredient: Ingredient in used_ingredients:
		if inventory.has_ingredient(used_ingredient):
			inventory.increase_ingredient_amount(used_ingredient, -1)

func _log_npc_preferences(order_history_element: OrderHistoryElement) -> void:
	if !order_history_element.is_npc_preference_deductible():
		return

	if (order_history_element.reaction == MixedProduct.REACTION.DISLIKES):
		_log_npc_dislike(
			order_history_element.npc,
			order_history_element.additional_effects[0]
		)
	if (order_history_element.reaction == MixedProduct.REACTION.LIKES):
		_log_npc_like(
			order_history_element.npc,
			order_history_element.additional_effects[0])

func _log_npc_dislike(npc: NPC, disliked_effect: Effect) -> void:
	if npc.dislikes.has(disliked_effect):
		npc.dislikes[disliked_effect] = true

func _log_npc_like(npc: NPC, liked_effect: Effect) -> void:
	if npc.likes.has(liked_effect):
		npc.likes[liked_effect] = true
