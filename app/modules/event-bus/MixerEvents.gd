class_name MixerEvents
extends Node

signal base_selected(base: Base)
signal ingredient_selector_toggle(slot: IngredientButton.SLOT)
signal ingredient_selector_unset(slot: IngredientButton.SLOT)
signal ingredient_selected(slot: IngredientButton.SLOT, ingredient: Ingredient)
signal mixture_changed
signal serve_mix(product: MixedProduct)
signal ingredient_effects_unlocked
signal order_received(product: Product)
signal unknown_effect_warning(visible: bool)
signal base_warning(visible: bool)