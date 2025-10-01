class_name CustomerDevtools
extends HBoxContainer

const GIVE_MONEY_AMOUNT: float = 10

var encounters: Dictionary[int, Encounter] = {}

@onready var devtool_actions: HBoxContainer = %DevtoolsActions
@onready var toggle_visibility: Button = %ToggleVisibility
@onready var encounter_selector: OptionButton = %EncounterSelector
@onready var start_encounter: Button = %StartEncounter
@onready var restart_encounter: Button = %RestartEncounter
@onready var give_money: Button = %GiveMoney
@onready var heal: Button = %GiveHealth


func _ready() -> void:
	devtool_actions.hide()
	_init_encounter_selector()

	toggle_visibility.pressed.connect(_on_toggle_visibility_pressed)
	start_encounter.pressed.connect(_on_start_encounter_pressed)
	restart_encounter.pressed.connect(_on_restart_encounter_pressed)
	give_money.pressed.connect(_on_give_money_pressed)
	heal.pressed.connect(_on_heal_pressed)

func _init_encounter_selector() -> void:
	var encounter_id: int = 1
	for encounter: Encounter in ResourceManager.encounters:
		encounter_selector.add_item(encounter.name)
		encounters[encounter_id] = encounter
		encounter_id += 1

	encounter_selector.select(encounters.keys()[0])

func _on_start_encounter_pressed() -> void:
	EventBus.debug.start_encounter.emit(encounters[encounter_selector.get_selected_id()])

func _on_restart_encounter_pressed() -> void:
	EventBus.debug.restart_encounter.emit()

func _on_give_money_pressed() -> void:
	EventBus.debug.increase_money.emit(GIVE_MONEY_AMOUNT)

func _on_heal_pressed() -> void:
	EventBus.debug.heal.emit(20)

func _on_toggle_visibility_pressed() -> void:
	devtool_actions.visible = !devtool_actions.visible
	toggle_visibility.text = "Show Dev Actions" if !devtool_actions.visible else "Hide Dev Actions"
