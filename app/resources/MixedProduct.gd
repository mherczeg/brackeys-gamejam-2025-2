class_name MixedProduct
extends Product

var unlocked_ingredient_effects: Array = []

var ingredients: Array[Ingredient]:
	set(new_ingredients):
		ingredients = new_ingredients
		var effect_appeared_once_set: Dictionary[Effect, bool] = {}
		var product_effects: Dictionary[Effect, bool] = {}
		var new_unlocked_ingredient_effects: Array = []

		for ingredient: Ingredient in new_ingredients:
			for effect: Effect in ingredient.effects:
				if !effect_appeared_once_set.has(effect):
					effect_appeared_once_set[effect] = true
				elif !product_effects.has(effect):
					product_effects[effect] = true
					if !ingredient.effects[effect]:
						ingredient.effects[effect] = true
						new_unlocked_ingredient_effects.append([ingredient, effect])

		effects = product_effects.keys()
		unlocked_ingredient_effects = new_unlocked_ingredient_effects
