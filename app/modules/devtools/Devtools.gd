class_name CustomerDevtools
extends Control

var encounters: Dictionary[int, Encounter] = {}
var encounter_stages: Array[Encounter.STAGE] = [
	Encounter.STAGE.FIRST,
	Encounter.STAGE.SECOND,
	Encounter.STAGE.THIRD
]

@onready var encounter_selector: OptionButton = $HBoxContainer/EncounterSelector
@onready var stage_selector: OptionButton = $HBoxContainer/StageSelector
@onready var render_encounter_button: Button = $HBoxContainer/RenderEncounter
@onready var start_encounter_button: Button = $HBoxContainer/StartEncounter
@onready var simulate_serving_mix: Button = $HBoxContainer/SimulateServingMix
@onready var start_shop_turn: Button = $HBoxContainer/StartShopTurn

func _ready() -> void:
	_init_encounter_selector()
	render_encounter_button.pressed.connect(_on_render_encounter_button_pressed)
	start_encounter_button.pressed.connect(EventBus.debug.start_random_encounter.emit)
	simulate_serving_mix.pressed.connect(EventBus.debug.serve_mixture.emit)
	start_shop_turn.pressed.connect(EventBus.debug.start_shop.emit)

func _init_encounter_selector() -> void:
	var encounter_id: int = 1
	for encounter: Encounter in ResourceManager.encounters:
		encounter_selector.add_item("Encounter %d" % encounter_id, encounter_id)
		encounters[encounter_id] = encounter
		encounter_id += 1

	encounter_selector.select(encounters.keys()[0])

func _on_render_encounter_button_pressed() -> void:
	EventBus.debug.render_encounter_stage.emit(
		encounters[encounter_selector.get_selected_id()],
		encounter_stages[stage_selector.selected]
	)
