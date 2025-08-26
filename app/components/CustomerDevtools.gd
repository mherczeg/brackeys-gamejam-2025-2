class_name CustomerDevtools
extends Control

const ENCOUNTERS: String = "res://resources/encounters"

var encounters: Dictionary[int, Encounter] = {}
var encounter_stages: Array[Encounter.STAGE] = [
	Encounter.STAGE.FIRST,
	Encounter.STAGE.SECOND,
	Encounter.STAGE.THIRD
]

@onready var encounter_selector: OptionButton = $HBoxContainer/EncounterSelector
@onready var stage_selector: OptionButton = $HBoxContainer/StageSelector
@onready var render_encounter_button: Button = $HBoxContainer/Button

func _ready() -> void:
	_load_all_effects()
	render_encounter_button.pressed.connect(_on_render_encounter_button_pressed)

func _load_all_effects() -> void:
	var dir: DirAccess = DirAccess.open(ENCOUNTERS)
	var encounter_id: int = 1
	if dir:
		for file_name: String in dir.get_files():
			if file_name.ends_with(".tres"):
				var resource: Resource = load(ENCOUNTERS.path_join(file_name))
				if resource is Encounter:
					encounter_selector.add_item(file_name.replace(".tres", ""), encounter_id)
					encounters[encounter_id] = resource
					encounter_id += 1

	encounter_selector.select(encounters.keys()[0])

func _on_render_encounter_button_pressed() -> void:
	EventBus.debug.render_encounter_stage.emit(
		encounters[encounter_selector.get_selected_id()],
		encounter_stages[stage_selector.selected]
	)
