class_name MixedProduct
extends Product

enum REACTION {NONE, UNFULFILLED, LIKES, DISLIKES}

var unlocked_effects: Dictionary[Ingredient, bool] = {}

var ingredients: Array[Ingredient]:
	set(new_ingredients):
		ingredients = new_ingredients
		var effect_appeared_once_set: Dictionary[Effect, bool] = {}
		var product_effects: Dictionary[Effect, bool] = {}
		var new_unlocked_effects: Dictionary[Ingredient, bool] = {}

		for ingredient: Ingredient in new_ingredients:
			for effect: Effect in ingredient.effects:
				if !effect_appeared_once_set.has(effect):
					effect_appeared_once_set[effect] = true
				elif !product_effects.has(effect):
					product_effects[effect] = true
					if !ingredient.effects[effect]:
						ingredient.effects[effect] = true
						new_unlocked_effects[ingredient] = true

		effects = product_effects.keys()
		unlocked_effects = new_unlocked_effects

func _init(_product_type: ProductType, _ingredients: Array[Ingredient]) -> void:
	product_type = _product_type
	ingredients = _ingredients

func has_fulfilled_product(product: Product) -> bool:
	var is_correct_product_type: bool = product_type == product.product_type
	var has_all_effects: bool = SetUtils.is_a_subset_of_b(
		SetUtils.array_to_set(product.effects),
		SetUtils.array_to_set(effects)
	)

	return is_correct_product_type && has_all_effects

func get_additional_effects(product: Product) -> Dictionary[Effect, bool]:
	return _effects_difference(
		SetUtils.array_to_set(effects),
		SetUtils.array_to_set(product.effects)
	)


func has_additional_liked_effects(product: Product, npc: NPC) -> bool:
	var additional_effects: Dictionary[Effect, bool] = get_additional_effects(product)

	for liked_effect: Effect in npc.likes.keys():
		if additional_effects.has(liked_effect):
			return true
	return false

func has_additional_disliked_effects(product: Product, npc: NPC) -> bool:
	var additional_effects: Dictionary[Effect, bool] = get_additional_effects(product)

	for disliked_effect: Effect in npc.dislikes.keys():
		if additional_effects.has(disliked_effect):
			return true
	return false

func get_reaction_for_effects(ordered_product: Product, npc: NPC) -> REACTION:
	if has_additional_liked_effects(ordered_product, npc):
		return REACTION.LIKES
	if has_additional_disliked_effects(ordered_product, npc):
		return REACTION.DISLIKES
	return REACTION.NONE

func get_complete_reaction(ordered_product: Product, npc: NPC) -> REACTION:
	if !has_fulfilled_product(ordered_product):
		return REACTION.UNFULFILLED
	return get_reaction_for_effects(ordered_product, npc)

func _effect_array_to_set(array: Array[Effect]) -> Dictionary[Effect, bool]:
	var result: Dictionary[Effect, bool] = {}
	for effect: Effect in SetUtils.array_to_set(array):
		result[effect] = true
	return result

func _effects_difference(
	effects_a: Dictionary,
	effects_b: Dictionary
) -> Dictionary[Effect, bool]:
	var result: Dictionary[Effect, bool] = {}
	for effect: Effect in SetUtils.difference(effects_a, effects_b).keys():
		result[effect] = true
	return result
