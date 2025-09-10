class_name MixerState
extends Node

signal order_changed
signal selection_changed

var current_encounter: Encounter = null
var current_npc: NPC = null:
	set(new_npc):
		current_npc = new_npc
		order_changed.emit()
var current_product: Product:
	get():
		if (current_encounter == null || current_npc == null):
			return null
		if !current_encounter.order.has(current_npc):
			return null
		return current_encounter.order[current_npc]

var selected_ingredients: Dictionary[MixerButtons.SLOT, Ingredient] = {}:
	set(updated_ingredients):
		selected_ingredients = updated_ingredients
		selection_changed.emit()

var selected_product_type: ProductType:
	set(updated_product_type):
		selected_product_type = updated_product_type
		selection_changed.emit()

func unset_slot_ingredient(slot: MixerButtons.SLOT) -> void:
	if selected_ingredients.has(slot):
		var new_selected_ingredients: Dictionary[MixerButtons.SLOT, Ingredient] = selected_ingredients.duplicate()
		new_selected_ingredients.erase(slot)
		selected_ingredients = new_selected_ingredients

func set_slot_ingredient(slot: MixerButtons.SLOT, ingredient: Ingredient) -> void:
	var new_selected_ingredients: Dictionary[MixerButtons.SLOT, Ingredient] = selected_ingredients.duplicate()
	new_selected_ingredients[slot] = ingredient
	selected_ingredients = new_selected_ingredients

func get_first_empty_slot() -> Variant:
	for slot: MixerButtons.SLOT in MixerButtons.SLOT.values():
		if !selected_ingredients.has(slot) || !selected_ingredients[slot]:
			return slot

	return null

func set_next_slot_ingredient(ingredient: Ingredient) -> void:
	var next_slot: Variant = get_first_empty_slot()
	if (next_slot == null):
		return

	set_slot_ingredient(next_slot as MixerButtons.SLOT, ingredient)
