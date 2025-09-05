class_name EncounterManager
extends Node

var current_encounter: Encounter
var _current_npc_index: int = 0
var _is_looping: bool = false

func set_current_encounter(encounter: Encounter) -> void:
	current_encounter = encounter
	_current_npc_index = 0

func get_current_npc() -> NPC:
	if not current_encounter or _current_npc_index >= current_encounter.customers.size():
		return null
	return current_encounter.customers[_current_npc_index]

func get_current_npc_index() -> int:
	return _current_npc_index

func advance_to_next_npc() -> void:
	_current_npc_index += 1

func has_more_customers() -> bool:
	return current_encounter != null and _current_npc_index < current_encounter.customers.size()

func get_next_encounter() -> Encounter:
	var all_encounters: Array[Encounter] = ResourceManager.encounters.duplicate()
	all_encounters.shuffle()

	for encounter: Encounter in all_encounters:
		if not Player.played_encounters.has(encounter):
			Player.played_encounters[encounter] = true
			return encounter

	# Reset if all played
	Player.played_encounters.clear()
	return ResourceManager.encounters.pick_random()

func should_continue_encounters() -> bool:
	return _is_looping

func complete_encounter() -> void:
	if current_encounter:
		Player.played_encounters[current_encounter] = true
	current_encounter = null
	_current_npc_index = 0

func evaluate_product(mixed_product: MixedProduct) -> String:
	var current_npc: NPC = get_current_npc()

	if not current_npc:
		return ""

	if mixed_product.unlocked_effects.size() > 0:
		EventBus.mixer.ingredient_effects_unlocked.emit()

	if _current_npc_index == 0:
		EventBus.game.encounter_evaluate_stage_started.emit()

	var ordered_product: Product = current_encounter.order[current_npc]
	var reaction_text: String = _get_reaction_text(mixed_product, ordered_product, current_npc)

	return reaction_text


func _get_reaction_text(mixed_product: MixedProduct, ordered_product: Product, npc: NPC) -> String:
	if not mixed_product.has_fulfilled_product(ordered_product):
		return current_encounter.failure_text[npc]
	if mixed_product.has_additional_liked_effects(ordered_product, npc):
		return current_encounter.like_text[npc]
	if mixed_product.has_additional_disliked_effects(ordered_product, npc):
		return current_encounter.dislike_text[npc]
	return "..."
