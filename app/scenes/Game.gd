class_name Game
extends Node2D

const GAMEPLAY_STEPS: Dictionary = {
	"MIXING": "MIXING",
	"CLEANUP": "CLEANUP"
}

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
var _render_complete: bool = false

@onready var customer_pane: CustomerPane = %CustomerPane

func _ready() -> void:
	customer_pane.pressed.connect(_on_customer_pane_click)
	EventBus.debug.render_encounter_stage.connect(render_encounter_stage)
	EventBus.debug.start_random_encounter.connect(start_random_encounter)

# this is very ineffiecient, but should be gone by tomorrow
func start_random_encounter() -> void:
	var dir: DirAccess = DirAccess.open(ENCOUNTERS)
	if dir:
		var randomized_files: Array = Array(dir.get_files())
		randomized_files.shuffle()
		for file_name: String in randomized_files:
			if file_name.ends_with(".tres"):
				var resource: Resource = load(ENCOUNTERS.path_join(file_name))
				if resource is Encounter:
					start_encounter(resource)
					return

func start_encounter(encounter: Encounter) -> void:
	_current_step_index = 0
	_current_encounter = encounter
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
			_render_complete = true
		Encounter.STAGE.THIRD:
			_render_complete = false
			await customer_pane.encounter_storybox.render_story_step(_current_encounter, Encounter.STAGE.THIRD)
			_render_complete = true
		GAMEPLAY_STEPS.MIXING:
			await EventBus.debug.serve_mixture
			next_step()
		GAMEPLAY_STEPS.CLEANUP:
			customer_pane.encounter_storybox.clear()
			_current_encounter = null

func next_step() -> void:
	_current_step_index += 1
	gameplay_loop()

func render_encounter_stage(encounter: Encounter, stage: Encounter.STAGE) -> void:
	customer_pane.encounter_storybox.render_story_step(encounter, stage)

func _on_customer_pane_click() -> void:
	if _current_encounter && SKIPPABLE_STEPS.has(GAME_LOOP_STEPS[_current_step_index]):
		if _render_complete:
			next_step()
		else:
			EventBus.customer.fast_forward.emit()
