class_name Game
extends Node2D

# I hate this, but I am not gonna figure out a good workaround to godot enum values matching up with other enums
enum GAMEPLAY_STEPS {MIXING = 11, CLEANUP = 12, WAIT_FOR_FEEDBACK = 13}

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
var _is_mixing: bool = false

@onready var customer_pane: CustomerPane = %CustomerPane
@onready var mixing_pane: MixingPane = %MixingPane
@onready var shop_pane: ShopPane = %ShopPane

func _ready() -> void:
	customer_pane.pressed.connect(_on_customer_pane_click)
	EventBus.debug.render_encounter_stage.connect(render_encounter_stage)
	EventBus.debug.start_random_encounter.connect(start_random_encounter)
	EventBus.debug.start_shop.connect(shop_pane.open)

func start_random_encounter() -> void:
	start_encounter(ResourceManager.encounters.pick_random())

func start_encounter(encounter: Encounter) -> void:
	_is_mixing = false
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
			_is_mixing = true
			var mixed_product: MixedProduct = await serve_order()
			mixing_pane.display_result(mixed_product)
			_is_mixing = false
			_render_complete = false
			await evaluate_served_product(mixed_product)
			_render_complete = true
			setup_next_order()
			if _current_npc:
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

func evaluate_served_product(mixed_product: MixedProduct) -> Signal:
	var current_npc_index: int = _current_encounter.customers.find(_current_npc)
	var ordered_product: Product = _current_encounter.order[_current_npc]
	var product_reaction: String = "..."

	if current_npc_index == 0:
		customer_pane.encounter_storybox.clear_stage_text()

	if (mixed_product.unlocked_effects.size()):
		EventBus.mixer.ingredient_effects_unlocked.emit()

	if !mixed_product.has_fulfilled_product(ordered_product):
		product_reaction = _current_encounter.failure_text[_current_npc]
	elif mixed_product.has_additional_liked_effects(ordered_product, _current_npc):
		product_reaction = _current_encounter.like_text[_current_npc]
	elif mixed_product.has_additional_disliked_effects(ordered_product, _current_npc):
		product_reaction = _current_encounter.dislike_text[_current_npc]

	return customer_pane.encounter_storybox.render_single_message(current_npc_index, product_reaction)

func _on_customer_pane_click() -> void:
	if _current_encounter && !_is_mixing:
		if _render_complete:
			next_step()
		else:
			EventBus.customer.fast_forward.emit()
