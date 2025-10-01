class_name GameStateMachine
extends Node

signal before_encounter_started(encounter: Encounter)
signal mixing_step_started(current_npc: NPC)
signal mixing_step_product_completed(product: MixedProduct)
signal encounter_completed(is_successful: bool)
signal encounter_stage_prepared_for_display(stage: Encounter.STAGE)
signal encounter_stage_display_completed
signal product_reaction_prepared_for_display(product_reaction: String)
signal product_reaction_display_completed

enum STAGE {
	STORY_FIRST,
	STORY_SECOND,
	MIXING,
	STORY_THIRD,
	SHOP,
	CLEANUP,
	IDLE,
	GAME_OVER
}

const DEFAULT_SHOP_TIMER: int = 3 # TODO dial in

@export var encounter_manager: EncounterManager

var current_stage: STAGE: get = get_current_stage

var _current_stage: STAGE = STAGE.IDLE
var _is_mixing: bool = false
var _is_processing: bool = false
var _time_to_shop: int = DEFAULT_SHOP_TIMER

func start_encounter(encounter: Encounter) -> void:
	_start_encounter_failsafe_cleanup()
	_start_encounter.bind(encounter).call_deferred()

func skip_stage() -> void:
	if encounter_manager.current_encounter == null or _is_mixing:
		return

	if _is_processing:
		_fast_forward_state()
	else:
		_advance_state()

func game_over() -> void:
	# there is no true game over. with a more fleshed out gameplay loop,
	# we will skip to the future with some resources lost, if the player has any.
	# for now, just clears the encounter
	_transition_to(STAGE.GAME_OVER)

func _start_encounter(encounter: Encounter) -> void:
	before_encounter_started.emit(encounter)
	_transition_to(STAGE.STORY_FIRST)

func _start_encounter_failsafe_cleanup() -> void:
	if _is_processing:
		_fast_forward_state()

	if _is_mixing:
		_is_mixing = false

	if encounter_manager.current_encounter:
		encounter_completed.emit(false)
		_current_stage = STAGE.IDLE

func _start_next_encounter() -> void:
	var next_encounter: Encounter = encounter_manager.get_next_encounter()
	start_encounter(next_encounter)

func _go_to_idle() -> void:
	_current_stage = STAGE.IDLE

func _go_to_game_over() -> void:
	_current_stage = STAGE.GAME_OVER

func _start_shop_turn() -> void:
	_transition_to(STAGE.SHOP)

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
		STAGE.STORY_THIRD, STAGE.SHOP:
			_transition_to(STAGE.CLEANUP)
		STAGE.CLEANUP, STAGE.IDLE, STAGE.MIXING, STAGE.GAME_OVER:
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
		STAGE.SHOP:
			await _handle_shop_stage()
		STAGE.CLEANUP:
			_handle_cleanup()
		STAGE.GAME_OVER:
			_handle_game_over()

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
	var served_order: ServedOrder = await EventBus.mixer.serve_mix
	_is_mixing = false
	return served_order.mixed_product


func _handle_evaluating_order(mixed_product: MixedProduct) -> void:
	_is_processing = true
	var product_reaction: String = encounter_manager.evaluate_product(mixed_product)
	if product_reaction:
		product_reaction_prepared_for_display.emit(product_reaction)
		await product_reaction_display_completed
	_is_processing = false

func _handle_shop_stage() -> void:
	EventBus.game.shop_stage_started.emit()
	await EventBus.game.shop_stage_completed
	# +1 for the current turn that doesn't end until cleanup
	_time_to_shop = DEFAULT_SHOP_TIMER + 1
	_advance_state()

func _handle_cleanup() -> void:
	encounter_completed.emit(true)
	_time_to_shop = max(0, _time_to_shop - 1)

	if !encounter_manager.should_continue_encounters():
		_go_to_idle()
		return

	if _time_to_shop == 0:
		_start_shop_turn()
		return

	_start_next_encounter()

func _handle_game_over() -> void:
	encounter_completed.emit(false)
	_go_to_game_over()

func get_current_stage() -> STAGE:
	return _current_stage
