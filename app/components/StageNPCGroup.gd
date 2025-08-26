class_name StageNPCGroup
extends Control

signal encounter_complete


@export var stage: Encounter.STAGE

var _npc_working: int = 0

@onready var stage_npcs: Array[StageNPC] = [
	$StageNPC,
	$StageNPC2,
	$StageNPC3
]

func show_encounter(encounter: Encounter) -> Signal:
	var texts: Array[String] = encounter.get_stage_text(stage).values()

	reset_npcs()
	watch_display_completion(encounter)

	for i: int in texts.size():
		stage_npcs[i].set_text(texts[i])
		stage_npcs[i].show()

	show()
	return encounter_complete

func watch_display_completion(encounter: Encounter) -> void:
	_npc_working = encounter.get_stage_text(stage).size()
	if _npc_working == 0:
		return

	for i: int in _npc_working:
		stage_npcs[i].set_text_complete.connect(_on_npc_done, CONNECT_ONE_SHOT)


func _on_npc_done() -> void:
	_npc_working -= 1
	if _npc_working == 0:
		encounter_complete.emit()

func reset_npcs() -> void:
	for stage_npc: StageNPC in stage_npcs:
		stage_npc.hide()
		stage_npc.set_text("")
