class_name StageNPCGroup
extends Control

signal encounter_complete


@export var stage: Encounter.STAGE

var _npc_with_interaciton: int = 0
@onready var stage_npcs: Array[StageNPC] = [
	$StageNPC,
	$StageNPC2,
	$StageNPC3
]

func show_encounter(encounter: Encounter) -> Signal:
	var texts: Array[String] = encounter.get_stage_text(stage).values()
	var npc_count: int = encounter.get_stage_text(stage).size()
	_reset_npcs()
	show()
	_set_npc_visibility(npc_count)
	_process_npc_interactions(texts)

	return encounter_complete

func _set_npc_visibility(npc_count: int) -> void:
	for i: int in npc_count:
		stage_npcs[i].show()

func _process_npc_interactions(texts: Array[String], _current_npc: int = 0) -> void:
	if _current_npc >= texts.size():
		encounter_complete.emit()
		return

	await stage_npcs[_current_npc].set_text(texts[_current_npc])

	_process_npc_interactions(texts, _current_npc + 1)


func watch_display_completion(encounter: Encounter) -> void:
	_npc_with_interaciton = encounter.get_stage_text(stage).size()
	if _npc_with_interaciton == 0:
		return

	for i: int in _npc_with_interaciton:
		stage_npcs[i].set_text_complete.connect(_on_npc_done, CONNECT_ONE_SHOT)


func _on_npc_done() -> void:
	_npc_with_interaciton -= 1
	if _npc_with_interaciton == 0:
		encounter_complete.emit()

func _reset_npcs() -> void:
	for stage_npc: StageNPC in stage_npcs:
		stage_npc.hide()
		stage_npc.clear_text()
