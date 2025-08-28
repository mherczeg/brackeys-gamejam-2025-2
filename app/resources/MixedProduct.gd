class_name MixedProduct
extends Product

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


func has_fulfilled_product(product: Product) -> bool:
	var is_correct_base: bool = base == product.base
	var has_all_effects: bool = SetUtils.is_a_subset_of_b(
		SetUtils.array_to_set(product.effects),
		SetUtils.array_to_set(effects)
	)


	return is_correct_base && has_all_effects

func has_additional_liked_effects(product: Product, npc: NPC) -> bool:
	var additional_effects: Dictionary = SetUtils.difference(
		SetUtils.array_to_set(effects),
		SetUtils.array_to_set(product.effects)
	)

	for liked_effect: Effect in npc.likes:
		if additional_effects.has(liked_effect):
			return true
	return false

func has_additional_disliked_effects(product: Product, npc: NPC) -> bool:
	var additional_effects: Dictionary = SetUtils.difference(
		SetUtils.array_to_set(effects),
		SetUtils.array_to_set(product.effects)
	)

	for disliked_effect: Effect in npc.dislikes:
		if additional_effects.has(disliked_effect):
			return true
	return false
