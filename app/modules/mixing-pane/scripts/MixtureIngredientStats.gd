class_name MixtureIngredientStats
extends RefCounted

var effect_counts: Dictionary[Effect, int] = {}
var ingredients_with_unknown_count: int = 0

func _init(ingredients: Dictionary[MixerButtons.SLOT, Ingredient]) -> void:
	_calculate_stats(ingredients)

func _calculate_stats(ingredients: Dictionary[MixerButtons.SLOT, Ingredient]) -> void:
	for ingredient: Ingredient in ingredients.values():
		var has_unknown_effect: bool = false

		for effect: Effect in ingredient.effects:
			if ingredient.is_effect_known(effect):
				effect_counts[effect] = effect_counts.get(effect, 0) + 1
			else:
				has_unknown_effect = true

		if has_unknown_effect:
			ingredients_with_unknown_count += 1