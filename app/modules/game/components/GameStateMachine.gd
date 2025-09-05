class_name GameStateMachine
extends Node

signal before_encounter_started(encounter: Encounter)
signal mixing_step_started(current_npc: NPC)
signal mixing_step_product_completed(product: MixedProduct)
signal encounter_completed
signal encounter_stage_prepared_for_display(stage: Encounter.STAGE)
signal encounter_stage_display_completed
signal product_reaction_prepared_for_display(product_reaction: String)
signal product_reaction_display_completed

enum STAGE {
	STORY_FIRST,
	STORY_SECOND,
	MIXING,
	STORY_THIRD,
	CLEANUP,
	IDLE
}

@export var encounter_manager: EncounterManager

var _current_stage: STAGE = STAGE.IDLE
var _is_mixing: bool = false
var _is_processing: bool = false


func start_encounter(encounter: Encounter) -> void:
	before_encounter_started.emit(encounter)
	_transition_to(STAGE.STORY_FIRST)

func skip_stage() -> void:
	if encounter_manager.current_encounter == null or _is_mixing:
		return

	if _is_processing:
		_fast_forward_state()
	else:
		_advance_state()

func _fast_forward_state() -> void:
	EventBus.customer.fast_forward.emit()

func _advance_state() -> void:
	match _current_stage:
		STAGE.STORY_FIRST:
			_transition_to(STAGE.STORY_SECOND)
		STAGE.STORY_SECOND:
			_transition_to(STAGE.MIXING)
		STAGE.MIXING:
			_transition_to(STAGE.STORY_THIRD)
		STAGE.STORY_THIRD:
			_transition_to(STAGE.CLEANUP)
		STAGE.CLEANUP, STAGE.IDLE, STAGE.MIXING:
			pass # Handled in _execute_current_state or already idle

func _transition_to(new_state: STAGE) -> void:
	_current_stage = new_state
	_execute_current_state()

func _execute_current_state() -> void:
	match _current_stage:
		STAGE.STORY_FIRST:
			await _handle_story_stage(Encounter.STAGE.FIRST)
		STAGE.STORY_SECOND:
			await _handle_story_stage(Encounter.STAGE.SECOND)
			_advance_state()
		STAGE.MIXING:
			await _handle_mixing()
		STAGE.STORY_THIRD:
			await _handle_story_stage(Encounter.STAGE.THIRD)
		STAGE.CLEANUP:
			_handle_cleanup()

func _handle_story_stage(stage: Encounter.STAGE) -> void:
	_is_processing = true
	encounter_stage_prepared_for_display.emit(stage)
	await encounter_stage_display_completed
	_is_processing = false

func _handle_mixing() -> void:
	var current_npc: NPC = encounter_manager.get_current_npc()
	if not current_npc:
		_advance_state()
		return

	await _handle_mixing_for_npc(current_npc)

	encounter_manager.advance_to_next_npc()

	if encounter_manager.has_more_customers():
		_execute_current_state() # Stay in mixing

func _handle_mixing_for_npc(current_npc: NPC) -> void:
	var mixed_product: MixedProduct = await _handle_mixing_order(current_npc)

	mixing_step_product_completed.emit(mixed_product)

	await _handle_evaluating_order(mixed_product)

func _handle_mixing_order(current_npc: NPC) -> MixedProduct:
	_is_mixing = true
	mixing_step_started.emit(current_npc)
	var mixed_product: MixedProduct = await EventBus.mixer.serve_mix
	_is_mixing = false
	return mixed_product


func _handle_evaluating_order(mixed_product: MixedProduct) -> void:
	_is_processing = true
	var product_reaction: String = encounter_manager.evaluate_product(mixed_product)
	if product_reaction:
		product_reaction_prepared_for_display.emit(product_reaction)
		await product_reaction_display_completed
	_is_processing = false

func _handle_cleanup() -> void:
	encounter_completed.emit()

	if encounter_manager.should_continue_encounters():
		var next_encounter: Encounter = encounter_manager.get_next_encounter()
		start_encounter(next_encounter)
	else:
		_current_stage = STAGE.IDLE
