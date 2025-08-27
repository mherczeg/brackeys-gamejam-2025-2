class_name Game
extends Node2D

# I hate this, but I am not gonna figure out a good workaround to godot enum values matching up with other enums
enum GAMEPLAY_STEPS {MIXING = 11, CLEANUP = 12}

const GAME_LOOP_STEPS: Array = [
	Encounter.STAGE.FIRST,
	Encounter.STAGE.SECOND,
	GAMEPLAY_STEPS.MIXING,
	Encounter.STAGE.THIRD,
	GAMEPLAY_STEPS.CLEANUP
]

const SKIPPABLE_STEPS: Dictionary = {
	Encounter.STAGE.FIRST: true,
	Encounter.STAGE.SECOND: true,
	Encounter.STAGE.THIRD: true,
}

const ENCOUNTERS: String = "res://resources/encounters"

var _current_step_index: int = 0
var _current_encounter: Encounter
var _current_npc: NPC
var _render_complete: bool = false

@onready var customer_pane: CustomerPane = %CustomerPane
@onready var mixing_pane: MixingPane = %MixingPane

func _ready() -> void:
	customer_pane.pressed.connect(_on_customer_pane_click)
	EventBus.debug.render_encounter_stage.connect(render_encounter_stage)
	EventBus.debug.start_random_encounter.connect(start_random_encounter)

# this is very ineffiecient, but should be gone by tomorrow
func start_random_encounter() -> void:
	start_encounter(ResourceManager.encounters.pick_random())

func start_encounter(encounter: Encounter) -> void:
	_current_step_index = 0
	_current_encounter = encounter
	_current_npc = encounter.customers[0]
	mixing_pane.start_encounter(encounter)
	gameplay_loop()


func gameplay_loop() -> void:
	match GAME_LOOP_STEPS[_current_step_index]:
		Encounter.STAGE.FIRST:
			_render_complete = false
			await customer_pane.encounter_storybox.render_story_step(_current_encounter, Encounter.STAGE.FIRST)
			_render_complete = true
		Encounter.STAGE.SECOND:
			_render_complete = false
			await customer_pane.encounter_storybox.render_story_step(_current_encounter, Encounter.STAGE.SECOND)
			next_step()
			_render_complete = true
		Encounter.STAGE.THIRD:
			_render_complete = false
			await customer_pane.encounter_storybox.render_story_step(_current_encounter, Encounter.STAGE.THIRD)
			_render_complete = true
		GAMEPLAY_STEPS.MIXING:
			var mixed_product: MixedProduct = await serve_order()
			mixing_pane.display_result(mixed_product)
			evaluate_served_product(mixed_product)
			setup_next_order()
			next_step()
		GAMEPLAY_STEPS.CLEANUP:
			customer_pane.encounter_storybox.clear()
			_current_encounter = null
			_current_npc = null
			mixing_pane.complete_encounter()

func next_step() -> void:
	if is_step_complete():
		_current_step_index += 1
	gameplay_loop()

func is_step_complete() -> bool:
	if GAME_LOOP_STEPS[_current_step_index] == GAMEPLAY_STEPS.MIXING:
		return _current_npc == null
	return true

func serve_order() -> Signal:
	mixing_pane.start_new_order(_current_npc)
	return EventBus.mixer.serve_mix


func setup_next_order() -> void:
	var customers: Array[NPC] = _current_encounter.customers

	var next_npc_index: int = customers.find(_current_npc) + 1
	if (customers.size() - 1 >= next_npc_index):
		_current_npc = customers[next_npc_index]
	else:
		_current_npc = null

func render_encounter_stage(encounter: Encounter, stage: Encounter.STAGE) -> void:
	customer_pane.encounter_storybox.render_story_step(encounter, stage)

func evaluate_served_product(mixed_product: MixedProduct) -> void:
	var ordered_product: Product = _current_encounter.order[_current_npc]

	var is_correct_base: bool = mixed_product.base == ordered_product.base
	var has_all_effects: bool = SetUtils.is_a_subset_of_b(
		SetUtils.array_to_set(ordered_product.effects),
		SetUtils.array_to_set(mixed_product.effects)
	)

	if (is_correct_base && has_all_effects):
		print("just what I wanted")
	else:
		print("this is wrong")

	if (mixed_product.unlocked_ingredient_effects.size()):
		EventBus.mixer.ingredient_effects_unlocked.emit()


func _on_customer_pane_click() -> void:
	if _current_encounter && SKIPPABLE_STEPS.has(GAME_LOOP_STEPS[_current_step_index]):
		if _render_complete:
			next_step()
		else:
			EventBus.customer.fast_forward.emit()
