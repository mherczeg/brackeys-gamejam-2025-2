class_name Game
extends Node2D

@onready var customer_pane: CustomerPane = %CustomerPane
@onready var mixing_pane: MixingPane = %MixingPane
@onready var shop_pane: ShopPane = %ShopPane
@onready var npc_pane: NPCPane = %NPCPane
@onready var game_state_machine: GameStateMachine = %GameStateMachine
@onready var encounter_manager: EncounterManager = %EncounterManager

func _ready() -> void:
	_connect_signals()

func start_encounter(encounter: Encounter) -> void:
	encounter_manager._is_looping = true
	game_state_machine.start_encounter(encounter)

func start_random_encounter() -> void:
	var encounter: Encounter = ResourceManager.encounters.pick_random()
	start_encounter(encounter)

func render_encounter_stage(encounter: Encounter, stage: Encounter.STAGE) -> void:
	customer_pane.encounter_storybox.render_story_step(encounter, stage)

func _connect_signals() -> void:
	customer_pane.pressed.connect(_on_customer_pane_pressed)
	_connect_game_state_signals()
	_connect_debug_signals()

func _connect_debug_signals() -> void:
	EventBus.debug.start_encounter.connect(_on_debug_start_encounter)
	EventBus.debug.restart_encounter.connect(_on_debug_restart_encounter)

func _connect_game_state_signals() -> void:
	game_state_machine.before_encounter_started.connect(_on_before_encounter_started)
	game_state_machine.mixing_step_started.connect(_on_mixing_step_started)
	game_state_machine.mixing_step_product_completed.connect(_on_mixing_step_mixing_step_product_completed)
	game_state_machine.encounter_completed.connect(_on_encounter_completed)
	game_state_machine.encounter_stage_prepared_for_display.connect(_on_encounter_stage_prepared_for_display)
	game_state_machine.product_reaction_prepared_for_display.connect(_on_product_reaction_prepared_for_display)


func _on_customer_pane_pressed() -> void:
	game_state_machine.skip_stage()

func _on_before_encounter_started(encounter: Encounter) -> void:
	encounter_manager.set_current_encounter(encounter)
	mixing_pane.start_encounter(encounter)

func _on_mixing_step_started(npc: NPC) -> void:
	mixing_pane.start_new_order(npc)

func _on_mixing_step_mixing_step_product_completed(mixed_product: MixedProduct) -> void:
	mixing_pane.display_result(mixed_product)

func _on_encounter_completed() -> void:
	customer_pane.encounter_storybox.clear()
	mixing_pane.complete_encounter()
	encounter_manager.complete_encounter()

func _on_encounter_stage_prepared_for_display(stage: Encounter.STAGE) -> void:
	await customer_pane.encounter_storybox.render_story_step(
		encounter_manager.current_encounter,
		stage
	)
	game_state_machine.encounter_stage_display_completed.emit()

func _on_product_reaction_prepared_for_display(product_reaction: String) -> void:
	await customer_pane.encounter_storybox.render_single_message(
		encounter_manager.get_current_npc_index(),
		product_reaction
	)
	game_state_machine.product_reaction_display_completed.emit()

func _on_debug_start_encounter(encounter: Encounter) -> void:
	start_encounter(encounter)

func _on_debug_restart_encounter() -> void:
	if encounter_manager.current_encounter:
		start_encounter(encounter_manager.current_encounter)
